from __future__ import annotations
from frappe.utils.file_manager import get_file
from typing import Any, Dict
import frappe
from frappe import _
import os, json, math,re
import anthropic
from frappe.utils.file_manager import save_file
from frappe.utils.file_manager import get_file_path

BATCH_SIZE=25
SYSTEM_FIELDS = {
    "name", "owner", "creation", "modified", "modified_by",
    "docstatus", "idx", "doctype", "parent", "parenttype",
    "parentfield", "amended_from"
}

_table_cache = {}
_field_cache = {}


@frappe.whitelist(allow_guest=False)
def test():
    file_name = frappe.db.get_value("File", {
        "file_name": "HR.jsonl",
        "folder": "Home/Training Data/Batch 2"
    }, "name")
    doc = frappe.get_doc("File", file_name)
    return doc.get_content()


def _get_openai_client():
    import openai
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


def _load_existing_file(out_file_name, folder):
    """Returns (existing_name, old_text, seen_anchors, existing_count)"""
    existing_name = frappe.db.get_value("File", {
        "file_name": out_file_name,
        "folder": folder
    }, "name")

    old_text = ""
    seen_anchors = set()

    if existing_name:
        file_doc = frappe.get_doc("File", existing_name)
        old_text = (file_doc.content or "")
        if isinstance(old_text, (bytes, bytearray)):
            old_text = old_text.decode("utf-8", "ignore")
        if not old_text:
            old_text = (file_doc.get_content() or "").strip()

        for line in old_text.splitlines():
            line = line.strip()
            if not line:
                continue
            try:
                obj = json.loads(line)
                a = (obj.get("anchor") or "").strip()
                if a:
                    seen_anchors.add(a)
            except Exception:
                pass

    existing_count = len([l for l in old_text.splitlines() if l.strip()]) if old_text else 0
    return existing_name, old_text, seen_anchors, existing_count


def _call_openai_with_retry(client, module_name: str) -> str | None:
    """
    Returns raw string content OR None if failed after retries.
    """
    last_err = None
    for attempt in range(MAX_RETRIES):
        try:
            resp = client.chat.completions.create(
                model="gpt-4o",
                temperature=1.0,
                messages=[
                    {
                        "role": "system",
                        "content": (
                            "You must output ONLY valid JSON. "
                            "Output must start with '[' and end with ']'. "
                            "Do NOT use markdown. Do NOT use code fences like ``` or ```json. "
                            "Do NOT add any explanation text."
                        )
                    },
                    {"role": "user", "content": _training_prompt(module_name)}
                ]
            )
            raw = (resp.choices[0].message.content or "").strip()
            # small delay after success to reduce 429 bursts
            if REQUEST_DELAY:
                time.sleep(REQUEST_DELAY)
            return raw

        except Exception as e:
            last_err = f"{type(e).__name__}: {e}"
            # log short error
            frappe.log_error(last_err, "OpenAI call failed (will retry)")
            _sleep_backoff(attempt)

    frappe.log_error(last_err or "Unknown error", "OpenAI call failed after retries")
    return None

import time, random, math

MAX_RETRIES = 5          # retry per OpenAI request
BASE_BACKOFF = 2.0       # seconds
MAX_BACKOFF = 60.0       # cap
REQUEST_DELAY = 0.8      # sleep after SUCCESS response to reduce 429 bursts


