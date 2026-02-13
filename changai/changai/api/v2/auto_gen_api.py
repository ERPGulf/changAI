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
def _get_training_data_dir() -> str:
    d = frappe.get_app_path("changai", "changai", "api", "v2", "data", "training_data")
    os.makedirs(d, exist_ok=True)
    return d

def _training_file_path(module_name: str) -> str:
    filename = f"{(module_name or '').lower()}_training_data.jsonl"
    return safe_path_in_dir(_get_training_data_dir(), filename)


# @frappe.whitelist()
# def generate_training_data(module_name: str, total_count: int):
#     client = _get_openai_client()
#     total_count = int(total_count)
#     output_file = _training_file_path(module_name)
#     existing_q = set()
#     existing_triplets = set()
#     if os.path.exists(output_file):
#         with open(output_file, "r", encoding="utf-8") as rf:
#             for ln in rf:
#                 ln = ln.strip()
#                 if not ln:
#                     continue
#                 try:
#                     obj = json.loads(ln)
#                 except Exception:
#                     continue
#                 q = (obj.get("sentence1") or "").strip()
#                 s2 = (obj.get("sentence2") or "").strip()
#                 label = float(obj.get("label") or 0)

#                 if q:
#                     existing_q.add(q)
#                 if q and s2:
#                     existing_triplets.add((q, s2, label))
#     prompt_template = """
# You are generating ERPNext schema-retrieval training data to train an embedder that maps business questions to the correct ERPNext tables/fields.
# MODULE: {module}
# OUTPUT FORMAT (STRICT):
# - Output MUST be JSONL.
# - Each line = ONE JSON object.
# - Do NOT wrap in an array.
# - Do NOT add any extra text.
# COUNT RULE (IMPORTANT — READ CAREFULLY):
# - You must create EXACTLY 10 UNIQUE business questions (sentence1).
# - sentence1 must be UNIQUE across the dataset (no duplicates).
# - You MUST output MULTIPLE JSONL lines per question when needed:
#   - one line per required positive candidate
#   - plus up to 2 lines for negative candidates
# - Therefore: TOTAL JSONL LINE COUNT MUST NOT BE 10.
#   It MUST be dynamic and will be MORE than 10 in most cases.
# QUESTION STYLE (CRITICAL — MUST FOLLOW):

# Questions must reflect how real ERPNext business users ask in daily operations.

# Common Question Categories:

# - Totals: total sales, revenue, purchase, tax, outstanding
# - Counts: number of invoices, orders, customers, items
# - Rankings: top/bottom customers, items, suppliers
# - Pending/Open/Overdue documents
# - Date-based queries: today, this month, last quarter, YTD
# - Stock & warehouse analysis
# - Payment status & collections
# - Profitability & margin
# - Supplier/customer performance
# - Trends & comparisons over time
# - Item performance (most sold, highest revenue, best margin, slow/fast moving, returns, stock aging, valuation)
# - Entity-specific queries (customer, supplier, item, warehouse mentioned by name)
# - Project costing & profitability
# - HR & payroll summaries
# - Tax & compliance reports
# - Cash flow & finance summaries
# - Production & manufacturing status
# - Customer support & SLA tracking
# - Budget vs actual comparisons
# - Multi-company consolidated reports
# - Audit/control checks
# - Logistics & shipping status
# - Recurring revenue/subscriptions
# - Discounts & promotion impact
# - Approval/workflow status

# Style Rules:

# - Short to medium length
# - Casual but professional
# - Natural business language
# - No spelling mistakes
# - No technical/database wording
# - No placeholder wording like "a specific item"
# - Must sound like a manager, accountant, warehouse head, HR officer, or operations staff
# For example:

# If MODULE is Selling → generate only sales/customer/item revenue related questions such as totals (sales revenue, discounts, outstanding sales), counts (number of quotations, sales orders, invoices, customers), rankings (top customers, best‑selling items, highest revenue orders), pending/open/overdue (quotations not converted, overdue invoices, open sales orders), date‑based queries (sales today, this month, last quarter, year‑to‑date), customer performance (repeat orders, credit utilization, payment timeliness), and trends (sales growth, item demand trends, seasonal comparisons).

