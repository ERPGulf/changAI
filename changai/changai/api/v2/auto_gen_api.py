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
JSON_EXT = ".json"
SCHEMA_YAML = "schema.yaml"
YAML_EXT = ".yaml"
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
        if file_name.endswith(JSON_EXT):
            return []
        if file_name.endswith((YAML_EXT, ".yml")):
            return {}
        return ""
    raw = doc.get_content() or ""
    if isinstance(raw, bytes):
        raw = raw.decode("utf-8", errors="replace")
    if file_name.endswith(JSON_EXT):
        return json.loads(raw or "[]")
    if file_name.endswith((YAML_EXT, ".yml")):
        obj = yaml.safe_load(raw) or {}
        return obj if isinstance(obj, dict) else {}
    return raw

def write_filedoctype(
    file_name: str,
    payload,
    folder: str = "Home/RAG Sources",
    is_private: int = 0
):
    if file_name.endswith(JSON_EXT):
        text = json.dumps(payload, ensure_ascii=False, indent=2)

    elif file_name.endswith((YAML_EXT, ".yml")):
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
        doc.save(ignore_permissions=True)
        doc.reload()
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

MODULES_TO_SYNC = ["Customer", "Item", "Currency", "Supplier"]


def _normalize_master_data_payload(payload: Any) -> tuple[Dict[str, Any], List[Dict[str, Any]]]:
    meta = payload.get("_meta") or {}
    data = payload.get("data") or []

    if not isinstance(meta, dict):
        meta = {}
    if not isinstance(data, list):
        data = []

    return meta, data


def _extract_existing_keys(data: List[Any]) -> Set[tuple]:
    keys: Set[tuple] = set()

    for row in data:
        if not isinstance(row, dict):
            continue

        dt = row.get("entity_type")
        eid = row.get("entity_id")

        if dt and eid:
            keys.add((dt, eid))

    return keys


def _build_master_data_row(entity_type: str, entity_id: str) -> Dict[str, Any]:
    return {
        "entity_type": entity_type,
        "entity_id": entity_id,
        "filters": {"field": "name", "value": entity_id},
    }


def _get_master_data_filters(last_sync: Optional[str]) -> Dict[str, Any]:
    if not last_sync:
        return {}
    return {"creation": [">", last_sync]}


def _sync_module_master_data(
    mod: str,
    data: List[Dict[str, Any]],
    existing_keys: Set[tuple],
    base_filters: Dict[str, Any],
) -> tuple[int, int]:
    entity_type = f"tab{mod}"
    records = frappe.get_all(mod, filters=base_filters, fields=["name"])

    added_count = 0
    fetched_count = len(records)

    for rec in records:
        key = (entity_type, rec.name)
        if key in existing_keys:
            continue

        data.append(_build_master_data_row(entity_type, rec.name))
        existing_keys.add(key)
        added_count += 1

    return fetched_count, added_count


@frappe.whitelist(allow_guest=False)
def sync_master_data_smart() -> Dict[str, Any]:
    file_name = "master_data.yaml"
    payload = _read_filedoctype(file_name, RAG_FOLDER)

    meta, data = _normalize_master_data_payload(payload)
    last_sync = meta.get("last_sync")
    existing_keys = _extract_existing_keys(data)
    base_filters = _get_master_data_filters(last_sync)

    added_total = 0
    added_by_module: Dict[str, int] = {}
    fetched_by_module: Dict[str, int] = {}

    for mod in MODULES_TO_SYNC:
        fetched_count, added_count = _sync_module_master_data(
            mod=mod,
            data=data,
            existing_keys=existing_keys,
            base_filters=base_filters,
        )
        fetched_by_module[mod] = fetched_count
        added_by_module[mod] = added_count
        added_total += added_count

    meta["last_sync"] = str(now_datetime())
    payload_out = {"_meta": meta, "data": data}
    file_doc = write_filedoctype(file_name, payload_out, folder=RAG_FOLDER)

    frappe.db.commit()  # nosemgrep: frappe-manual-commit

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
TABLES_JSON = "tables.json"
YML_EXTENSIONS = (".yaml", ".yml")


