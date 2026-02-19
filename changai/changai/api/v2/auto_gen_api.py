from __future__ import annotations
from typing import Any, Dict, List, Optional, Set
import datetime
import gc
import json
import os
import time
import json
import os
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

def _training_prompt(module_name: str,failed_questions:list) -> str:
    return f"""
Generate 10 JSONL for ERPNext module: {module_name}

IMPORTANT FOCUS:
The retrieval model is currently failing on certain types of questions.
You MUST generate questions similar in intent, structure, wording style,
and filtering patterns to the FAILED_QUESTIONS listed below.

FAILED_QUESTIONS (model predicted wrong table for these):
{json.dumps(failed_questions, ensure_ascii=False, indent=2)}

INSTRUCTIONS FOR FOCUS:
- At least 6 out of 10 questions MUST follow the same intent pattern
  as the FAILED_QUESTIONS.
- Keep similar business meaning but vary wording naturally.
- Include messy/chat style variations.
- Include time filters / grouping / ranking if relevant.
- DO NOT mention table names in the anchor.

USER QUESTIONS: Casual, messy, real chat ("how much stock for XYZ?", "who's our best supplier lately?")
Mix: simple lookups + complex multi-hop (≥4 must use 2+ tables OR 2+ conditions)

FORMAT:
{{"qid": "{module_name}_NNN", "anchor": "casual question", "positives": ["[TABLE] tabX | desc: ...", "[FIELD] f | [TABLE] tabX | desc: ...", ...]}}

POSITIVES = ALL tables + ALL fields needed:
- Filters: item_code, status, warehouse, posting_date
- Joins: parent field + foreign key both sides
- Aggregates: grouping field + sum/count field
- Child tables: MUST include parent table + parent field

Each positive string:
"[TABLE] tabX | desc: What it stores. Why needed for THIS query."
"[FIELD] name | [TABLE] tabX | desc: this should be a very clear and helpful description about the field and its relevancy here which helps model modernbert to understand why we used that field here."

EXAMPLES:

Simple:
{{
  "qid": "S_01",
  "anchor": "stock for item XYZ?",
  "positives": [
    "[TABLE] tabBin | desc: Contains current available stock quantity for each item in each warehouse. Used to answer real-time inventory balance and on-hand stock questions.",
    "[FIELD] item_code | [TABLE] tabBin | desc: Identifies the specific product being queried. Filtered to match the item mentioned in the question such as 'XYZ'.",
    "[FIELD] actual_qty | [TABLE] tabBin | desc: Represents the live quantity available in stock. This field directly answers how much stock is currently available.",
    "[FIELD] warehouse | [TABLE] tabBin | desc: Indicates the storage location of the stock. Used when users want stock by location or total across warehouses."
  ]
}}

Multi-hop:
{{
  "qid": "S_02",
  "anchor": "top supplier this quarter?",
  "positives": [
    "[TABLE] tabPurchase Order | desc: Records purchase transactions made to suppliers. Used to calculate how much has been ordered or spent per supplier.",
    "[FIELD] supplier | [TABLE] tabPurchase Order | desc: Links each purchase order to a specific supplier. Grouped to compute total purchases per supplier.",
    "[FIELD] grand_total | [TABLE] tabPurchase Order | desc: Stores the monetary value of each purchase order. Summed to determine total spend and rank suppliers by volume.",
    "[FIELD] transaction_date | [TABLE] tabPurchase Order | desc: Represents the date of the purchase order. Filtered to match the current quarter time range.",
    "[TABLE] tabSupplier | desc: Master data table containing supplier details such as name and contact information. Joined to display readable supplier names.",
    "[FIELD] name | [TABLE] tabSupplier | desc: Primary supplier identifier used for display and ranking output."
  ]
}}

Child table (must have parent):
{{
  "qid": "S_03",
  "anchor": "items sold this month?",
  "positives": [
    "[TABLE] tabSales Invoice | desc: Stores sales transaction headers including invoice date and customer information. Used to filter sales by time period such as this month.",
    "[FIELD] posting_date | [TABLE] tabSales Invoice | desc: Represents the invoice date. Filtered to restrict results to the current month.",
    "[TABLE] tabSales Invoice Item | desc: Contains individual line items for each sales invoice. Used to retrieve the actual products sold.",
    "[FIELD] parent | [TABLE] tabSales Invoice Item | desc: Links each item row to its parent sales invoice. Required to apply date filtering from the invoice header.",
    "[FIELD] item_code | [TABLE] tabSales Invoice Item | desc: Identifies the product sold. Used to list or aggregate items sold in the selected period.",
    "[FIELD] qty | [TABLE] tabSales Invoice Item | desc: Represents the quantity sold per item. Summed to calculate total units sold."
  ]
}}

RULES:
- Do NOT rely on DocType names in the anchor. Users rarely say “Sales Invoice / Issue / Purchase Order”. Use real business wording + synonyms
- Include docstatus field when query implies filtering by document state

Return ONLY JSONL.
""".strip()


