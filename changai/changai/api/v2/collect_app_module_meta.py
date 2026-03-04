import frappe
import json

# Get ALL modules from erpnext app automatically
all_modules = frappe.get_all(
    "Module Def",
    filters={"app_name": "erpnext"},
    pluck="name"
)
print(f"Found {len(all_modules)} modules in ERPNext: {all_modules}")

# Load existing tables.json
tables_existing = frappe.db.get_value("File", {
    "file_name": "tables.json",
    "folder": "Home/RAG Sources"
}, "name")

if not tables_existing:
    frappe.throw("tables.json not found in Home/RAG Sources")

tables_file_doc = frappe.get_doc("File", tables_existing)
existing_tables = json.loads(tables_file_doc.get_content() or "[]")
print(f"Existing tables count: {len(existing_tables)}")

# Get all tab-prefixed table names for all erpnext modules
new_tables = []
for module in all_modules:
    doctypes = frappe.get_all(
        "DocType",
        filters={
            "module": module,
            "issingle": 0,
            "is_virtual": 0
        },
        pluck="name"
    )
    for dt in doctypes:
        table = f"tab{dt}"
        new_tables.append(table)

print(f"Total tables found from ERPNext: {len(new_tables)}")

# Merge without duplicates
merged = sorted(set(existing_tables) | set(new_tables))
print(f"New tables added: {len(merged) - len(existing_tables)}")
print(f"Total tables after merge: {len(merged)}")

# Save back
tables_file_doc.content = json.dumps(merged, indent=2)
tables_file_doc.save(ignore_permissions=True)
frappe.db.commit()

print("✅ tables.json updated successfully!")