def _generate_raw_records(client, module_name, total_count, seen_anchors):
    """Calls OpenAI in batches, returns raw anchor+positives records (with retry + backoff)."""
    num_reqs = math.ceil(total_count / BATCH_SIZE)
    raw_records = []
    for _ in range(num_reqs):
        if len(raw_records) >= total_count:
            break
        raw = None
        last_err = None
        for attempt in range(MAX_RETRIES):
            try:
                resp = client.chat.completions.create(
                    model="gpt-4o",
                    temperature=1.0,
                    messages=[
                        {
                            "role": "system",
                            "content": (
                                "You must output ONLY valid JSON. "
                                "Output must start with '[' and end with ']'. "
                                "Do NOT use markdown. Do NOT use code fences like ``` or ```json. "
                                "Do NOT add any explanation text."
                            )
                        },
                        {"role": "user", "content": _training_prompt(module_name)}
                    ]
                )
                raw = (resp.choices[0].message.content or "").strip()
                if REQUEST_DELAY:
                    time.sleep(REQUEST_DELAY)

                break  # success => exit retry loop

            except Exception as e:
                last_err = f"{type(e).__name__}: {e}"
                frappe.log_error(last_err, "OpenAI call failed (retrying)")

                # exponential backoff + jitter
                delay = min(MAX_BACKOFF, BASE_BACKOFF * (2 ** attempt))
                delay = delay * (0.7 + random.random() * 0.6)
                time.sleep(delay)

        # if still failed after retries, skip this batch
        if not raw:
            frappe.log_error(last_err or "Unknown error", "OpenAI call failed after retries")
            continue

        # ✅ KEEP your existing markdown cleanup EXACTLY
        if raw.startswith("```"):
            raw = raw.split("```", 1)[1]
            raw = raw.rsplit("```", 1)[0]
            raw = raw.strip()

        frappe.log_error(raw[:1500], "OPENAI_RAW_OUTPUT")

        try:
            arr = json.loads(raw)
        except Exception:
            frappe.log_error(raw[:1500], "OpenAI output not JSON array")
            continue

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
            raw_records.append({
                "anchor": anchor,
                "positives": positives
            })

            if len(raw_records) >= total_count:
                break

    return raw_records


def _validate_table(doctype):
    if doctype not in _table_cache:
        _table_cache[doctype] = bool(frappe.db.exists("DocType", doctype))
    return _table_cache[doctype]


def _validate_field(doctype, fieldname):
    # ✅ System fields are always valid on any doctype
    if fieldname in SYSTEM_FIELDS:
        return True

    cache_key = f"{doctype}.{fieldname}"
    if cache_key not in _field_cache:
        try:
            meta = frappe.get_meta(doctype)
            field_names = [f.fieldname for f in meta.fields]
            _field_cache[cache_key] = fieldname in field_names
        except Exception:
            _field_cache[cache_key] = False

    return _field_cache[cache_key]


def _is_positive_valid(positive):
    # ── TABLE check ──────────────────────────────────────────
    if positive.startswith("[TABLE]"):
        match = re.match(r'\[TABLE\]\s+([\w\s]+?)(?:\s*\||\s*$)', positive)
        if not match:
            return False, "Could not parse [TABLE] format"
        table = match.group(1).strip()
        doctype = table[3:] if table.startswith("tab") else table
        if not _validate_table(doctype):
            return False, f"DocType '{doctype}' does not exist"
        return True, None

    # ── FIELD check ──────────────────────────────────────────
    elif positive.startswith("[FIELD]"):
        match = re.match(r'\[FIELD\]\s+(\w+)\s+\|\s+\[TABLE\]\s+([\w\s]+?)(?:\s*\||\s*$)', positive)
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


def _validate_records(raw_records):
    """Validates positives in each record, returns (validated_records, total_removed_positives)"""
    validated_records = []
    total_removed_positives = 0

    for record in raw_records:
        valid_positives = []
        invalid_positives = []

        for positive in record["positives"]:
            is_valid, reason = _is_positive_valid(positive)
            if is_valid:
                valid_positives.append(positive)
            else:
                invalid_positives.append((positive, reason))
                total_removed_positives += 1

        if not valid_positives:
            frappe.log_error(
                f"anchor: {record['anchor']}\nreasons: {[r for _, r in invalid_positives]}",
                "Validation: Record dropped"
            )
            continue

        validated_records.append({
            "anchor": record["anchor"],
            "positives": valid_positives
        })

    return validated_records, total_removed_positives


def _assign_qids(validated_records, module_name, existing_count):
    """Assigns sequential QIDs based on existing record count"""
    final_records = []
    for i, record in enumerate(validated_records):
        qid = f"{module_name}_{str(existing_count + i + 1).zfill(3)}"
        new_record = {
            "qid": qid,
            "anchor": record["anchor"],
            "positives": record["positives"]
        }

        final_records.append(new_record)
    return final_records


