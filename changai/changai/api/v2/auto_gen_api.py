from changai.changai.api.v2.text2sql_pipeline_v2 import call_gemini
from frappe.utils import nowdate, add_days,now_datetime,add_to_date
import json,os,frappe,yaml,re,openai


BASE_DIR = os.path.dirname(__file__)
DATA_DIR = os.path.join(BASE_DIR, "data")
TABLES_JSON = os.path.join(DATA_DIR, "tables.json")
SCHEMA_YAML = os.path.join(DATA_DIR, "schema.yaml")


@frappe.whitelist(allow_guest=False)
def generate_response(user_query):
    if not user_query or not user_query.strip():
        return {
            "ok": False,
            "message": "I can help you with your queries. Please ask something."
        }

    try:
        response = call_gemini(user_query.strip())
        return {
            "ok": True,
            "response": response
        }

    except Exception as e:
        frappe.log_error(
            title="generate_response failed",
            message=frappe.get_traceback()
        )
        return {
            "ok": False,
            "message": "Something went wrong while generating the response."
        }


@frappe.whitelist(allow_guest=False)
def sync_master_data_smart():
    file_path = "/opt/hyrin/frappe-bench/apps/changai/changai/changai/data/master_data.yaml"
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    try:
        with open(file_path, "r") as f:
            payload = yaml.safe_load(f) or {}
    except (FileNotFoundError, yaml.YAMLError):
        payload = {}

    if not isinstance(payload, dict):
        payload = {}

    meta = payload.get("_meta") or {}
    data = payload.get("data") or []

    if not isinstance(meta, dict):
        meta = {}
    if not isinstance(data, list):
        data = []

    last_sync = meta.get("last_sync")
    existing_keys = set()
    for row in data:
        if isinstance(row, dict):
            dt = row.get("entity_type")
            eid = row.get("entity_id")
            if dt and eid:
                existing_keys.add((dt, eid))

    modules = ["Customer", "Item", "Currency","Supplier"]
    added_by_module = {}
    fetched_by_module = {}
    base_filters = {}
    if last_sync:
        base_filters = {"creation": [">", last_sync]}

    added_total = 0

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
                "filters": {"field": "name", "value": rec.name}
            })
            existing_keys.add(key)
            added_count += 1
            added_total += 1

        added_by_module[mod] = added_count

    # ---------- Update checkpoint + write ----------
    meta["last_sync"] = str(now_datetime())
    payload = {"_meta": meta, "data": data}

    with open(file_path, "w") as f:
        yaml.safe_dump(payload, f, default_flow_style=False, sort_keys=False)

    return {
        "ok": True,
        "message": (
            f"Sync complete ✅ Added {added_total} new records."
            if added_total else
            "Sync complete ✅ No new records to add."
        ),
        "added_total": added_total,
        "added_by_module": added_by_module,
        "fetched_by_module": fetched_by_module,
        "last_sync_used": last_sync or "FIRST_RUN(full_fetch)",
        "new_last_sync": meta["last_sync"]
    }

BASE_DIR = os.path.dirname(__file__)
DATA_DIR = os.path.join(BASE_DIR, "data")
TABLES_JSON = os.path.join(DATA_DIR, "tables.json")
SCHEMA_YAML = os.path.join(DATA_DIR, "schema.yaml")

SKIP_DOCTYPES = {
    "DocType", "User", "Role", "Has Role", "Module Def",
    "Property Setter", "Customize Form", "User Permission",
    "Activity Log", "Access Log", "Error Log", "Version",
    "Installed Applications", "Prepared Report",
}

def _load_json_list(path):
    try:
        with open(path, "r") as f:
            x = json.load(f)
        return x if isinstance(x, list) else []
    except Exception:
        return []

def _save_json_list(path, items):
    with open(path, "w") as f:
        json.dump(items, f, indent=2, ensure_ascii=False)

def _load_yaml(path):
    try:
        with open(path, "r") as f:
            x = yaml.safe_load(f) or {}
        return x if isinstance(x, dict) else {}
    except Exception:
        return {}

def _save_yaml(path, obj):
    with open(path, "w") as f:
        yaml.safe_dump(obj, f, sort_keys=False, allow_unicode=True)

def _tab(dt):
    return f"tab{dt}"

def _strip_tab(t):
    return t[3:] if t.startswith("tab") else t

# ✅ Incremental DocType fetch using modified + 2-minute buffer
def get_doctypes_changed_since(last_sync):
    filters = {"disabled": 0, "istable": 0}

    if last_sync:
        try:
            since = add_to_date(last_sync, minutes=-2)  # buffer
        except Exception:
            since = last_sync
        filters["modified"] = [">=", since]

    doctypes = frappe.get_all("DocType", filters=filters, pluck="name")
    return [dt for dt in doctypes if dt not in SKIP_DOCTYPES]

def _get_openai_client():
    settings = frappe.get_single("ChangAI Settings")
    try:
        api_key = settings.get_password("openai_api_key")
    except Exception:
        api_key = None

    if not api_key:
        api_key = os.getenv("OPENAI_API_KEY")

    if not api_key:
        frappe.throw("OpenAI API key is not set in ChangAI Settings")

    return openai.OpenAI(api_key=api_key)

