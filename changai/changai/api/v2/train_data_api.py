from __future__ import annotations

import os, json, math, re, time, random, traceback
from typing import Any, Dict, List, Tuple

import frappe
from frappe import _
import openai

MAX_RETRIES = 5
BASE_BACKOFF = 2.0
MAX_BACKOFF = 60.0
REQUEST_DELAY = 0.1
BATCH_SIZE = 25

SYSTEM_FIELDS = {
    "name", "owner", "creation", "modified", "modified_by",
    "docstatus", "idx", "doctype", "parent", "parenttype",
    "parentfield", "amended_from"
}

_table_cache: Dict[str, bool] = {}
_field_cache: Dict[str, set] = {}  # doctype -> set(fieldnames)


def _get_claude_client():
    settings = frappe.get_single("ChangAI Settings")
    try:
        api_key = settings.get_password("claude_api_key")
    except Exception:
        api_key = None

    if not api_key:
        frappe.throw(_("Anthropic API key is not set in ChangAI Settings"))

    import anthropic
    return anthropic.Anthropic(api_key=api_key)


def _get_openai_client():
    settings = frappe.get_single("ChangAI Settings")
    api_key = None
    try:
        api_key = settings.get_password("openai_api_key")
    except Exception:
        api_key = None

    if not api_key:
        frappe.throw(_("OpenAI API key is not set in ChangAI Settings"))

    return openai.OpenAI(api_key=api_key)


def _sleep_backoff(attempt: int, base: float = BASE_BACKOFF, cap: float = MAX_BACKOFF):
    delay = min(cap, base * (2 ** attempt))
    delay = delay * (0.7 + random.random() * 0.6)
    time.sleep(delay)


# def _get_abs_path(module_name: str) -> str:
#     """Real file path inside public/files so it becomes downloadable."""
#     site_path = frappe.get_site_path("public", "files")
#     target_dir = os.path.join(site_path, "Training Data", "Batch 2")
#     os.makedirs(target_dir, exist_ok=True)
#     return os.path.join(target_dir, f"{module_name}.jsonl")
def _get_abs_path(module_name: str, folder_path: str,suffix: str = "") -> str:
    relative = folder_path.replace("Home/", "", 1)
    site_path = frappe.get_site_path("public", "files")
    target_dir = os.path.join(site_path, relative)
    os.makedirs(target_dir, exist_ok=True)
    return os.path.join(target_dir, f"{module_name}{suffix}.jsonl")


