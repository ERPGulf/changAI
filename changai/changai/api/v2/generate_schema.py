import os
import yaml
from typing import Dict, List, Any, Optional

import frappe


BUSINESS_MODULES = [
    "Assets", "Utilities", "Support", "Stock", "Manufacturing", "Setup",
    "Selling", "Projects", "Buying", "CRM", "Accounts",
]

CUSTOM_BUSINESS_MODULES = ["Zatca Erpgulf"]


def _ensure_dir(p: str) -> None:
    os.makedirs(p, exist_ok=True)


def _tab(dt: str) -> str:
    return f"tab{dt}"


def _split_select_options(options: str) -> List[str]:
    if not options:
        return []
    return [o.strip() for o in (options or "").split("\n") if o.strip()]


def _is_layout_field(fieldtype: str) -> bool:
    return fieldtype in {
        "Section Break", "Column Break", "Tab Break", "HTML",
        "Fold", "Button", "Image", "Heading"
    }


def _best_field_description(df: Any) -> str:
    desc = (getattr(df, "description", "") or "").strip()
    if desc:
        return desc
    lbl = (getattr(df, "label", "") or "").strip()
    return lbl or ""


def _best_table_description(dt_meta: Any) -> str:
    desc = (getattr(dt_meta, "description", "") or "").strip()
    if desc:
        return desc
    lbl = (getattr(dt_meta, "label", "") or "").strip()
    return lbl or (getattr(dt_meta, "name", "") or "")

def build_field_yaml(parent_dt: str, df: Any) -> Dict[str, Any]:
    fieldname = df.fieldname
    ft = (df.fieldtype or "").strip()

    out: Dict[str, Any] = {
        "name": fieldname,
        "description": (df.label or "").strip(),
    }

    # OPTIONS → only for Select
    if ft == "Select":
        opts = _split_select_options(df.options or "")
        if opts:
            out["options"] = opts

    # JOIN_HINT → only for Link / Table
    if ft == "Link" and df.options:
        out["join_hint"] = {
            "table": _tab(df.options),
            "on": f"{fieldname} = {_tab(df.options)}.name",
        }
    elif ft == "Table" and df.options:
        out["join_hint"] = {
            "table": _tab(df.options),
            "on": f"{_tab(df.options)}.parent = {_tab(parent_dt)}.name",
        }

    return out



def build_table_yaml(dt_meta: Any) -> Dict[str, Any]:
    dt = dt_meta.name

    fields_yaml: List[Dict[str, Any]] = []
    for df in dt_meta.fields:
        if not df.fieldname:
            continue
        if _is_layout_field(df.fieldtype):
            continue
        fields_yaml.append(build_field_yaml(dt, df))

    return {
        "table": _tab(dt),
        "synonyms_en": [],
        "description": _best_table_description(dt_meta),
        "fields": fields_yaml,
    }


def get_doctypes_for_modules(modules: List[str]) -> List[Dict[str, Any]]:
    return frappe.get_all(
        "DocType",
        filters={"module": ["in", modules]},
        fields=["name", "module"],
        order_by="module asc, name asc",
    )


def run_yaml(out_path: str, modules: List[str]) -> Dict[str, Any]:
    _ensure_dir(os.path.dirname(out_path))

    doctypes = get_doctypes_for_modules(modules)

    tables_yaml: List[Dict[str, Any]] = []
    per_table_field_counts: Dict[str, int] = {}
    total_fields = 0
    skipped = 0

    for row in doctypes:
        dt = row["name"]
        try:
            dt_meta = frappe.get_meta(dt)
        except Exception:
            skipped += 1
            continue

        t = build_table_yaml(dt_meta)
        tables_yaml.append(t)

        fc = len(t.get("fields", []))
        per_table_field_counts[t["table"]] = fc
        total_fields += fc

    # YAML output only (list)
    with open(out_path, "w", encoding="utf-8") as f:
        yaml.safe_dump(tables_yaml, f, sort_keys=False, allow_unicode=True)

    return {
        "Hi":"Hi",
        "output_path": out_path,
        "modules_count": len(modules),
        "tables_count": len(tables_yaml),
        "total_fields_count": total_fields,
        "fields_per_table": per_table_field_counts,
        "skipped_doctypes": skipped,
    }


@frappe.whitelist(allow_guest=False)
def main(out_path: Optional[str] = None):
    modules = list(dict.fromkeys(BUSINESS_MODULES + CUSTOM_BUSINESS_MODULES))

    default_path = "/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/v2/enriched_schema_test/enriched_schema.yaml"
    out_path = out_path or default_path

    return run_yaml(out_path=out_path, modules=modules)

# DO NOT call main() here. Use bench execute.