# ──────────────────────────────────────────────
# SUB API 9: Save to File doctype
# ──────────────────────────────────────────────
def _save_to_file(existing_name, out_file_name, folder, old_text, final_records):
    """Combines old + new records and saves to Frappe File doctype"""
    new_text = "\n".join(json.dumps(r, ensure_ascii=False) for r in final_records).strip()
    combined = (old_text.rstrip() + "\n" + new_text).strip() if old_text else new_text

    if existing_name:
        file_doc = frappe.get_doc("File", existing_name)
        file_doc.content = combined
        file_doc.folder = folder
        file_doc.is_private = 0
        file_doc.save(ignore_permissions=True)
    else:
        try:
            file_doc = frappe.get_doc({
                "doctype": "File",
                "file_name": out_file_name,
                "content": combined,
                "is_private": 0,
                "folder": folder,
            }).insert(ignore_permissions=True)
        except Exception as e:
            frappe.log_error(str(e), "Failed to create File document")
            raise e

    frappe.db.commit()
    return file_doc
import time
import random
import traceback

# --- tune these safely ---
MAX_RETRIES = 5          # how many retries per OpenAI call
BASE_BACKOFF = 2.0       # seconds
MAX_BACKOFF = 60.0       # seconds cap
REQUEST_DELAY = 0.8      # seconds delay after a SUCCESS call (rate limit friendly)


def _sleep_backoff(attempt: int, base: float = BASE_BACKOFF, cap: float = MAX_BACKOFF):
    """
    Exponential backoff with jitter.
    attempt=0 -> ~base seconds, attempt=1 -> ~2*base, etc.
    """
    delay = min(cap, base * (2 ** attempt))
    # jitter 0.7x..1.3x
    delay = delay * (0.7 + random.random() * 0.6)
    time.sleep(delay)


def _call_openai_with_retry(client, module_name: str) -> str | None:
    """
    Returns raw string content OR None if failed after retries.
    """
    last_err = None
    for attempt in range(MAX_RETRIES):
        try:
            resp = client.chat.completions.create(
                model="gpt-4o",
                temperature=1.0,
                messages=[
                    {
                        "role": "system",
                        "content": (
                            "You must output ONLY valid JSON. "
                            "Output must start with '[' and end with ']'. "
                            "Do NOT use markdown. Do NOT use code fences like ``` or ```json. "
                            "Do NOT add any explanation text."
                        )
                    },
                    {"role": "user", "content": _training_prompt(module_name)}
                ]
            )
            raw = (resp.choices[0].message.content or "").strip()
            # small delay after success to reduce 429 bursts
            if REQUEST_DELAY:
                time.sleep(REQUEST_DELAY)
            return raw

        except Exception as e:
            last_err = f"{type(e).__name__}: {e}"
            # log short error
            frappe.log_error(last_err, "OpenAI call failed (will retry)")
            _sleep_backoff(attempt)

    frappe.log_error(last_err or "Unknown error", "OpenAI call failed after retries")
    return None


def _strip_code_fences(raw: str) -> str:
    raw = (raw or "").strip()
    if raw.startswith("```"):
        raw = raw.split("```", 1)[1]
        raw = raw.rsplit("```", 1)[0]
        raw = raw.strip()
    return raw



def _append_records_to_file(existing_name, out_file_name, folder, new_records):
    """
    Appends records to an existing File doc OR creates if missing.
    This prevents losing progress mid-run.
    """
    new_text = "\n".join(json.dumps(r, ensure_ascii=False) for r in new_records).strip()
    if not new_text:
        return None

    if existing_name:
        file_doc = frappe.get_doc("File", existing_name)
        old_text = (file_doc.content or "")
        if isinstance(old_text, (bytes, bytearray)):
            old_text = old_text.decode("utf-8", "ignore")
        if not old_text:
            old_text = (file_doc.get_content() or "").strip()

        combined = (old_text.rstrip() + "\n" + new_text).strip() if old_text else new_text
        file_doc.content = combined
        file_doc.folder = folder
        file_doc.is_private = 0
        file_doc.save(ignore_permissions=True)
    else:
        file_doc = frappe.get_doc({
            "doctype": "File",
            "file_name": out_file_name,
            "content": new_text,
            "is_private": 0,
            "folder": folder,
        }).insert(ignore_permissions=True)

    frappe.db.commit()
    return file_doc


