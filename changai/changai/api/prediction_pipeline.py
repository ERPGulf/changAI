"""Replicate Api Test"""

import re
import random
import requests
import frappe
from jinja2 import Template
import jinja2
import logging
import nltk
from nltk.tokenize import word_tokenize
import re
from symspellpy.symspellpy import SymSpell, Verbosity

nltk.download("punkt", quiet=True)

pleasantry_responses = {
    "how are you": "I'm doing great, thanks for asking! How about you?",
    "ok": "If you need any help I'm here.",
    "how are u": "I'm doing great, thanks for asking! How about you?",
    "Hii": "Hey there! 😊 How can I help you today?",
    "have a good day": "Thank you. Wishing you a productive day ahead!",
    "have a great day": "Appreciate it. Have a great day too!",
    "what is your name?": "I’m Changai, your assistant for ERP tasks like sales, reports, and inventory insights.",
    "what is your task": "I’m Changai, ERP is my specialty. If you need help with invoices, reports, or stock levels, I’ve got you covered.",
    "how's it going": "All good here! How's it going with you?",
    "what's up": "Not much, just chilling! What's good with you?",
    "what's going on": "Just doing my thing! How about you?",
    "how are things": "Things are smooth! Hope the same for you!",
    "good morning": "Morning! Hope your day's off to a great start!",
    "good afternoon": "Good afternoon! What can I help you with today?",
    "good evening": "Evening! How's your night going?",
    r"^hello+$": "Hey! What brings you here today?",
    "who are you": "I'm Changai, your ERP assistant for business tasks like sales reports, inventory checks, and more. Just ask away!",
    "nice to see you": "Right back at you! Great to connect!",
    "howdy": "Howdy! What's the vibe today?",
    "what's new": "Just hanging out, ready to chat! What's new with you?",
    "long time no see": "Wow, it's been a while! Good to catch up!",
    "hope you're well": "Thanks! I'm awesome, and I hope you are too!",
    "greetings": "Greetings! What's on your mind today?",
    "thank you": "You're welcome! Happy to help anytime.",
    "thanks": "Anytime! Let me know if you need anything else.",
    "thanks a lot": "You got it! Glad I could assist.",
    "thank you very much": "You're most welcome!",
    "thx": "No problem!",
    "ty": "You're welcome!",
    "appreciate it": "Glad to help!",
    "much appreciated": "Always here for you!",
    r"^bye+$": "Catch you later! 👋",
    "goodbye": "Goodbye! Have a great day!",
    "see you": "See you soon!",
    "talk to you later": "Sure! Looking forward to it.",
    "have a nice day": "You too! Take care!",
    "hello": "Hi! Nice to hear from you!",
    "hi": "Hey there! What's up?",
    "heyy": "Hello! I'm here to help with your business data. How can I assist you today?",
    r"^h(i+|e+y+|e+i+)$": "Yo! Good to see you!",
    "yo": "Yo, what's good?",
    "you're welcome": "Anytime! Let me know if there's anything else you need.",
    "you are welcome": "Glad I could help!",
    "no problem": "Happy to help!",
    "no worries": "All good!",
    "anytime": "Of course! I'm always here to help.",
    "sure": "Yep! Let me know if you need more info.",
    "my pleasure": "It’s a pleasure helping you!",
    "of course": "Absolutely! Feel free to ask more.",
    "don't mention it": "Got you! 😊",
    r"^thank(s| you| you so much| you very much|s a lot)?$": "You're most welcome!",
}

