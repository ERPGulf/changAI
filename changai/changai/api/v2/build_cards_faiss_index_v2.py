import json
import yaml
import numpy as np
import faiss
from pathlib import Path
from typing import List, Dict, Any

import frappe
from langchain_core.documents import Document
from langchain_community.docstore.in_memory import InMemoryDocstore
from langchain_community.vectorstores import FAISS
from changai.changai.api.v2.text2sql_pipeline_v2 import get_embedding_engine
import os

def get_base_fvs_dir() -> str:
    base = frappe.get_site_path("private", "changai", "fvs_stores", "erpnext")
    base_path = Path(base).resolve()
    base_path.mkdir(parents=True, exist_ok=True)
    return str(base_path)

BASE_FVS = get_base_fvs_dir()
TABLE_FVS_PATH  = os.path.join(BASE_FVS, "table_fvs")
SCHEMA_FVS_PATH = os.path.join(BASE_FVS, "schema_fvs")
ENTITY_FVS_PATH = os.path.join(BASE_FVS, "masterdata_fvs")
RAG_FOLDER = "Home/RAG Sources"
HNSW_M           = 32
EF_CONSTRUCTION  = 256
EF_SEARCH        = 64


def _read_file_doc(file_name: str, folder: str = RAG_FOLDER) -> str:
    """Read a file from Frappe File DocType and return its content as string."""
    file_id = frappe.db.get_value(
        "File",
        {"file_name": file_name, "folder": folder},
        "name",
    )
    if not file_id:
        frappe.throw(f"File not found in {folder}: {file_name}")

    doc = frappe.get_doc("File", file_id)
    content = doc.get_content() or ""
    if isinstance(content, bytes):
        content = content.decode("utf-8", errors="replace")
    return content


def _load_yaml_from_file_doc(file_name: str) -> Any:
    """Load a YAML file from Frappe File DocType."""
    content = _read_file_doc(file_name)
    return yaml.safe_load(content)


def _load_json_from_file_doc(file_name: str) -> Any:
    """Load a JSON file from Frappe File DocType."""
    content = _read_file_doc(file_name)
    try:
        return json.loads(content)
    except json.JSONDecodeError as e:
        frappe.throw(f"Invalid JSON in {file_name}: {e}")


def _assert_dir_inside_base(dir_path: str, base_dir: str) -> Path:
    base = Path(base_dir).resolve()
    d = Path(dir_path).resolve()
    if base != d and base not in d.parents:
        raise ValueError(f"Unsafe output dir (outside base): {d}")
    return d


def build_table_docs(table_list: List[str]) -> List[Document]:
    """
    Build one Document per table name from tables.json.
    tables.json is a flat list: ["tabSales Invoice", "tabPurchase Order", ...]
    """
    docs = []
    for table_name in table_list:
        if not isinstance(table_name, str) or not table_name.strip():
            continue
        docs.append(Document(
            page_content=f"[TABLE] {table_name}",
            metadata={
                "type": "table",
                "table": table_name,
            }
        ))
    return docs


def build_schema_docs(schema: List[Dict[str, Any]]) -> List[Document]:
    """
    Build field-level Documents from schema.yaml.
    One Document per field — same method as the notebook.
    """
    docs = []
    for t in schema.get("tables", []):
        if not isinstance(t, dict) or "table" not in t:
            continue

        table_name = t.get("table")
        module     = t.get("module", "")
        fields     = t.get("fields") or []

        for f in fields:
            field_name = f.get("name")
            field_desc = f.get("description", "") or ""
            join_hint  = f.get("join_hint") or ""
            options    = f.get("options") or ""

            if not field_name:
                continue

            metadata = {
                "type": "field",
                "table": table_name,
                "field": field_name,
                "module": module,
            }
            if options:
                metadata["options"] = options
            if join_hint:
                metadata["join_hint"] = join_hint

            page_content = (
                f"[FIELD] {field_name} | [TABLE] {table_name}\n{field_desc}"
            )
            if join_hint:
                page_content += f"\n{join_hint}"
            if options:
                page_content += f"\n{options}"

            docs.append(Document(
                page_content=page_content,
                metadata=metadata,
            ))

    return docs