@frappe.whitelist(allow_guest=False)
def generate_training_data(module_name: str, total_count: int):
    """
    Updated version:
    - Retry+backoff for 429/5xx
    - Batch-by-batch incremental save (no progress loss)
    - Correct batching (ceil)
    """
    total_count = int(total_count)
    out_file_name = f"{module_name}.jsonl"
    folder = "Home/Training Data/Batch 2"

    # 1) Load existing
    existing_name, old_text, seen_anchors, existing_count = _load_existing_file(out_file_name, folder)

    client = _get_openai_client()

    # We will generate in loops until we reach requested total_count NEW records
    total_generated_raw = 0
    total_validated = 0
    total_removed_positives = 0

    # how many new records do we still need?
    remaining = total_count
    max_outer_loops = math.ceil(total_count / BATCH_SIZE) + 10

    last_file_doc = None

    for _outer in range(max_outer_loops):
        if remaining <= 0:
            break

        # 2) Generate one "chunk" up to remaining (but OpenAI returns BATCH_SIZE)
        chunk_target = min(remaining, BATCH_SIZE)
        raw_records = _generate_raw_records(client, module_name, chunk_target, seen_anchors)
        if not raw_records:
            continue

        total_generated_raw += len(raw_records)

        # 3) Validate
        validated_records, removed = _validate_records(raw_records)
        total_removed_positives += removed

        if not validated_records:
            continue

        # 4) Assign QIDs for THIS batch based on current existing_count
        final_records = _assign_qids(validated_records, module_name, existing_count)

        # 5) Append-save immediately (progress safe)
        try:
            last_file_doc = _append_records_to_file(existing_name, out_file_name, folder, final_records)
            if last_file_doc and not existing_name:
                # if file was created just now, capture its name for future appends
                existing_name = last_file_doc.name
        except Exception as e:
            frappe.log_error(traceback.format_exc(), "Append save failed")
            return {"ok": False, "message": str(e)}

        # update counters
        existing_count += len(final_records)
        total_validated += len(final_records)
        remaining -= len(final_records)

    if total_validated <= 0:
        return {"ok": False, "message": "No valid records generated. Check Error Log."}

    start_qid = f"{module_name}_{str(existing_count - total_validated + 1).zfill(3)}"
    end_qid = f"{module_name}_{str(existing_count).zfill(3)}"

    return {
        "ok": True,
        "file_url": (last_file_doc.file_url if last_file_doc else None),
        "file_docname": (last_file_doc.name if last_file_doc else existing_name),
        "generated": total_generated_raw,
        "after_validation": total_validated,
        "positives_removed": total_removed_positives,
        "message": (
            f"Generated {total_generated_raw} → "
            f"Validated {total_validated} → "
            f"Saved with QIDs {start_qid} to {end_qid}"
        )
    }

@frappe.whitelist(allow_guest=False)
def start_train(module_name: str, total_count: int):
    frappe.enqueue(
        "changai.changai.api.v2.train_data_api.generate_training_data",
        queue="long",
        timeout=14400,
        module_name=module_name,
        total_count=total_count,
    )

    return {"ok": True, "message": "Training job queued."}