# If MODULE is Buying → generate supplier/purchase related questions such as totals (purchase spend, supplier credits, outstanding payables), counts (number of purchase orders, receipts, supplier invoices), rankings (top suppliers by spend, lowest cost suppliers, most reliable suppliers), pending/open/overdue (open purchase orders, overdue supplier invoices), date‑based queries (purchases today, this month, last quarter, year‑to‑date), supplier performance (on‑time delivery, quality issues, average lead time), and trends (purchase spend trends, supplier category comparisons).

# If MODULE is Stock → generate inventory/warehouse related questions such as totals (stock valuation, total items in warehouse, stock inflow/outflow), counts (number of items below reorder level, stock transfers, warehouses), rankings (fast‑moving items, slow‑moving items, top warehouses by stock value), pending/open/overdue (pending stock transfers, unfulfilled delivery notes), date‑based queries (stock movement today, this month, last quarter, year‑to‑date), warehouse analysis (stock aging, negative stock, capacity utilization), and trends (inventory turnover, stock consumption trends, seasonal demand).

# If MODULE is Accounts → generate finance/payment/tax related questions such as totals (revenue, expenses, outstanding receivables/payables, tax liability), counts (number of invoices, journal entries, payments received/made), rankings (top customers by payments, suppliers by outstanding balances), pending/open/overdue (overdue invoices, pending payments, unapproved entries), date‑based queries (cash flow today, this month, last quarter, year‑to‑date), payment status (paid vs. unpaid invoices, partial payments, collections), profitability/margin (gross margin, net profit, project profitability), and trends (revenue vs. expense trends, tax trends, cash flow comparisons).


# FOR EACH of the 10 UNIQUE QUESTIONS:
# - Add ALL required positives (label=1.0): the MINIMUM tables/fields needed to generate correct SQL.
# - Add MAXIMUM 2 negatives (label=0.0): near-miss candidates not needed.
# FORMAT PER LINE (STRICT):
# {{"gid":"{module}","sentence1":"...","sentence2":"...","label":1.0}}
# sentence2 format ONLY:
# - Table:
#   "[TABLE] tabDoctype | desc: <2-3 sentences, specific reasoning>"
# - Field:
#   "[FIELD] fieldname | [TABLE] tabDoctype | desc: <2-3 sentences, specific reasoning>"
# DESCRIPTION REQUIREMENTS (VERY IMPORTANT):
# - Required for BOTH positives and negatives.
# - 2–3 sentences.
# - Must be CLEAR and easy to understand:
#   1) First sentence: explain WHAT this table/field represents in ERPNext (business meaning).
#   2) Second sentence: explain WHY it is needed (or not needed) for THIS question (SQL logic: filter/group/sum/join/date/status).
# - No generic phrases like "to get data" / "to retrieve details".
# - For negatives (label=0.0): explain why it looks related but is not required (wrong document stage, wrong module, wrong metric, etc.).
# OTHER RULES:
# - Use real ERPNext names only (tabBin, tabStock Ledger Entry, tabSales Invoice, tabPurchase Invoice, tabCustomer, tabItem, tabWarehouse, etc.).
# - Never fake names like tab1/tab2 or "Lead tab3".
# - No duplicate sentence2 lines across the entire output.
# Return ONLY JSONL.
# """
#     written_lines = 0
#     new_unique_questions = 0
#     with open(output_file, "a", encoding="utf-8") as f:
#         while len(existing_q) < total_count:
#             prompt = prompt_template.format(module=module_name)
#             resp = client.chat.completions.create(
#                 model="gpt-4",
#                 messages=[
#                     {"role": "system", "content": "Output ONLY JSONL. No extra text."},
#                     {"role": "user", "content": prompt}
#                 ],
#                 temperature=0.3,
#                 max_tokens=2000
#             )
#             text = (resp.choices[0].message.content or "").strip()
#             lines = [ln.strip() for ln in text.splitlines() if ln.strip()]
#             for ln in lines:
#                 try:
#                     obj = json.loads(ln)
#                 except Exception:
#                     continue
#                 q = (obj.get("sentence1") or "").strip()
#                 s2 = (obj.get("sentence2") or "").strip()
#                 label = float(obj.get("label") or 0)
#                 if not q or not s2:
#                     continue
#                 triplet = (q, s2, label)
#                 if triplet in existing_triplets:
#                     continue
#                 is_new_question = q not in existing_q
#                 if is_new_question:
#                     if len(existing_q) >= total_count:
#                         continue
#                     existing_q.add(q)
#                     new_unique_questions += 1
#                 f.write(json.dumps(obj, ensure_ascii=False) + "\n")
#                 existing_triplets.add(triplet)
#                 written_lines += 1
#                 if len(existing_q) >= total_count:
#                     break
#     return {
#         "ok": True,
#         "file": output_file,
#         "unique_questions_total": len(existing_q),
#         "unique_questions_added_this_run": new_unique_questions,
#         "lines_written_this_run": written_lines
#     }

