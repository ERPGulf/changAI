from __future__ import annotations
from pathlib import Path
import os, json, math, re, time, random, traceback
from typing import Any, Dict, List, Tuple
import frappe
from google.oauth2 import service_account
from frappe import _
from google.genai import types
from google import genai
from changai.changai.api.v2.build_cards_faiss_index_v2 import _ensure_folder_exists
import openai
from vertexai.generative_models import GenerativeModel, GenerationConfig
from google.cloud import aiplatform

MAX_RETRIES = 5
BASE_BACKOFF = 2.0
MAX_BACKOFF = 60.0
REQUEST_DELAY = 30
BATCH_SIZE = 25
TABLE_TAG = "[TABLE]"
FIELD_TAG = "[FIELD]"
LINK_TAG = "[LINK]"

SYSTEM_FIELDS = {
    "name", "owner", "creation", "modified", "modified_by",
    "docstatus", "idx", "doctype", "parent", "parenttype",
    "parentfield", "amended_from"
}

_table_cache: Dict[str, bool] = {}
_field_cache: Dict[str, set] = {}


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

    with open(abs_path, "r", encoding="utf-8") as f:  # nosemgrep: security.frappe-security-file-traversal - abs_path is constructed via frappe.get_site_path with a sanitized module name, not directly user-controlled
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
    with open(abs_path, "a", encoding="utf-8") as f:  # nosemgrep: security.frappe-security-file-traversal - abs_path is constructed via frappe.get_site_path with a sanitized module name, not directly user-controlled
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

    frappe.db.commit()  # nosemgrep: frappe-manual-commit - explicit commit required to persist File DocType record immediately after disk write during training data sync
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
    if positive.startswith(TABLE_TAG):
        match = re.match(r"\[TABLE\]\s+(\w[\w ]*?)(?:(?:\s*\|)|(?:\s*$))", positive)
        if not match:
            return False, "Could not parse [TABLE] format"
        table = match.group(1).strip()
        doctype = table[3:] if table.startswith("tab") else table
        if not _validate_table(doctype):
            return False, f"DocType '{doctype}' does not exist"
        return True, None

    if positive.startswith(FIELD_TAG):
        match = re.match(r"\[FIELD\]\s+(\w+)\s+\|\s+\[TABLE\]\s+(\w[\w ]*?)(?:(?:\s*\|)|(?:\s*$))", positive)
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

    if positive.startswith(LINK_TAG):
        match = re.match(r"\[LINK\]\s+(\w[\w ]*?)\s+->\s+(\w[\w ]*?)\s+ON\s+(\w+)(?:(?:\s*\|)|(?:\s*$))", positive)
        if not match:
            return False, "Could not parse [LINK] format"
        table_a = match.group(1).strip()
        table_b = match.group(2).strip()
        field  = match.group(3).strip()
        doctype_a = table_a[3:] if table_a.startswith("tab") else table_a
        doctype_b = table_b[3:] if table_b.startswith("tab") else table_b
        if not _validate_table(doctype_a):
            return False, f"[LINK] DocType '{doctype_a}' does not exist"
        if not _validate_table(doctype_b):
            return False, f"[LINK] DocType '{doctype_b}' does not exist"
        if not _validate_field(doctype_a, field):
            return False, f"[LINK] Field '{field}' does not exist in '{doctype_a}'"
        return True, None

    return False, "Positive must start with [TABLE], [FIELD], or [LINK]"



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


def _generate_batch_claude(client, module_name, seen_anchors, module_description, total_count, wrong_examples=None) -> List[dict] :
    raw = None
    for attempt in range(MAX_RETRIES):
        try:
            import anthropic
            try:
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
            except Exception as e:
                frappe.log_error(f"Error: {e}","429 error")
                if "429" in str(e):
                    time.sleep(10)
                raise
            if REQUEST_DELAY:
                time.sleep(REQUEST_DELAY)

            break

        except Exception as e:
            frappe.log_error(str(e)[:100], "Claude call failed (retrying)")
            _sleep_backoff(attempt)

    if not raw:
        # frappe.log_error("All retries failed", "generate_batch_claude failed")
        return []

    if raw.startswith("```"):
        raw = raw.split("```", 1)[1]
        raw = raw.rsplit("```", 1)[0].strip()

    try:
        arr = json.loads(raw)
    except Exception:
        # frappe.log_error(raw[:100], "Claude output not valid JSON array")
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


def _generate_batch(client, module_name, seen_anchors, module_description, total_count, wrong_examples=None) -> List[dict]:
    raw = None
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
                    {"role": "user", "content": _training_prompt(module_name,module_description,BATCH_SIZE,wrong_examples)}  # <-- must exist in your module
                ]
            )

            raw = (resp.choices[0].message.content or "").strip()

            if REQUEST_DELAY:
                time.sleep(REQUEST_DELAY)

            break

        except Exception as e:
            # frappe.log_error(str(e)[:300], "OpenAI call failed (retrying)")
            _sleep_backoff(attempt)

    if not raw:
        # frappe.log_error("All retries failed", "generate_batch failed")
        return []

    # Strip accidental fences
    if raw.startswith("```"):
        raw = raw.split("```", 1)[1]
        raw = raw.rsplit("```", 1)[0].strip()

    try:
        arr = json.loads(raw)
    except Exception:
