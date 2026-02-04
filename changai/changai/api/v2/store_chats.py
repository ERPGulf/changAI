import json
import frappe
import requests 
def save_message_doc(session_id:str,message_type:str,content:str):

    doc=frappe.get_doc({
        "doctype":"ChangAI Chat History",
        "session_id": session_id,
        "message_type": message_type,
        "content": content or ""
    })
    doc.insert(ignore_permissions=True)
    frappe.db.commit()
    return doc.name


@frappe.whitelist(allow_guest=True)
def save_turn_2(session_id: str, user_text: str=None, bot_text: dict=None):
    import json

    # find existing document
    doc_name = frappe.db.exists("ChangAI Chat History", {"session_id": session_id})

    history = []
    if doc_name:
        raw = frappe.db.get_value("ChangAI Chat History", doc_name, "content")
        if raw:
            try:
                history = json.loads(raw)
            except Exception:
                history = []

    if user_text:
        history.append({"human": user_text})
    if bot_text:
        history.append({"ai": bot_text})
    new_content = json.dumps(history, ensure_ascii=False, indent=2)

    if doc_name:
        frappe.db.set_value(
            "ChangAI Chat History",
            doc_name,
            "content",
            new_content,
            update_modified=True
        )
        frappe.db.commit()
        return doc_name

    else:
        doc = frappe.get_doc({
            "doctype": "ChangAI Chat History",
            "session_id": session_id,
            "content": new_content
        })
        doc.insert(ignore_permissions=True)
        frappe.db.commit()
        return doc.name


@frappe.whitelist(allow_guest=True)
def get_chat_history_1(session_id):
    import json
    doc_name = frappe.db.exists("ChangAI Chat History", {"session_id": session_id})
    if not doc_name:
        return []

    raw = frappe.db.get_value(
        "ChangAI Chat History",
        doc_name,
        "content"
    )

    if not raw:
        return []

    try:
        history = json.loads(raw)
    except Exception:
        return []

    return history[-10:]
PROMPT_FOLLOWUP ="""You are ChangAI, an ERP entity-value detector + query rewriter.

Return ONLY valid JSON with EXACTLY these keys:
{{"standalone_question":"...","contains_values":true/false}}

Meaning of contains_values (STRICT):
- true = the latest message contains ANY explicit or implied ENTITY IDENTIFIER that should be matched to master data
  (customer/supplier/item/warehouse/employee/etc.)

Examples (TRUE):
- "invoice of ayan" (implied name)
- "who bought laptop last month"
- "sales of pens today"
- "top items in electronics category"

- false = NO entity identifier is mentioned.
  This includes queries that only contain filters, time ranges, counts, ranking words, or statuses.

Examples (FALSE):
- "show all customers"
- "unpaid suppliers list"
- "sales orders pending delivery"
- "payment received this month"
- "top vendor dues list"
- "today sales"
- "last 3 customers"

Rules:
- Any reference to a product or product category (even if generic, e.g., laptop, pen, printer, phone, chair, electronics)
  MUST be treated as an entity and set contains_values = true.
- Only entity names/codes or product/category references make contains_values=true.
- Rewrite only if needed; otherwise keep it unchanged.
- When unsure between item vs non-item, prefer contains_values=true.
- true also when the message contains a PRODUCT CATEGORY or ITEM GROUP or any similar entity filters like emntioned before,
  that must be resolved to master data records.

Chat history (use ONLY human lines):
{rows}

Latest user message:
{qstn}
"""
@frappe.whitelist(allow_guest=False)
def respond_from_cache(user_question:str):
    if user_question:
        doc=frappe.db.get_value("ChangAI Logs",{"user_question":user_question},["sql_generated","result"],as_dict=False)
        return doc

@frappe.whitelist(allow_guest=False)
def inject_prompt(user_qstn,session_id):
    rows=get_chat_history_1(session_id)
    prompt=PROMPT_FOLLOWUP.format(rows=rows,qstn=user_qstn)
    return prompt


def normalize(value):
    if isinstance(value, str):
        try:
            value = json.loads(value)
        except:
            pass
    if isinstance(value, (list, dict)):
        value = json.dumps(value)
    return value