business_keywords = [
    "contacts",
    "how many customers",
    "invoice",
    "partners",
    "customer count",
    "purchase",
    "number of customers",
    "number of employees",
    "employee count",
    "items",
    "salary",
    "how many employees",
    "how many records",
    "number of records",
    "records in",
    "records for",
    "employee table",
    "list all",
    "show all",
    "total number",
    "total count",
    "invoice amount",
    "outstanding amount",
    "sales invoice",
    "purchase invoice",
    "supplier",
    "employee details",
    "customer details",
    "status of",
    "data for",
    "sum of",
    "get all",
    "sales",
    "selling ",
    "created in the last",
    "show details of",
    "employee number",
    "customer name",
    "invoice status",
    "stock?",
    "employees",
    "total number of customers",
    "total outstanding amount",
    "total",
    "count of",
    "maximum",
    "minimum",
    "spent",
    "average",
    "number",
    "customers",
    "customer",
    "employee",
    "employee numbers",
    "sales invoices",
    "status",
    "show",
    "list",
    "details",
    "sum",
    "salaries",
    "salary",
    "outstanding",
    "amount",
    "SI-",
    "EMP-",
    "doctype",
    "show fields",
    "child",
    "show all fields",
    "show customer names",
    "employee name",
    "employee id",
    "invoice number",
    "quotation number",
    "purchase order number",
    "employee emp",
    "invoice si",
    "item code",
    "project id",
    "manager of employee",
    "employee and their",
    "customer and their",
    "supplier and their",
    "employee salary",
    "document status",
    "created today",
    "created yesterday",
    "created this month",
    "created last month",
    "created this year",
    "created last year",
    "in the past week",
    "in the last 7 days",
    "payment",
    "total paid",
    "expense",
    "payroll",
    "leave balance",
    "attendance",
    "inventory",
    "stock balance",
    "stock quantity",
    "item quantity",
    "available quantity",
    "warehouse",
    "batch",
    "serial number",
    "users",
    "item price",
    "report",
    "summary",
    "overview",
    "graph",
    "chart",
    "number of transactions",
    "transactions today",
    "recent activity",
    "business summary",
    "top selling items",
    "most sold items",
    "least sold items",
    "sales this week",
    "sales this month",
    "profit this month",
    "monthly revenue",
    "monthly expense",
    "weekly performance",
    "annual summary",
    "compare sales",
    "compare revenue",
    "business trend",
    "employee salary slip",
    "attendance report",
    "absent employees",
    "present employees",
    "employee leaves",
    "leave report",
    "leave application",
    "employee check-in",
    "late employees",
    "monthly attendance",
    "employee designation",
    "employee department",
    # --- New Inventory & Stock ---
    "low stock items",
    "items to reorder",
    "inventory value",
    "stock aging",
    "item movement",
    "item transfers",
    "warehouse stock",
    "item availability",
    "reorder level",
    "reorder date",
    "current inventory",
    "pending invoices",
    "paid invoices",
    "overdue invoices",
    "payment status",
    "payment received",
    "last payment",
    "purchase order",
    "sales order",
    "order summary",
    "order count",
    "invoice details",
    "invoice due date",
    "invoice total",
    "amount received",
    "amount due",
    "top customers",
    "active customers",
    "recent customers",
    "supplier list",
    "supplier payments",
    "customer balance",
    "supplier balance",
    "customer transactions",
    "supplier transactions",
    "customer feedback",
    "customer issues",
    "daily report",
    "weekly report",
    "monthly report",
    "performance report",
    "sales dashboard",
    "inventory dashboard",
    "employee dashboard",
    "report for",
    "created last week",
    "created in last 30 days",
    "created last quarter",
    "created this quarter",
    "updated today",
    "last updated",
]


sorted_pleasantries = sorted(pleasantry_responses.keys(), key=len, reverse=True)
non_erp_responses = [
    "I'm here to assist with ERP-related queries such as sales, purchases, and inventory.",
    "Please ask a question related to business data or reports.",
    "I'm focused on business operations—try asking about invoices, customers, or stock.",
    "My scope is limited to ERP functions. Let me know how I can help with business data.",
    "I'm designed to handle ERP queries. Could you rephrase that in a business context?",
    "I specialize in business data insights. Want to know about your recent transactions or performance?",
    "Let's keep it ERP-focused—try asking about your sales, profit, or purchase orders.",
    "I'm built to assist with your business workflows. Please ask something related to operations or finance.",
    "I can help best with ERP questions—like sales trends, supplier performance, or customer insights.",
    "Currently, I’m focused on ERP support. Try asking about your documents, reports, or data analysis.",
    "I'm tailored to answer ERP-related queries. Think along the lines of orders, ledgers, or deliveries.",
    "My expertise is business operations. Let’s talk about inventory, billing, or employee records.",
    "That sounds interesting, but I work best with ERP-related topics—such as transactions and analytics.",
    "ERP is my specialty. If you need help with invoices, reports, or stock levels, I’ve got you covered.",
    "I’m tuned to understand your business systems. Want help with finance, HR, or logistics?",
    "I handle business-focused questions. Please try asking about workflows or key metrics.",
    "I assist with enterprise data. Try questions related to productivity, revenue, or customer activity.",
    "My role is to simplify your ERP interactions. How about something on operations or compliance?",
]
# Initialize SymSpell
sym_spell = SymSpell(max_dictionary_edit_distance=2, prefix_length=7)
sym_spell.load_dictionary(
    "/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/erp_dictionary.txt",
    term_index=0,
    count_index=1,
)