def build_entity_docs(master_data: List[Dict[str, Any]]) -> List[Document]:
    """
    Build entity Documents from master_data.yaml.
    Uses embedding_text if present, else builds from canonical_name + aliases.
    """
    docs = []
    for md in master_data["data"]:
        if not isinstance(md, dict):
            continue

        # Use embedding_text if provided
        text = (md.get("embedding_text") or "").strip()

        if not text:
            entity_type  = (md.get("entity_type") or "entity").strip()
            canonical    = (md.get("canonical_name") or md.get("entity_id") or "").strip()
            aliases      = md.get("aliases") or []
            misspellings = md.get("misspellings") or []

            parts = []
            if canonical:
                parts.append(f"{entity_type.title()}: {canonical}")
            if aliases:
                parts.append(f"Also known as {', '.join(aliases)}")
            if misspellings:
                parts.append(f"Common misspellings: {', '.join(misspellings)}")

            text = ". ".join(parts)

        if not text:
            continue

        docs.append(Document(
            page_content=f"search_document: {text}",
            metadata={
                "type": "entity",
                "entity_type": md.get("entity_type"),
                "entity_id": md.get("entity_id"),
                "canonical_name": md.get("canonical_name"),
                "aliases": md.get("aliases", []),
                "description": md.get("description", ""),
            }
        ))

    return docs


# ──────────────────────────────────────────────
# FAISS Store Builder
# ──────────────────────────────────────────────
def _build_and_save_faiss(
    docs: List[Document],
    out_path: str,
    label: str,
) -> None:
    """Build a FAISS HNSW index from docs and save to disk."""

    if not docs:
        frappe.throw(f"No documents to index for: {label}")

    safe_path = _assert_dir_inside_base(out_path, BASE_FVS)
    safe_path.mkdir(parents=True, exist_ok=True)

    emb = get_embedding_engine()

    frappe.publish_progress(0, title=label, description=f"Embedding {len(docs)} documents...")

    doc_texts = [d.page_content for d in docs]
    vectors   = emb.embed_documents(doc_texts)

    dim   = len(vectors[0])
    index = faiss.IndexHNSWFlat(dim, HNSW_M)
    index.hnsw.efConstruction = EF_CONSTRUCTION
    index.hnsw.efSearch       = EF_SEARCH
    index.add(np.array(vectors, dtype="float32"))

    store = FAISS(
        embedding_function=emb,
        index=index,
        docstore=InMemoryDocstore({i: docs[i] for i in range(len(docs))}),
        index_to_docstore_id={i: i for i in range(len(docs))},
        normalize_L2=True,
    )
    store.save_local(str(safe_path))
    frappe.logger().info(f"[FVS] {label} — {len(docs)} docs | dim={dim} | path={safe_path}")


# ──────────────────────────────────────────────
# Main Entry Point
# ──────────────────────────────────────────────
@frappe.whitelist(allow_guest=False)
def build_all_fvs() -> Dict[str, Any]:
    """
    Enqueues 3 separate background jobs to build FAISS vector stores.
    """
    frappe.enqueue(
        "changai.changai.api.v2.build_cards_faiss_index_v2.build_table_fvs_job",
        queue="long",
        timeout=1800,
    )
    frappe.enqueue(
        "changai.changai.api.v2.build_cards_faiss_index_v2.build_schema_fvs_job",
        queue="long",
        timeout=1800,
    )
    frappe.enqueue(
        "changai.changai.api.v2.build_cards_faiss_index_v2.build_master_data_fvs_job",
        queue="long",
        timeout=1800,
    )
    return {
        "status": "enqueued",
        "message": "All 3 FVS build jobs have been queued. Check Error Logs for progress.",
    }


def build_table_fvs_job():
    try:
        tables_list = _load_json_from_file_doc("tables.json")
        table_docs = build_table_docs(tables_list)
        _build_and_save_faiss(table_docs, TABLE_FVS_PATH, "ERPNext Table FVS")
        frappe.logger().info(f"ERPNext Table FVS built: {len(table_docs)} docs")
    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "Build Table FVS Failed")


def build_schema_fvs_job():
    try:
        schema = _load_yaml_from_file_doc("schema.yaml")
        schema_docs = build_schema_docs(schema)
        _build_and_save_faiss(schema_docs, SCHEMA_FVS_PATH, "ERPNext Schema FVS")
        frappe.logger().info(f"ERPNext Schema FVS built: {len(schema_docs)} docs")
    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "Build Schema FVS Failed")


def build_master_data_fvs_job():
    try:
        master_data = _load_yaml_from_file_doc("master_data.yaml")
        entity_docs = build_entity_docs(master_data)
        _build_and_save_faiss(entity_docs, ENTITY_FVS_PATH, "ERPNext Master Data FVS")
        frappe.logger().info(f"ERPNext Master Data FVS built: {len(entity_docs)} docs")
    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "Build Master Data FVS Failed")
