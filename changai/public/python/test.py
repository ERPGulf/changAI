import frappe
import json

def is_visible_field(field):
    """Filter out hidden or layout-only fields."""
    return (
        field.get("fieldtype") not in ["Section Break", "Column Break", "Tab Break"]
        and not field.get("hidden")
        and field.get("fieldname")
    )

def get_doctype_meta(doctype):
    frappe.init(site="hyrin.erpgulf.com")
    frappe.connect()

    meta = frappe.get_meta(doctype)
    visible_fields = [f for f in meta.fields if is_visible_field(f)]

    return {
        "module": meta.module,
        "description": meta.description or f"ERPNext DocType for {doctype}",
        "fields": [f"{f.fieldname} ({f.fieldtype})" for f in visible_fields]
    }

if __name__ == "__main__":
    doc_types_to_check = [
        "Sales Invoice", "Sales Order", "Supplier", "Item", "Quotation",
        "Lead", "Opportunity", "Purchase Invoice", "Customer",
        "Purchase Order", "Purchase Receipt", "Tax Category"
    ]

    all_meta = {}
    for dt in doc_types_to_check:
        all_meta[dt] = get_doctype_meta(dt)

    # 🔧 Save to single JSON file
    with open("/opt/hyrin/frappe-bench/apps/changai/changai/changai/Datasets/Metafiles/erpnext_doctypes_meta.json", "w") as f:
        json.dump(all_meta, f, indent=2)

    print("✅ All DocType metadata saved to erpnext_doctypes_meta.json")