def _seed_seen_from_disk(abs_path: str) -> Tuple[set, int]:
    """Return (seen_anchors, existing_count_lines)."""
    seen = set()
    count = 0
    if not os.path.exists(abs_path):
        return seen, count

    with open(abs_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                obj = json.loads(line)
                if not isinstance(obj, dict):
                    continue
                anchor = (obj.get("anchor") or "").strip()
                if anchor:
                    seen.add(anchor)
                    count += 1
            except Exception:
                # ignore malformed lines
                continue

    return seen, count


def _append_to_disk(abs_path: str, records: List[dict]):
    if not records:
        return

    # Ensure folder exists
    os.makedirs(os.path.dirname(abs_path), exist_ok=True)

    # Append JSONL safely
    file_exists = os.path.exists(abs_path)
    with open(abs_path, "a", encoding="utf-8") as f:
        # If file exists and not empty, ensure newline separation
        if file_exists and os.path.getsize(abs_path) > 0:
            f.write("\n")
        f.write("\n".join(json.dumps(r, ensure_ascii=False) for r in records))
        f.write("\n")


def _sync_frappe_file_doc(module_name: str, abs_path: str, folder_path: str, suffix: str = ""):
    """
    Create/Update File doc that points to the on-disk file.
    """
    relative = folder_path.replace("Home/", "", 1)
    out_file_name = f"{module_name}{suffix}.jsonl"
    file_url = f"/files/{relative}/{out_file_name}"
    existing = frappe.db.get_value(
        "File",
        {"file_name": out_file_name, "folder": folder_path},
        "name",
    )
    size = os.path.getsize(abs_path) if os.path.exists(abs_path) else 0

    if existing:
        file_doc = frappe.get_doc("File", existing)
        file_doc.file_url = file_url
        file_doc.file_size = size
        file_doc.is_private = 0
        file_doc.folder = folder_path
        file_doc.save(ignore_permissions=True)
    else:
        file_doc = frappe.get_doc({
            "doctype": "File",
            "file_name": out_file_name,
            "file_url": file_url,
            "is_private": 0,
            "file_size": size,
            "folder": folder_path,
        }).insert(ignore_permissions=True)

    frappe.db.commit()
    return file_doc


def _validate_table(doctype: str) -> bool:
    if doctype not in _table_cache:
        _table_cache[doctype] = bool(frappe.db.exists("DocType", doctype))
    return _table_cache[doctype]


def _get_fieldnames_set(doctype: str) -> set:
    if doctype in _field_cache:
        return _field_cache[doctype]

    try:
        meta = frappe.get_meta(doctype)
        field_names = {f.fieldname for f in meta.fields if f.fieldname}
        # include system-ish implicit ones you might allow
        field_names |= set(SYSTEM_FIELDS)
        _field_cache[doctype] = field_names
    except Exception:
        _field_cache[doctype] = set()

    return _field_cache[doctype]


def _validate_field(doctype: str, fieldname: str) -> bool:
    if fieldname in SYSTEM_FIELDS:
        return True
    return fieldname in _get_fieldnames_set(doctype)


def _is_positive_valid(positive: str):
    if positive.startswith("[TABLE]"):
        match = re.match(r"\[TABLE\]\s+([\w\s]+?)(?:\s*\||\s*$)", positive)
        if not match:
            return False, "Could not parse [TABLE] format"
        table = match.group(1).strip()
        doctype = table[3:] if table.startswith("tab") else table
        if not _validate_table(doctype):
            return False, f"DocType '{doctype}' does not exist"
        return True, None

    if positive.startswith("[FIELD]"):
        match = re.match(r"\[FIELD\]\s+(\w+)\s+\|\s+\[TABLE\]\s+([\w\s]+?)(?:\s*\||\s*$)", positive)
        if not match:
            return False, "Could not parse [FIELD] format"
        field = match.group(1).strip()
        table = match.group(2).strip()
        doctype = table[3:] if table.startswith("tab") else table
        if not _validate_table(doctype):
            return False, f"DocType '{doctype}' does not exist"
        if not _validate_field(doctype, field):
            return False, f"Field '{field}' does not exist in '{doctype}'"
        return True, None

    return False, "Positive does not start with [TABLE] or [FIELD]"


def _validate_records(raw_records: List[dict]):
    validated_records = []
    total_removed_positives = 0

    for record in raw_records:
        valid_positives = []
        invalid_positives = []

        for positive in record.get("positives", []):
            is_valid, reason = _is_positive_valid(positive)
            if is_valid:
                valid_positives.append(positive)
            else:
                invalid_positives.append((positive, reason))
                total_removed_positives += 1

        if not valid_positives:
            frappe.log_error(
                f"anchor: {record.get('anchor')}\nreasons: {[r for _, r in invalid_positives]}",
                "Validation: Record dropped"
            )
            continue

        validated_records.append({
            "anchor": record["anchor"],
            "positives": valid_positives
        })

    return validated_records, total_removed_positives


def _assign_qids(validated_records: List[dict], module_name: str, existing_count: int):
    final_records = []
    for i, record in enumerate(validated_records):
        qid = f"{module_name}_{str(existing_count + i + 1).zfill(3)}"
        final_records.append({
            "qid": qid,
            "anchor": record["anchor"],
            "positives": record["positives"]
        })
    return final_records

# @frappe.whitelist(allow_guest=True)
# def test_claude():
#     client = _get_claude_client()
#     resp = client.messages.create(
#         model="claude-sonnet-4-6",   # ✅ Cheapest model
#         max_tokens=100,                 # keep small for testing
#         temperature=0.7,
#         messages=[
#             {"role": "user", "content": "Say hello in one short sentence."}
#         ]
#     )

#     return (resp.content[0].text or "").strip()

def _generate_batch_claude(client, module_name: str, seen_anchors: set, module_description,total_count) -> List[dict]:
    raw = None
    # schema_context = build_schema_context_for_module(module_name)
    for attempt in range(MAX_RETRIES):
        try:
            import anthropic
            resp = client.messages.create(
                model="claude-sonnet-4-6",
                max_tokens=4096,
                temperature=1.0,
                system=(
                    "You must output ONLY a valid JSON array. "
                    "Start with '[' and end with ']'. "
                    "No markdown. No code fences. No explanation."
                ),
                messages=[
                    {"role": "user", "content": _val_prompt(module_name,module_description,BATCH_SIZE)}
                ]
            )

            raw = (resp.content[0].text or "").strip()

            if REQUEST_DELAY:
                time.sleep(REQUEST_DELAY)

            break

        except Exception as e:
            frappe.log_error(str(e)[:100], "Claude call failed (retrying)")
            _sleep_backoff(attempt)

    if not raw:
        frappe.log_error("All retries failed", "generate_batch_claude failed")
        return []

    if raw.startswith("```"):
        raw = raw.split("```", 1)[1]
        raw = raw.rsplit("```", 1)[0].strip()

    try:
        arr = json.loads(raw)
    except Exception:
        frappe.log_error(raw[:100], "Claude output not valid JSON array")
        return []

    if not isinstance(arr, list):
        frappe.log_error(raw[:100], "Claude output not a list")
        return []

    records = []
    for obj in arr:
        if not isinstance(obj, dict):
            continue
        anchor = (obj.get("anchor") or "").strip()
        positives = obj.get("positives")
        if not anchor or not isinstance(positives, list) or not positives:
            continue
        if anchor in seen_anchors:
            continue
        seen_anchors.add(anchor)
        records.append({"anchor": anchor, "positives": positives})

    return records


def _generate_batch(client, module_name: str, seen_anchors: set,module_description,total_count) -> List[dict]:
    raw = None
    # schema_context = build_schema_context_for_module(module_name)
    for attempt in range(MAX_RETRIES):
        try:
            resp = client.chat.completions.create(
                model="gpt-4o",
                temperature=1.0,
                messages=[
                    {
                        "role": "system",
                        "content": (
                            "You must output ONLY a valid JSON array. "
                            "Start with '[' and end with ']'. "
                            "No markdown. No code fences. No explanation."
                        )
                    },
                    {"role": "user", "content": _training_prompt(module_name,module_description,BATCH_SIZE)}  # <-- must exist in your module
                ]
            )

            raw = (resp.choices[0].message.content or "").strip()

            if REQUEST_DELAY:
                time.sleep(REQUEST_DELAY)

            break

        except Exception as e:
            frappe.log_error(str(e)[:300], "OpenAI call failed (retrying)")
            _sleep_backoff(attempt)

    if not raw:
        frappe.log_error("All retries failed", "generate_batch failed")
        return []

    # Strip accidental fences
    if raw.startswith("```"):
        raw = raw.split("```", 1)[1]
        raw = raw.rsplit("```", 1)[0].strip()

    try:
        arr = json.loads(raw)
    except Exception:
        frappe.log_error(
    title="OpenAI output not valid JSON array",
    message=raw[:100],
)
        return []

    if not isinstance(arr, list):
        frappe.log_error(
    title="OpenAI output not a list",
    message=raw[:100],
)
        return []

    records = []
    for obj in arr:
        if not isinstance(obj, dict):
            continue

        anchor = (obj.get("anchor") or "").strip()
        positives = obj.get("positives")

        if not anchor or not isinstance(positives, list) or not positives:
            continue

        if anchor in seen_anchors:
            continue

        seen_anchors.add(anchor)
        records.append({"anchor": anchor, "positives": positives})

    return records


@frappe.whitelist(allow_guest=False)
def generate_data(modules, total_count: int, path: str, use_claude: bool = False):
    """
    Generates training records and APPENDS to disk JSONL.
    Then syncs/updates a Frappe File doc pointing to that file.
    """
    if use_claude:
        client = _get_claude_client()
        generate_fn = _generate_batch_claude
    else:
        client = _get_openai_client()
        generate_fn = _generate_batch
    
    modules = json.loads(modules) if isinstance(modules, str) else modules
    total_count = int(total_count)
    # total_count=25
    suffix = "_val" if "Validation" in path else "_train"
    for module_rec in modules:
        module_name=module_rec["module"]
        module_description=module_rec["description"]
        total_count = int(total_count)
        abs_path = _get_abs_path(module_name, path, suffix)
        # Seed from disk
        seen_anchors, existing_count = _seed_seen_from_disk(abs_path)
        total_generated_raw = 0
        total_validated = 0
        total_removed_positives = 0
        remaining = total_count
        max_loops = math.ceil(total_count / BATCH_SIZE) * 2
        for _ in range(max_loops):
            if remaining <= 0:
                break
 
            raw_records = generate_fn(client, module_name, seen_anchors, module_description,remaining)
            if not raw_records:

                continue

            total_generated_raw += len(raw_records)

            # 2) Validate
            validated_records, removed = _validate_records(raw_records)
            total_removed_positives += removed
            if not validated_records:
                continue

            # 3) Assign QIDs
            final_records = _assign_qids(validated_records, module_name, existing_count)

            # 4) Append to disk immediately (so progress isn't lost)
            try:
                _append_to_disk(abs_path, final_records)
                _sync_frappe_file_doc(module_name, abs_path, path, suffix)
            except Exception as e:
                frappe.log_error(traceback.format_exc(), "Append to disk failed")
                return {"ok": False, "message": str(e)}

            existing_count += len(final_records)
            total_validated += len(final_records)
            remaining -= len(final_records)
        if total_validated <= 0:
            frappe.log_error(f"No valid records for {module_name}", "generate_data")
            continue
        # Final sync
        file_doc = _sync_frappe_file_doc(module_name, abs_path, path, suffix)

    return {
        "ok": True,
        "message": f"Generated training data for {module_name}"
    }


@frappe.whitelist(allow_guest=False)
def start_train(modules, total_count: int):
    val_count = max(1, int(int(total_count) * 0.25))

    # frappe.enqueue(
    #     "changai.changai.api.v2.train_data_api.generate_data",
    #     queue="long",
    #     timeout=14400,
    #     modules=modules,
    #     total_count=total_count,
    #     path="Home/Training Data/Batch 2",
    #     use_claude=False,                    # <-- OpenAI
    # )
    frappe.enqueue(
        "changai.changai.api.v2.train_data_api.generate_data",
        queue="long",
        timeout=14400,
        modules=modules,
        total_count=val_count,
        path="Home/Validation Data/Batch 2",
        use_claude=True,                     # <-- Claude
    )
    return {"ok": True, "message": "Training and validation jobs queued."}


def _training_prompt(module_name: str,module_description,BATCH_SIZE) -> str:
    return f"""
You are generating training data for an ERPNext assistant.
TASK:
Generate EXACTLY {BATCH_SIZE} training records for the {module_name} module in Frappe/ERPNexts.
You can read the descirption given below about the module and generate realistic questions.
{module_name}
{module_description}
OUTPUT FORMAT (STRICT):
- Return ONLY a valid JSON ARRAY.
- The array must contain EXACTLY {BATCH_SIZE} objects.
- Do NOT output JSONL.
- Do NOT output markdown.
- Do NOT output code fences.
- Do NOT output explanations.
Anchor style rules:
- Questions must be data fetch/lookup intent only
- User is always asking to SEE, FIND, LIST, CHECK, or COUNT data
- Think: someone querying a dashboard or asking a report question in a hurry, not writing SQL or technical queries.
- Mix styles: ultra-short ("helmet stock dubai"), casual ("how many cement bags in sharjah?"), urgency ("need diesel qty in muscat asap"), doubt ("any PVC fittings left in doha or not?")
- Use business wording and synonyms.
- Occasionally include typos or incomplete phrasing
- Avoid SQL-like or technical phrasing
- Do NOT mention DocType or table names in anchor.
EXAMPLE:
[
  {{
    "anchor": "stock left for item havels Cable in dammam warehouse?",
    "positives": [
      "[TABLE] tabBin | desc: Stores real-time inventory levels for each item-warehouse combination in ERPNext",
      "[FIELD] item_code | [TABLE] tabBin | desc: Unique identifier of the product/item to filter stock records",
      "[FIELD] warehouse | [TABLE] tabBin | desc: Name or location of the warehouse (e.g., dammam) to scope the stock query",
      "[FIELD] actual_qty | [TABLE] tabBin | desc: Current physically available stock quantity for the item in the given warehouse"
    ]
  }}
]
CRITICAL:
- "positives" MUST be a JSON ARRAY (list).
- Each item inside "positives" MUST be a STRING.
- NEVER return objects or dictionaries inside "positives".

IMPORTANT:
- Output MUST start with '[' and end with ']'
- Do NOT include ``` or ```json anywhere
""".strip()


def _val_prompt(module_name, description, BATCH_SIZE):
    return f"""
You are generating ERPNext schema-retrieval training data.
This is for production testing of a trained retrieval model, so focus on variety and real-world business questions.
CRITICAL OUTPUT RULE:
Return ONLY a valid JSON array. Start with '[' and end with ']'. No markdown. No code fences. No explanation.
ANCHOR RULES:
- Questions must be data fetch/lookup intent only
- Casual, messy, real chat style.
- Mix styles: ultra-short ("helmet stock dubai"), casual ("how many cement bags in sharjah?"), urgency ("need diesel qty in muscat asap"), doubt ("any PVC fittings left in doha or not?") et..
- cover all styles of queriy types in the output, with no specific ratio. The more variety the better.
- Do NOT mention DocType or table names in anchor.
- Use business wording and synonyms.
[
  {{
    "anchor": "which suppliers didnt deliver on time last month?",
    "positives": [
      "[TABLE] tabPurchase Order",
      "[FIELD] supplier | [TABLE] tabPurchase Order",
      "[FIELD] schedule_date | [TABLE] tabPurchase Order",
      "[FIELD] status | [TABLE] tabPurchase Order"
    ]
  }}
]
REQUIREMENTS:
- Generate EXACTLY {BATCH_SIZE} UNIQUE objects
- NEVER include Doctype names in questions
- Casual business language
- Grammar mistakes allowed
- This is for testing a trained Model in retrieval, so focus on covering all varieties and production oriented questions.
- {module_name}: {description}
""".strip()



def build_schema_context_for_module(module_name: str) -> str:
    doctypes = frappe.get_all(
        "DocType",
        filters={"module": module_name, "custom": 0},
        pluck="name"
    )
    blocks = []
    for dt in doctypes:
        meta = frappe.get_meta(dt)
        fields = [f"- {f.fieldname}" for f in meta.fields if f.fieldname]

        if fields:
            blocks.append(
                f"TABLE: tab{meta.name}\nFIELDS:\n" + "\n".join(fields)
            )
    return "\n\n".join(blocks)