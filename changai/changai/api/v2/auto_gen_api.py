from __future__ import annotations
from typing import Any, Dict, List, Optional, Set
import datetime
import gc
import json
import os
import time
from typing import List, Dict, Any, Optional
from sentence_transformers import SentenceTransformer
from langchain_community.vectorstores import FAISS
from langchain_core.embeddings import Embeddings
import yaml
import frappe
from frappe import _
from frappe.utils import now_datetime, add_to_date
from anthropic import Anthropic
import openai
import math
from pathlib import Path
from frappe.utils.file_manager import get_file
from changai.changai.api.v2.text2sql_pipeline_v2 import call_gemini

def safe_path_in_dir(base_dir: str, filename: str) -> str:
    """
    Build a safe path inside base_dir using only a filename (no folders).
    Prevents ../ traversal.
    """
    base_dir_abs = os.path.abspath(base_dir)
    filename_only = os.path.basename(filename)
    full = os.path.abspath(os.path.join(base_dir_abs, filename_only))
    if not full.startswith(base_dir_abs + os.sep):
        raise frappe.ValidationError(_("Invalid file path"))
    return full


def _get_data_dir() -> str:
    d = frappe.get_app_path("changai", "changai", "api", "v2", "data")
    os.makedirs(d, exist_ok=True)
    return d


def _path(name: str) -> str:
    return safe_path_in_dir(_get_data_dir(), name)


TABLES_JSON = "tables.json"
SCHEMA_YAML = "schema.yaml"
TRAIN_JOSNL="training_data.jsonl"
META_SCHEMA_YAML = "meta_schema.yaml"

IGNORED_FIELDTYPES: Set[str] = {
    "Section Break", "Column Break", "Tab Break", "Page Break", "Table Break",
    "Fold", "Heading", "HTML", "HTML Editor", "Text Editor", "Markdown Editor",
    "Code", "Button", "Attach", "Attach Image", "Image", "Signature", "Icon", "Barcode",
}


def _load_yaml(filename: str) -> Dict[str, Any]:
    path = _path(filename)
    try:
        with open(path, "r", encoding="utf-8") as f:
            obj = yaml.safe_load(f) or {}
        return obj if isinstance(obj, dict) else {}
    except FileNotFoundError:
        return {}
    except Exception:
        return {}


def _save_yaml(filename: str, obj: Dict[str, Any]) -> None:
    """
    Atomic write to prevent corruption.
    """
    path = _path(filename)
    tmp = f"{path}.tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        yaml.safe_dump(obj, f, sort_keys=False, allow_unicode=True)
    os.replace(tmp, path)


def _load_json_list(filename: str) -> List[str]:
    path = _path(filename)
    try:
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)
        return data if isinstance(data, list) else []
    except FileNotFoundError:
        return []
    except Exception:
        return []


def _save_json_list(filename: str, items: List[str]) -> None:
    path = _path(filename)
    tmp = f"{path}.tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(items, f, ensure_ascii=False, indent=2)
    os.replace(tmp, path)


def _field_dict(df) -> Dict[str, Any]:
    return {
        "name": df.fieldname,
        "description": (df.description or "").strip(),
        "type": df.fieldtype,
        "options": df.options,
    }


def _tab(dt: str) -> str:
    dt = (dt or "").strip()
    return f"tab{dt}"


def _strip_tab(t: str) -> str:
    t = (t or "").strip()
    return t[3:] if t.startswith("tab") else t


