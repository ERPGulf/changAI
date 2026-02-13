import frappe
import json

BUSINESS_MODULES = [
    "Selling","Buying","Stock","Accounts","HR","CRM","Support","Projects","Assets","Manufacturing"
]

def business_doctypes():
    return frappe.get_all(
        "DocType",
        filters={"module": ["in", BUSINESS_MODULES]},
        fields=["name", "module"],
    )

def export_table_names():
    doctypes = business_doctypes()
    table_names = [f"tab{d['name']}" for d in doctypes]

    output_file = frappe.get_site_path("private", "files", "changai_table_names.json")
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(table_names, f, indent=2)

    return {"count": len(table_names), "path": output_file}
