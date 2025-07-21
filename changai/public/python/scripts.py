import frappe
import json
import os
import json
def export_meta():
    meta_data = {}

    # Only fetch doctypes where custom = 0 (standard)
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
    path = "/opt/hyrin/frappe-bench/apps/changai/changai/public/json/meta.json"
    with open(path, "w") as f:
        json.dump(meta_data, f, indent=2)

    print(f"✅ meta.json written to {path} with {len(meta_data)} doctypes.")
