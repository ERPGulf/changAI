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
PROMPT_FOLLOWUP = """You are ChangAI, an ERP entity-value detector + query rewriter.

Return ONLY valid JSON with EXACTLY these keys:
{{"standalone_question":"...","contains_values":true/false}}

### TASK 1 — SPELL CORRECTION:
- Fix any typos or spelling mistakes in the latest message before doing anything else
- Examples:
  - "slaes order of lst mnoth" → "sales order of last month"
  - "whcih custoemr has pendign" → "which customer has pending"
  - "stok of chiar item" → "stock of chair item"

### TASK 2 — CONTINUITY DETECTION:
- Check if the latest message is a follow-up or refers to previous conversation
- Look at the last 3-4 human messages in chat history for context
- If it IS a follow-up, rewrite as a fully self-contained standalone question
- Always put the final rewritten (and corrected) question in "standalone_question"

Follow-up indicators:
- Pronouns with no clear referent: "it", "they", "that", "those", "him", "her", "his"
- Incomplete references: "same customer", "that item", "the one", "same period"
- Continuation words: "also", "and what about", "what else", "show more"
- Short vague messages: "and today?", "what about last month?", "how many?"

Examples:
  History: "show sales of ahmed"
  Latest: "what about his pending invoices"
  → standalone_question: "show pending invoices of ahmed"

  History: "stock of office chair in main warehouse"
  Latest: "what about side tabel?"
  → standalone_question: "stock of side table in main warehouse"

  History: "top 5 customers this month"
  Latest: "show lst month also"
  → standalone_question: "top 5 customers last month"

  History: "employees in accounts department"
  Latest: "hw many are absent today?"
  → standalone_question: "how many employees in accounts department are absent today"

### TASK 3 — ENTITY DETECTION (contains_values):
Meaning of contains_values (STRICT):

TRUE = standalone_question contains ANY explicit or implied ENTITY IDENTIFIER
that should be matched to master data
(customer/supplier/item/warehouse/employee/category etc.)

Examples (TRUE):
- "invoice of ayan" (name)
- "who bought laptop last month" (product)
- "sales of pens today" (product)
- "top items in electronics category" (category)
- "stock of office chair in main warehouse" (item + warehouse)

FALSE = NO entity identifier mentioned.
Only filters, time ranges, counts, ranking words, or statuses.

Examples (FALSE):
- "show all customers"
- "unpaid suppliers list"
- "sales orders pending delivery"
- "payment received this month"
- "top vendor dues list"
- "today sales"

Rules:
- Any product/item/category reference → contains_values = true
- Only entity names/codes or product/category references → contains_values = true
- When unsure between item vs non-item → prefer contains_values = true

### OUTPUT FORMAT (STRICT — no extra keys, no markdown):
{{"standalone_question":"...","contains_values":true/false}}

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