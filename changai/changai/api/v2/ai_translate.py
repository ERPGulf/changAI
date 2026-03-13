import os
import frappe
from frappe import _
from anthropic import Anthropic

@frappe.whitelist()
def translate_and_store(docname, doctype, from_field, text, to_language):  # ← add doctype param
    """
    Translates text and stores it in a dynamically created field
    """
    if not text:
        frappe.throw(_("No text to translate"))
    settings = frappe.get_single("ChangAI Settings")
    try:
        api_key = settings.claude_api_key
    except Exception:
        api_key = None
    if not api_key:
        api_key = os.getenv("ANTHROPIC_API_KEY")
    if not api_key:
        frappe.throw(
            _(
                "Claude API key is not configured.<br><br>"
                "Please go to <b>Remote Tab in ChangAI Settings</b> and enter your <b>Claude API Key</b>.<br><br>"
                "Get your API key from "
                "<a href='https://console.anthropic.com/account/keys' target='_blank'>Anthropic Console</a>."
            ),
            title=_("Missing Claude API Key")
        )
    try:
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
    except anthropic.AuthenticationError:
        frappe.throw(
            _(
                "Claude API key is invalid.<br><br>"
                "Please go to <b>ChangAI Settings</b> and enter a valid <b>Claude API Key</b>."
            ),
            title=_("Invalid Claude API Key")
        )
    except anthropic.RateLimitError:
        frappe.throw(
            _(
                "Claude API rate limit exceeded.<br><br>"
                "Please wait a moment and try again, or upgrade your Anthropic plan."
            ),
            title=_("Claude Rate Limit Exceeded")
        )
    except anthropic.APIConnectionError:
        frappe.throw(
            _(
                "Could not connect to Claude API.<br><br>"
                "Please check your internet connection and try again."
            ),
            title=_("Claude Connection Error")
        )
    except anthropic.APIStatusError as e:
        frappe.throw(
            _(
                "Claude API error (status {0}): {1}"
            ).format(e.status_code, str(e)),
            title=_("Claude API Error")
        )
    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "Claude Translate Unexpected Error")
        frappe.throw(
            _("Translation failed: {0}").format(str(e)),
            title=_("Translation Error")
        )
    lang_code = to_language.lower().replace(" ", "_")
    target_fieldname = f"{from_field}_{lang_code}"
    if not frappe.db.exists(
        "Custom Field",
        {
            "dt": doctype,
            "fieldname": target_fieldname
        }
    ):
        frappe.get_doc({
            "doctype": "Custom Field",
            "dt": doctype,
            "label": f"{from_field.replace('_', ' ').title()} ({to_language})",
            "fieldname": target_fieldname,
            "fieldtype": "Data",
            "insert_after": from_field,
            "read_only": 1
        }).insert(ignore_permissions=True)
        frappe.clear_cache(doctype=doctype)
    doc = frappe.get_doc(doctype, docname)
    doc.set(target_fieldname, translated_text)
    doc.save(ignore_permissions=True)
    return target_fieldname