@frappe.whitelist(allow_guest=False)
def sync_master_data_smart() -> Dict[str, Any]:
    file_name = "master_data.yaml"
    existing = frappe.db.get_value("File", {
        "file_name": file_name,
        "folder": "Home/RAG Sources"
    }, "name")
    if existing:
        file_doc = frappe.get_doc("File", existing)
        payload = yaml.safe_load(file_doc.get_content()) or {}
    else:
        payload = {}
    meta = payload.get("_meta") or {}
    data = payload.get("data") or []
    if not isinstance(meta, dict):
        meta = {}
    if not isinstance(data, list):
        data = []
    last_sync = meta.get("last_sync")
    existing_keys: Set[tuple] = set()
    for row in data:
        if isinstance(row, dict):
            dt = row.get("entity_type")
            eid = row.get("entity_id")
            if dt and eid:
                existing_keys.add((dt, eid)) 
    modules = ["Customer", "Item", "Currency", "Supplier"]
    base_filters: Dict[str, Any] = {}
    if last_sync:
        base_filters = {"creation": [">", last_sync]}
    added_total = 0
    added_by_module: Dict[str, int] = {}
    fetched_by_module: Dict[str, int] = {}
    for mod in modules:
        entity_type = f"tab{mod}"
        records = frappe.get_all(mod, filters=base_filters, fields=["name"])
        fetched_by_module[mod] = len(records)
        added_count = 0
        for rec in records:
            key = (entity_type, rec.name)
            if key in existing_keys:
                continue
            data.append({
                "entity_type": entity_type,
                "entity_id": rec.name,
                "filters": {"field": "name", "value": rec.name},
            })
            existing_keys.add(key)
            added_count += 1
            added_total += 1

        added_by_module[mod] = added_count
    meta["last_sync"] = str(now_datetime())
    payload_out = {"_meta": meta, "data": data}
    yaml_content = yaml.dump(payload_out, allow_unicode=True, sort_keys=False).encode("utf-8")
    if existing:
        file_doc.content = yaml_content
        file_doc.save(ignore_permissions=True)
    else:
        file_doc = frappe.get_doc({
            "doctype": "File",
            "file_name": file_name,
            "is_private": 0,
            "content": yaml_content,
            "folder": "Home/RAG Sources"
        }).insert(ignore_permissions=True)
    msg = (
        _("Sync complete ✅ Added {0} new records.").format(added_total)
        if added_total
        else _("Sync complete ✅ No new records to add.")
    )
    return {
        "ok": True,
        "message": msg,
        "added_total": added_total,
        "added_by_module": added_by_module,
        "fetched_by_module": fetched_by_module,
        "last_sync_used": last_sync or "FIRST_RUN(full_fetch)",
        "new_last_sync": meta["last_sync"],
        "file_url": file_doc.file_url,
    }

@frappe.whitelist(allow_guest=False)
def get_doctypes_changed_since(last_sync: Optional[str]) -> List[str]:
    SKIP_MODULES = {"Core", "Custom", "Website", "Desk", "Email", "Integration", "Automation", "Workflow", ""}

    filters: Dict[str, Any] = {
        "module": ["in", erpnext_modules],
        "issingle": 0,
        "is_virtual": 0,
    }

    if last_sync:
        try:
            since = add_to_date(last_sync, minutes=-2)
            filters["modified"] = [">=", since]
        except Exception:
            pass

    return frappe.get_all("DocType", filters=filters, pluck="name")


