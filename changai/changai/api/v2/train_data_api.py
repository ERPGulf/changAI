from __future__ import annotations
from frappe.utils.file_manager import get_file
import json
import os
import math
from typing import Any, Dict

import frappe
from frappe import _
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

import os, json, math
import frappe
import anthropic
import json, math
import frappe
import anthropic
from frappe.utils.file_manager import save_file
import json, math
import frappe
import anthropic
from frappe.utils.file_manager import save_file
import json, math
import frappe
import anthropic

import frappe
from frappe.utils.file_manager import get_file_path

@frappe.whitelist(allow_guest=False)
def test():
    file_name = frappe.db.get_value("File", {
        "file_name": "HR.jsonl",
        "folder": "Home/Training Data/Batch 2"
    }, "name")
    doc = frappe.get_doc("File", file_name)
    return doc.get_content()
@frappe.whitelist(allow_guest=False)
def generate_training_data(module_name: str, total_count: int):
    settings = frappe.get_single("ChangAI Settings")
    api_key = settings.get_password("claude_api_key")
    if not api_key:
        frappe.throw("Claude API key missing in ChangAI Settings")

    client = anthropic.Anthropic(api_key=api_key)

    total_count = int(total_count)
    num_reqs = math.ceil(total_count / 25)

    out_file_name = f"{module_name}.jsonl"
    folder = "Home/Training Data/Batch 2"

    existing_name = frappe.db.get_value("File", {"file_name": out_file_name}, "name")

    old_text = ""
    seen = set()

    if existing_name:
        file_doc = frappe.get_doc("File", existing_name)

        old_text = (file_doc.content or "")
        if isinstance(old_text, (bytes, bytearray)):
            old_text = old_text.decode("utf-8", "ignore")

        old_text = (old_text or "").strip()
        if not old_text:
            old_text = (file_doc.get_content() or "").strip()

        for line in old_text.splitlines():
            line = line.strip()
            if not line:
                continue
            try:
                obj = json.loads(line)
                if isinstance(obj, dict):
                    a = (obj.get("anchor") or "").strip()
                    if a:
                        seen.add(a)
            except Exception:
                pass

    new_lines = []
    system=(
  "You must output ONLY valid JSON. "
  "Output must start with '[' and end with ']'. "
  "Do NOT use markdown. Do NOT use code fences like ``` or ```json. "
  "Do NOT add any explanation text."
)
    for _ in range(num_reqs):
        if len(new_lines) >= total_count:
            break

        resp = client.messages.create(
            model="claude-sonnet-4-5",
            max_tokens=6000,
            system=system,
            messages=[{"role": "user", "content": _training_prompt(module_name)}],
        )

        raw = "".join(block.text for block in resp.content if hasattr(block, "text")).strip()
                
        # ✅ Remove markdown code fences if present
        if raw.startswith("```"):
            # remove starting ```json or ```
            raw = raw.split("```", 1)[1]
            raw = raw.rsplit("```", 1)[0]
            raw = raw.strip()

        # 🔥 DEBUG once (keep it for now)
        frappe.log_error(raw[:1500], "CLAUDE_RAW_OUTPUT")

        try:
            arr = json.loads(raw)
        except Exception:
            frappe.log_error(raw[:1500], "Claude output not JSON array")
            continue
        for obj in arr:
            if not isinstance(obj, dict):
                continue
            anchor = (obj.get("anchor") or "").strip()
            positives = obj.get("positives")
            if not anchor or not isinstance(positives, list) or not positives:
                continue
            if anchor in seen:
                continue
            seen.add(anchor)
            new_lines.append(json.dumps(obj, ensure_ascii=False))

            if len(new_lines) >= total_count:
                break

    # ✅ IMPORTANT: don’t save if nothing generated
    if not new_lines:
        return {"ok": False, "message": "No valid objects returned. Check Error Log: CLAUDE_RAW_OUTPUT / Claude output not JSON array."}

    new_text = "\n".join(new_lines).strip()
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
            return {"ok":False,"message":str(e)}

    frappe.db.commit()

    return {
        "ok": True,
        "file_url": file_doc.file_url,
        "file_docname": file_doc.name,
        "new_lines_added": len(new_lines),
        "total_unique_questions": len(seen),
        "message": f"Added {len(new_lines)} lines. Total unique: {len(seen)}.",
    }


def _training_prompt(module_name: str) -> str:
    return f"""
You are generating training data for an ERPNext assistant.

TASK:
Generate EXACTLY 25 training examples for ERPNext module: {module_name}

OUTPUT FORMAT (STRICT):
- Return ONLY a valid JSON ARRAY.
- The array must contain EXACTLY 25 objects.
- Do NOT output JSONL.
- Do NOT output markdown.
- Do NOT output code fences.
- Do NOT output explanations.
- Start directly with "[" and end with "]".

SCHEMA (keys must match exactly):
{{
  "qid": "{module_name}_NNN",
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

Now generate the JSON array with exactly 25 objects:
IMPORTANT:
- Output MUST start with '[' and end with ']'
- Do NOT include ``` or ```json anywhere
""".strip()

@frappe.whitelist(allow_guest=False)
def start_train(module_name: str, total_count: int):
    frappe.enqueue(
        "changai.changai.api.v2.train_data_api.generate_training_data",
        queue="long",
        timeout=14400,
        module_name=module_name,
        total_count=total_count,
    )
    return {"ok": True, "message": "Train Created Job running."}
import anthropic

