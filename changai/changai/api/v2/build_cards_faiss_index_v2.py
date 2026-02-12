import os
from pathlib import Path
import glob
import json
import yaml
import numpy as np
import faiss
from typing import List, Dict, Any, Tuple
from langchain_core.documents import Document
from langchain_community.docstore.in_memory import InMemoryDocstore
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings

BASE_CARDS_DIR = "/opt/hyrin/frappe-bench/apps/changai/changai/changai/cards_v2"

SCHEMA_DIR = os.path.join(BASE_CARDS_DIR, "schema")
ENTITY_DIR = os.path.join(BASE_CARDS_DIR, "entity")

OUT_BASE = "/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/fvs_stores"
OUT_SCHEMA = os.path.join(OUT_BASE, "schema_fvs")
OUT_ENTITY = os.path.join(OUT_BASE, "entity_fvs")

EMBED_MODEL_NAME = "hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned"

HNSW_M = 32
EF_CONSTRUCTION = 256
EF_SEARCH = 64

def _assert_file_inside_base(file_path: str, base_dir: str) -> str:
    base = Path(base_dir).resolve()
    p = Path(file_path).resolve()
    if base != p and base not in p.parents:
        raise ValueError(f"Unsafe file path (outside base dir): {p}")
    return str(p)

def load_yaml_dir(path: str) -> List[Dict[str, Any]]:
    """
    Loads all *.yaml in a folder.
    Supports yaml files that contain a list[dict] or a single dict.
    Returns a flat list of dict items.
    """
    out: List[Dict[str, Any]] = []
    base_dir = Path(path).resolve()
    for fp in sorted(glob.glob(os.path.join(str(base_dir), "*.yaml"))):
        safe_fp = _assert_file_inside_base(fp, str(base_dir))
        with open(safe_fp, "r", encoding="utf-8") as f:
            doc = yaml.safe_load(f)

        if doc is None:
            continue
        if isinstance(doc, list):
            out.extend([x for x in doc if isinstance(x, dict)])
        elif isinstance(doc, dict):
            out.append(doc)
        else:
            print(f"⚠️ Skipping unsupported YAML type in {fp}: {type(doc)}")
    return out


def _join(parts, sep=" "):
    return sep.join(p.strip() for p in parts if p and str(p).strip())


def _serialize_options(opts) -> str:
    """Supports options as list[str] or newline-separated string."""
    if not opts:
        return ""
    if isinstance(opts, str):
        items = [x.strip() for x in opts.splitlines() if x.strip()]
        return ", ".join(items)
    if isinstance(opts, (list, tuple)):
        items = [str(x).strip() for x in opts if str(x).strip()]
        return ", ".join(items)
    return str(opts).strip()


def _entity_page_content(md: Dict[str, Any]) -> str:
    """
    Uses embedding_text if provided, else generates a clean entity page content.
    """
    et = (md.get("embedding_text") or "").strip()
    if et:
        return et

    entity_type = (md.get("entity_type") or "entity").strip()
    canonical = (md.get("canonical_name") or md.get("entity_id") or "").strip()
    aliases = md.get("aliases", []) or []
    misspellings = md.get("misspellings", []) or []

    alias_text = ", ".join(aliases)
    typo_text = ", ".join(misspellings)

    return _join(
        [
            f"{entity_type.title()}: {canonical}" if canonical else "",
            f"Also known as {alias_text}" if alias_text else "",
            f"Common misspellings: {typo_text}" if typo_text else "",
        ],
        sep=". ",
    )


def build_schema_docs(schema_cards: List[Dict[str, Any]]) -> List[Document]:
    """
    Builds documents for schema retrieval:
    - table docs
    - field docs (includes options + join_hint)
    """
    docs: List[Document] = []
    source_id = 0

    for sc in schema_cards:
        # Only accept proper table blocks
        if not isinstance(sc, dict) or "table" not in sc:
            continue

        tname = sc["table"]
        syn_en = ", ".join(sc.get("synonyms_en", []) or [])
        desc = sc.get("description", "") or ""

        notes = sc.get("notes", [])
        notes = " ".join(notes) if isinstance(notes, list) else (notes or "")

        # Table doc
        table_text = _join([
            f"[TABLE] {tname}",
            f"[DESC] {desc}" if desc else "",
            f"[ALIAS_EN] {syn_en}" if syn_en else "",
            f"[NOTES] {notes}" if notes else "",
        ], sep=" | ")

        docs.append(Document(
            page_content=f"search_document: {table_text}",
            metadata={
                "type": "table",
                "table": tname,
                "source_id": source_id,
                "retrieval_key": f"[TABLE] {tname}",
            }
        ))
        source_id += 1

        # Field docs
        for f in sc.get("fields", []) or []:
            fname = f.get("name", "UNKNOWN")
            ftype = f.get("type", "UNKNOWN")
            fdesc = f.get("description", "") or ""
            syn_f = ", ".join(f.get("synonyms_en", []) or [])

            enum_vals = f.get("enum_values", []) or []
            options = f.get("options", None)
            join_hint = (f.get("join_hint", "") or "").strip()

            parts = [
                f"[FIELD] {fname} ({ftype})",
                f"[TABLE] {tname}",
                f"[DESC] {fdesc}" if fdesc else "",
            ]

            if enum_vals:
                parts.append(f"[ENUM] {', '.join([str(v) for v in enum_vals])}")

            opt_text = _serialize_options(options)
            if opt_text:
                parts.append(f"[OPTIONS] {opt_text}")

            if join_hint:
                parts.append(f"[JOIN_HINT] {join_hint}")

            if syn_f:
                parts.append(f"[ALIAS_EN] {syn_f}")

            field_text = _join(parts, sep=" | ")

            docs.append(Document(
                page_content=f"search_document: {field_text}",
                metadata={
                    "type": "field",
                    "table": tname,
                    "field": fname,
                    "source_id": source_id,
                    "retrieval_key": f"[FIELD] {fname} | [TABLE] {tname}",
                }
            ))
            source_id += 1

    return docs