@frappe.whitelist(allow_guest=False)
def sync_tables_and_schema_smart() -> Dict[str, Any]:
    schema_file_name = "schema.yaml"
    tables_file_name = "tables.json"
    schema_existing = frappe.db.get_value("File", {
        "file_name": schema_file_name,
        "folder": "Home/RAG Sources"
    }, "name")
    if schema_existing:
        schema_file_doc = frappe.get_doc("File", schema_existing)
        payload = yaml.safe_load(schema_file_doc.get_content()) or {}
    else:
        payload = {}

    meta = payload.get("_meta") or {}
    tables_blocks = payload.get("tables") or []
    if not isinstance(tables_blocks, list):
        tables_blocks = []

    # Load existing tables.json
    tables_existing = frappe.db.get_value("File", {
        "file_name": tables_file_name,
        "folder": "Home/RAG Sources"
    }, "name")
    if tables_existing:
        tables_file_doc = frappe.get_doc("File", tables_existing)
        existing_tables = json.loads(tables_file_doc.get_content() or "[]")
    else:
        existing_tables = []

    by_table = {
        b.get("table"): b
        for b in tables_blocks
        if isinstance(b, dict) and b.get("table")
    }
    last_sync_raw = meta.get("last_doctype_sync")
    changed_doctypes = get_doctypes_changed_since(last_sync_raw)
    changed_tables = set(_tab(dt) for dt in changed_doctypes)
    missing_from_schema = set(t for t in existing_tables if t not in by_table)

    # Combine changed + missing — these are all tables to process
    tables_to_process = sorted(changed_tables | missing_from_schema)

    if not tables_to_process:
        return {"ok": True, "message": _("No changes detected")}

    merged_tables = sorted(set(existing_tables) | changed_tables)

    # Loop over tables to process
    for table in tables_to_process:
        dt = _strip_tab(table)
        if not frappe.db.exists("DocType", dt):
            continue

        frappe.clear_cache(doctype=dt)
        meta_dt = frappe.get_meta(dt)

        # Build existing fields lookup ONCE per table
        existing_fields = {}
        if table in by_table:
            existing_fields = {
                ef.get("name"): ef
                for ef in by_table[table].get("fields", [])
                if isinstance(ef, dict)
            }

        # Build fields list from meta
        fields = []
        for f in meta_dt.fields:
            if not f.fieldname:
                continue
            existing_desc = existing_fields.get(f.fieldname, {}).get("description", "")
            fields.append({
                "name": f.fieldname,
                "fieldtype": f.fieldtype,
                "label": f.label or "",
                "description": existing_desc
            })

        # Update existing block or create new one
        if table in by_table:
            by_table[table]["fields"] = fields
            by_table[table]["desc_done"] = False
        else:
            by_table[table] = {
                "table": table,
                "description": "",
                "fields": fields,
                "desc_done": False
            }

    # Rebuild tables_blocks from updated by_table
    tables_blocks = list(by_table.values())

    # Update meta and save schema.yaml
    meta["last_doctype_sync"] = str(now_datetime())
    _save_yaml(SCHEMA_YAML, {"_meta": meta, "tables": tables_blocks})

    # Save tables.json
    if tables_existing:
        tables_file_doc.content = json.dumps(merged_tables, indent=2)
        tables_file_doc.save(ignore_permissions=True)
    else:
        frappe.get_doc({
            "doctype": "File",
            "file_name": tables_file_name,
            "folder": "Home/RAG Sources",
            "content": json.dumps(merged_tables, indent=2),
            "is_private": 0
        }).insert(ignore_permissions=True)

    frappe.db.commit()

    return {
        "ok": True,
        "changed_tables": len(changed_tables),
        "missing_added": len(missing_from_schema),
        "total_tables": len(merged_tables),
        "message": f"Synced {len(changed_tables)} changed + {len(missing_from_schema)} new tables"
    }


@frappe.whitelist(allow_guest=False)
def _get_claude_client() -> Optional[Anthropic]:
    settings = frappe.get_single("ChangAI Settings")
    api_key = None
    try:
        api_key = settings.get_password("claude_api_key")
    except Exception:
        api_key = None

    if not api_key:
        api_key = os.getenv("ANTHROPIC_API_KEY")

    if not api_key:
        frappe.logger().error("Claude API key missing. Set ChangAI Settings claude_api_key or env ANTHROPIC_API_KEY.")
        return None

    return Anthropic(api_key=api_key)


def _extract_json_object(text: str) -> Optional[Dict[str, Any]]:
    if not text or not str(text).strip():
        return None
    text = str(text).strip()

    try:
        obj = json.loads(text)
        return obj if isinstance(obj, dict) else None
    except Exception:
        pass

    start = text.find("{")
    end = text.rfind("}")
    if start != -1 and end != -1 and end > start:
        candidate = text[start:end + 1]
        try:
            obj = json.loads(candidate)
            return obj if isinstance(obj, dict) else None
        except Exception:
            return None

    return None


