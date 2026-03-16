import os
import frappe
from frappe import _
from anthropic import Anthropic

@frappe.whitelist()
def translate_and_store(docname, doctype, from_field,to_field, text, to_language):  # ← add doctype param
    """
    Translates text and stores it in a dynamically created field
    """
    meta = frappe.get_meta(doctype)
    field_meta = meta.get_field(to_field)

    if field_meta and field_meta.fieldtype == "Link":
        frappe.throw(
            f"Field '{to_field}' is a Link field and cannot be translated in place."
        )
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
    frappe.clear_cache(doctype=doctype)
    doc = frappe.get_doc(doctype, docname)
    if not hasattr(doc, to_field):
        frappe.throw(f"Field '{to_field}' does not exist on Item")
    doc.set(to_field, translated_text)
    doc.save(ignore_permissions=True)
    return to_field
