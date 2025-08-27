"""
This module provides API endpoints for processing user questions.
It supports conversational handling and integrates with ERP data via dynamic query generation.
"""

import re
import random
import json
import requests
import frappe
import spacy
import jinja2
from symspellpy.symspellpy import SymSpell, Verbosity


nlp = spacy.load("en_core_web_sm", disable=["tagger", "parser"])
sym_spell = SymSpell(max_dictionary_edit_distance=2, prefix_length=7)
custom_dictionary = "/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/erp_dictionary.txt"
sym_spell.load_dictionary(custom_dictionary, term_index=0, count_index=1)

# Load pleasantries once
pleasantry_file_path = "/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/pleasantry.json"
with open(pleasantry_file_path, "r", encoding="utf-8") as f:
    PLEASANTRIES = sorted(json.load(f).items(), key=lambda x: len(x[0]), reverse=True)
# Cache compiled patterns once at startup
COMPILED_PLEASANTRIES = [
    (re.compile(pattern, re.IGNORECASE), response)
    for pattern, response in PLEASANTRIES
]

def fast_match_pleasantry(text):
    clean_text = text.lower().strip()
    for compiled_pattern, response in COMPILED_PLEASANTRIES:
        if compiled_pattern.fullmatch(clean_text):
            return response
    return None

# Load business keywords once
business_keywords_file = "/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/business_keywords.json"
with open(business_keywords_file, "r", encoding="utf-8") as f:
    BUSINESS_KEYWORDS = {kw.lower() for kw in json.load(f)["business_keywords"]}

non_erp_responses = [
    "I'm here to assist with ERP-related queries such as sales, purchases, and inventory.",
    "Please ask a question related to business data or reports.",
    "I'm focused on business operations—try asking about invoices, customers, or stock.",
    "My scope is limited to ERP functions. Let me know how I can help with business data.",
    "I'm designed to handle ERP queries. Could you rephrase that in a business context?"
]
STOP_WORDS = {
    # Pronouns
    "tell","as","a","all",
    "i", "me", "my", "mine", "myself",
    "you", "your", "yours", "yourself", "yourselves",
    "he", "him", "his", "himself",
    "she", "her", "hers", "herself",
    "it", "its", "itself",
    "we", "us", "our", "ours", "ourselves",
    "they", "them", "their", "theirs", "themselves",

    # Articles & determiners
    "a", "an", "the", "this", "that", "these", "those", "such",

    # Auxiliary & modal verbs
    "is", "am", "are", "was", "were", "be", "being", "been",
    "do", "does", "did", "doing",
    "have", "has", "had", "having",
    "will", "would", "shall", "should", "can", "could", "may", "might", "must",

    # Conjunctions
    "and", "or", "but", "if", "because", "while", "although", "though", "unless", 
    "until", "since", "so", "yet",

    # Prepositions
    "in", "on", "at", "by", "for", "with", "about", "against", 
    "between", "into", "through", "during", "before", "after",
    "above", "below", "to", "from", "up", "down", "out", "off", "over", "under","of",

    # Question words
    "what", "which", "who", "whom", "whose", 
    "when", "where", "why", "how",

    # Degree / comparison
    "than", "more", "most", "much", "many", "few", "less", "least", "enough",

    # Common fillers
    "ok", "okay", "well", "like", "just", "really", "very", "also", "too", "still",

    # Contractions / informal
    "what's", "that's", "it's", "there's", "here's", "let's", "who's", "where's", 
    "how's", "i'm", "you're", "he's", "she's", "we're", "they're",
    "i've", "you've", "we've", "they've",
    "i'll", "you'll", "he'll", "she'll", "we'll", "they'll",
    "i'd", "you'd", "he'd", "she'd", "we'd", "they'd",
}


@frappe.whitelist(allow_guest=True)
def load_pleasantry_responses():
    """Load pleasantry responses"""
    try:
        with open(pleasantry_file_path, "r", encoding="utf-8") as f:
            return json.load(f)
    except (json.JSONDecodeError, IOError) as e:
        frappe.log_error(f"Error loading pleasantries: {str(e)}", "Pleasantry Loader")
        return {}

@frappe.whitelist(allow_guest=True)
def get_sorted_pleasantries():
    """Return sorted (pattern, response) pairs"""
    data =PLEASANTRIES
    return sorted(data.items(), key=lambda x: len(x[0]), reverse=True)


@frappe.whitelist(allow_guest=True)
def load_business_keywords():
    """load business keywords"""
    with open(
        business_keywords_file,
        "r",
        encoding="utf-8",
    ) as f:
        return set(json.load(f)["business_keywords"])

