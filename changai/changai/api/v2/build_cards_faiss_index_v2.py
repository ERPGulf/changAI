import os,glob,yaml,numpy as np
from langchain_community.vectorstores import FAISS
from langchain_core.documents import Document
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_ollama import OllamaEmbeddings
import faiss
import requests
from tqdm import tqdm
import einops
from time import time
from changai.changai.api.v2.text2sql_pipeline_v2 import get_settings

CONFIG=get_settings()
BASE=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/cards_v2"



class ReplicateEmbeddings:
    def __init__(self,api_url:str,version:str,api_token:str):
        self.api_url=api_url.rstrip("/")
        self.version=version
        self.api_token=api_token
    def _call_replicate(self,text:str) -> list[float]:
        payload = {
            "version": self.version,
            "input": {
                # match your Replicate model’s input schema
                "user_input": text
            }
        }
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_token}",
            "Prefer": "wait"
        }
        res = requests.post(self.api_url, json=payload, headers=headers, timeout=300)
        res.raise_for_status()
        data = res.json()
        # assuming your model returns the embedding list in data["output"]
        return data["output"]
    def embed_documents(self,texts:list[str])->list[list[float]]:
        return [self._call_replicate(t) for t in texts]

def load_yaml_dir(path):
  out=[]
  for fp in glob.glob(os.path.join(path,"*.yaml")):
    with open(fp,"r",encoding="utf-8") as f:
        doc = yaml.safe_load(f)
        if isinstance(doc, list):
            out.extend(doc)
        elif doc:
            out.append(doc)
  return out


def _join(parts, sep=" "):
    """Join non-empty trimmed parts with a separator."""
    return sep.join(p.strip() for p in parts if p and str(p).strip())

def _md_serialize_labels(labels):
    if not labels:
        return ""
    return ", ".join(map(str, labels))

def _md_serialize_filters(filters):
    if not filters:
        return ""
    parts = []
    for key, val in (filters or {}).items():
        if isinstance(val, (list, tuple)):
            parts.append(f"{key}=" + ",".join(map(str, val)))
        else:
            parts.append(f"{key}={val}")
    return "; ".join(parts)

def _md_valid_tables(valid_for_tables):
    if not valid_for_tables:
        return ""
    res = []
    for item in valid_for_tables:
        # safe access
        table = item.get("table", "")
        field = item.get("field", "")
        if table and field:
            res.append(f"{table}.{field}")
    return ", ".join(res)

# Build a compact, natural page_content for entity cards (best for embedding)
def _entity_page_content(md):
    # 1) If embedding_text is present, use it directly (best for embeddings)
    et = (md.get("embedding_text") or "").strip()
    if et:
        return et

    # 2) Fallback: build a reasonable sentence from fields
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

# Build Docs

schema_cards=load_yaml_dir(os.path.join(BASE,"schema"))
glossary_cards=load_yaml_dir(os.path.join(BASE,"glossary"))
metric_cards=load_yaml_dir(os.path.join(BASE,"metrics"))
permission_cards=load_yaml_dir(os.path.join(BASE,"permissions"))
enum_cards=load_yaml_dir(os.path.join(BASE,"enum"))
period_currency_cards=load_yaml_dir(os.path.join(BASE,"rules"))
join_cards=load_yaml_dir(os.path.join(BASE,"joins"))
masterdata_cards=load_yaml_dir(os.path.join(BASE,"entity"))

schema_docs,enum_docs,periods_docs,currency_docs=[],[],[],[]
metric_docs,master_docs,glossary_docs,join_docs=[],[],[],[]

