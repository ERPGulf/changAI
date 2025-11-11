import json
import frappe
import requests 
@frappe.whitelist(allow_guest=True)
def save_message_doc(session_id:str,message_type:str,content:str):
    if message_type not in ["ai","human"]:
        frappe.throw("message_type must be 'human' or 'ai'")
    doc=frappe.get_doc({
        "doctype":"ChangAI Log",
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
def get_chat_history(session_id):
    rows=frappe.get_all("ChangAI Log",filters={"session_id":session_id},fields=["content","message_type"])
    rows.reverse()
    result=[]
    for item in rows:
        rec={item["message_type"]:item["content"]}
        result.append(rec)
    return result
PROMPT_FOLLOWUP="""
You are a Query Rewriter.

Below is the recent chat history between the user and the assistant.
Title: Chat History
{rows}

(Only the last 10 messages are shown.)

Task:
1. Review the conversation context.
2. If the latest user message appears to be a *follow-up* (refers to something mentioned earlier),
   rewrite it into a complete, standalone question that includes the missing context based on the chat history.
3. If it is **not** a follow-up, return the message unchanged.

Latest User Question:
{qstn}

Rules:
- Return ONLY the rewritten question text — no explanations, no extra text, no JSON, no placeholders.
- Do NOT prefix with anything like "Rewritten:" or "Question:".
- Output must contain only the final question as plain text.

"""
@frappe.whitelist(allow_guest=True)
def inject_prompt(user_qstn,session_id):
    rows=get_chat_history(session_id)
    prompt=PROMPT_FOLLOWUP.format(rows=rows,qstn=user_qstn)
    return prompt,rows

