import json
import frappe
from typing import Any
CHANGAI_CHAT_HIST_DOC = "ChangAI Chat History"
 
def save_message_doc(session_id:str,message_type:str,content:str):

    doc=frappe.get_doc({
        "doctype":CHANGAI_CHAT_HIST_DOC,
        "session_id": session_id,
        "message_type": message_type,
        "content": content or ""
    })
    doc.insert(ignore_permissions=True)
    return doc.name


@frappe.whitelist(allow_guest=False)
def save_turn_2(session_id: str, user_text: str=None, bot_text: Any = None):
    # find existing document
    doc_name = frappe.db.exists(CHANGAI_CHAT_HIST_DOC, {"session_id": session_id})

    history = []
    if doc_name:
        raw = frappe.db.get_value(CHANGAI_CHAT_HIST_DOC, doc_name, "content")
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
            CHANGAI_CHAT_HIST_DOC,
            doc_name,
            "content",
            new_content,
            update_modified=True
        )
        return doc_name

    else:
        doc = frappe.get_doc({
            "doctype": CHANGAI_CHAT_HIST_DOC,
            "session_id": session_id,
            "content": new_content
        })
        doc.insert(ignore_permissions=True)
        return doc.name


@frappe.whitelist(allow_guest=False)
def get_chat_history(session_id: str) -> list:
    doc_name = frappe.db.exists(CHANGAI_CHAT_HIST_DOC, {"session_id": session_id})
    if not doc_name:
        return []

    raw = frappe.db.get_value(
        CHANGAI_CHAT_HIST_DOC,
        doc_name,
        "content"
    )

    if not raw:
        return []

    try:
        history = json.loads(raw)
    except Exception:
        return []

    return history[-5:]

@frappe.whitelist(allow_guest=False)
def respond_from_cache(user_question:str):
    if user_question:
        doc=frappe.db.get_value("ChangAI Logs",{"user_question":user_question},["sql_generated","result"],as_dict=False)
        return doc

PROMPT_FOLLOWUP = """You are an ERP query rewriter and entity detector.
Return ONLY valid JSON:
{{"standalone_question":"...","contains_values":true/false}}
TASK 1 — FOLLOW-UP
- If the query depends on previous messages, rewrite it as a complete standalone question.
- Otherwise keep it unchanged.
TASK 2 — ENTITY DETECTION
contains_values = TRUE Any noun that refers to a specific named master record 
(item name, customer name, supplier name, warehouse name, employee name) 
if not sure then also contains_values = TRUE otherwise contains_values = FALSE
Eg:
TASK 3 — ERP CONTEXTUAL REWRITE
1. Normalize:
- Fix typos, clear English
- Do NOT change entity values
2.complete intent
Never change the question's intent — only fix grammar and map ERP terms.
3. ERP mapping:
- Map generic terms to standard ERPNext concepts based on intent
- Avoid vague words if clearer business terms exist
- Do NOT invent documents or use report names.
Examples:
stock → Bin / Stock Ledger Entry
production → Work Order
finance/profit → GL Entry
4. Field hints (max 1–2):
Use natural phrasing ("based on", "using")
sales → grand_total
qty → qty
stock → actual_qty
production → produced_qty
finance → debit / credit
status → status
5. Time fields:
Sales/Stock/Finance → posting_date
Work Order → actual_start_date / actual_end_date
Timesheet → start_date / end_date
Timesheet Detail → from_time / to_time
- NEVER use posting_date for Timesheet
- NEVER use creation unless asked
6. Relationships:
- Include linked entities if required
STYLE:
- Natural business language
- No SQL, no tab* names
EXAMPLES:
"total sales amount last month"
→ What is the total sales amount from Sales Invoices last month based on grand_total and posting_date?
"stock in warehouse a"
→ What is the stock quantity in Warehouse A based on actual_qty from Bin?
"who worked today"
→ Which employees logged time today based on Timesheet start_date or Timesheet Detail from_time?
If the query mentions Draft, Submitted, or Cancelled, explicitly include docstatus in the rewritten question.
- Do not add a specific document type unless it is clearly implied by the user query or required by standard ERPNext business meaning.
- For vague money questions, clarify the business meaning as actual, ordered, quoted, paid, or outstanding, but do not guess the document type incorrectly.
- If the user says "spend", treat it as actual purchase/expense, not quotation or order commitment, unless the user explicitly mentions order, quotation, or planned purchase.
- Preserve all filter conditions, status values, and keywords from the original question — never drop them during rewriting.

Chat history:
{rows}
User:
{qstn}
"""
@frappe.whitelist(allow_guest=False)
def inject_prompt(user_qstn: str, session_id: str) -> str:
    rows=get_chat_history(session_id)
    prompt=PROMPT_FOLLOWUP.format(rows=rows,qstn=user_qstn)
    return prompt


def normalize(value):
    if isinstance(value, str):
        try:
            value = json.loads(value)
        except Exception:
            return value
    if isinstance(value, (list, dict)):
        return json.dumps(value)
    return value