def build_docs():
    docs = []
    # ------------- Tables -------------
    for sc in schema_cards:
        tname = sc["table"]
        syn_en = ", ".join(sc.get("synonyms_en", []) or [])
        desc   = sc.get("description", "") or ""
        notes  = sc.get("notes", [])
        notes  = " ".join(notes) if isinstance(notes, list) else (notes or "")

        # Table-level doc (compact; synonyms included)
        schema_docs.append({
            "text": _join([
                f"[TABLE] {tname}",
                f"[DESC] {desc}" if desc else "",
                f"[ALIAS_EN] {syn_en}" if syn_en else "",
                f"[NOTES] {notes}" if notes else "",
            ], sep=" | "),
            "metadata": {"type": "table", "table": tname}
        })

        # Field-level docs
        for f in sc.get("fields", []):
            fname = f.get("name", "UNKNOWN")
            ftype = f.get("type", "UNKNOWN")
            fdesc = f.get("description", "")
            syn_en = ", ".join(f.get("synonyms_en", []) or [])
            syn_ar = ", ".join(f.get("synonyms_ar", []) or [])
            role   = ", ".join(f.get("role", []) or [])

            schema_docs.append({
                "text": _join([
                    f"[FIELD] {fname} ({ftype})",
                    f"[TABLE] {tname}",
                    f"[DESC] {fdesc}" if fdesc else "",
                    f"[ROLE] {role}" if role else "",
                    f"[ALIAS_EN] {syn_en}" if syn_en else "",
                    f"[ALIAS_AR] {syn_ar}" if syn_ar else "",
                ], sep=" | "),
                "metadata": {
                    "type": "field",
                    "table": tname,
                    "field": fname,
                    "role": f.get("role", [])
                }
            })

    # ------------- Joins -------------
    for jc in join_cards:
        join_docs.append({
            "text": _join([
                f"[JOIN] {jc.get('from','')} → {jc.get('to','')}",
                f"[ON] {jc.get('on','')}",
                f"[TYPE] {jc.get('join_type','inner')}",
                f"[RELATIONSHIP] {jc.get('relationship','')}",
                f"[WHY] {jc.get('rationale','')}",
            ], sep=" | "),
            "metadata": {
                "type": "join",
                "from": jc.get("from"),
                "to": jc.get("to")
            }
        })

    # ------------- Glossary -------------
    for gl in glossary_cards:
        mp = gl.get("map", {}) or {}
        for k, targets in mp.items():
            target_str = ", ".join(targets or [])
            glossary_docs.append({
                "text": _join([f"[GLOSSARY_EN] {k}", f"[MAPS_TO] {target_str}"], sep=" | "),
                "metadata": {"type": "glossary", "lang": "en", "key": k, "targets": targets}
            })

    # ------------- Metrics -------------
    for mc in metric_cards:
        metric_docs.append({
            "text": _join([
                f"[METRIC] {mc['metric']}",
                f"[TABLE] {mc['table']}",
                f"[EXPR] {mc['expression']}",
                f"[DESC] {mc.get('description','')}"
            ], sep=" | "),
            "metadata": {"type": "metric", "name": mc["metric"], "table": mc["table"]}
        })

    # ------------- Enums -------------
    for ec in enum_cards:
        enum_docs.append({
            "text": _join([
                f"[ENUM] {ec['table']}.{ec['field']}",
                f"[VALUES] {', '.join(ec.get('values',[]))}"
            ], sep=" | "),
            "metadata": {"type": "enum", "table": ec["table"], "field": ec["field"]}
        })

    # ------------- Period / Currency rules -------------
    for pc in period_currency_cards:
        periods = pc.get("periods", {}) or {}
        for key, spec in periods.items():
            periods_docs.append({
                "text": _join([f"[PERIOD] {key}", f"[SQL] {spec.get('filter_sql','')}"], sep=" | "),
                "metadata": {"type": "period", "name": key}
            })
    for cc in period_currency_cards:
        currencies = cc.get("currencies", {}) or {}
        for key, mapping in currencies.items():
            currency_docs.append({
                "text": _join([f"[CURRENCY] {key}", f"[RULE] {mapping}"], sep=" | "),
                "metadata": {"type": "currency", "code": key}
            })

    # ------------- Masterdata (Entity cards) -------------
    for md in masterdata_cards:
        text = _entity_page_content(md)
        meta = {
            "type": "entity",
            "entity_type": md.get("entity_type"),
            "entity_id": md.get("entity_id"),
            "canonical_name": md.get("canonical_name"),
            "aliases": md.get("aliases", []),
            "misspellings": md.get("misspellings", []),
            "filters": md.get("filters", {}),
            # keep notes/description if you find them useful at runtime
            "description": md.get("description", ""),
        }

        master_docs.append({"text": text, "metadata": meta})


    return master_docs,schema_docs,enum_docs,glossary_docs,currency_docs,periods_docs,metric_docs,join_docs


master_docs, schema_docs, enum_docs, glossary_docs, currency_docs, periods_docs, metric_docs, join_docs = build_docs()

schema_docs=[Document(page_content=d["text"],metadata=d.get("metadata",{})) for d in schema_docs]
glossary_docs=[Document(page_content=d["text"],metadata=d.get("metadata",{})) for d in glossary_docs]
currency_docs=[Document(page_content=d["text"],metadata=d.get("metadata",{})) for d in currency_docs]
periods_docs=[Document(page_content=d["text"],metadata=d.get("metadata",{})) for d in periods_docs]
enum_docs=[Document(page_content=d["text"],metadata=d.get("metadata",{})) for d in enum_docs]
master_docs=[Document(page_content=d["text"],metadata=d.get("metadata",{})) for d in master_docs]
metric_docs=[Document(page_content=d["text"],metadata=d.get("metadata",{})) for d in metric_docs]
join_docs=[Document(page_content=d["text"],metadata=d.get("metadata",{})) for d in join_docs]

all_docs = (
    schema_docs + glossary_docs + currency_docs + periods_docs + 
    metric_docs + join_docs + master_docs + enum_docs
)

texts = [d.page_content for d in all_docs]
print(texts[:10])
metas = [d.metadata for d in all_docs]
print(metas[:10])
print(f"🚀 Generating index embeddings for {len(texts)} docs via Ollama...")

# emb = HuggingFaceEmbeddings(
#     model_name="nomic-ai/nomic-embed-text-v1.5",
#     model_kwargs={"trust_remote_code": True, "device": "cpu"}
# )

# vector_store = FAISS.from_texts(
#     texts=texts,
#     embedding=emb,
#     metadatas=metas
# )

# vector_store.save_local(INDEX_PATH)
# print(f"✅ HNSW FAISS index built and saved at: {INDEX_PATH}")