#         frappe.log_error(
#     title="OpenAI output not valid JSON array",
#     message=raw[:100],
# )
        return []

    if not isinstance(arr, list):
#         frappe.log_error(
#     title="OpenAI output not a list",
#     message=raw[:100],
# )
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


def _get_gemini_client():
    """
    Returns an authenticated Gemini client using service account credentials from ChangAI Settings.
    """
    settings = frappe.get_single("ChangAI Settings")
    json_content = settings.get("gemini_json_content")
    service_account_info = json.loads(json_content)
    project_id    = settings.get("gemini_project_id")
    location      = settings.get("location") or "us-central1"
    if not gemini_json_content :
        frappe.throw(_("Gemini service account JSON file path is missing or invalid"))
    creds = service_account.Credentials.from_service_account_info(
        service_account_info,
        scopes=['https://www.googleapis.com/auth/cloud-platform']
    )
    client = genai.Client(
        vertexai=True,
        project=project_id,
        location=location,
        credentials=creds,
    )
    return client

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


def testing_file(module_name):
    results = []
    wrong_examples = frappe.get_all("File", filters={"file_name": f"{module_name}.json","folder":"Home/Test Results"}, fields=["name", "file_url"])
    for file in wrong_examples:
        file_doc=frappe.get_doc("File",file.name)
        results.append({
            "name": file.name,
            "file_url": file.file_url,
            "content": file_doc.get_content()
        })
    return results


@frappe.whitelist(allow_guest=False)
def generate_data(modules: str, total_count: int, path: str, use_claude: bool = False,use_gemini: bool = False):
    """
    Generates training records and APPENDS to disk JSONL.
    Then syncs/updates a Frappe File doc pointing to that file.
    """
    _ensure_folder_exists(path)
    if use_claude:
        client = _get_claude_client()
        generate_fn = _generate_batch_claude
    elif use_gemini:
        client = _get_gemini_client()
        generate_fn = _generate_batch_gemini
    else:
        client = _get_openai_client()
        generate_fn = _generate_batch
    
    modules = json.loads(modules) if isinstance(modules, str) else modules
    suffix = "_val" if "Validation" in path else "_train"
    for module_rec in modules:
        module_name=module_rec["module"]
        module_description=module_rec["description"]
        wrong_file_name = f"{module_name.lower().replace(' ', '_')}.json"

        wrong_file_path = frappe.db.get_value("File", {
            "file_name": wrong_file_name,
            "folder": "Home/Test Results"
        }, "name")

        if wrong_file_path:
            wrong_file_doc = frappe.get_doc("File", wrong_file_path)
            raw_content = wrong_file_doc.get_content()
            wrong_examples = json.loads(raw_content) if raw_content else []
            if not isinstance(wrong_examples, list):
                wrong_examples = []
        else:
            wrong_examples = []
        total_count = int(total_count)
        abs_path = _get_abs_path(module_name, path, suffix)
        seen_anchors, existing_count = _seed_seen_from_disk(abs_path)
        total_generated_raw = 0
        total_validated = 0
        total_removed_positives = 0
        remaining = total_count
        max_loops = math.ceil(total_count / BATCH_SIZE) * 2
        for _ in range(max_loops):
            if remaining <= 0:
                break
            raw_records = generate_fn(client, module_name, seen_anchors, module_description,remaining,wrong_examples)
            if not raw_records:
                continue
            total_generated_raw += len(raw_records)
            validated_records, removed = _validate_records(raw_records)
            total_removed_positives += removed
            if not validated_records:
                continue
            try:
                final_records = _assign_qids(validated_records, module_name, existing_count)
            except Exception as e:
                return {"ok":False,"message":f"Error assigning QIDs: {str(e)}"}
            try:
                _append_to_disk(abs_path, final_records)
                # _sync_frappe_file_doc(module_name, abs_path, path, suffix)
            except Exception as e:
                frappe.log_error(str(e),"Error appending to disk")
                return {"ok": False, "message": str(e)}

            existing_count += len(final_records)
            total_validated += len(final_records)
            remaining -= len(final_records)
        if total_validated <= 0:
            continue
        try:
            file_doc = _sync_frappe_file_doc(module_name, abs_path, path, suffix)
        except Exception as e:
            frappe.log_error(str(e),"Error syncing frappe file doc")
            return {"ok":False,"message":f"Error {str(e)}"}
    return {
        "ok": True,
        "message": f"Generated training data for {module_name}"
    }


@frappe.whitelist(allow_guest=False)
def start_train(modules: str, total_count: int):
    total_count=int(total_count)
    val_count = max(1, int(int(total_count) * 0.25))

    frappe.enqueue(
        "changai.changai.api.v2.train_data_api.generate_data",
        queue="long",
        timeout=14400,
        modules=modules,
        total_count=total_count,
        path="Home/Training Data/Batch 4",
        use_claude=False,
        use_gemini=True
    )
    frappe.enqueue(
        "changai.changai.api.v2.train_data_api.generate_data",
        queue="long",
        timeout=14400,
        modules=modules,
        total_count=25,
        path="Home/Validation Data/Batch 3",
        use_claude=True,                     # <-- Claude
    )
    return {"ok": True, "message": "Training and validation jobs queued."}