# Define stopwords
STOP_WORDS = {
    "a",
    "an",
    "the",
    "is",
    "are",
    "was",
    "were",
    "i",
    "you",
    "me",
    "my",
    "made",
    "all",
    "he",
    "she",
    "it",
    "we",
    "they",
    "them",
    "their",
    "our",
    "what",
    "who",
    "than",
    "more",
    "when",
    "where",
    "why",
    "how",
    "your",
    "for" "can",
    "what",
    "which",
    "how",
    "much",
    "we",
    "due",
    "to",
    "of",
    "the",
    "to",
    "for",
    "in",
    "on",
    "at",
    "with",
    "from",
    "by",
    "of",
    "and",
    "or",
    "but",
    "do",
    "does",
    "did",
    "have",
    "has",
    "had",
}


@frappe.whitelist(allow_guest=True)
def correct_sentence(text):
    import re
    from symspellpy.symspellpy import SymSpell, Verbosity

    custom_dictionary = (
        "/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/erp_dictionary.txt"
    )

    sym_spell = SymSpell(max_dictionary_edit_distance=2, prefix_length=7)
    sym_spell.load_dictionary(custom_dictionary, term_index=0, count_index=1)

    stopwords_set = STOP_WORDS

    def is_probable_id(word):
        return (
            bool(re.search(r"[A-Za-z]", word)) and bool(re.search(r"\d", word))
        ) or bool(re.search(r"[_\-]", word))

    tokens = re.findall(r"\b[\w\-']+\b|[^\w\s]", text)

    corrected_tokens = []

    for token in tokens:
        if not re.match(r"[\w\-']+", token):
            corrected_tokens.append(token)
            continue

        if is_probable_id(token) or token.lower() in stopwords_set or token.isdigit():
            corrected_tokens.append(token)
            continue

        suggestions = sym_spell.lookup(
            token.lower(), Verbosity.CLOSEST, max_edit_distance=2
        )
        corrected = suggestions[0].term if suggestions else token

        if token.istitle():
            corrected = corrected.capitalize()
        elif token.isupper():
            corrected = corrected.upper()

        corrected_tokens.append(corrected)

    return " ".join(corrected_tokens)


@frappe.whitelist(allow_guest=True)
def match_pleasantry(text):
    clean_text = text.lower().strip()
    for pattern, response in pleasantry_responses.items():
        if re.match(pattern, clean_text):
            return response
    return None


@frappe.whitelist(allow_guest=True)
def respond_to_greeting_with_fuzzy(text):
    corrected_text = correct_sentence(text)
    corrected_text_lower = corrected_text.lower()
    corrected_words = set(re.findall(r"\b\w+\b", corrected_text_lower))

    if set(business_keywords) & corrected_words:
        return {"type": "ERP", "response": 0, "corrected": corrected_text}

    for pleasantry in sorted_pleasantries:
        if re.search(
            r"(?<!\w)" + re.escape(pleasantry) + r"(?!\w)", corrected_text_lower
        ):
            normalized_text = corrected_text.lower().replace("’", "'").strip()
            response = match_pleasantry(normalized_text)
            if response:
                return {"type": "Greeting", "response": response}
            else:
                return {
                    "type": "Greeting",
                    "response": "Hello! How can I assist you today?",
                }

    return {
        "type": "Other",
        "response": random.choice(non_erp_responses),
        "corrected": corrected_text,
    }


@frappe.whitelist(allow_guest=True)
def run_query(query):
    """Run a query."""
    try:
        if not query:
            return {"error": "Query not provided."}
        result = eval(query)
        return {"success": True, "response": result}

    except Exception as e:
        return {"success": False, "response": str(e)}