def build_entity_docs(entity_cards: List[Dict[str, Any]]) -> List[Document]:
    """
    Builds documents for entity retrieval (master data cards).
    """
    docs: List[Document] = []
    source_id = 0

    for md in entity_cards:
        if not isinstance(md, dict):
            continue

        text = _entity_page_content(md)
        if not text:
            continue

        canonical = md.get("canonical_name") or md.get("entity_id") or ""
        retrieval_key = f"[ENTITY] {canonical}"

        docs.append(Document(
            page_content=f"search_document: {text}",
            metadata={
                "type": "entity",
                "entity_type": md.get("entity_type"),
                "entity_id": md.get("entity_id"),
                "canonical_name": md.get("canonical_name"),
                "aliases": md.get("aliases", []),
                "description": md.get("description", ""),
                "source_id": source_id,
                "retrieval_key": retrieval_key,
            }
        ))
        source_id += 1

    return docs


def _assert_dir_inside_base(dir_path: str, base_dir: str) -> Path:
    base = Path(base_dir).resolve()
    d = Path(dir_path).resolve()
    if base != d and base not in d.parents:
        raise ValueError(f"Unsafe output dir (outside base): {d}")
    return d


def build_faiss_store(
    docs: List[Document],
    embeddings: HuggingFaceEmbeddings,
    out_dir: str,
) -> None:
    if not docs:
        raise RuntimeError(f"No documents provided for FAISS build: {out_dir}")

    safe_out_dir = _assert_dir_inside_base(out_dir, OUT_BASE)
    safe_out_dir.mkdir(parents=True, exist_ok=True)

    print(f"Encoding {len(docs)} documents for: {safe_out_dir}")
    doc_texts = [d.page_content for d in docs]
    vectors = embeddings.embed_documents(doc_texts)

    dim = len(vectors[0])
    index = faiss.IndexHNSWFlat(dim, HNSW_M)
    index.hnsw.efConstruction = EF_CONSTRUCTION
    index.hnsw.efSearch = EF_SEARCH

    index.add(np.array(vectors, dtype="float32"))

    store = FAISS(
        embedding_function=embeddings,
        index=index,
        docstore=InMemoryDocstore({i: docs[i] for i in range(len(docs))}),
        index_to_docstore_id={i: i for i in range(len(docs))},
        normalize_L2=True,
    )

    store.save_local(str(safe_out_dir))

    mapping = {docs[i].metadata.get("source_id", i): i for i in range(len(docs))}
    mapping_path = safe_out_dir / "source_id_to_idx.json"
    with mapping_path.open("w", encoding="utf-8") as f:
        json.dump(mapping, f, ensure_ascii=False)

    print(f"✅ Saved FAISS store to: {safe_out_dir}")
    print(f"   Docs: {len(docs)} | Dim: {dim} | M:{HNSW_M} | efC:{EF_CONSTRUCTION} | efS:{EF_SEARCH}")

def build_all_indexes():
    schema_cards = load_yaml_dir(SCHEMA_DIR)
    entity_cards = load_yaml_dir(ENTITY_DIR)

    print(f"Loaded schema cards: {len(schema_cards)}")
    print(f"Loaded entity cards: {len(entity_cards)}")

    schema_docs = build_schema_docs(schema_cards)
    entity_docs = build_entity_docs(entity_cards)

    print(f"Schema docs: {len(schema_docs)}")
    print(f"Entity docs: {len(entity_docs)}")

    embeddings = HuggingFaceEmbeddings(
        model_name=EMBED_MODEL_NAME,
        model_kwargs={"trust_remote_code": True},
        encode_kwargs={"normalize_embeddings": True, "batch_size": 128},
    )

    # Build separately
    build_faiss_store(schema_docs, embeddings, OUT_SCHEMA)
    build_faiss_store(entity_docs, embeddings, OUT_ENTITY)

    print("🎉 DONE — Built both schema + entity indexes")


if __name__ == "__main__":
    build_all_indexes()
