import os
import frappe  # Run inside bench environment

# 🔧 Configuration
doc_types_to_check = ["Sales Invoice", "Purchase Invoice", "Customer"]

# 🛠️ Ensure output directory exists
def is_visible_field(field):
    """Filter out hidden or layout-only fields."""
    return (
        field.get("fieldtype") not in ["Section Break", "Column Break", "Tab Break"]
        and not field.get("hidden")
        and field.get("fieldname")
    )

def export_fields(doc_type):
    meta = frappe.get_meta(doc_type)
    visible_fields = [f for f in meta.fields if is_visible_field(f)]

    lines = [f"{f.fieldname} ({f.fieldtype})" for f in visible_fields]

    # Write to .txt file
    file_path = "/opt/hyrin/frappe-bench/apps/changai/changai/changai/Datasets/Metafiles"
    with open(file_path, "w") as f:
        f.write("\n".join(lines))
    print(f"✅ Saved: {file_path}")

# 🚀 Run for each DocType
for dt in doc_types_to_check:
    export_fields(dt)
