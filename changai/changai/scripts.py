import frappe
import json
from pathlib import Path

def _assert_path_inside_base(file_path: str, base_dir: str) -> str:
    base = Path(base_dir).resolve()
    p = Path(file_path).resolve()
    if base != p and base not in p.parents:
        raise ValueError(f"Unsafe path: {p}")
    return str(p)

def export_meta():
    meta_data = {}

    doctypes = frappe.get_all("DocType", filters={"custom": 0}, fields=["name", "module"])

    for dt in doctypes:
        try:
            meta = frappe.get_meta(dt["name"])
            fields = [f.fieldname for f in meta.fields if f.fieldname]
            description = meta.get("description") or f"Standard ERPNext doctype for {dt['name']}"
            meta_data[dt["name"]] = {"module": dt["module"], "description": description, "fields": fields}
        except Exception:
            frappe.log_error(frappe.get_traceback(), f"export_meta skipped {dt['name']}")

    path = frappe.get_site_path("private", "files", "meta.json")
    safe_path = _assert_path_inside_base(path, frappe.get_site_path())

    with open(safe_path, "w", encoding="utf-8") as f:
        json.dump(meta_data, f, indent=2, ensure_ascii=False)

    return {"ok": True, "path": path, "doctype_count": len(meta_data)}