@frappe.whitelist()
def generate_training_data_1(module_name: str, total_count: int):
    client = _get_openai_client()
    total_count = int(total_count)
    output_file = _training_file_path(module_name)
    existing_q = set()
    existing_triplets = set()
    if os.path.exists(output_file):
        with open(output_file, "r", encoding="utf-8") as rf:
            for ln in rf:
                ln = ln.strip()
                if not ln:
                    continue
                try:
                    obj = json.loads(ln)
                except Exception:
                    continue
                q = (obj.get("sentence1") or "").strip()
                s2 = (obj.get("sentence2") or "").strip()
                label = float(obj.get("label") or 0)

                if q:
                    existing_q.add(q)
                if q and s2:
                    existing_triplets.add((q, s2, label))
    
    # Module-specific examples
    # Module-specific examples
    module_examples = {
    "Selling": "sales revenue/discounts/outstanding, quotation/order/invoice counts, top customers/best-selling items/highest revenue orders, quotations not converted/overdue invoices/open sales orders, sales today/this month/last quarter/YTD, customer performance (repeat orders, credit utilization, payment timeliness), trends (sales growth, item demand, seasonal comparisons)",
    
    "Accounts": "revenue/expenses/outstanding receivables-payables/tax liability, invoice/journal entry/payment counts, top customers by payments/suppliers by outstanding balances, overdue invoices/pending payments/unapproved entries, cash flow today/this month/last quarter/YTD, payment status (paid vs unpaid, partial payments, collections), profitability/margin (gross margin, net profit, project profitability), trends (revenue vs expense, tax trends, cash flow comparisons)",
    
    "CRM": "lead counts/conversion rates, opportunity pipeline value, lead sources performance, won/lost deals, sales funnel analysis, contact/lead activity tracking, follow-up pending/overdue, campaign effectiveness, lead response time, customer acquisition cost, deals by territory/sales person, lead aging, opportunity win probability",
    
    "Buying": "purchase spend/supplier credits/outstanding payables, PO/receipt/supplier invoice counts, top suppliers by spend/lowest cost/most reliable, open POs/overdue supplier invoices, purchases today/this month/last quarter/YTD, supplier performance (on-time delivery, quality issues, average lead time), trends (purchase spend, supplier category comparisons)",
    
    "Projects": "project profitability/costs/margins, task completion rates, project timeline/delays, resource allocation/utilization, billable vs non-billable hours, project budget vs actual, milestone tracking, overdue tasks/projects, timesheet summaries, project-wise revenue/expenses, team performance by project, project status (on-track/at-risk/delayed)",
    
    "Manufacturing": "production order status/completion, work order quantities/delays, BOM costs/material consumption, production efficiency/yield rates, machine/workstation utilization, job card completion/pending, manufacturing costs vs planned, scrap/wastage analysis, production capacity utilization, WIP (work in progress) valuation, operations completion tracking, downtime analysis",
    
    "Stock": "stock valuation/total items/stock inflow-outflow, items below reorder/stock transfers/warehouse counts, fast-moving/slow-moving items/top warehouses by stock value, pending stock transfers/unfulfilled delivery notes, stock movement today/this month/last quarter/YTD, warehouse analysis (stock aging, negative stock, capacity utilization), trends (inventory turnover, stock consumption, seasonal demand)",
    
    "Support": "ticket counts by status/priority, resolution time/SLA compliance, open/overdue tickets, customer satisfaction scores, first response time, ticket aging/backlog, support agent performance, escalated tickets, ticket trends by category/type, average handling time, ticket volume by channel, recurring issues/top complaints",
    
    "Assets": "asset valuation/depreciation, asset counts by category/location, maintenance schedules/overdue maintenance, asset utilization rates, capitalized vs expensed items, asset disposal/write-offs, depreciation expense this period, asset register by department, insurance renewals due, warranty expiry tracking, asset acquisition costs, asset condition tracking",
    
    "HR": "payroll summaries/salary disbursements, employee counts by department/designation, attendance/leave tracking, leave balances/pending approvals, benefit allocations/deductions, performance reviews/appraisal cycles, hiring status/open positions, department-wise costs, overtime/shift patterns, resignation/termination tracking, employee onboarding status, training completion rates"
}

    module_example = module_examples.get(module_name, "relevant business queries for this module")
    prompt_template = """
Generate ERPNext schema-retrieval training data for MODULE: {module}

OUTPUT FORMAT (STRICT):
- JSONL only (one JSON object per line, no array wrapper, no extra text)
- Format: {{"gid":"{module}","sentence1":"...","sentence2":"...","label":1.0}}

COUNT RULE:
- EXACTLY 10 UNIQUE business questions (sentence1)
- Multiple JSONL lines per question: ALL required positives (label=1.0) + up to 2 negatives (label=0.0)
- Positives = ALL tables/fields needed for correct SQL (varies per question)
- Total output lines will be dynamic and significantly > 10

QUESTION STYLE (CRITICAL):
Reflect real ERPNext user queries. Common categories: totals (sales, revenue, purchase, tax, outstanding), counts (invoices, orders, customers, items), rankings (top/bottom customers/items/suppliers), pending/open/overdue documents, date-based (today, this month, last quarter, YTD), stock/warehouse analysis, payment status/collections, profitability/margin, supplier/customer performance, trends/comparisons over time, item performance (most sold, highest revenue, best margin, slow/fast moving, returns, stock aging, valuation), entity-specific (customer/supplier/item/warehouse by name), project costing/profitability, HR/payroll summaries, tax/compliance reports, cash flow/finance summaries, production/manufacturing status, customer support/SLA tracking, budget vs actual, multi-company consolidated reports, audit/control checks, logistics/shipping status, recurring revenue/subscriptions, discounts/promotion impact, approval/workflow status.

Style: short-medium length, casual professional, natural business language, no technical/database terms, no placeholders ("a specific item"), sound like manager/accountant/warehouse head/HR officer/ops staff.

For MODULE {module}, generate questions like: {module_example}

sentence2 FORMAT:
- Table: "[TABLE] tabDoctype | desc: <2-3 sentences>"
- Field: "[FIELD] fieldname | [TABLE] tabDoctype | desc: <2-3 sentences>"

DESCRIPTION (2-3 sentences, BOTH positives/negatives):
1) WHAT: business meaning in ERPNext
2) WHY: needed/not needed for this question (SQL logic: filter/group/sum/join/date/status)
For negatives: explain why it seems related but isn't (wrong stage/module/metric)

RULES:
- Use Only the Real ERPNext Tables and field names
- No duplicates in sentence2 across output
- ALL required positives + max 2 negatives per question

Return ONLY JSONL.
"""
    written_lines = 0
    new_unique_questions = 0
    with open(output_file, "a", encoding="utf-8") as f:
        while len(existing_q) < total_count:
            prompt = prompt_template.format(module=module_name, module_example=module_example)
            resp = client.chat.completions.create(
                model="gpt-4",
                messages=[
                    {"role": "system", "content": "Output ONLY JSONL. No extra text."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.3,
                max_tokens=2000
            )
            text = (resp.choices[0].message.content or "").strip()
            lines = [ln.strip() for ln in text.splitlines() if ln.strip()]
            for ln in lines:
                try:
                    obj = json.loads(ln)
                except Exception:
                    continue
                q = (obj.get("sentence1") or "").strip()
                s2 = (obj.get("sentence2") or "").strip()
                label = float(obj.get("label") or 0)
                if not q or not s2:
                    continue
                triplet = (q, s2, label)
                if triplet in existing_triplets:
                    continue
                is_new_question = q not in existing_q
                if is_new_question:
                    if len(existing_q) >= total_count:
                        continue
                    existing_q.add(q)
                    new_unique_questions += 1
                f.write(json.dumps(obj, ensure_ascii=False) + "\n")
                existing_triplets.add(triplet)
                written_lines += 1
                if len(existing_q) >= total_count:
                    break
    return {
        "ok": True,
        "file": output_file,
        "unique_questions_total": len(existing_q),
        "unique_questions_added_this_run": new_unique_questions,
        "lines_written_this_run": written_lines
    }