def extract_entities(text):
    # Detect simple entities: IDs, codes, dates
    return re.findall(r"\b[A-Z]{2,}-\d+\b|\b\d{4}-\d{2}-\d{2}\b", text)


@frappe.whitelist(allow_guest=True)
def correct_sentence(text):

    stopwords_set = STOP_WORDS
    # entities=extract_entities(text)
    # def is_probable_id(word):
    #     return (
    #         (bool(re.search(r"[A-Za-z]", word)) and bool(re.search(r"\d", word)))
    #         or bool(re.search(r"[_\-]", word))
    #     )

    doc = nlp(text)
    entities = [(ent.text, ent.start_char, ent.end_char) for ent in doc.ents]


    text_to_correct = text
    placeholder_map = {}
    for i, (ent_text, _, _) in enumerate(entities):
        placeholder = f"__ENTITY{i}__"
        text_to_correct = text_to_correct.replace(ent_text, placeholder)
        placeholder_map[placeholder] = ent_text

    tokens = re.findall(r"\b[\w\-']+\b|[^\w\s]", text_to_correct)
    print("✂ Tokens:", tokens)

    corrected_tokens = []

    for token in tokens:
        if not re.match(r"[\w\-']+", token):
            corrected_tokens.append(token)
            continue

        if token.lower() in stopwords_set or token.isdigit():
            corrected_tokens.append(token)
            continue

        # Lookup
        suggestions = sym_spell.lookup(token.lower(), Verbosity.CLOSEST, max_edit_distance=2)
        print(f"💡 Suggestions for '{token}':", [s.term for s in suggestions])

        corrected = suggestions[0].term if suggestions else token

        if token.istitle():
            corrected = corrected.capitalize()
        elif token.isupper():
            corrected = corrected.upper()

        corrected_tokens.append(corrected)

    corrected_text = " ".join(corrected_tokens)

    # --- STEP 3: Restore entities ---
    for placeholder, ent_text in placeholder_map.items():
        corrected_text = corrected_text.replace(placeholder, ent_text)

    print("✅ Final corrected:", corrected_text)
    return corrected_text


@frappe.whitelist(allow_guest=True)
def match_pleasantry(text):
    clean_text = text.lower().strip()
    pleasantries =PLEASANTRIES
    for pattern, response in pleasantries.items():
        try:
            if re.fullmatch(pattern, clean_text):  
                return response
        except re.error:
            # If pattern is not a valid regex, treat it as exact match
            if pattern.lower() == clean_text:
                return response
    return None


@frappe.whitelist(allow_guest=True)
def fuzzy_intent_router(text):
    """Responds to a user question  with a fuzzy match"""
    corrected_text = correct_sentence(text)
    corrected_text_lower = corrected_text.lower()
    corrected_words = set(re.findall(r"\b\w+\b", corrected_text_lower))

    if BUSINESS_KEYWORDS & corrected_words:
        return {"type": "ERP", "response": 0, "corrected": corrected_text}

    for pleasantry in get_sorted_pleasantries():
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
                    "response": random.choice(non_erp_responses),
                }

    return {
        "type": "Other",
        "response": random.choice(non_erp_responses),
        "corrected": corrected_text,
    }


@frappe.whitelist(allow_guest=True)
def fuzzy_intent_router_1(text):
    """Responds to a user question with a fuzzy match"""
    corrected_text = correct_sentence(text)
    corrected_text_lower = corrected_text.lower()

    corrected_words = set(re.findall(r"\b\w+\b", corrected_text_lower))
    # business_keywords = {kw.lower() for kw in load_business_keywords()}

    # ERP keywords
    if BUSINESS_KEYWORDS & corrected_words:
        return {"type": "ERP", "response": 0, "corrected": corrected_text}
    safe_text = re.sub(r"[^\w\s]", "", corrected_text_lower) 
    for pattern, response in PLEASANTRIES:
        if re.search(pattern, safe_text):
            return {"type": "Greeting", "response": response, "corrected": corrected_text}
    

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


import datetime


@frappe.whitelist(allow_guest=True)
def sanitize_dates(obj):
    if isinstance(obj, list):
        return [sanitize_dates(i) for i in obj]
    elif isinstance(obj, dict):
        return {k: sanitize_dates(v) for k, v in obj.items()}
    elif isinstance(obj, (datetime.date, datetime.datetime)):
        return obj.isoformat()
    else:
        return obj


