from changai.changai.api.v2.text2sql_pipeline_v2 import call_gemini
from frappe.utils import nowdate, add_days,now_datetime,add_to_date
import json,os,frappe,yaml,re,openai,time
from anthropic import Anthropic
import anthropic
import gc

BASE_DIR = os.path.dirname(__file__)
DATA_DIR = os.path.join(BASE_DIR, "data")
TABLES_JSON = os.path.join(DATA_DIR, "tables.json")
SCHEMA_YAML = os.path.join(DATA_DIR, "schema.yaml")
# Fieldtypes to ignore when building schema.yaml (not useful for embedding / SQL)
IGNORED_FIELDTYPES = {
    # Layout / UI
    "Section Break",
    "Column Break",
    "Tab Break",
    "Table Break",
    "Fold",
    "Heading",

    # Display-only content
    "HTML",
    "HTML Editor",
    "Text Editor",
    "Markdown Editor",
    "Code",

    # Action / UI controls
    "Button",

    # Attachments / media (usually not part of analytical queries)
    "Attach",
    "Attach Image",
    "Image",
    "Signature",

    # Visual selectors / scans (rarely needed for reporting)
    "Icon",
    "Barcode",
}

@frappe.whitelist(allow_guest=False)
def sync_master_data_smart():
    BASE_DIR = os.path.dirname(__file__)
    DATA_DIR = os.path.join(BASE_DIR, "data")
    os.makedirs(DATA_DIR, exist_ok=True)
    file_path = os.path.join(DATA_DIR, "meta_schema.yaml")  # ✅ define
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

    modules = ["Customer", "Item", "Currency", "Supplier"]

    base_filters = {}
    if last_sync:
        base_filters = {"creation": [">", last_sync]}

    added_total = 0
    added_by_module = {}
    fetched_by_module = {}

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
def _tab(dt: str) -> str:
    """Convert DocType name -> MariaDB table name used by Frappe."""
    dt = (dt or "").strip()
    return f"tab{dt}"

def _strip_tab(t: str) -> str:
    """Convert table name like 'tabSales Invoice' -> 'Sales Invoice'."""
    t = (t or "").strip()
    return t[3:] if t.startswith("tab") else t


def _load_json_list(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)

        return data if isinstance(data, list) else []

    except FileNotFoundError:
        return []

    except json.JSONDecodeError:
        # corrupted / partially-written file
        return []

    except Exception:
        return []

def get_doctypes_changed_since(last_sync):
    filters = {}
    SKIP_MODULES = {
        "Core",
        "Custom",
        "Website",
        "Desk",
        "Email",
        "Integration",
        "Automation",
    }
    if last_sync:
        try:
            since = add_to_date(last_sync, minutes=-2)
        except Exception:
            since = last_sync
        filters["modified"] = [">=", since]

    doctypes = frappe.get_all("DocType", filters=filters, pluck="name")
    out = []

    for dt in doctypes:
        meta = frappe.get_meta(dt)

        # Skip system/internal modules
        if meta.module in SKIP_MODULES:
            continue

        # Skip virtual doctypes
        if getattr(meta, "is_virtual", 0):
            continue

        # Skip Single doctypes (settings)
        if getattr(meta, "issingle", 0):
            continue

        out.append(dt)

    return out