def _normalize_schema_payload(payload: Any) -> tuple[Dict[str, Any], List[Dict[str, Any]]]:
    if not isinstance(payload, dict):
        return {}, []

    meta = payload.get("_meta") or {}
    tables_blocks = payload.get("tables") or []

    if not isinstance(meta, dict):
        meta = {}
    if not isinstance(tables_blocks, list):
        tables_blocks = []

    return meta, tables_blocks


def _normalize_existing_tables(existing_tables: Any) -> List[str]:
    return existing_tables if isinstance(existing_tables, list) else []


def _build_table_map(tables_blocks: List[Any]) -> Dict[str, Dict[str, Any]]:
    return {
        block.get("table"): block
        for block in tables_blocks
        if isinstance(block, dict) and block.get("table")
    }


def _get_changed_doctypes(last_sync_raw: Optional[str]) -> List[str]:
    if not last_sync_raw:
        return []
    return get_doctypes_changed_since(last_sync_raw)


def _get_tables_to_process(
    by_table: Dict[str, Dict[str, Any]],
    existing_tables: List[str],
    changed_doctypes: List[str],
) -> tuple[Set[str], Set[str], Set[str], List[str], List[str]]:
    changed_tables = {_tab(dt) for dt in changed_doctypes}
    existing_tables_set = set(existing_tables)

    missing_from_schema = {t for t in existing_tables if t not in by_table}
    new_from_changed = {
        t for t in changed_tables
        if t not in by_table and t not in existing_tables_set
    }

    tables_to_process = sorted(changed_tables | missing_from_schema | new_from_changed)
    merged_tables = sorted(existing_tables_set | changed_tables)

    return changed_tables, missing_from_schema, new_from_changed, tables_to_process, merged_tables


def _get_existing_fields_for_table(by_table: Dict[str, Dict[str, Any]], table: str) -> Dict[str, Dict[str, Any]]:
    table_block = by_table.get(table) or {}
    return {
        field.get("name"): field
        for field in table_block.get("fields", [])
        if isinstance(field, dict) and field.get("name")
    }


def _merge_select_options(live_options_raw: str, existing_options: Any) -> List[str]:
    live_options = [opt.strip() for opt in live_options_raw.split("\n") if opt.strip()]

    if isinstance(existing_options, str):
        existing_options = [opt.strip() for opt in existing_options.split("\n") if opt.strip()]
    elif not isinstance(existing_options, list):
        existing_options = []

    return list(dict.fromkeys(live_options + existing_options))


def _build_field_entry(field_meta: Any, existing_fields: Dict[str, Dict[str, Any]]) -> Optional[Dict[str, Any]]:
    if not field_meta.fieldname:
        return None

    existing_field = existing_fields.get(field_meta.fieldname, {})
    entry = {
        "name": field_meta.fieldname,
        "fieldtype": field_meta.fieldtype,
        "label": field_meta.label or "",
        "description": existing_field.get("description", ""),
    }

    if field_meta.fieldtype == "Select" and field_meta.options:
        entry["options"] = _merge_select_options(
            field_meta.options,
            existing_field.get("options", []),
        )
    elif field_meta.fieldtype == "Link" and field_meta.options:
        entry["join_hint"] = field_meta.options

    return entry


def _build_fields_from_meta(meta_dt: Any, existing_fields: Dict[str, Dict[str, Any]]) -> List[Dict[str, Any]]:
    fields: List[Dict[str, Any]] = []

    for field_meta in meta_dt.fields:
        field_entry = _build_field_entry(field_meta, existing_fields)
        if field_entry:
            fields.append(field_entry)

    return fields


def _has_pending_descriptions(fields: List[Dict[str, Any]]) -> bool:
    return any(
        not (field.get("description") or "").strip()
        for field in fields
        if isinstance(field, dict) and field.get("name")
    )