@frappe.whitelist(allow_guest=True)
def fetch_data_from_server(qstn):
    """
    Handles a user question by detecting greetings or sending it to a prediction API.
    Returns either a greeting response, ERP query results, or an error message.
    """
    response_msg = fuzzy_intent_router_1(qstn)
    if response_msg["type"] in ("Greeting", "Other"):
        return {"response": response_msg["response"]}
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
        query_result["response"] = sanitize_dates(query_result["response"])
        doc = response_data["output"]["predicted_doctype"]
        user_template = format_data_conversationally(query_result["response"], doc)
        frappe.get_doc(
            {
                "doctype": "Changai Query Log",
                "question": response_msg["corrected"],
                "doc": doc,
                "query": query,
                "top_fields": json.dumps(response_data["output"]["top_fields"]),
                "fields": json.dumps(response_data["output"]["selected_fields"]),
                "response": json.dumps(query_result["response"]) or user_template,
            }
        ).insert(ignore_permissions=True)
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
    conversational_template = """
{#- MACRO to format a single record conversationally -#}
{%- macro format_record(record, doctype=None, concise=False) -%}
    {%- if record is mapping -%}

        {# Case: has name and status #}
        {%- if 'name' in record and 'status' in record -%}
            {%- if concise -%}
{{ record.status }}
            {%- else -%}
The {{ doctype or 'record' }} '{{ record.name }}' is currently marked as '{{ record.status }}'.
            {%- endif -%}

        {# Case: has name, description, and multiple fields #}
        {%- elif 'name' in record and record|length > 2 and 'description' in record -%}
            {%- if concise -%}
{{ record.description }}
            {%- else -%}
Here are the details for {{ doctype or 'record' }} '{{ record.name }}': {{ record.description }}
            {%- endif -%}

        {# Case: has subject #}
        {%- elif 'subject' in record -%}
            {%- if concise -%}
{{ record.subject }}
            {%- else -%}
Take a look at the details for '{{ record.subject }}'.
            {%- endif -%}

        {# Case: has title #}
        {%- elif 'title' in record -%}
            {%- if concise -%}
{{ record.title }}
            {%- else -%}
Here’s what I found for '{{ record.title }}'.
            {%- endif -%}

        {# Case: has only name #}
        {%- elif 'name' in record -%}
            {%- if concise -%}
{{ record.name }}
            {%- else -%}
The {{ doctype or 'record' }} is '{{ record.name }}'.
            {%- endif -%}

        {# Default case: show first value or fallback #}
        {%- else -%}
            {{ record.values()|first or 'Information not available' }}

        {%- endif -%}

    {# If not a mapping, just display it #}
    {%- else -%}
        {{ record or 'Information not available' }}
    {%- endif -%}
{%- endmacro -%}


{#- MAIN RESPONSE TEMPLATE -#}

{# Case 1: Error string detection (check first) #}
{%- if data is string and ('DoesNotExistError' in data or 'not found' in data or 'OperationalError' in data) -%}
    I encountered an error. The system returned this message: {{ data }}

{# Case 2: Sequence of results #}
{%- elif data is sequence and data is not mapping and data is not string -%}
    {%- set display_count = 5 -%}

    {# Case: multiple results #}
    {%- if data|length > 1 -%}
I found {{ data|length }} results.

Here are the first few:
{% for item in data[:display_count] %}
{{ loop.index }}. {{ format_record(item, doctype, concise=True) }}
{% endfor %}
{%- if data|length > display_count -%}
...and {{ data|length - display_count }} more not shown.
{%- endif -%}

    {# Case: single item in list #}
    {%- elif data|length == 1 -%}

        {# If it’s a dictionary with a numeric value (count) #}
        {%- if data[0] is mapping and (data[0].values()|first is number) -%}
            {%- set record = data[0] -%}
            {%- set key = record.keys()|list|first -%}
I found {{ record[key] }} {{ "record" if record[key] == 1 else "records" }}.
        {# Otherwise use normal formatting #}
        {%- else -%}
Result found:
{{ format_record(data[0], doctype) | trim }}
        {%- endif -%}

    {%- else -%}
I couldn’t find any records for {{ doctype or 'your query' }}.
    {%- endif -%}




{# Case 3: Single dictionary result #}
{%- elif data is mapping -%}
    {{ format_record(data, doctype) | trim }}

{# Case 4: Simple value #}
{%- else -%}
    The result for your query is {{ data if data is not none and data != '' else 'Information not available' }}.
{%- endif -%}
"""

    if isinstance(user_data, dict) and user_data.get("success") is False:
        return f":x: Error: {user_data.get('error', 'Unknown error')}"
    env = jinja2.Environment(
        trim_blocks=True, lstrip_blocks=True, extensions=["jinja2.ext.do"]
    )
    template = env.from_string(conversational_template)
    return template.render(data=user_data, doctype=doctype)
