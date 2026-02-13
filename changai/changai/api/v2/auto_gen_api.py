from __future__ import annotations
from typing import Any, Dict, List, Optional, Set
import datetime
import gc
import json
import os
import time
import yaml
import frappe
from frappe import _
from frappe.utils import now_datetime, add_to_date
from anthropic import Anthropic
import openai
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
    payload = _load_yaml(META_SCHEMA_YAML)
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
    _save_yaml(META_SCHEMA_YAML, payload_out)

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
    }


@frappe.whitelist(allow_guest=False)
def get_doctypes_changed_since(last_sync: Optional[str]) -> List[str]:
    SKIP_MODULES = {"Core", "Custom", "Website", "Desk", "Email", "Integration", "Automation", "Workflow", ""}

    filters: Dict[str, Any] = {
        "module": ["not in", list(SKIP_MODULES)],
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
    payload = _load_yaml(SCHEMA_YAML)
    meta = payload.get("_meta") or {}
    tables_blocks = payload.get("tables") or []
    if not isinstance(tables_blocks, list):
        tables_blocks = []

    last_sync_raw = meta.get("last_doctype_sync")
    changed_doctypes = get_doctypes_changed_since(last_sync_raw)

    if not changed_doctypes:
        return {"ok": True, "message": _("No changes detected")}

    changed_tables = sorted({_tab(dt) for dt in changed_doctypes})

    existing_tables = _load_json_list(TABLES_JSON)
    merged_tables = sorted(set(existing_tables) | set(changed_tables))
    _save_json_list(TABLES_JSON, merged_tables)

    by_table = {
        b.get("table"): b
        for b in tables_blocks
        if isinstance(b, dict) and b.get("table")
    }

    for table in changed_tables:
        dt = _strip_tab(table)
        if not frappe.db.exists("DocType", dt):
            continue

        frappe.clear_cache(doctype=dt)
        meta_dt = frappe.get_meta(dt)

        current_fields: List[Dict[str, Any]] = [{"name": "name", "description": ""}]
        for df in meta_dt.fields:
            if not df.fieldname:
                continue
            if (df.fieldtype or "") in IGNORED_FIELDTYPES:
                continue
            if df.fieldname == "name":
                continue
            current_fields.append(_field_dict(df))

        current_set = {f["name"] for f in current_fields}
        block = by_table.get(table)

        if not block:
            block = {
                "table": table,
                "description": (meta_dt.description or "").strip(),
                "fields": current_fields,
            }
            tables_blocks.append(block)
        else:
            existing_fields = block.get("fields") or []
            filtered_existing = [f for f in existing_fields if isinstance(f, dict) and f.get("name") in current_set]

            existing_names = {f.get("name") for f in filtered_existing}
            for f in current_fields:
                if f["name"] not in existing_names:
                    filtered_existing.append(f)
            block["fields"] = sorted(filtered_existing, key=lambda x: x.get("name") != "name")
        frappe.local.meta_cache = {}
        if len(changed_tables) > 10:
            gc.collect()

    meta["last_doctype_sync"] = str(now_datetime())
    _save_yaml(SCHEMA_YAML, {"_meta": meta, "tables": tables_blocks})

    return {"ok": True, "message": _("Synced {0} tables").format(len(changed_tables))}


def _get_openai_client():
    settings = frappe.get_single("ChangAI Settings")
    api_key = None
    try:
        api_key = settings.get_password("openai_api_key")
    except Exception:
        api_key = None

    if not api_key:
        api_key = os.getenv("OPENAI_API_KEY")

    if not api_key:
        frappe.throw(_("OpenAI API key is not set in ChangAI Settings"))

    return openai.OpenAI(api_key=api_key)


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
    batch_size: int = 15,          # Lowered for token safety
    max_tables: int = 0,
    checkpoint_every_table: int = 10, # Increased to reduce Disk I/O load
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
                desc_map = _smart_desc_map_1(client, table, batch)
                
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


def _smart_desc_map_1(client, table_name: str, fields: List[Dict[str, Any]]) -> Dict[str, str]:
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


@frappe.whitelist(allow_guest=True)
def test_openai_connection(api_key: str = None) -> dict:
    """
    Simple OpenAI connectivity test.
    Verifies:
    - API key validity
    - Network connectivity
    - Model availability
    - JSON response parsing
    """

    try:
        # 1️⃣ Get API key
        if not api_key:
            settings = frappe.get_single("ChangAI Settings")
            try:
                api_key = settings.get_password("openai_api_key")
            except Exception:
                api_key = None

        if not api_key:
            api_key = os.getenv("OPENAI_API_KEY")

        if not api_key:
            return {"ok": False, "error": "No OpenAI API key found"}

        # 2️⃣ Create client
        from openai import OpenAI
        client = OpenAI(api_key=api_key)

        # 3️⃣ Make simple request
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": "Return ONLY JSON."},
                {"role": "user", "content": "Reply exactly with {\"status\":\"ok\"}"}
            ],
            temperature=0,
            max_tokens=50,
            timeout=60,
        )

        content = response.choices[0].message.content.strip()

        return {
            "ok": True,
            "model": "gpt-4o-mini",
            "response": content
        }

    except Exception as e:
        frappe.logger().exception("OpenAI test failed")
        return {
            "ok": False,
            "error": str(e)
        }