def _generate_batch_gemini(client,module_name: str, seen_anchors: set, module_description, total_count,wrong_examples) -> List[dict]:
    raw = None
    MODEL_ID = "gemini-2.5-flash-lite"
    system_instruction = (
        "You must output ONLY a valid JSON array. "
        "Start with '[' and end with ']'. "
        "No markdown. No code fences. No explanation."
    )

    for attempt in range(MAX_RETRIES):
        contents = None
        try:
            cfg = types.GenerateContentConfig(
                temperature=0.9,
                max_output_tokens=4096,
                system_instruction=system_instruction,
            )
            try:
                contents = [{"role": "user", "parts": [{"text": _training_prompt(
                    module_name, module_description, BATCH_SIZE, wrong_examples
                )}]}]
            except Exception as e:
                frappe.log_error(title="Empty prompt", message=f"Error building prompt: {str(e)}")
                return []
            try:
                response = client.models.generate_content(
                    model=MODEL_ID,
                    contents=contents,
                    config=cfg,
                )
                raw = (response.text or "").strip()
            except Exception as e:
                frappe.log_error(f"Error: {e}","429 error")
                if "429" in str(e):
                    time.sleep(30)
                raise

            if REQUEST_DELAY:
                time.sleep(REQUEST_DELAY)

            break

        except Exception as e:
            frappe.log_error(
                title="Gemini generate_content.test failed",
                message=f"{str(e)}\n\nContents: {json.dumps(contents)[:8000] if contents else 'N/A'}"
            )
            _sleep_backoff(attempt)

    if not raw:
        return []

    if raw.startswith("```"):
        raw = raw.split("```", 1)[1].rsplit("```", 1)[0].strip()

    try:
        arr = json.loads(raw)
    except json.JSONDecodeError:
        cleaned = re.sub(r',\s*([\]}])', r'\1', raw)
        try:
            arr = json.loads(cleaned)
        except Exception:
            frappe.log_error(title="Gemini JSON parse failed", message=raw[:3000])
            return []
    except Exception:
        frappe.log_error(title="Gemini JSON parse failed", message=raw[:3000])
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


def _training_prompt(module_name: str, module_description: str, BATCH_SIZE: int, wrong_examples: list = None) -> str:
    hard_n = (BATCH_SIZE * 3) // 10
    std_n = BATCH_SIZE - hard_n 

    err_data = ""
    if wrong_examples:
        wrong_examples = json.loads(wrong_examples) if isinstance(wrong_examples, str) else wrong_examples
        err_list = "\n".join(
            [f"Fail: {e['anchor']} | Wrong: {e.get('top5',['?'])[0]}" for e in wrong_examples[:4]]
        )
        err_data = f"""
        FIX FAILED PATTERNS:
        {err_list}
        RULE:
        - If failed patterns are provided above, generate targeted corrected anchors or similar anchors that retrieve the correct tables/fields.
        """
    else:
        err_data = """
        NOTE:
        - No failed patterns are provided.
        - Generate normal high-quality training examples for this module.
        """
    return f"""
Act: ERP Architect. Task: Generate {BATCH_SIZE} training records (JSON).
Module: {module_name} ({module_description})
{err_data}
if the Error 
ANCHOR RULES:
- Queries for: SEE, FIND, LIST, CHECK, COUNT.
- Style: Fast/Urgent, Casual, Typos. No SQL/Technical phrasing.
- Mix: {std_n} Standard, {hard_n} Targeted (Hard/Tricky). 1 distractor from other module.
RULES:
- Use standard ERPNext schema (incl. Parent-Child).
- Format: RAW JSON ARRAY ONLY. No markdown/prose.
EXAMPLE:
[{{
    "anchor": "who authorized the extra items received in the Dammam warehouse yesterday?",
    "positives": [
      "[TABLE] tabPurchase Receipt | desc: Root transaction for physical goods arrival; holds authorization metadata.",
      "[TABLE] tabUser | desc: Master table for system users to map 'owner' IDs to full names/emails.",
      "[FIELD] owner | [TABLE] tabPurchase Receipt | desc: The User ID of the specific employee who 'Submitted' (authorized) this receipt.",
      "[FIELD] set_warehouse | [TABLE] tabPurchase Receipt | desc: Header-level field to filter by location, like 'Dammam'.",
      "[LINK] tabPurchase Receipt -> tabUser ON owner | desc: Join: Connects the document creator to their profile to identify the 'who'."
    ]
}}]
Make sure positives' must be a SINGLE-LEVEL list of strings.DO NOT use objects, nested lists, or dictionaries inside 'positives'.
OUTPUT: RAW JSON ARRAY [{BATCH_SIZE} records]. Start '[' end ']'.
""".strip()