def _smart_desc_map(client, table_name, fields):
    minimal = [
        {"name": f.get("name"), "description": f.get("description", "")}
        for f in fields
    ]

    prompt = f"""
You are an expert ERP Data Engineer. For the database table '{table_name}',
rewrite the description for each field so an embedding model can distinguish EXACTLY why/when to use it.

Return JSON only: {{ "fieldname": "new description", ... }}

Fields:
{json.dumps(minimal, indent=2)}
"""

    resp = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": "Output JSON only."},
            {"role": "user", "content": prompt}
        ],
        response_format={"type": "json_object"}
    )
    return json.loads(resp.choices[0].message.content)

@frappe.whitelist(allow_guest=False)
def sync_tables_and_schema_smart():
    os.makedirs(DATA_DIR, exist_ok=True)
    payload = _load_yaml(SCHEMA_YAML)
    meta = payload.get("_meta") or {}
    tables_blocks = payload.get("tables") or []
    if not isinstance(meta, dict): meta = {}
    if not isinstance(tables_blocks, list): tables_blocks = []

    last_doctype_sync = meta.get("last_doctype_sync")

    changed_doctypes = get_doctypes_changed_since(last_doctype_sync)
    changed_tables = sorted({_tab(dt) for dt in changed_doctypes})

    existing_tables = _load_json_list(TABLES_JSON)
    existing_set = set(existing_tables)

    new_tables = [t for t in changed_tables if t not in existing_set]
    merged = sorted(existing_set | set(new_tables))

    if new_tables:
        _save_json_list(TABLES_JSON, merged)

    by_table = {b.get("table"): b for b in tables_blocks if isinstance(b, dict) and b.get("table")}

    client = None
    created_table_blocks = 0
    new_fields_added = 0
    new_field_descriptions_generated = 0
    removed_fields_total = 0  # ✅ NEW

    # ✅ Process NEW tables + CHANGED tables (so field renames in existing doctypes get handled)
    tables_to_process = sorted(set(new_tables) | set(changed_tables))

    for table in tables_to_process:
        dt = _strip_tab(table)
        if not frappe.db.exists("DocType", dt):
            continue

        meta_dt = frappe.get_meta(dt)
        current_fieldnames = [f.fieldname for f in meta_dt.fields if f.fieldname]
        current_set = set(current_fieldnames)

        block = by_table.get(table)

        # New table block
        if not block:
            block = {
                "table": table,
                "description": (meta_dt.description or "").strip(),
                "fields": [{"name": fn, "description": ""} for fn in current_fieldnames]
            }
            tables_blocks.append(block)
            by_table[table] = block
            created_table_blocks += 1
            new_fields_added += len(current_fieldnames)

            if block["fields"]:
                client = client or _get_openai_client()
                desc_map = _smart_desc_map(client, table, block["fields"])
                for fld in block["fields"]:
                    fn = fld.get("name")
                    if fn in desc_map:
                        fld["description"] = desc_map[fn]
                        new_field_descriptions_generated += 1

        else:
            fields_list = block.get("fields") or []
            if not isinstance(fields_list, list):
                fields_list = []

            # ✅ REMOVE missing fields (handles rename/delete)
            before = len(fields_list)
            fields_list = [
                f for f in fields_list
                if isinstance(f, dict) and f.get("name") in current_set
            ]
            removed_fields_total += (before - len(fields_list))

            existing_fieldnames = {
                x.get("name")
                for x in fields_list
                if isinstance(x, dict) and x.get("name")
            }

            # ✅ Add new fields (includes renamed new name)
            new_fieldnames = [fn for fn in current_fieldnames if fn not in existing_fieldnames]
            if not new_fieldnames:
                block["fields"] = fields_list
                continue

            new_fields = [{"name": fn, "description": ""} for fn in new_fieldnames]
            fields_list.extend(new_fields)
            block["fields"] = fields_list
            new_fields_added += len(new_fields)

            client = client or _get_openai_client()
            desc_map = _smart_desc_map(client, table, new_fields)
            for fld in new_fields:
                fn = fld.get("name")
                if fn in desc_map:
                    fld["description"] = desc_map[fn]
                    new_field_descriptions_generated += 1

    meta["last_sync"] = str(now_datetime())
    meta["last_doctype_sync"] = meta["last_sync"]

    payload = {"_meta": meta, "tables": tables_blocks}
    _save_yaml(SCHEMA_YAML, payload)

    return {
        "ok": True,
        "message": "Sync done ✅ (incremental doctypes + schema update)",
        "new_tables_added": len(new_tables),
        "new_table_blocks_created": created_table_blocks,
        "new_fields_added": new_fields_added,
        "removed_fields_total": removed_fields_total,  # ✅ NEW
        "new_field_descriptions_generated": new_field_descriptions_generated,
        "last_doctype_sync_used": last_doctype_sync or "FIRST_RUN",
        "new_last_doctype_sync": meta["last_doctype_sync"]
    }
