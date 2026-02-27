import os
import json
import re
import frappe
from anthropic import Anthropic

TARGET_COUNT = 200
BATCH_SIZE = 10
MAX_ATTEMPTS = 50



def ensure_validation_folder() -> str:
    folder_name = "Validation Data"
    parent_folder = "Home"
    full_path = f"{parent_folder}/{folder_name}"

    folder = frappe.get_value(
        "File",
        {
            "file_name": folder_name,
            "folder": parent_folder,
            "is_folder": 1
        },
        "name"
    )

    if folder:
        return full_path

    frappe.get_doc({
        "doctype": "File",
        "file_name": folder_name,
        "folder": parent_folder,
        "is_folder": 1,
        "is_private": 0
    }).insert(ignore_permissions=True, ignore_if_duplicate=True)

    return full_path


def append_validation_file(folder: str, filename: str, new_records: list[dict]):
    if not new_records:
        return

    existing_file = frappe.get_value(
        "File",
        {
            "file_name": filename,
            "folder": folder,
            "is_folder": 0
        },
        "name"
    )

    new_content = "\n".join(
        json.dumps(record, ensure_ascii=False) for record in new_records
    ) + "\n"

    if existing_file:
        file_doc = frappe.get_doc("File", existing_file)
        old_content = file_doc.get_content() or ""
        file_doc.content = (old_content + new_content).encode("utf-8")
        file_doc.save(ignore_permissions=True)
    else:
        frappe.get_doc({
            "doctype": "File",
            "file_name": filename,
            "folder": folder,
            "content": new_content.encode("utf-8"),
            "is_private": 0
        }).insert(ignore_permissions=True)


def load_existing_records(folder: str, filename: str) -> list[dict]:
    file_name = frappe.get_value(
        "File",
        {
            "file_name": filename,
            "folder": folder,
            "is_folder": 0
        },
        "name"
    )

    if not file_name:
        return []

    content = frappe.get_doc("File", file_name).get_content() or ""
    records = []

    for line in content.splitlines():
        try:
            records.append(json.loads(line))
        except Exception:
            continue

    return records


@frappe.whitelist(allow_guest=True)
def _get_claude_client() -> Anthropic:
    settings = frappe.get_single("ChangAI Settings")

    try:
        api_key = settings.get_password("claude_api_key")
    except Exception:
        api_key = None

    if not api_key:
        api_key = os.getenv("ANTHROPIC_API_KEY")

    if not api_key:
        frappe.throw("Claude API key is not set")

    return Anthropic(api_key=api_key)



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


def _training_prompt(module_name, description, schema_context, count):
    return f"""
You are generating ERPNext schema-retrieval training data.
This is for production testing of a trained retrieval model, so focus on variety and real-world business questions only from the schema below.
CRITICAL OUTPUT RULE:
Return ONLY valid JSON wrapped inside <json>...</json>.
ANCHOR RULES:
- Questions must be data fetch/lookup intent only
- Casual, messy, real chat style.
- Mix styles: ultra-short ("helmet stock dubai"), casual ("how many cement bags in sharjah?"), urgency ("need diesel qty in muscat asap"), doubt ("any PVC fittings left in doha or not?") et..
- cover all styles of queriy types in the output, with no specific ratio. The more variety the better.
- Do NOT mention DocType or table names in anchor.
- Use business wording and synonyms.
<json>
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
</json>
REQUIREMENTS:
- Generate EXACTLY {count} UNIQUE objects
- Use ONLY schema below
- NEVER include Doctype names in questions
- Casual business language
- Grammar mistakes allowed
- This is for testing a trained Model in retrieval, so focus on covering all varieties and production oriented questions.
- {module_name}: {description}
SCHEMA:
Create Questions for the below schema only.Nothing from outside this schema. Focus on variety of questions that can be asked only from this schema.!!
{schema_context}
""".strip()

def _extract_json_block(text: str) -> list[dict]:
    match = re.search(r"<json>(.*?)</json>", text, re.S)
    if not match:
        return []

    try:
        parsed = json.loads(match.group(1).strip())
        return parsed if isinstance(parsed, list) else []
    except Exception:
        return []