def _update_or_create_table_block(
    by_table: Dict[str, Dict[str, Any]],
    table: str,
    fields: List[Dict[str, Any]],
) -> None:
    if table in by_table:
        by_table[table]["fields"] = fields
        by_table[table]["desc_done"] = not _has_pending_descriptions(fields)
        return

    by_table[table] = {
        "table": table,
        "description": "",
        "fields": fields,
        "desc_done": False,
    }


def _process_schema_table(table: str, by_table: Dict[str, Dict[str, Any]]) -> bool:
    dt = _strip_tab(table)
    if not frappe.db.exists("DocType", dt):
        return False

    frappe.clear_cache(doctype=dt)
    meta_dt = frappe.get_meta(dt)

    existing_fields = _get_existing_fields_for_table(by_table, table)
    fields = _build_fields_from_meta(meta_dt, existing_fields)
    _update_or_create_table_block(by_table, table, fields)

    return True


def _write_schema_outputs(meta: Dict[str, Any], by_table: Dict[str, Dict[str, Any]], merged_tables: List[str]) -> None:
    write_filedoctype(
        SCHEMA_YAML,
        {"_meta": meta, "tables": list(by_table.values())},
        folder=RAG_FOLDER,
    )
    write_filedoctype(
        TABLES_JSON,
        merged_tables,
        folder=RAG_FOLDER,
    )