def _save_json_list(path, items):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(items, f, indent=2, ensure_ascii=False)
@frappe.whitelist(allow_guest=False)
def sync_tables_and_schema_smart():
    os.makedirs(DATA_DIR, exist_ok=True)
    payload = _load_yaml(SCHEMA_YAML)
    meta = payload.get("_meta") or {}
    tables_blocks = payload.get("tables") or []

    if not isinstance(meta, dict):
        meta = {}
    if not isinstance(tables_blocks, list):
        tables_blocks = []

    last_doctype_sync = meta.get("last_doctype_sync")
    changed_doctypes = get_doctypes_changed_since(last_doctype_sync)
    changed_tables = sorted({_tab(dt) for dt in changed_doctypes})

    existing_tables = _load_json_list(TABLES_JSON)
    existing_set = set(existing_tables)
    new_tables = [t for t in changed_tables if t not in existing_set]
    merged = sorted(existing_set | set(new_tables))

    if new_tables:
        _save_json_list(TABLES_JSON, merged)

    by_table = {
        b.get("table"): b
        for b in tables_blocks
        if isinstance(b, dict) and b.get("table")
    }

    created_table_blocks = 0
    new_fields_added = 0
    removed_fields_total = 0

    for table in changed_tables:
        dt = _strip_tab(table)
        if not frappe.db.exists("DocType", dt):
            continue

        meta_dt = frappe.get_meta(dt)
        current_fieldnames = ["name"]
        current_fields = [{"name": "name", "description": ""}]

        for df in meta_dt.fields:
            if not df.fieldname:
                continue
            if (df.fieldtype or "") in IGNORED_FIELDTYPES:
                continue
            if df.fieldname == "name":
                continue
            current_fieldnames.append(df.fieldname)
            current_fields.append(_field_dict(df))

        current_fieldnames = _dedup_keep_order(current_fieldnames)
        current_set = set(current_fieldnames)
        block = by_table.get(table)

        if not block:
            block = {
                "table": table,
                "description": (meta_dt.description or "").strip(),
                "fields": current_fields,
            }
            tables_blocks.append(block)
            by_table[table] = block
            created_table_blocks += 1
            new_fields_added += len(current_fieldnames)
            continue

        # EXISTING TABLE: remove missing fields + add new fields
        fields_list = block.get("fields") or []
        if not isinstance(fields_list, list):
            fields_list = []

        before = len(fields_list)
        fields_list = [
            f for f in fields_list
            if isinstance(f, dict) and f.get("name") in current_set
        ]
        removed_fields_total += (before - len(fields_list))

        existing_fieldnames = {
            f.get("name") for f in fields_list if isinstance(f, dict)
        }

        add_map = {f["name"]: f for f in current_fields if f.get("name")}
        new_fieldnames = [
            fn for fn in current_fieldnames if fn not in existing_fieldnames
        ]

        if new_fieldnames:
            for fn in new_fieldnames:
                fields_list.append(add_map.get(fn, {"name": fn, "description": ""}))
            new_fields_added += len(new_fieldnames)

        # ensure 'name' stays first
        name_entry = [f for f in fields_list if f.get("name") == "name"]
        rest = [f for f in fields_list if f.get("name") != "name"]
        block["fields"] = name_entry + rest

    meta["last_sync"] = str(now_datetime())
    meta["last_doctype_sync"] = meta["last_sync"]

    payload = {"_meta": meta, "tables": tables_blocks}
    _save_yaml(SCHEMA_YAML, payload)

    return {
        "ok": True,
        "message": "Skeleton sync done ✅ (includes child tables + options + join_hint, no OpenAI)",
        "new_tables_added": len(new_tables),
        "new_table_blocks_created": created_table_blocks,
        "new_fields_added": new_fields_added,
        "removed_fields_total": removed_fields_total,
        "new_last_doctype_sync": meta["last_doctype_sync"],
    }

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

def _load_yaml(path):
    try:
        with open(path, "r") as f:
            x = yaml.safe_load(f) or {}
        return x if isinstance(x, dict) else {}
    except Exception:
        return {}


def _save_yaml(path, obj):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        yaml.safe_dump(obj, f, sort_keys=False, allow_unicode=True)


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


def _extract_json_object(text: str):
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
        frappe.logger().error(
            "Claude API key missing. Set ChangAI Settings claude_api_key or env ANTHROPIC_API_KEY."
        )
        return None

    return Anthropic(api_key=api_key)


def _smart_desc_map(client, table_name, fields):
    """
    Shorter prompt to reduce tokens + faster + less memory.
    """
    if not client:
        return {}

    minimal = [{"name": f.get("name"), "description": (f.get("description") or "")} for f in fields]

    prompt = f"""
You are generating SHORT, HIGH-SIGNAL field descriptions for an ERP schema embedding model.

Table: {table_name}

GOAL:
Help an embedding model correctly match user questions to the right field.

STRICT RULES:
- Do NOT rename field names.
- Do NOT explain database concepts (primary key, immutable, system-generated, etc).
- Do NOT add generic phrases like "used for reporting" or "stores data".
- Output ONLY a JSON object in this format:
  {{"field_name": "description"}}

DESCRIPTION GUIDELINES (VERY IMPORTANT):
- 1 sentence only (max 2 if absolutely necessary).
- Focus on WHEN and WHY a user would reference this field in a question.
- Mention how it differs from similar fields ONLY if useful for disambiguation.
- Write as if the description will be embedded, not read by humans.

Fields JSON:
{json.dumps(minimal, ensure_ascii=False)}
""".strip()


    for attempt in range(3):
        try:
            msg = client.messages.create(
                model="claude-sonnet-4-5",
                max_tokens=900,
                temperature=0.2,
                system="Return ONLY a JSON object. No markdown. No extra text.",
                messages=[{"role": "user", "content": prompt}]            )

            text_parts = []
            for b in getattr(msg, "content", []) or []:
                if getattr(b, "type", None) == "text" and getattr(b, "text", None):
                    text_parts.append(b.text)
            text = "\n".join(text_parts).strip()

            parsed = _extract_json_object(text)
            if isinstance(parsed, dict):
                out = {}
                for k, v in parsed.items():
                    if isinstance(k, str) and isinstance(v, str) and k.strip() and v.strip():
                        out[k.strip()] = v.strip()
                return out

            frappe.logger().warning(
                f"Claude returned non-JSON table={table_name} attempt={attempt+1} preview={text[:200]!r}"
            )
            time.sleep(2 * (attempt + 1))

        except anthropic.RateLimitError as e:
            frappe.logger().warning(f"Claude RateLimit table={table_name} attempt={attempt+1}: {e}")
            time.sleep(2 * (attempt + 1))

        except anthropic.APIConnectionError as e:
            frappe.logger().warning(f"Claude ConnectionError table={table_name} attempt={attempt+1}: {e}")
            time.sleep(2 * (attempt + 1))

        except anthropic.APIStatusError as e:
            status = getattr(e, "status_code", None)
            frappe.logger().warning(f"Claude StatusError table={table_name} attempt={attempt+1} status={status}: {e}")
            if status in (401, 403):
                break
            time.sleep(2 * (attempt + 1))

        except Exception as e:
            frappe.logger().error(f"Claude unknown error table={table_name} attempt={attempt+1}: {e}")
            time.sleep(2 * (attempt + 1))

    return {}


