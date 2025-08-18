"""
This module provides API endpoints for processing user questions.
It supports conversational handling and integrates with ERP data via dynamic query generation.
"""

import re
import random
import json
import requests
import frappe
import jinja2
import nltk
from symspellpy.symspellpy import SymSpell,Verbosity
nltk.download("punkt", quiet=True)


def load_pleasantry_responses():
    """Load pleasantry responses"""
    path="/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/pleasantry.json"
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except (json.JSONDecodeError, IOError) as e:
        frappe.log_error(f"Error loading pleasantries: {str(e)}", "Pleasantry Loader")
        return {}


def load_business_keywords():
    """load business keywords"""
    with open("/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/business_keywords.json", "r",encoding="utf-8") as f:
        return set(json.load(f)["business_keywords"])


sorted_pleasantries = sorted(load_pleasantry_responses().keys(), key=len, reverse=True)
non_erp_responses = [
    "I'm here to assist with ERP-related queries such as sales, purchases, and inventory.",
    "Please ask a question related to business data or reports.",
    "I'm focused on business operations—try asking about invoices, customers, or stock.",
    "My scope is limited to ERP functions. Let me know how I can help with business data.",
    "I'm designed to handle ERP queries. Could you rephrase that in a business context?",
    (
        "Let's keep it ERP-focused—try asking about your sales, "
        "profit, or purchase orders."
    ),
    (
        "I'm built to assist with your business workflows. "
        "Please ask something related to operations or finance."
    ),
    (
        "I can help best with ERP questions—like sales trends, "
        "supplier performance, or customer insights."
    ),
    (
        "Currently, I’m focused on ERP support. Try asking about your "
        "documents, reports, or data analysis."
    ),
    (
        "I'm tailored to answer ERP-related queries. Think along the lines "
        "of orders, ledgers, or deliveries."
    ),
    (
        "My expertise is business operations. Let’s talk about inventory, "
        "billing, or employee records."
    ),
    (
        "That sounds interesting, but I work best with ERP-related topics—"
        "such as transactions and analytics."
    ),
    (
        "ERP is my specialty. If you need help with invoices, reports, or "
        "stock levels, I’ve got you covered."
    ),
    (
        "I’m tuned to understand your business systems. Want help with "
        "finance, HR, or logistics?"
    ),
    (
        "I handle business-focused questions. Please try asking about "
        "workflows or key metrics."
    ),
    (
        "I assist with enterprise data. Try questions related to productivity, "
        "revenue, or customer activity."
    ),
    (
        "My role is to simplify your ERP interactions. How about something "
        "on operations or compliance?"
    ),
]


STOP_WORDS = {
    "a", "an", "the", "is", "are", "was", "were", "i", "you", "me", "my", "made", "all",
    "he", "she", "it", "we", "they", "them", "their", "our", "what", "who", "than", "more",
    "when", "where", "why", "how", "your", "for", "can", "which", "much", "due", "to", "of",
    "in", "on", "at", "with", "from", "by", "and", "or", "but", "do", "does", "did", "have",
    "has", "had"
}


@frappe.whitelist(allow_guest=True)
def correct_sentence(text):
    """Corrects misspelled keywords in a sentence using the SymSpell library,
    while preserving structured ERP identifiers."""

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
    """Checks whether the input matches any predefined pleasantry responses."""
    clean_text = text.lower().strip()
    for pattern, response in load_pleasantry_responses().items():
        if re.match(pattern, clean_text):
            return response
    return None


@frappe.whitelist(allow_guest=True)
def fuzzy_intent_router(text):
    """Responds to a user question  with a fuzzy match"""
    corrected_text = correct_sentence(text)
    corrected_text_lower = corrected_text.lower()
    corrected_words = set(re.findall(r"\b\w+\b", corrected_text_lower))

    if set(load_business_keywords()) & corrected_words:
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
    """
    Handles a user question by detecting greetings or sending it to a prediction API.
    Returns either a greeting response, ERP query results, or an error message.
    """
    response_msg = fuzzy_intent_router(qstn)
    if response_msg["type"] in ("Greeting", "Other"):
        return {
            "response":response_msg["response"]
        }
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
        frappe.get_doc({
        "doctype": "Changai Query Log",
        "question":response_msg["corrected"],
        "doc":doc,
        "query":query,
        "top_fields":json.dumps(response_data["output"]["top_fields"]),
        "fields":json.dumps(response_data["output"]["selected_fields"]),
        "response":json.dumps(query_result["response"]) or user_template
        
    }).insert(ignore_permissions=True)
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
    """
    conversational_template ="""
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

{# Case 4: Error string detection #}
{%- elif data is string and ('DoesNotExistError' in data or 'not found' in data or 'OperationalError' in data) -%}
    I encountered an error. The system returned this message: {{ data }}

{# Case 5: Simple value #}
{%- else -%}
    The result for your query is {{ data if data is not none and data != '' else 'null' }}.
{%- endif -%}
"""

    if isinstance(user_data, dict) and user_data.get("success") is False:
        return f":x: Error: {user_data.get('error', 'Unknown error')}"
    env = jinja2.Environment(
        trim_blocks=True,
        lstrip_blocks=True,
        extensions=['jinja2.ext.do']
    )
    template = env.from_string(conversational_template)
    return template.render(data=user_data, doctype=doctype)