@frappe.whitelist(allow_guest=False)
def sync_tables_and_schema_smart() -> Dict[str, Any]:
    payload = _read_filedoctype(SCHEMA_YAML, RAG_FOLDER)
    meta, tables_blocks = _normalize_schema_payload(payload)

    existing_tables_raw = _read_filedoctype(TABLES_JSON, RAG_FOLDER)
    existing_tables = _normalize_existing_tables(existing_tables_raw)

    by_table = _build_table_map(tables_blocks)
    last_sync_raw = meta.get("last_doctype_sync")
    changed_doctypes = _get_changed_doctypes(last_sync_raw)

    changed_tables, missing_from_schema, _, tables_to_process, merged_tables = _get_tables_to_process(
        by_table=by_table,
        existing_tables=existing_tables,
        changed_doctypes=changed_doctypes,
    )

    if not tables_to_process:
        return {"ok": True, "message": _("No changes detected")}

    for table in tables_to_process:
        _process_schema_table(table, by_table)

    meta["last_doctype_sync"] = str(now_datetime())

    try:
        _write_schema_outputs(meta, by_table, merged_tables)
    except Exception as e:
        return {"error": str(e)}

    frappe.db.commit()  # nosemgrep: frappe-manual-commit - explicit commit required to persist schema/table sync changes to File DocType

    return {
        "ok": True,
        "changed_tables": len(changed_tables),
        "missing_added": len(missing_from_schema),
        "total_tables": len(merged_tables),
        "message": f"Synced {len(changed_tables)} changed + {len(missing_from_schema)} new tables",
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

def _get_field_names(fields: List[Dict[str, Any]]) -> List[str]:
    return [
        field.get("name")
        for field in fields
        if isinstance(field, dict) and field.get("name")
    ]


def _build_desc_prompt(table_name: str, field_names: List[str]) -> str:
    return f"""
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


def _extract_claude_text(msg: Any) -> str:
    text_parts: List[str] = []

    for block in getattr(msg, "content", []) or []:
        if getattr(block, "type", None) == "text" and getattr(block, "text", None):
            text_parts.append(block.text)

    return "\n".join(text_parts).strip()


def _normalize_desc_map(parsed: Any) -> Dict[str, str]:
    if not isinstance(parsed, dict):
        return {}

    out: Dict[str, str] = {}
    for key, value in parsed.items():
        if isinstance(key, str) and isinstance(value, str) and key.strip() and value.strip():
            out[key.strip()] = value.strip()
    return out


def _call_claude_desc_map_once(client: Anthropic, prompt: str) -> Any:
    return client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=500,
        temperature=0.2,
        system="Return ONLY a JSON object. No markdown. No extra text.",
        messages=[{"role": "user", "content": prompt}],
        timeout=180,
    )


def _smart_desc_map(client: Optional[Anthropic], table_name: str, fields: List[Dict[str, Any]]) -> Dict[str, str]:
    if not client:
        return {}

    field_names = _get_field_names(fields)
    if not field_names:
        return {}

    prompt = _build_desc_prompt(table_name, field_names)

    for attempt in range(3):
        try:
            msg = _call_claude_desc_map_once(client, prompt)
            text = _extract_claude_text(msg)

            parsed = _extract_json_object(text)
            normalized = _normalize_desc_map(parsed)
            if normalized:
                return normalized

            frappe.logger().warning(
                f"Claude returned non-JSON table={table_name} attempt={attempt+1} preview={text[:200]!r}"
            )
        except Exception as e:
            frappe.logger().error(f"Claude error table={table_name} attempt={attempt+1}: {e}")

        time.sleep(2 * (attempt + 1))

    return {}


def _reset_frappe_local_cache() -> None:
    frappe.local.meta_cache = {}
    if hasattr(frappe.local, "docs"):
        frappe.local.docs = {}


def _get_pending_fields(block: Dict[str, Any]) -> List[Dict[str, Any]]:
    fields = block.get("fields") or []
    return [
        field
        for field in fields
        if isinstance(field, dict)
        and field.get("name")
        and not (field.get("description") or "").strip()
    ]


def _mark_table_desc_done(block: Dict[str, Any]) -> None:
    block["desc_done"] = not any(
        isinstance(field, dict) and not (field.get("description") or "").strip()
        for field in block.get("fields", [])
    )


def _save_schema_checkpoint(meta: Dict[str, Any], tables_blocks: List[Dict[str, Any]]) -> None:
    write_filedoctype(
        SCHEMA_YAML,
        {"_meta": meta, "tables": tables_blocks},
        folder=RAG_FOLDER,
    )


def _process_pending_field_batches(
    client,
    table: str,
    pending_fields: List[Dict[str, Any]],
    batch_size: int,
) -> Dict[str, int]:
    updated_in_table = 0
    updated_fields = 0
    consecutive_errors = 0

    for i in range(0, len(pending_fields), batch_size):
        batch = pending_fields[i:i + batch_size]
        desc_map = _smart_desc_map(client, table, batch)

        if not desc_map:
            consecutive_errors += 1
            continue

        consecutive_errors = 0

        for field in batch:
            field_name = field.get("name")
            if field_name in desc_map:
                field["description"] = desc_map[field_name].strip()
                updated_fields += 1
                updated_in_table += 1

        frappe.db.commit()  # nosemgrep: periodic commit to persist progress during long-running schema sync

    return {
        "updated_in_table": updated_in_table,
        "updated_fields": updated_fields,
        "consecutive_errors": consecutive_errors,
    }


def _process_table_for_missing_descriptions(
    client,
    block: Dict[str, Any],
    batch_size: int,
) -> Dict[str, int]:
    if not isinstance(block, dict):
        return {
            "updated_in_table": 0,
            "updated_fields": 0,
            "consecutive_errors": 0,
            "skipped": 1,
        }

    table = block.get("table")
    pending_fields = _get_pending_fields(block)

    if not pending_fields:
        block["desc_done"] = True
        return {
            "updated_in_table": 0,
            "updated_fields": 0,
            "consecutive_errors": 0,
            "skipped": 0,
        }

    block["desc_done"] = False

    try:
        result = _process_pending_field_batches(
            client=client,
            table=table,
            pending_fields=pending_fields,
            batch_size=batch_size,
        )
    except Exception as e:
        frappe.logger().error(f"Critical error in table {table}: {e}")
        return {
            "updated_in_table": 0,
            "updated_fields": 0,
            "consecutive_errors": 1,
            "skipped": 0,
        }

    if result["updated_in_table"]:
        _mark_table_desc_done(block)

    result["skipped"] = 0
    return result


@frappe.whitelist(allow_guest=False)
def fill_missing_field_descriptions(
    batch_size: int = 15,
    max_tables: int = 0,
    checkpoint_every_table: int = 10,
) -> Dict[str, Any]:
    payload = _read_filedoctype(SCHEMA_YAML)
    meta = payload.get("_meta") or {}
    tables_blocks = payload.get("tables") or []

    if not isinstance(tables_blocks, list):
        return {"ok": False, "message": _("schema.yaml invalid")}

    client = _get_openai_client()
    if not client:
        return {"ok": False, "message": _("OpenAI API key missing")}

    updated_tables = 0
    updated_fields = 0
    processed_updated_tables = 0
    tables_since_last_save = 0
    consecutive_errors = 0

    for block in tables_blocks:
        _reset_frappe_local_cache()

        result = _process_table_for_missing_descriptions(
            client=client,
            block=block,
            batch_size=batch_size,
        )

        updated_in_table = result["updated_in_table"]
        updated_fields += result["updated_fields"]
        consecutive_errors = result["consecutive_errors"]

        if updated_in_table:
            updated_tables += 1
            processed_updated_tables += 1
            tables_since_last_save += 1

        if tables_since_last_save >= checkpoint_every_table:
            _save_schema_checkpoint(meta, tables_blocks)
            tables_since_last_save = 0
            gc.collect()

        if consecutive_errors > 5:
            frappe.logger().error("Stopping job: Too many consecutive API errors.")
            break

        if max_tables and processed_updated_tables >= max_tables:
            break

    meta["last_desc_sync"] = str(now_datetime())
    _save_schema_checkpoint(meta, tables_blocks)
    frappe.db.commit()  # nosemgrep: frappe-semgrep-rules.rules.frappe-manual-commit

    return {
        "ok": True,
        "tables_updated": updated_tables,
        "fields_updated": updated_fields,
        "status": "Complete" if consecutive_errors <= 5 else "Partial Failure",
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

def _get_field_names(fields: List[Dict[str, Any]]) -> List[str]:
    return [
        field.get("name")
        for field in fields
        if isinstance(field, dict) and field.get("name")
    ]


def _build_desc_prompt(table_name: str, field_names: List[str]) -> str:
    return f"""
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


def _normalize_desc_map(parsed: Any) -> Dict[str, str]:
    if not isinstance(parsed, dict):
        return {}

    out: Dict[str, str] = {}
    for key, value in parsed.items():
        if isinstance(key, str) and isinstance(value, str) and key.strip() and value.strip():
            out[key.strip()] = value.strip()
    return out


def _call_openai_desc_map_once(client, prompt: str):
    return client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": "Return ONLY a valid JSON object. No markdown. No extra text."},
            {"role": "user", "content": prompt},
        ],
        temperature=0.2,
        max_tokens=800,
        timeout=180,
    )


def _smart_desc_map_openai(client, table_name: str, fields: List[Dict[str, Any]]) -> Dict[str, str]:
    if not client:
        return {}

    field_names = _get_field_names(fields)
    if not field_names:
        return {}

    prompt = _build_desc_prompt(table_name, field_names)

    for attempt in range(3):
        try:
            response = _call_openai_desc_map_once(client, prompt)
            text = (response.choices[0].message.content or "").strip()

            parsed = _extract_json_object(text)
            normalized = _normalize_desc_map(parsed)
            if normalized:
                return normalized

            frappe.logger().warning(
                f"OpenAI returned non-JSON table={table_name} attempt={attempt+1} preview={text[:200]!r}"
            )
        except Exception as e:
            frappe.logger().error(f"OpenAI error table={table_name} attempt={attempt+1}: {e}")

        time.sleep(2 * (attempt + 1))

    return {}