@frappe.whitelist(allow_guest=False)
def fill_missing_field_descriptions(
    batch_size: int = 3,
    max_tables: int = 0,
    checkpoint_every_table: int = 1,
):
    frappe.logger().info("Description job started")

    payload = _load_yaml(SCHEMA_YAML)
    meta = payload.get("_meta") or {}
    tables_blocks = payload.get("tables") or []
    if not isinstance(tables_blocks, list):
        return {"ok": False, "message": "schema.yaml invalid"}

    client = _get_claude_client()
    if not client:
        return {"ok": False, "message": "Claude API key not configured (claude_api_key / ANTHROPIC_API_KEY)"}

    BATCH_SIZE = max(1, int(batch_size))
    updated_tables = 0
    updated_fields = 0

    processed_updated_tables = 0

    for block in tables_blocks:
        if not isinstance(block, dict):
            continue

        table = block.get("table")
        fields = block.get("fields") or []
        if not table or not isinstance(fields, list):
            continue

        pending_fields = [
            f for f in fields
            if isinstance(f, dict)
            and f.get("name")
            and not (f.get("description") or "").strip()
        ]
        if not pending_fields:
            continue

        frappe.logger().info(f"Table={table} pending_fields={len(pending_fields)}")
        updated_in_table = 0

        for i in range(0, len(pending_fields), BATCH_SIZE):
            batch = pending_fields[i:i + BATCH_SIZE]
            frappe.logger().info(f"Table={table} batch={i//BATCH_SIZE + 1} size={len(batch)}")

            desc_map = _smart_desc_map(client, table, batch) or {}

            for f in batch:
                fn = f.get("name")
                if fn and fn in desc_map and desc_map[fn].strip():
                    f["description"] = desc_map[fn]
                    updated_fields += 1
                    updated_in_table += 1
            gc.collect()

        if updated_in_table:
            updated_tables += 1
            processed_updated_tables += 1
            if int(checkpoint_every_table) >= 1:
                meta["last_desc_sync_partial"] = str(now_datetime())
                payload = {"_meta": meta, "tables": tables_blocks}
                _save_yaml(SCHEMA_YAML, payload)
                frappe.logger().info(f"Checkpoint saved after table={table} updated_fields_in_table={updated_in_table}")
            if int(max_tables) and processed_updated_tables >= int(max_tables):
                frappe.logger().info(f"Stopping early due to max_tables={max_tables}")
                break

    meta["last_desc_sync"] = str(now_datetime())
    payload = {"_meta": meta, "tables": tables_blocks}
    _save_yaml(SCHEMA_YAML, payload)

    frappe.logger().info(f"Description job finished tables={updated_tables} fields={updated_fields}")

    return {
        "ok": True,
        "message": "Field descriptions generated ✅",
        "tables_updated": updated_tables,
        "fields_updated": updated_fields,
        "last_desc_sync": meta["last_desc_sync"],
    }


@frappe.whitelist()
def sync_schema_and_enqueue_descriptions():
    sync_tables_and_schema_smart()
    frappe.enqueue(
        "changai.changai.api.v2.auto_gen_api.fill_missing_field_descriptions",
        queue="long",
        timeout=14400
    )
    return {"ok": True, "message": "Schema updated ✅ Field descriptions running in background 🧠"}