def _smart_desc_map(client: Optional[Anthropic], table_name: str, fields: List[Dict[str, Any]]) -> Dict[str, str]:
    if not client:
        return {}

    field_names = [f.get("name") for f in fields if isinstance(f, dict) and f.get("name")]
    if not field_names:
        return {}

    prompt = f"""
Generate SHORT, HIGH-SIGNAL ERP field descriptions for embedding retrieval.

Table: {table_name}

Rules:
- Do NOT rename fields.
- 1 sentence per field.
- Focus on WHEN/WHY this field is used in business questions.
- Output ONLY JSON object: {{"field_name": "description"}}

Fields:
{json.dumps(field_names, ensure_ascii=False)}
""".strip()

    for attempt in range(3):
        try:
            msg = client.messages.create(
                model="claude-sonnet-4-5",
                max_tokens=500,
                temperature=0.2,
                system="Return ONLY a JSON object. No markdown. No extra text.",
                messages=[{"role": "user", "content": prompt}],
                timeout=180,
            )

            text_parts: List[str] = []
            for b in getattr(msg, "content", []) or []:
                if getattr(b, "type", None) == "text" and getattr(b, "text", None):
                    text_parts.append(b.text)

            text = "\n".join(text_parts).strip()
            parsed = _extract_json_object(text)

            if isinstance(parsed, dict):
                out: Dict[str, str] = {}
                for k, v in parsed.items():
                    if isinstance(k, str) and isinstance(v, str) and k.strip() and v.strip():
                        out[k.strip()] = v.strip()
                return out

            frappe.logger().warning(
                f"Claude returned non-JSON table={table_name} attempt={attempt+1} preview={text[:200]!r}"
            )
            time.sleep(2 * (attempt + 1))

        except Exception as e:
            frappe.logger().error(f"Claude error table={table_name} attempt={attempt+1}: {e}")
            time.sleep(2 * (attempt + 1))

    return {}

@frappe.whitelist(allow_guest=False)
def fill_missing_field_descriptions(
    batch_size: int = 15,         
    max_tables: int = 0,
    checkpoint_every_table: int = 10,
) -> Dict[str, Any]:
    payload = _load_yaml(SCHEMA_YAML)
    meta = payload.get("_meta") or {}
    tables_blocks = payload.get("tables") or []

    if not isinstance(tables_blocks, list):
        return {"ok": False, "message": _("schema.yaml invalid")}

    client = _get_openai_client()
    if not client:
        return {"ok": False, "message": _("OpenAI API key missing")}

    # Stats tracking
    updated_tables = 0
    updated_fields = 0
    processed_updated_tables = 0
    tables_since_last_save = 0
    consecutive_errors = 0 

    for block in tables_blocks:
        # Prevent Memory Bloat: Clear Frappe caches every iteration
        frappe.local.meta_cache = {}
        if hasattr(frappe.local, 'docs'): frappe.local.docs = {}
        
        if not isinstance(block, dict) or block.get("desc_done"):
            continue

        table = block.get("table")
        fields = block.get("fields") or []
        
        pending_fields = [
            f for f in fields
            if isinstance(f, dict) and f.get("name") and not (f.get("description") or "").strip()
        ]
        
        if not pending_fields:
            block["desc_done"] = True
            continue

        updated_in_table = 0
        try:
            for i in range(0, len(pending_fields), batch_size):
                batch = pending_fields[i:i + batch_size]
                desc_map = _smart_desc_map(client, table, batch)
                
                if not desc_map:
                    consecutive_errors += 1
                    continue
                
                consecutive_errors = 0 # Reset on success
                for f in batch:
                    fn = f.get("name")
                    if fn in desc_map:
                        f["description"] = desc_map[fn].strip()
                        updated_fields += 1
                        updated_in_table += 1
                
                # DB Heartbeat: keep the SQL connection alive
                frappe.db.commit()

        except Exception as e:
            frappe.logger().error(f"Critical error in table {table}: {e}")
            consecutive_errors += 1

        if updated_in_table:
            updated_tables += 1
            processed_updated_tables += 1
            tables_since_last_save += 1
            # Mark table as done if no empty descriptions remain
            block["desc_done"] = not any(isinstance(x, dict) and not (x.get("description") or "").strip() for x in block.get("fields", []))

        # Checkpoint: Save to disk every X tables
        if tables_since_last_save >= checkpoint_every_table:
            _save_yaml(SCHEMA_YAML, {"_meta": meta, "tables": tables_blocks})
            tables_since_last_save = 0
            gc.collect() # Garbage collection

        # Safety: If API fails 5 times in a row, stop to save credits/time
        if consecutive_errors > 5:
            frappe.logger().error("Stopping job: Too many consecutive API errors.")
            break

        if max_tables and processed_updated_tables >= max_tables:
            break

    # Final Save and cleanup
    meta["last_desc_sync"] = str(now_datetime())
    _save_yaml(SCHEMA_YAML, {"_meta": meta, "tables": tables_blocks})
    frappe.db.commit()

    return {
        "ok": True,
        "tables_updated": updated_tables,
        "fields_updated": updated_fields,
        "status": "Complete" if consecutive_errors <= 5 else "Partial Failure"
    }