def _training_prompt(module_name: str) -> str:
    return f"""
You are generating training data for an ERPNext assistant.

TASK:
Generate EXACTLY {BATCH_SIZE} training records for the {module_name} module in Frappe/ERPNext.

OUTPUT FORMAT (STRICT):
- Return ONLY a valid JSON ARRAY.
- The array must contain EXACTLY {BATCH_SIZE} objects.
- Do NOT output JSONL.
- Do NOT output markdown.
- Do NOT output code fences.
- Do NOT output explanations.
- Start directly with "[" and end with "]".

SCHEMA (keys must match exactly):
{{
  "anchor": "...",
  "positives": ["...", "..."]
}}

ANCHOR RULES:
- Casual, messy, real chat style.
- Do NOT mention DocType or table names in anchor.
- Use business wording and synonyms.
- Include time filters, grouping, ranking where relevant.

POSITIVES RULES:
- positives is a LIST OF STRINGS.
- Each string should be short and single-line.
- Include ALL required tables and fields needed to answer the question:
  - Filters: item_code, status, warehouse, posting_date
  - Joins: include join keys on both sides (e.g., child.parent + parent.name)
  - Aggregates: include group-by field + sum/count field
  - Child tables: MUST include parent table AND join field
  - Include docstatus if query implies document state

POSITIVES FORMAT EXAMPLES:
- "[TABLE] tabBin | desc: stock balance per item per warehouse"
- "[FIELD] item_code | [TABLE] tabBin | desc: item filter"
- "[FIELD] actual_qty | [TABLE] tabBin | desc: available quantity"
- "[FIELD] parent | [TABLE] tabSales Invoice Item | desc: join to invoice"
- "[FIELD] name | [TABLE] tabSales Invoice | desc: invoice id"

EXAMPLE OUTPUT STRUCTURE:
[
  {{
    "qid": "{module_name}_01",
    "anchor": "stock left for item xyz in kochi warehouse?",
    "positives": [
      "[TABLE] tabBin | desc: stock per item/warehouse",
      "[FIELD] item_code | [TABLE] tabBin | desc: filter item",
      "[FIELD] warehouse | [TABLE] tabBin | desc: filter warehouse",
      "[FIELD] actual_qty | [TABLE] tabBin | desc: available quantity"
    ]
  }}
]

Now generate the JSON array with exactly {BATCH_SIZE} objects:
IMPORTANT:
- Output MUST start with '[' and end with ']'
- Do NOT include ``` or ```json anywhere
""".strip()

# to Audit all train files - if still any non Existing Meta after correction?
@frappe.whitelist(allow_guest=False)
def audit_file(file_name, folder="Home/Training Data/Batch 2"):
    file_doc_name = frappe.db.get_value("File", {
        "file_name": file_name,
        "folder": folder
    }, "name")
    
    file_doc = frappe.get_doc("File", file_doc_name)
    content = file_doc.get_content()
    
    records_ok = []
    records_removed = []  # whole record removed
    positives_removed = []  # only specific positive removed

    for line in content.splitlines():
        line = line.strip()
        if not line:
            continue
        
        obj = json.loads(line)
        positives = obj.get("positives", [])
        qid = obj.get("qid", "unknown")
        anchor = obj.get("anchor", "")

        bad_positives = []
        good_positives = []

        for positive in positives:
            reason = None

            # ── Check TABLE ──────────────────────────────
            table_match = re.search(r'\[TABLE\]\s+([\w\s]+?)(?:\s*\||\s*$)', positive)
            if table_match:
                table = table_match.group(1).strip()
                doctype = table[3:] if table.startswith("tab") else table
                if not frappe.db.exists("DocType", doctype):
                    reason = f"DocType '{doctype}' does not exist"

            # ── Check FIELD ──────────────────────────────
            field_match = re.match(r'\[FIELD\]\s+(\w+)\s+\|\s+\[TABLE\]\s+([\w\s]+?)(?:\s*\||\s*$)', positive)
            if field_match and not reason:
                field = field_match.group(1).strip()
                table = field_match.group(2).strip()
                doctype = table[3:] if table.startswith("tab") else table

                if field in SYSTEM_FIELDS:
                    pass  # always valid
                elif frappe.db.exists("DocType", doctype):
                    meta = frappe.get_meta(doctype)
                    field_names = [f.fieldname for f in meta.fields]
                    if field not in field_names:
                        reason = f"Field '{field}' does not exist in '{doctype}'"
                else:
                    reason = f"DocType '{doctype}' does not exist"

            if reason:
                bad_positives.append({"positive": positive, "reason": reason})
            else:
                good_positives.append(positive)

        # ── Classify record ──────────────────────────────
        if not bad_positives:
            records_ok.append(qid)

        elif not good_positives:
            # whole record would be removed
            records_removed.append({
                "qid": qid,
                "anchor": anchor,
                "bad_positives": bad_positives
            })

        else:
            # record kept but some positives stripped
            positives_removed.append({
                "qid": qid,
                "anchor": anchor,
                "bad_positives": bad_positives,
                "good_positives": good_positives
            })
    return {
        "summary": {
            "total_records": len(records_ok) + len(records_removed) + len(positives_removed),
            "clean": len(records_ok),
            "fully_removed": len(records_removed),
            "partial_removed": len(positives_removed),
        }
    }