@frappe.whitelist(allow_guest=False)
def generate_training_data(module_name: str, total_count: int):
    client = _get_openai_client()
    total_count = int(total_count)
    num_reqs = math.ceil(total_count / 10)
    file_name, file_content = get_file(f"{module_name}_test.jsonl")
    data = [json.loads(line) for line in f if line.strip()]
    question_list = [item["question"] for item in data]
    prompt = _training_prompt(module_name, question_list)
    system_msg = (
        "You're creating training data for an ERPNext chatbot that helps users query business data. "
        "Users ask questions casually like they're chatting with a coworker, not writing SQL."
    )
    seen = set()
    out_lines = []
    req_used = 0

    for _ in range(num_reqs):
        if len(out_lines) >= total_count:
            break

        req_used += 1
        resp = client.chat.completions.create(
            model="gpt-4",
            messages=[{"role": "system", "content": system_msg}, {"role": "user", "content": prompt}],
            temperature=0.3,
            max_tokens=6000,
        )

        for ln in (resp.choices[0].message.content or "").splitlines():
            ln = ln.strip()
            if not ln:
                continue
            try:
                obj = json.loads(ln)
            except Exception:
                continue

            q = (obj.get("anchor") or "").strip()
            pos = obj.get("positives")

            if not q or not isinstance(pos, list) or not pos or q in seen:
                continue

            seen.add(q)
            out_lines.append(json.dumps(obj, ensure_ascii=False))
    file_name = f"{module_name}.jsonl"
    new_content = "\n".join(out_lines)
    existing_file = frappe.db.get_value("File", {
        "file_name": file_name,
        "folder": "Home/Training Data/Batch 2"
    }, "name")
    if existing_file:
        file_doc = frappe.get_doc("File", existing_file)
        old_content = file_doc.get_content() or ""
        combined_content = (old_content.rstrip() + "\n" + new_content).strip()
        file_doc.content = combined_content
        file_doc.save(ignore_permissions=True)
    else:
        file_doc = frappe.get_doc({
            "doctype": "File",
            "file_name": file_name,
            "is_private": 0,
            "content": new_content,
            "folder": "Home/Training Data/Batch 2"
        }).insert(ignore_permissions=True)

        file_doc.save(ignore_permissions=True)
    msg = f"Created {len(out_lines)} lines across {req_used} request(s). Unique questions: {len(seen)}."
    if len(out_lines) < total_count:
        msg += f" ⚠️ Expected {total_count}, but only got {len(out_lines)} unique."

    return {
        "ok": True,
        "file_url": file_doc.file_url,
        "file_name": file_doc.name,
        "requests_sent": req_used,
        "lines_written": len(out_lines),
        "unique_questions_written": len(seen),
        "message": msg,
    }

def create_folder_if_not_exists(folder_name: str):
    """
    Create folder if it doesn't exist
    
    Args:
        folder_name: Folder name (e.g., "Training Data")
    
    Returns:
        Folder name
    """
    # Check if folder exists
    existing = frappe.db.exists("File", {
        "file_name": folder_name,
        "is_folder": 1,
        "folder": "Home"
    })
    
    if existing:
        return existing
    
    # Create folder
    folder_doc = frappe.get_doc({
        "doctype": "File",
        "file_name": folder_name,
        "is_folder": 1,
        "folder": "Home"
    })
    folder_doc.insert()
    
    return folder_doc.name

@frappe.whitelist(allow_guest=False)
def generate_response(user_query):
    return "Hi"

import os
import json
import math
import frappe
from pathlib import Path
from anthropic import Anthropic

def _get_claude_client():
    settings = frappe.get_single("ChangAI Settings")

    api_key = None
    try:
        api_key = settings.get_password("claude_api_key")
    except Exception:
        api_key = None

    if not api_key:
        api_key = os.getenv("ANTHROPIC_API_KEY")

    if not api_key:
        frappe.throw("Claude API key is not configured")

    return Anthropic(api_key=api_key)


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
class STEmbeddings(Embeddings):
    def __init__(self, model_id_or_path: str):
        self.model = SentenceTransformer(model_id_or_path)

    def embed_documents(self, texts: List[str]) -> List[List[float]]:
        return self.model.encode(texts, normalize_embeddings=True).tolist()

    def embed_query(self, text: str) -> List[float]:
        return self.model.encode([text], normalize_embeddings=True)[0].tolist()

def ensure_faiss_folder(path: str):
    if not os.path.isdir(path):
        raise FileNotFoundError(f"FVS folder not found: {path}")
    files = set(os.listdir(path))
    if "index.faiss" not in files or "index.pkl" not in files:
        raise FileNotFoundError(
            f"FAISS folder missing index.faiss/index.pkl: {path} (found: {sorted(list(files))[:30]})"
        )

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
        "file_name": file_name,
        "folder": "Home/Test Results"
    }, "name")

    if existing:
        wrong_file_doc = frappe.get_doc("File", existing)
        wrong_file_doc.content = wrong_content
        wrong_file_doc.save(ignore_permissions=True)
    else:
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

def load_json_from_frappe_file(file_path: str) -> dict:
    """
    Load JSON data from Frappe File DocType
    
    Args:
        file_path: File path like "Validation Data/erpnext_test_questions_all_240.json"
                   or just filename "erpnext_test_questions_all_240.json"
    
    Returns:
        Parsed JSON data
    """
    # Extract filename from path
    if "/" in file_path:
        filename = file_path.split("/")[-1]
        folder_hint = file_path.rsplit("/", 1)[0]
    else:
        filename = file_path
        folder_hint = None
    
    # Try to find the file
    filters = {
        "file_name": filename,
        "is_folder": 0
    }
    
    # Add folder filter if provided
    if folder_hint:
        filters["folder"] = ["like", f"%{folder_hint}%"]
    
    file_name = frappe.db.exists("File", filters)
    
    if not file_name:
        # Try without folder filter
        file_name = frappe.db.exists("File", {
            "file_name": filename,
            "is_folder": 0
        })
    
    if not file_name:
        frappe.throw(f"File not found: {file_path}")
    
    # Load file
    file_doc = frappe.get_doc("File", file_name)
    content = file_doc.get_content()
    
    # Parse JSON
    try:
        data = json.loads(content.decode('utf-8'))
        return data
    except Exception as e:
        frappe.throw(f"Failed to parse JSON from {filename}: {str(e)}")
