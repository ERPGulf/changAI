# Copyright (c) 2025, ERpGulf and contributors
# For license information, please see license.txt

# import frappe
from frappe.model.document import Document


class test(Document):
	pass
import logging
import os
import json
import requests
import frappe
from dotenv import load_dotenv
import re

import json
import os
import requests
import frappe
load_dotenv()



@frappe.whitelist(allow_guest=False)
def extract_doctype_and_fields(query):
    """Extract DocType and fields from a Frappe query string."""
    doctype_match = re.search(r'frappe\.(?:get_list|get_all|get_doc)\(["\'](.*?)["\']', query)
    doctype = doctype_match.group(1) if doctype_match else None
    fields_match = re.findall(r'["\']([\w]+)["\']\s*:', query)
    return doctype, fields_match


def is_valid_doctype(doctype):
    """Check if the given DocType exists in the system."""
    return frappe.db.exists("DocType", doctype)


def get_doctype_fields(doctype):
    """Retrieve all available field names for the given DocType dynamically."""
    if not is_valid_doctype(doctype):
        return None
    meta = frappe.get_meta(doctype)
    return [df.fieldname for df in meta.fields]

def validate_query_fields(doctype, extracted_fields):
    """Check if the extracted fields exist in the given DocType."""
    available_fields = get_doctype_fields(doctype)
    if not available_fields:
        return False, f"DocType '{doctype}' does not exist."
    invalid_fields = [field for field in extracted_fields if field not in available_fields]
    if invalid_fields:
        return False, f"Invalid fields {invalid_fields} in DocType '{doctype}'."
    
    return True, "Fields are valid."

def execute_validated_query(query):
    """Extracts, validates, and executes a Frappe query if valid."""
    doctype, fields = extract_doctype_and_fields(query)
    if not doctype:
        return "⚠️ Error: Could you give a valid DocType name"
    valid, message = validate_query_fields(doctype, fields)
    if not valid:
        return f"⚠️ {message}"
    # return execute_frappe_query(query)

@frappe.whitelist(allow_guest=True)
def query_huggingface(user_input):
    API_URL = "https://api-inference.huggingface.co/models/hyrinmansoor/text2frappetest"
    API_KEY = os.getenv("HUGGINGFACE_API_KEY")
    if not API_KEY:
        return {"success": False, "error": "Missing API key"}
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    }
    prompt = "translate text to Frappe Query: " + user_input
    try:
        response = requests.post(
                API_URL, 
                headers=headers, 
                json={"inputs": prompt, "parameters": {"max_length": 1000}},
                timeout=60
)
        response_data = response.json()
        ai_response = response_data[0].get("generated_text", "AI failed to respond.")
        ai_response = ai_response.replace('\\', '').replace('\"', '').replace("\\n", "\n")
        ai_response = ai_response.replace("//", "").strip()
        print("Final AI Response:", ai_response)
        return {"success": True, "response": ai_response}
    except Exception as e:
        return {"success": False, "error": str(e)}


@frappe.whitelist(allow_guest=True)
def execute_frappe_query(frappe_query):
    try:
        result = eval(frappe_query)
        return result
    except Exception as e:
        return {"error": str(e)}
# import frappe
# import json
# import os

# def get_all_doctype_metadata():
#     # Setup Frappe environment
#     site = 'hyrin.erpgulf.com'  # e.g., 'mysite.local' or 'erp.yourdomain.com'
#     frappe.init(site=site)
#     frappe.connect()

#     all_meta = {}
#     doctypes = frappe.get_all("DocType", pluck="name")

#     for doctype in doctypes:
#         try:
#             meta = frappe.get_meta(doctype)
#             all_meta[doctype] = {
#                 "fields": [
#                     {
#                         "label": df.label,
#                         "fieldname": df.fieldname,
#                         "fieldtype": df.fieldtype,
#                         "options": df.options,
#                         "reqd": df.reqd
#                     }
#                     for df in meta.fields
#                     if df.fieldtype not in ["Section Break", "Column Break"]
#                 ]
#             }
#         except Exception as e:
#             frappe.log_error(f"Error fetching meta for {doctype}: {str(e)}")

#     with open("/opt/hyrin/frappe-bench/apps/changai/changai/public/json/meta.json", "w") as f:
#         json.dump(all_meta, f, indent=4)

#     print("Metadata exported successfully.")
#     frappe.destroy()  # Clean up DB connections

# get_all_doctype_metadata()




import json

# Load the existing training dataset
def load_training_data():
    with open("/opt/hyrin/frappe-bench/apps/changai/changai/public/json/erp_doctype_prediction_dataset_v2_deduplicated.json", "r") as file:
        return json.load(file)

# Load the meta file containing doctype names and fields
def load_meta_file():
    with open("/opt/hyrin/frappe-bench/apps/changai/changai/public/json/meta.json", "r") as file:
        return json.load(file)

# Function to integrate meta data (doctype and fields) with the existing dataset
def enrich_with_meta_data(existing_data, meta_data):
    enriched_data = []
    for entry in existing_data:
        query = entry['input']
        doctype = entry['output']

    # Iterate over the existing data and add fields from the meta file
    for query, doctype in existing_data:
        if doctype in meta_data:
            # Retrieve the fields for the doctype from the meta file
            fields = meta_data[doctype]["fields"]
            
            # Add both the doctype and fields to the training data
            enriched_data.append({
                'instruction': 'Predict the relevant ERPNext Doctype(s) for the question below.',
                'input': query,
                'output': doctype,
                'metadata': {
                    'doctype': doctype,  # Store the doctype
                    'fields': fields  # Store the fields associated with the doctype
                }
            })
    
    return enriched_data

# Save the enriched training data to a file
def save_enriched_training_data(enriched_data):
    with open("enriched_training_data_with_meta.json", "w") as file:
        json.dump(enriched_data, file, indent=4)

# # Main function to process everything
# def main():
#     # Load the existing data and the meta file
#     existing_data = load_training_data()
#     meta_data = load_meta_file()

#     # Enrich the existing data with fields from the meta file
#     enriched_data = enrich_with_meta_data(existing_data, meta_data)

#     # Save the enriched dataset with meta doctype and fields included
#     save_enriched_training_data(enriched_data)
#     print(f"Enriched dataset saved as 'enriched_training_data_with_meta.json' with {len(enriched_data)} records.")

# # Run the main function
# if __name__ == "__main__":
#     main()

# import frappe
# import json
# import os

# # Set path to your site (replace with your actual site name)
# site_name = "site1.local"  # e.g., "yourcompany.local" or "dev.local"

# # Set context
# frappe.init(site=site_name)
# frappe.connect()
# frappe.set_user("Administrator")  # Optional, to avoid session issues

meta_data = {}

# Pull standard doctypes
doctypes = frappe.get_all("DocType", filters={"custom": 0}, fields=["name", "module"])

for dt in doctypes:
    try:
        meta = frappe.get_meta(dt["name"])
        fields = [f.fieldname for f in meta.fields if f.fieldname]
        description = meta.get("description") or f"Standard ERPNext doctype for {dt['name']}"

        meta_data[dt["name"]] = {
            "module": dt["module"],
            "description": description,
            "fields": fields
        }
    except Exception as e:
        print(f"⚠️ Skipped {dt['name']}: {e}")

# Save to file
output_path = "/opt/hyrin/frappe-bench/apps/changai/meta.json"
with open(output_path, "w") as f:
    json.dump(meta_data, f, indent=2)

print(f"✅ meta.json written to: {output_path}")

# Close DB connection at the end
frappe.destroy()
