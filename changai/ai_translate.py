import os
import frappe
from anthropic import Anthropic


@frappe.whitelist()
def translate_and_store(docname, from_field, text, to_language):
    """
    Translates text and stores it in a dynamically created Item field
    """

    if not text:
        frappe.throw("No text to translate")

   
    settings = frappe.get_single("ChangAI Settings")

    try:
        api_key = settings.get_password("claude_api_key")
    except Exception:
        api_key = None

    if not api_key:
        api_key = os.getenv("ANTHROPIC_API_KEY")

    if not api_key:
        frappe.throw("Claude API key is not set")

    client = Anthropic(api_key=api_key)

    prompt = f"""
Translate the following text into {to_language}.
Return ONLY the translated text.

Text:
{text}
"""

    response = client.messages.create(
        model="claude-3-haiku-20240307",
        max_tokens=1024,
        temperature=0,
        messages=[{"role": "user", "content": prompt}]
    )

    translated_text = response.content[0].text.strip()

   
    lang_code = to_language.lower().replace(" ", "_")
    target_fieldname = f"{from_field}_{lang_code}"

    if not frappe.db.exists(
        "Custom Field",
        {
            "dt": "Item",
            "fieldname": target_fieldname
        }
    ):
        frappe.get_doc({
            "doctype": "Custom Field",
            "dt": "Item",
            "label": f"{from_field.replace('_', ' ').title()} ({to_language})",
            "fieldname": target_fieldname,
            "fieldtype": "Data",
            "insert_after": from_field,
            "read_only": 1
        }).insert(ignore_permissions=True)

        frappe.clear_cache(doctype="Item")

   
    item = frappe.get_doc("Item", docname)
    item.set(target_fieldname, translated_text)
    item.save(ignore_permissions=True)

    return target_fieldname