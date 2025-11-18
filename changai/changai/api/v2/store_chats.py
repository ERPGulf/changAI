import json
import frappe
import requests 
@frappe.whitelist(allow_guest=True)
def save_message_doc(session_id:str,message_type:str,content:str):
    if message_type not in ["ai","human"]:
        frappe.throw("message_type must be 'human' or 'ai'")
    doc=frappe.get_doc({
        "doctype":"ChangAI Chat History",
        "session_id": session_id,
        "message_type": message_type,
        "content": content or ""
    })
    doc.insert(ignore_permissions=True)
    frappe.db.commit()
    return doc.name


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
def save_turn(session_id:str,user_text:str,bot_text:str):
    if user_text:
        user_row=save_message_doc(session_id,"human",user_text)
    if bot_text:
        ai_row=save_message_doc(session_id,"ai",bot_text)
    return ai_row,user_row


@frappe.whitelist(allow_guest=True)
def save_turn_2(session_id: str, user_text: str = None, bot_text: str = None):
    doc_name = frappe.db.exists("ChangAI Chat History", {"session_id": session_id})

    current_value = ""
    if doc_name:
        current_value = frappe.db.get_value(
            "ChangAI Chat History",
            doc_name,
            "content"
        ) or ""

    lines = []
    if current_value:
        lines.append(current_value)
    if user_text:
        lines.append(json.dumps({"human": user_text}, ensure_ascii=False))
    if bot_text:
        lines.append(json.dumps({"ai": bot_text}, ensure_ascii=False))

    new_content = "\n".join(lines)

    if doc_name:
        # Update directly, bypassing user-level permission checks
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
def get_chat_history(session_id):
    rows=frappe.get_all("ChangAI Chat History",filters={"session_id":session_id},fields=["content","message_type"])
    rows.reverse()
    result=[]
    for item in rows:
        rec={item["message_type"]:item["content"]}
        result.append(rec)
    return result

@frappe.whitelist(allow_guest=True)
def get_chat_history_1(session_id):
    doc_name = frappe.db.exists("ChangAI Chat History", {"session_id": session_id})
    if not doc_name:
        return ""
    # Use db.get_value instead of get_doc to avoid read perm issues
    current_value = frappe.db.get_value(
        "ChangAI Chat History",
        doc_name,
        "content"
    )
    return current_value or ""

# PROMPT_FOLLOWUP="""
# You are a Query Rewriter.

# Below is the recent chat history between the user and the assistant.
# Title: Chat History
# {rows}

# (Only the last 10 messages are shown.)

# Task:
# 1. Review the conversation context.
# 2. If the latest user message appears to be a *follow-up* (refers to something mentioned earlier),
#    rewrite it into a complete, standalone question that includes the missing context based on the chat history.
# 3. If it is **not** a follow-up, return the message unchanged.

# Latest User Question:
# {qstn}

# Rules:
# - Return ONLY the rewritten question text — no explanations, no extra text, no JSON, no placeholders.
# - Do NOT prefix with anything like "Rewritten:" or "Question:".
# - Output must contain only the final question as plain text.

# """

PROMPT_FOLLOWUP = """You are ChangAI, an ERP query rewriter.

Task:
Rewrite the latest user message into a complete standalone question.

Chat history:
- It is a list of JSON-like lines.
- Use ONLY the human messages as context.
- IGNORE all ai messages completely (do not copy their wording or numbers).

Rules:
- If the latest message is a follow-up, expand it using only human messages from history.
- If it is NOT a follow-up, return it unchanged.
- Do NOT answer the question.
- Do NOT provide results, counts, or dates.
- Do NOT add information that is not present in the human messages or the latest message.
- Output exactly ONE plain-text question, no explanations, no SQL, no markdown.
- Do not use ai message for formatting the latest question.

Chat history:
{rows}

Latest user message:
{qstn}
"""


@frappe.whitelist(allow_guest=True)
def inject_prompt(user_qstn,session_id):
    rows=get_chat_history_1(session_id)
    prompt=PROMPT_FOLLOWUP.format(rows=rows,qstn=user_qstn)
    return prompt


@frappe.whitelist(allow_guest=True)
def save_logs(user_question, formatted_q, context, sql, val, tries, err, formatted_result):
    doc = frappe.new_doc("ChangAI Logs")
    doc.user_question = user_question
    doc.rewritten_question = formatted_q
    doc.schema_retrieved = context
    doc.sql_generated = sql
    doc.validation = val
    doc.tries = tries
    doc.error = err
    doc.formatted_result = formatted_result
    doc.insert(ignore_permissions=True)
    frappe.db.commit()
    return doc.name
