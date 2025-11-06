# imports
import os,glob,yaml,numpy as np
from langchain_community.vectorstores import FAISS
from langchain_core.documents import Document
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_ollama import OllamaEmbeddings
import faiss
from tqdm import tqdm
from time import time
from changai.changai.api.v2.text2sql_pipeline import get_settings

CONFIG=get_settings()
BASE=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/cards_v2"


#load yaml files from card folder
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
    # Flatten dicts like {"name": ["A. Williams", "A. W."]} -> "name=A. Williams,A. W."
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
    entity_type = md.get("entity", "").strip() or "Entity"
    filters = md.get("filters", "")
    name = md.get("id", "").strip()
    labels = md.get("labels", []) or []

    # Keep aliases short in text (full list stays in metadata)
    alias_sample = []
    for lbl in labels:
        if lbl and lbl != name and lbl not in alias_sample:
            alias_sample.append(lbl)
        if len(alias_sample) >= 4:
            break
    aliases_text = _md_serialize_labels(alias_sample)

    # Optional human-readable "appears in" from valid_for_tables
    appears = []
    for vt in md.get("valid_for_tables", []):
        t = vt.get("table", "")
        if not t:
            continue
        # Convert ERPNext table names to human labels (simple heuristics)
        if t.startswith("tab"):
            human = t.replace("tab", "").strip()
        else:
            human = t
        # De-duplicate while keeping order
        if human and human not in appears:
            appears.append(human)
    appears_in_text = _md_serialize_labels(appears[:6])

    # Build natural text WITHOUT filters/schema syntax
    parts = [
        f"[ENTITY] {entity_type}" if name else f"[ENTITY] {entity_type}",
        f"[FILTERS] {filters}"    ]
    # Remove empties and join into one line
    return _join(parts)

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
            "subtype": md.get("type", "alias"),
            "entity": md.get("entity"),
            "id": md.get("id"),
            "labels": md.get("labels", []),
            "typo_variants": md.get("typo_variants", []),
            "ngrams": md.get("ngrams", []),
            "examples": md.get("examples", []),
            "filters": md.get("filters", {}),
            "valid_for_tables": md.get("valid_for_tables", []),
            "match_strategy": md.get("match_strategy"),
            "fuzzy": md.get("fuzzy"),
            "confidence": md.get("confidence"),
            "context": md.get("context", {}),
            "tenant_id": md.get("tenant_id"),
            "notes": md.get("notes", ""),
            "description": md.get("description", "")
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

# Embedding Model Init
emb = OllamaEmbeddings(base_url=CONFIG['OLLAMA_URL'], model=CONFIG['EMBED_MODEL'])


# Create Vector Fiass Index
texts = [d.page_content for d in all_docs]
metas = [d.metadata for d in all_docs]
print(f"🚀 Generating index embeddings for {len(texts)} docs via Ollama...")

embeddings = []
for t in tqdm(texts, desc="Embedding"):
    try:
        vec = emb.embed_query(t)
        embeddings.append(vec)
    except Exception as e:
        print(f"❌ Error embedding doc: {e}")
        embeddings.append(np.zeros(len(embeddings[0]) if embeddings else 768))
embeddings = np.array(embeddings).astype("float32")

dim = embeddings.shape[1]
index = faiss.IndexHNSWFlat(dim, 32)   # 32 neighbors per node
index.hnsw.efConstruction = 200        # accuracy vs. build speed
index.hnsw.efSearch = 64               # accuracy vs. query speed
print("🏗️ Building HNSW index...")
index.add(embeddings)

vector_store = FAISS.from_texts(
    texts=texts,
    embedding=emb,
    metadatas=metas
)

vector_store.save_local(INDEX_PATH)
print(f"✅ HNSW FAISS index built and saved at: {INDEX_PATH}")
