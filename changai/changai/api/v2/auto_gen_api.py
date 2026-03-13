from __future__ import annotations
from typing import Any, Dict, List, Optional, Set
import datetime
import gc
import json
import os
import time
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
from changai.changai.api.v2.train_data_api import _get_openai_client

RAG_FOLDER = "Home/RAG Sources"
erpnext_modules = [
    "Selling",
    "Stock",
    "Buying",
    "Assets",
    "Accounts",
    "CRM",
    "Projects",
    "Manufacturing",
    "Support",
    "Subcontracting",
    "Quality Management",
    "Regional",
    "Maintenance",
]


IGNORED_FIELDTYPES: Set[str] = {
    "Section Break", "Column Break", "Tab Break", "Page Break", "Table Break",
    "Fold", "Heading", "HTML", "HTML Editor", "Text Editor", "Markdown Editor",
    "Code", "Button", "Attach", "Attach Image", "Image", "Signature", "Icon", "Barcode",
}


def _get_file_doc_by_name(file_name: str, folder: str = RAG_FOLDER) -> Optional["frappe.model.document.Document"]:
    file_id = frappe.db.get_value("File", {"file_name": file_name, "folder": folder}, "name")
    if not file_id:
        return None
    return frappe.get_doc("File", file_id)


def _read_filedoctype(file_name: str, folder: str = RAG_FOLDER):
    doc = _get_file_doc_by_name(file_name, folder)
    if not doc:
        if file_name.endswith(".json"):
            return []
        if file_name.endswith((".yaml", ".yml")):
            return {}
        return ""
    raw = doc.get_content() or ""
    if isinstance(raw, bytes):
        raw = raw.decode("utf-8", errors="replace")
    if file_name.endswith(".json"):
        return json.loads(raw or "[]")
    if file_name.endswith((".yaml", ".yml")):
        obj = yaml.safe_load(raw) or {}
        return obj if isinstance(obj, dict) else {}
    return raw

def write_filedoctype(
    file_name: str,
    payload,
    folder: str = "Home/RAG Sources",
    is_private: int = 0
):
    if file_name.endswith(".json"):
        text = json.dumps(payload, ensure_ascii=False, indent=2)

    elif file_name.endswith((".yaml", ".yml")):
        text = yaml.safe_dump(payload, allow_unicode=True, sort_keys=False)

    else:
        text = str(payload)

    content = text.encode("utf-8")

    existing = frappe.db.get_value(
        "File",
        {"file_name": file_name, "folder": folder},
        "name"
    )

    if existing:
        doc = frappe.get_doc("File", existing)
        frappe.logger().info(f"Overwriting {file_name} → file_url={doc.file_url}")
        doc.save_file(content=content, overwrite=True)
        doc.reload()
        frappe.logger().info(f"Done overwriting {file_name}")
        return doc
    else:
        doc = frappe.get_doc({
            "doctype": "File",
            "file_name": file_name,
            "folder": folder,
            "is_private": is_private,
            "content": content,
        }).insert(ignore_permissions=True)
        return doc
def _tab(dt: str) -> str:
    dt = (dt or "").strip()
    return f"tab{dt}"


def _strip_tab(t: str) -> str:
    t = (t or "").strip()
    return t[3:] if t.startswith("tab") else t


@frappe.whitelist(allow_guest=False)
def sync_master_data_smart() -> Dict[str, Any]:
    file_name = "master_data.yaml"
    payload = _read_filedoctype(file_name,RAG_FOLDER)
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
    file_doc = write_filedoctype(file_name, payload_out, folder=RAG_FOLDER)
    frappe.db.commit()  # nosemgrep: frappe-manual-commit - explicit commit required to persist File DocType write immediately after master data sync
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
    filters: Dict[str, Any] = {
        "module": ["in", erpnext_modules],
        "issingle": 0,
        "is_virtual": 0,
    }
    if last_sync:
        try:
            since = add_to_date(last_sync, minutes=-2)
            filters["modified"] = [">=", since]  # catches updated tables
        except Exception:
            pass

    results = frappe.get_all("DocType", filters=filters, pluck="name")

    # Also catch newly created DocTypes since last sync
    if last_sync:
        try:
            since = add_to_date(last_sync, minutes=-2)
            new_doctypes = frappe.get_all(
                "DocType",
                filters={
                    "module": ["in", erpnext_modules],
                    "issingle": 0,
                    "is_virtual": 0,
                    "creation": [">=", since],
                },
                pluck="name",
            )
            results = list(set(results) | set(new_doctypes))
        except Exception:
            pass

    return results

