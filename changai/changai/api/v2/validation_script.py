import frappe
import json
import re
import os

_table_cache = {}
_field_cache = {}

SYSTEM_FIELDS = {
    "name", "owner", "creation", "modified", "modified_by",
    "docstatus", "idx", "doctype", "parent", "parenttype",
    "parentfield", "amended_from"
}

def parse_positive(positive):
    if positive.startswith("[TABLE]"):
        match = re.match(r'\[TABLE\]\s+([\w\s]+?)(?:\s*\||\s*$)', positive)
        if match:
            return {"type": "table", "table": match.group(1).strip(), "field": None}
    elif positive.startswith("[FIELD]"):
        match = re.match(r'\[FIELD\]\s+(\w+)\s+\|\s+\[TABLE\]\s+([\w\s]+?)(?:\s*\||\s*$)', positive)
        if match:
            return {"type": "field", "field": match.group(1).strip(), "table": match.group(2).strip()}
    return None

def tab_to_doctype(table_name):
    if table_name.startswith("tab"):
        return table_name[3:]
    return table_name

def validate_table(doctype):
    if doctype not in _table_cache:
        _table_cache[doctype] = bool(frappe.db.exists("DocType", doctype))
    return _table_cache[doctype]

def validate_field(doctype, fieldname):
    if fieldname in SYSTEM_FIELDS:
        return True
    cache_key = f"{doctype}.{fieldname}"
    if cache_key not in _field_cache:
        try:
            meta = frappe.get_meta(doctype)
            field_names = [f.fieldname for f in meta.fields]
            _field_cache[cache_key] = fieldname in field_names
        except:
            _field_cache[cache_key] = False
    return _field_cache[cache_key]

def is_positive_valid(positive):
    parsed = parse_positive(positive)
    if not parsed:
        return False, "Could not parse positive format"

    doctype = tab_to_doctype(parsed["table"])

    if not validate_table(doctype):
        return False, f"Table '{parsed['table']}' (DocType: '{doctype}') does not exist"

    if parsed["type"] == "field":
        if not validate_field(doctype, parsed["field"]):
            return False, f"Field '{parsed['field']}' does not exist in '{doctype}'"

    return True, None

def get_file_path(file_url):
    if "/private/files/" in file_url:
        return frappe.get_site_path("private", "files", file_url.split("/private/files/")[-1])
    elif "/files/" in file_url:
        return frappe.get_site_path("public", "files", file_url.split("/files/")[-1])
    return None

@frappe.whitelist(allow_guest=True)
def run_validation(folder):
    TRAINING_FOLDER = folder

    files = frappe.get_all("File",
        filters={
            "folder": TRAINING_FOLDER,
            "file_name": ["like", "%.jsonl"]
        },
        fields=["file_name", "file_url"]
    )
    if not files:
        frappe.msgprint(f"❌ No .jsonl files found in {TRAINING_FOLDER}")
        return
    frappe.msgprint(f"📂 Found {len(files)} file(s) — starting validation & cleaning...")
    total_records        = 0
    total_removed_records = 0
    total_removed_positives = 0
    total_kept           = 0
    for file in files:
        file_path = get_file_path(file["file_url"])

        if not file_path or not os.path.exists(file_path):
            frappe.msgprint(f"⚠️ Could not locate: {file['file_name']}")
            continue

        frappe.msgprint(f"🔍 Processing: {file['file_name']}")

        try:
            with open(file_path, "r", encoding="utf-8") as f:
                lines = f.readlines()
        except Exception as e:
            frappe.msgprint(f"❌ Could not read {file['file_name']}: {str(e)}")
            continue

        valid_records    = []
        removed_records  = []
        file_total       = 0

        for line in lines:
            line = line.strip()
            if not line:
                continue
            try:
                record = json.loads(line)
            except:
                continue

            file_total    += 1
            total_records += 1

            # ── 1. Check positives is actually a list ──────────────────────
            positives = record.get("positives")
            if not isinstance(positives, list):
                removed_records.append({
                    "qid"   : record.get("qid", "unknown"),
                    "anchor": record.get("anchor", ""),
                    "reason": "positives is not a list"
                })
                total_removed_records += 1
                continue

            # ── 2. Filter out invalid positives, keep valid ones ───────────
            valid_positives   = []
            invalid_positives = []

            for positive in positives:
                is_valid, reason = is_positive_valid(positive)
                if is_valid:
                    valid_positives.append(positive)
                else:
                    invalid_positives.append((positive, reason))
                    total_removed_positives += 1

            # ── 3. Drop whole record only if NO valid positives remain ──────
            if not valid_positives:
                removed_records.append({
                    "qid"   : record.get("qid", "unknown"),
                    "anchor": record.get("anchor", ""),
                    "reason": f"All positives were invalid: {[r for _, r in invalid_positives]}"
                })
                total_removed_records += 1
                continue

            # ── 4. Keep record with only the valid positives ───────────────
            record["positives"] = valid_positives
            valid_records.append(record)
            total_kept += 1

        # Overwrite original file with cleaned records
        try:
            with open(file_path, "w", encoding="utf-8") as f:
                for record in valid_records:
                    f.write(json.dumps(record) + "\n")

            frappe.msgprint(
                f"✅ {file['file_name']}\n"
                f"   Total: {file_total} | Kept: {len(valid_records)} | "
                f"Removed records: {len(removed_records)} | Removed positives: {total_removed_positives}"
            )

            if removed_records:
                preview = "\n".join([
                    f"  ❌ [{r['qid']}] → {r['reason']}"
                    for r in removed_records[:5]
                ])
                if len(removed_records) > 5:
                    preview += f"\n  ... and {len(removed_records) - 5} more"
                frappe.msgprint(preview)

        except Exception as e:
            frappe.msgprint(f"❌ Could not overwrite {file['file_name']}: {str(e)}")

    frappe.msgprint(
        f"🏁 Done!\n"
        f"   Total records: {total_records}\n"
        f"   Records kept: {total_kept}\n"
        f"   Records fully removed: {total_removed_records}\n"
        f"   Individual positives removed: {total_removed_positives}"
    )