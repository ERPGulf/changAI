"""Replicate Api Test"""
import re
import requests
import frappe
from jinja2 import Template
import jinja2
import logging

@frappe.whitelist(allow_guest=True)
def run_query(query):
    """Run a query."""
    try:
        if not query:
            return {"error": "Query not provided."}
        result = eval(query)
        return {"success": True, "response":result}

    except Exception as e:
        return {"success": False, "response": str(e)}

@frappe.whitelist(allow_guest=True)
def fetch_data_from_server(qstn):
    """Fetch data"""
    token=frappe.db.get_single_value("Settings","token")
    api_url=frappe.db.get_single_value("Settings","prediction_url")
    version_id=frappe.db.get_single_value("Settings","version_id")
    headers= {
        "Content-Type": "application/json",
        "Prefer": "wait",
        "Authorization": f"Bearer {token}"
      }
    data={
        "version":version_id,
        "input":{
         "user_input": qstn
        }
    }
    response=requests.post(api_url,headers=headers,json=data)
    response.raise_for_status()
    response_data=response.json()
    query=response_data["output"]["frappe_query"]
    query_cleaned=query.replace("[BT]","`")
    query_data = run_query(query_cleaned)
    doc=response_data["output"]["predicted_doctype"]
    user_template = format_data_conversationally(query_data["response"], doc)

    return {
        "query":query_cleaned,
        "doctype":response_data["output"]["predicted_doctype"],
        "top_fields":response_data["output"]["top_fields"],
        "fields":response_data["output"]["selected_fields"],
        "query_data":user_template,
        "data":query_data["response"]
}
    
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
        {#- This logic checks for the most descriptive keys first -#}
        {%- if 'employee_name' in record -%}
            Details for employee {{ record.employee_name }}: {{ record.get('employee_number', 'None') }}
        {%- elif 'name' in record and 'status' in record -%}
            The {{ doctype if doctype else 'record' }} '{{ record.name }}' has a status of '{{ record.status }}'.
        {%- elif 'name' in record and record|length > 2 and 'description' in record -%}
            Here are the details for {{ doctype if doctype else 'record' }} '{{ record.name }}': {{ record.get('description', '') }}
        {%- elif 'subject' in record -%}
            Here are the details for '{{ record.subject }}'.
        {%- elif 'title' in record -%}
            Here are the details for '{{ record.title }}'.
        {%- elif 'name' in record -%}
            The result is '{{ record.name }}'.
        {%- elif 'employee' in record -%}
            The result is '{{ record.employee }}'.
        {%- elif 'naming_series' in record -%}
            The naming series is '{{ record.naming_series }}'.
        {%- elif 'status' in record and record|length == 1 -%}
            The status is '{{ record.status }}'.
        {%- elif 'customer_details' in record -%}
            {%- if record.customer_details is not none -%}
                Customer Details: {{ record.customer_details }}
            {%- else -%}
                Customer details are not available for this record.
            {%- endif -%}
        {%- else -%}
            The {{ doctype if doctype else 'result' }} is {{ record.values()|first if record.values()|first is not none else 'not available' }}.
        {%- endif -%}
    {#- Handle tuples/lists from raw SQL results -#}
    {%- elif record is sequence and record is not string -%}
        {#- Custom loop to replace empty strings and None with N/A for cleaner output -#}
        {%- set parts = [] -%}
        {%- for x in record -%}
            {%- if x is none or x == '' -%}
                {%- do parts.append('N/A') -%}
            {%- else -%}
                {%- do parts.append(x) -%}
            {%- endif -%}
        {%- endfor -%}
        {{ parts | join(', ') }}
    {%- else -%}
        {{ record }}
    {%- endif -%}
{%- endmacro -%}

{#- ================================================================= #}
{#-                 MAIN TEMPLATE LOGIC                               #}
{#- ================================================================= #}

{#- 1. Handle lists/tuples of results (from get_all, get_list, sql) -#}
{#-
    FIX: Added 'data is not mapping' and 'data is not string' to the condition.
    Jinja2's 'is sequence' test returns true for dictionaries and strings, 
    so we must explicitly exclude them to prevent errors when slicing.
-#}
{%- if data is sequence and data is not mapping and data is not string -%}
    {%- if data|length > 1 -%}
        {#- Handle specific SQL error tuples -#}
        {%- if data|length == 2 and data[0] is number and data[1] is string -%}
            I encountered a database error: {{ data[1] }} (Code: {{ data[0] }})
        {%- else -%}
            I found {{ data|length }} results. Here are the first few:
            {%- for item in data[:3] %}
            - {{ format_record(item, doctype) | trim }}
            {%- endfor %}
        {%- endif -%}
    {%- elif data|length == 1 -%}
        {#- Handle raw SQL count like ((3,),) -#}
        {%- if data[0] is sequence and data[0] is not string and data[0]|length == 1 and data[0][0] is number -%}
            {#- ADDED: |int filter to handle floats -#}
            The query returned {{ data[0][0]|int }} result{{ 's' if data[0][0]|int != 1 else '' }}.
        {#- Use verbose format for any single-item dict that contains a None value -#}
        {%- elif data[0] is mapping and none in data[0].values() -%}
            I found one result:
            - {{ format_record(data[0], doctype) | trim }}
        {%- else -%}
            {{ format_record(data[0], doctype) | trim }}
        {%- endif -%}
    {%- else -%}
        I couldn't find any records for {{ doctype or 'your query' }}.
    {%- endif -%}

{#- 2. Handle single dictionary results (from get_doc or similar) -#}
{%- elif data is mapping -%}
    {{ format_record(data, doctype) | trim }}

{#- 3. Handle specific error strings like DoesNotExistError or OperationalError -#}
{%- elif data is string and ('DoesNotExistError' in data or 'not found' in data or 'OperationalError' in data) -%}
    I encountered an error. The system returned this message: {{ data }}

{#- 4. Handle a single direct value (from get_value or simple sql) -#}
{%- else -%}
    {#- CHANGED: Treat empty string '' the same as None, and output 'null' -#}
    The result for your query is {{ data if data is not none and data != '' else 'null' }}.
{%- endif -%}
"""

def format_data_conversationally(user_data, doctype=None):
    """
    Formats user data using the single, powerful conversational Jinja2 template.

    Args:
        user_data: The data returned from the backend (can be a list, dict, or primitive).
        doctype (str, optional): The type of document being processed (e.g., "Invoice", "User").

    Returns:
        A formatted, human-readable string.
    """
    # --- Error Handling First ---
    if isinstance(user_data, dict) and user_data.get("success") is False:
        return f"❌ Error: {user_data.get('error', 'Unknown error')}"

    # --- Template Rendering ---
    env = jinja2.Environment(
        trim_blocks=True, 
        lstrip_blocks=True, 
        extensions=['jinja2.ext.do']
    )
    template = env.from_string(CONVERSATIONAL_TEMPLATE)
    
    return template.render(data=user_data, doctype=doctype)