@frappe.whitelist(allow_guest=False)
def sync_tables_and_schema_smart() -> Dict[str, Any]:
    schema_file_name = "schema.yaml"
    tables_file_name = "tables.json"
    payload = _read_filedoctype(schema_file_name,RAG_FOLDER)
    meta = payload.get("_meta") or {}
    tables_blocks = payload.get("tables") or []
    if not isinstance(tables_blocks, list):
        tables_blocks = []
    existing_tables = _read_filedoctype(tables_file_name,RAG_FOLDER)
    if not isinstance(existing_tables, list):
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
    new_from_changed = set(t for t in changed_tables if t not in by_table and t not in set(existing_tables))
    tables_to_process = sorted(changed_tables | missing_from_schema | new_from_changed)
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
    tables_blocks = list(by_table.values())
    meta["last_doctype_sync"] = str(now_datetime())
    try:
        write_filedoctype("schema.yaml", {"_meta": meta, "tables": tables_blocks}, folder=RAG_FOLDER)
        write_filedoctype("tables.json", merged_tables, folder=RAG_FOLDER)
    except Exception as e:
        return {
            "error":str(e)
        }
    frappe.db.commit()  # nosemgrep: frappe-manual-commit - explicit commit required to persist schema/table sync changes to File DocType
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
    payload = _read_filedoctype("schema.yaml")
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

        # ✅ FIX: don't blindly trust desc_done — re-check actual pending fields
        if not isinstance(block, dict):
            continue

        table = block.get("table")
        fields = block.get("fields") or []

        pending_fields = [
            f for f in fields
            if isinstance(f, dict) and f.get("name") and not (f.get("description") or "").strip()
        ]

        if not pending_fields:
            block["desc_done"] = True  # mark done only if truly nothing pending
            continue

        block["desc_done"] = False  # reset — new fields found, need processing

        updated_in_table = 0
        try:
            for i in range(0, len(pending_fields), batch_size):
                batch = pending_fields[i:i + batch_size]
                desc_map = _smart_desc_map(client, table, batch)
                
                if not desc_map:
                    consecutive_errors += 1
                    continue
                
                consecutive_errors = 0  # Reset on success
                for f in batch:
                    fn = f.get("name")
                    if fn in desc_map:
                        f["description"] = desc_map[fn].strip()
                        updated_fields += 1
                        updated_in_table += 1
                
                # DB Heartbeat: keep the SQL connection alive
                frappe.db.commit()  # nosemgrep: periodic commit to persist progress during long-running schema sync

        except Exception as e:
            frappe.logger().error(f"Critical error in table {table}: {e}")
            consecutive_errors += 1

        if updated_in_table:
            updated_tables += 1
            processed_updated_tables += 1
            tables_since_last_save += 1
            # Mark table as done if no empty descriptions remain
            block["desc_done"] = not any(
                isinstance(x, dict) and not (x.get("description") or "").strip()
                for x in block.get("fields", [])
            )

        # Checkpoint: Save to disk every X tables
        if tables_since_last_save >= checkpoint_every_table:
            write_filedoctype("schema.yaml", {"_meta": meta, "tables": tables_blocks}, folder=RAG_FOLDER)
            tables_since_last_save = 0
            gc.collect()

        # Safety: If API fails 5 times in a row, stop to save credits/time
        if consecutive_errors > 5:
            frappe.logger().error("Stopping job: Too many consecutive API errors.")
            break

        if max_tables and processed_updated_tables >= max_tables:
            break

    # Final Save and cleanup
    meta["last_desc_sync"] = str(now_datetime())
    write_filedoctype("schema.yaml", {"_meta": meta, "tables": tables_blocks}, folder=RAG_FOLDER)
    frappe.db.commit()  # nosemgrep: frappe-semgrep-rules.rules.frappe-manual-commit
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


def _smart_desc_map_openai(client, table_name: str, fields: List[Dict[str, Any]]) -> Dict[str, str]:
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