@frappe.whitelist()
def sync_schema_and_enqueue_descriptions() -> Dict[str, Any]:
    sync_tables_and_schema_smart()
    frappe.enqueue(
        "changai.changai.api.v2.auto_gen_api.fill_missing_field_descriptions",
        queue="long",
        timeout=14400,
    )
    return {"ok": True, "message": _("Schema updated ✅ Field descriptions running in background 🧠")}


def _smart_desc_map(client, table_name: str, fields: List[Dict[str, Any]]) -> Dict[str, str]:
    if not client:
        return {}

    field_names = [f.get("name") for f in fields if isinstance(f, dict) and f.get("name")]
    if not field_names:
        return {}

    prompt = f"""
Generate SHORT, HIGH-SIGNAL ERP field descriptions for embedding retrieval.

Table: {table_name}

Rules:
- Do NOT rename fields.
- 1 sentence per field.
- Focus on WHEN/WHY this field is used in business questions.
- Output ONLY JSON object: {{"field_name": "description"}}

Fields:
{json.dumps(field_names, ensure_ascii=False)}
""".strip()

    for attempt in range(3):
        try:
            response = client.chat.completions.create(
                model="gpt-4o-mini",   # fast + cheap + stable
                messages=[
                    {"role": "system", "content": "Return ONLY a valid JSON object. No markdown. No extra text."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.2,
                max_tokens=800,
                timeout=180,
            )

            text = response.choices[0].message.content.strip()

            parsed = _extract_json_object(text)

            if isinstance(parsed, dict):
                out: Dict[str, str] = {}
                for k, v in parsed.items():
                    if isinstance(k, str) and isinstance(v, str) and k.strip() and v.strip():
                        out[k.strip()] = v.strip()
                return out

            frappe.logger().warning(
                f"OpenAI returned non-JSON table={table_name} attempt={attempt+1} preview={text[:200]!r}"
            )
            time.sleep(2 * (attempt + 1))

        except Exception as e:
            frappe.logger().error(f"OpenAI error table={table_name} attempt={attempt+1}: {e}")
            time.sleep(2 * (attempt + 1))

    return {}
def _get_training_data_dir() -> str:
    d = frappe.get_app_path("changai", "changai", "api", "v2", "data", "training_data")
    os.makedirs(d, exist_ok=True)
    return d


def _training_file_path(module_name: str) -> str:
    filename = f"{(module_name or '').lower()}_training_data.jsonl"
    return safe_path_in_dir(_get_training_data_dir(), filename)


@frappe.whitelist(allow_guest=True)
def build_schema_context_for_module(module_name: str) -> str:
    """
    Build minimal strict schema context:
    Only table name + field names.
    """

    payload = _load_yaml(SCHEMA_YAML)
    tables_blocks = payload.get("tables") or []

    doctypes = frappe.get_all(
        "DocType",
        filters={"module": module_name},
        pluck="name"
    ) or []

    allowed_tables = {f"tab{dt}" for dt in doctypes}

    lines = []

    for b in tables_blocks:
        if not isinstance(b, dict):
            continue

        table = b.get("table")
        if table not in allowed_tables:
            continue

        fields = b.get("fields") or []
        field_names = [
            f["name"]
            for f in fields
            if isinstance(f, dict) and f.get("name")
        ]

        lines.append(
            f"{table}: {', '.join(field_names)}"
        )

    return "\n".join(lines)


# ---------------------------------------------------------
# Validation prompt (generalized, non-memorized)
# ---------------------------------------------------------
def _validation_prompt(module_name: str, schema_context: str) -> str:
    return f"""
You are generating VALIDATION data for an ERP schema-retrieval model.

PURPOSE:
This data is used ONLY to test generalization.
The questions must feel natural, real-world, and non-repetitive.
Do NOT mimic training data patterns.

OUTPUT FORMAT (STRICT):
- JSONL only
- One JSON object per line
- Format:
  {{"gid":"{module_name}","sentence1":"...","sentence2":"...","label":1.0}}

QUESTION RULES:
- Business users only (no technical words)
- Short to medium length
- Paraphrased, generalized intent
- Avoid exact metrics or rigid phrasing
- Think how a DIFFERENT user might ask the same thing

SCHEMA RULES (STRICT):
- Use ONLY tables and fields listed below
- Do NOT invent anything
- If a question cannot be answered using schema, skip it

SCHEMA CONTEXT:
{schema_context}

sentence2 FORMAT:
- Table:
  "[TABLE] tabDoctype | desc: 2–3 sentences (WHAT + WHY)"
- Field:
  "[FIELD] fieldname | [TABLE] tabDoctype | desc: 2–3 sentences (WHAT + WHY)"

DESCRIPTION RULE:
- Explain relevance lightly
- Do NOT sound instructional
- For negatives: explain why it looks relevant but is not required

FINAL RULES:
- Do NOT repeat question styles
- Do NOT mention training, validation, or schema
- Return ONLY JSONL
""".strip()


# ---------------------------------------------------------
# Validation file path
# ---------------------------------------------------------
def _validation_file_path(module_name: str) -> str:
    filename = f"{(module_name or '').lower()}_validation_data.jsonl"
    return safe_path_in_dir(_get_training_data_dir(), filename)


# ---------------------------------------------------------
# Main validation generator
# ---------------------------------------------------------
@frappe.whitelist()
def generate_validation_data(module_name: str):
    settings = frappe.get_single("ChangAI Settings")

    total_records = int(settings.no_of_records or 0)
    if total_records <= 0:
        frappe.throw("no_of_records must be greater than 0")

    validation_count = max(1, math.ceil(total_records * 0.2))

    schema_context = build_schema_context_for_module(module_name)
    if not schema_context:
        return {
            "ok": False,
            "message": f"No schema context found for module '{module_name}'"
        }

    prompt = _validation_prompt(module_name, schema_context)

    client = _get_claude_client()
    output_file = _validation_file_path(module_name)

    resp = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=6000,
        temperature=0.6,
        messages=[
            {
                "role": "user",
                "content": prompt
            }
        ]
    )

    text = (resp.content[0].text or "").strip()
    lines = [ln.strip() for ln in text.splitlines() if ln.strip()]

    written = 0
    unique_questions = set()

    with open(output_file, "a", encoding="utf-8") as f:
        for ln in lines:
            try:
                obj = json.loads(ln)
            except Exception:
                continue

            q = (obj.get("sentence1") or "").strip()
            s2 = (obj.get("sentence2") or "").strip()

            if not q or not s2:
                continue

            if q in unique_questions:
                continue

            f.write(json.dumps(obj, ensure_ascii=False) + "\n")
            unique_questions.add(q)
            written += 1

            if written >= validation_count:
                break

    frappe.db.commit()

    return {
        "ok": True,
        "module": module_name,
        "validation_target": validation_count,
        "lines_written": written,
        "file": output_file
    }


def to_pos_int(x, default: int = 20, name: str = "value") -> int:
    try:
        v = int(x)
    except (TypeError, ValueError):
        v = default
    if v <= 0:
        raise ValueError(f"{name} must be > 0 (got {v})")
    return v

def extract_table(doc) -> Optional[str]:
    md = doc.metadata or {}
    for key in ("table", "doctype", "doc_type", "name"):
        if md.get(key):
            return md.get(key)

    txt = (doc.page_content or "").strip()
    if txt.startswith("[TABLE] "):
        # "[TABLE] tabSales Invoice | desc: ..."
        after = txt[len("[TABLE] "):]
        return after.split("|")[0].strip()
    if txt.startswith("TABLE "):
        parts = txt.split()
        return parts[1].strip() if len(parts) > 1 else None
    if txt.startswith("tab"):
        return txt.split("|")[0].strip()

    return None

def topk_tables(vs: FAISS, q: str, k: int = 20) -> List[str]:
    k = to_pos_int(k, default=20, name="topk")
    hits = vs.similarity_search(q, k=k)
    out = []
    for h in hits:
        t = extract_table(h)
        if t:
            out.append(t)
    return out

@frappe.whitelist(allow_guest=True)
def test_model(
    module_name:str,
) -> Dict[str, Any]:
    topk = 20
    topk = to_pos_int(topk, default=20, name="topk")
    questions_file_path= f"/files/{module_name}_test.jsonl"
    model_path= "hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned"
    file_doc = frappe.get_doc("File", {"file_url": questions_file_path})
    abs_path = file_doc.get_full_path()
    with open(abs_path, "r", encoding="utf-8") as f:
        data = [json.loads(line) for line in f if line.strip()]
    faiss_doc = frappe.get_doc("File", {"file_name": "index.faiss"})
    fvs_abs_path = os.path.dirname(faiss_doc.get_full_path())
    emb = STEmbeddings(model_path)
    vs = FAISS.load_local(fvs_abs_path, emb, allow_dangerous_deserialization=True)
    total = correct = skipped = 0
    wrong = []
    for row in data:
        q = (row.get("question") or "").strip()
        exp = (row.get("expected_top1") or "").strip()
        if not q or not exp:
            skipped += 1
            continue
        total += 1
        top_tables = topk_tables(vs, q, k=topk)
        pred_top1 = top_tables[0] if top_tables else None
        is_correct = exp in top_tables[:topk]
        if is_correct:
            correct += 1
        else:
            wrong.append({
                "question": q,
                "expected_top1": exp,
                "pred_top1": pred_top1,
                "top_tables": top_tables[:topk],
            })
    file_name = f"{module_name}_test.jsonl"
    wrong_content = "\n".join(json.dumps(row) for row in wrong)
    existing = frappe.db.get_value("File", {
    "file_name": ("like", f"{module_name}_test%.jsonl"),
    "folder": "Home/Test Results"
}, "name")
    if existing:
        frappe.delete_doc("File", existing, ignore_permissions=True)
    wrong_file_doc = frappe.get_doc({
            "doctype": "File",
            "file_name": file_name,
            "is_private": 0,
            "content": wrong_content,
            "folder": "Home/Test Results"
        }).insert(ignore_permissions=True)

    return {
        "total_evaluated": total,
        "correct": correct,
        "wrong": len(wrong),
        "skipped_missing_fields": skipped,
        "accuracy": round((correct / total) if total else 0.0, 4),
        "wrong_predictions": {
            "count": len(wrong),
            "file_name": wrong_file_doc.name,
            "file_url": wrong_file_doc.file_url,
        },
    }
