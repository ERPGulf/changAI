import frappe
import json

OUTPUT_FILE = "/content/changai_table_names.json"

BUSINESS_MODULES = [
    "Selling",
    "Buying",
    "Stock",
    "Accounts",
    "HR",
    "CRM",
    "Support",
    "Projects",
    "Assets",
    "Manufacturing"
]

# Fetch doctypes from these modules
doctypes = frappe.get_all(
    "DocType",
    filters={"module": ["in", BUSINESS_MODULES]},
    fields=["name", "module"]
)

table_names = [f"tab{d.name}" for d in doctypes]

with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    json.dump(table_names, f, indent=2)

print(f"✅ Saved {len(table_names)} table names to {OUTPUT_FILE}")
