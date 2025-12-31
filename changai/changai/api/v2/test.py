import frappe

def extract_select_fields(doctype):
    meta = frappe.get_meta(doctype)
    fields = []

    for df in meta.fields:
        if df.fieldtype == "Select" and (df.options or "").strip():
            options = [
                opt.strip()
                for opt in df.options.split("\n")
                if opt.strip()
            ]
            fields.append({
                "doctype": doctype,
                "fieldname": df.fieldname,
                "label": df.label,
                "options": options
            })

    return fields


# Example
rows = extract_select_fields("Sales Invoice")
for r in rows:
    print(r["fieldname"], "=>", r["options"])