@frappe.whitelist(allow_guest=True)
def fetch_data_from_server(qstn):
    response_msg = respond_to_greeting_with_fuzzy(qstn)
    if response_msg["type"] in ("Greeting", "Other"):
        return response_msg["response"]

    try:
        token = frappe.db.get_single_value("Settings", "token")
        api_url = frappe.db.get_single_value("Settings", "prediction_url")
        version_id = frappe.db.get_single_value("Settings", "version_id")

        headers = {
            "Content-Type": "application/json",
            "Prefer": "wait",
            "Authorization": f"Bearer {token}",
        }
        data = {
            "version": version_id,
            "input": {"user_input": response_msg["corrected"]},
        }
        response = requests.post(api_url, headers=headers, json=data)
        response.raise_for_status()

        response_data = response.json()
        query = response_data["output"]["frappe_query"].replace("[BT]", "`")
        query_result = run_query(query)
        doc = response_data["output"]["predicted_doctype"]
        user_template = format_data_conversationally(query_result["response"], doc)

        return {
            "corrcetd_qstn": response_msg["corrected"],
            "query": query,
            "doctype": doc,
            "top_fields": response_data["output"]["top_fields"],
            "fields": response_data["output"]["selected_fields"],
            "query_data": user_template,
            "data": query_result["response"],
        }

    except Exception as e:
        return {"error": str(e)}


@frappe.whitelist(allow_guest=True)
def format_data_conversationally(user_data, doctype=None):
    """
    Formats user data using the single, powerful conversational Jinja2 template.
    Args:
        user_data: The data returned from the backend (can be a list, dict, or primitive).
        doctype (str, optional): The type of document being processed (e.g., "Invoice", "User").
    Returns:
        A formatted, human-readable string.
    """
    CONVERSATIONAL_TEMPLATE = """
{#- MACRO to format a single record conversationally -#}
{%- macro format_record(record, doctype) -%}
    {%- if record is mapping -%}
        {%- if 'name' in record and 'status' in record -%}
            The {{ doctype if doctype else 'record' }} '{{ record.name }}' has a status of '{{ record.status }}'.
        {%- elif 'name' in record and record|length > 2 and 'description' in record -%}
            Here are the details for {{ doctype if doctype else 'record' }} '{{ record.name }}': {{ record.get('description', '') }}
        {%- elif 'subject' in record -%}
            Here are the details for '{{ record.subject }}'.
        {%- elif 'title' in record -%}
            Here are the details for '{{ record.title }}'.
        {%- elif 'name' in record -%}
            The result is '{{ record.name }}'.
        {%- else -%}
            The {{ doctype if doctype else 'result' }} is {{ record.values()|first if record.values()|first is not none else 'not available' }}.
        {%- endif -%}
    {%- else -%}
        {{ record }}
    {%- endif -%}
{%- endmacro -%}

{%- if data is sequence and data is not mapping and data is not string -%}
    {%- if data|length > 1 -%}
        I found {{ data|length }} results. Here are the first few:
        {%- for item in data[:3] %}
        - {{ format_record(item, doctype) | trim }}
        {%- endfor %}
    {%- elif data|length == 1 -%}
        I found one result:
        - {{ format_record(data[0], doctype) | trim }}
    {%- else -%}
        I couldn't find any records for {{ doctype or 'your query' }}.
    {%- endif -%}
{#- 2. Handle single dictionary results (from get_doc or similar) -#}
{%- elif data is mapping -%}
    {{ format_record(data, doctype) | trim }}
{#- 3. Handle a single direct value (from get_value or simple sql) -#}
{%- else -%}
    The result for your query is {{ data if data is not none else 'details not available' }}.
{%- endif -%}
"""
    # --- Error Handling First ---
    if isinstance(user_data, dict) and user_data.get("success") is False:
        return f":x: Error: {user_data.get('error', 'Unknown error')}"
    # --- Template Rendering ---
    env = jinja2.Environment(trim_blocks=True, lstrip_blocks=True)
    template = env.from_string(CONVERSATIONAL_TEMPLATE)
    return template.render(data=user_data, doctype=doctype)