@frappe.whitelist(allow_guest=True)
def generate_validation_data(module_name: str,description:str, total_count: int = TARGET_COUNT):
    # module_examples = {
    #     "Buying": "supplier delays, overdue purchase orders",
    #     "CRM": "lead followups, pipeline confusion",
    #     "Stock": "warehouse stock mismatch",
    #     "HR": "attendance and payroll issues",
    #     "Selling": "pending invoices, discounts"
    # }
    schema_context = build_schema_context_for_module(module_name)
    if not schema_context:
        frappe.throw(f"No schema found for module {module_name}")

    folder = ensure_validation_folder()
    filename = f"{module_name.lower()}_test.jsonl"

    existing = load_existing_records(folder, filename)
    start_index = len(existing) + 1
    remaining = TARGET_COUNT - len(existing)

    if remaining <= 0:
        return {
            "ok": True,
            "questions_written": len(existing),
            "expected_questions": TARGET_COUNT,
            "message": "Target already satisfied"
        }

    client = _get_claude_client()
    new_records = []
    attempts = 0

    while remaining > 0 and attempts < MAX_ATTEMPTS:
        attempts += 1

        prompt = _training_prompt(
            module_name,
            description,
            schema_context,
            min(BATCH_SIZE, remaining)
        )

        resp = client.messages.create(
            model="claude-3-haiku-20240307",
            max_tokens=3000,
            temperature=0.15,
            messages=[{"role": "user", "content": prompt}]
        )

        data = _extract_json_block(resp.content[0].text or "")
        if not data:
            continue

        for obj in data:
            if remaining <= 0:
                break
            if not obj.get("anchor") or not obj.get("positives"):
                continue

            new_records.append({
                "qid": f"{module_name}_{str(start_index).zfill(3)}",
                "anchor": obj["anchor"],
                "positives": obj["positives"]
            })

            start_index += 1
            remaining -= 1

    append_validation_file(folder, filename, new_records)
    frappe.db.commit()

    if remaining > 0:
        frappe.log_error(
            "ChangAI Partial Generation",
            f"{module_name}: {TARGET_COUNT - remaining}/{TARGET_COUNT} after {attempts} attempts"
        )

    existing_count = len(existing)
    is_append = existing_count > 0

    # return {
    #     "ok": remaining == 0,
    #     "folder": folder,
    #     "file": filename,
    #     "questions_written": len(existing) + len(new_records),
    #     "expected_questions": TARGET_COUNT,
    #     "attempts": attempts,
    #     "message": (
    #         "Full dataset generated"
    #         if remaining == 0
    #         else f"Partial dataset: {TARGET_COUNT - remaining}/{TARGET_COUNT}"
    #     )
    # }
    return {
    "ok": remaining == 0,
    "folder": folder,
    "file": filename,
    "previous_records": existing_count,
    "new_records_added": len(new_records),
    "questions_written": existing_count + len(new_records),
    "expected_questions": TARGET_COUNT,
    "starting_qid": (
        f"{module_name}_{str(existing_count + 1).zfill(3)}"
        if is_append else f"{module_name}_001"
    ),
    "attempts": attempts,
    "message": (
        f"Appended {len(new_records)} new records to existing file "
        f"({existing_count} already present). QIDs continued from "
        f"{module_name}_{str(existing_count + 1).zfill(3)}."
        if is_append else
        "New validation file created and populated from scratch."
    )
}

#*************************************************************************************************************

@frappe.whitelist()
def generate_validation_data_for_modules(modules, total_count: int = TARGET_COUNT):
    """
    Generate validation data ONLY for selected modules & descriptions
    """

    if isinstance(modules, str):
        modules = frappe.parse_json(modules)

    if not modules:
        frappe.throw("No modules selected")

    results = []

    for row in modules:
        module_name = row.get("module")
        description = row.get("description")

        if not module_name or not description:
            results.append({
                "module": module_name,
                "ok": False,
                "error": "Missing module or description"
            })
            continue

        try:
            result = generate_validation_data(
                module_name=module_name,
                description=description,   
                total_count=total_count
            )

            if not result.get("file_path"):
                frappe.log_error(
                    f"No file generated for module {module_name}",
                    "ChangAI Validation Empty Output"
                )

            results.append({
                "module": module_name,
                "ok": True,
                "file_path": result.get("file_path"),
                "records": result.get("records_generated", 0)
            })

        except Exception:
            frappe.log_error(
                frappe.get_traceback(),
                f"ChangAI Validation Generation Failed: {module_name}"
            )
            results.append({
                "module": module_name,
                "ok": False,
                "error": "Exception during generation"
            })

    return {
        "ok": True,
        "modules_processed": len(results),
        "results": results,
        "message": f"Validation data generated for {len(results)} module(s)"
    }