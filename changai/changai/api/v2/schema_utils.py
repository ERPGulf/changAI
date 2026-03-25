import sqlglot
from sqlglot import exp
from sqlglot import optimizer
from sqlglot.schema import MappingSchema
import frappe
import json
from typing import Any, Dict, List, Tuple, Union, Optional, Set
import yaml
from pathlib import Path

_ASSETS_DIR = Path(frappe.get_app_path("changai", "changai", "api", "v2", "assets")).resolve()
RAG_FOLDER = "Home/RAG Sources"
JSON_EXT = ".json"
YAML_EXT = ".yaml"
def _get_file_doc_by_name(file_name: str, folder: str = RAG_FOLDER) -> Optional["frappe.model.document.Document"]:
    file_id = frappe.db.get_value("File", {"file_name": file_name, "folder": folder}, "name")
    if not file_id:
        return None
    return frappe.get_doc("File", file_id)


def _read_filedoctype(file_name: str, folder: str = RAG_FOLDER):
    doc = _get_file_doc_by_name(file_name, folder)
    if not doc:
        if file_name.endswith(JSON_EXT):
            return []
        if file_name.endswith((YAML_EXT, ".yml")):
            return {}
        return ""
    raw = doc.get_content() or ""
    if isinstance(raw, bytes):
        raw = raw.decode("utf-8", errors="replace")
    if file_name.endswith(JSON_EXT):
        return json.loads(raw or "[]")
    if file_name.endswith((YAML_EXT, ".yml")):
        obj = yaml.safe_load(raw) or {}
        return obj if isinstance(obj, dict) else {}
    return raw


def read_asset(file_name: str, base: str = "assets") -> Any:
    """
    base:
      - "assets"  -> changai/changai/api/v2/assets
      - "prompts" -> changai/changai/prompts
    """
    file_name = (file_name or "").strip()
    if not file_name:
        frappe.throw(_("file_name is required"))

    ext = Path(file_name).suffix.lower()
    if ext not in _ALLOWED_EXT:
        frappe.throw(_("Unsupported file type: {0}").format(ext))

    if base == "assets":
        root = _ASSETS_DIR
    elif base == "prompts":
        root = _PROMPTS_DIR
    else:
        root = None
    if root is None:
        frappe.throw(_("Invalid base: {0}").format(base))

    path = _safe_join(root, file_name)

    if not path.is_file():
        frappe.throw(_("File not found: {0}").format(str(path)))

    content = path.read_text(encoding="utf-8", errors="replace")

    if ext == ".json":
        try:
            return json.loads(content)
        except json.JSONDecodeError as e:
            frappe.throw(_("Invalid JSON in {0}: {1}").format(str(path), str(e)))
    if ext == ".yaml" or ext == ".yml":
        try:
            return yaml.safe_load(content)
        except yaml.YAMLError as e:
            frappe.throw(_("Invalid YAML in {0}: {1}").format(str(path), str(e)))
    return content

def _load_mapping_data() -> dict:
    return read_asset("metaschema_clean_v2.json")

@frappe.whitelist()
def validate_sql_schema(sql: str, dialect: str = "mysql") -> dict:
    try:
        mapping_data = _load_mapping_data()  # fresh load every time
        schema = MappingSchema(mapping_data, dialect=dialect)

        ast = sqlglot.parse_one(sql, read=dialect)

        for table in ast.find_all(exp.Table):
            if table.name and table.name not in mapping_data:
                return {"ok": False, "error": f"Table '{table.name}' does not exist in schema"}

        qualified = optimizer.qualify.qualify(ast, schema=schema)
        return {"ok": True, "qualified_sql": qualified.sql()}

    except sqlglot.errors.OptimizeError as e:
        return {"ok": False, "error": str(e)}
    except sqlglot.errors.ParseError as e:
        return {"ok": False, "error": str(e)}


@frappe.whitelist()
def convert_yaml_schema_to_sqlglot_meta() -> dict:
    try:
        data = _read_filedoctype("schema.yaml")
        meta = {}
        for table_entry in data.get("tables", []):
            table_name = table_entry.get("table")
            fields = table_entry.get("fields", [])
            if table_name:
                meta[table_name] = {
                    field["name"]: "TEXT"
                    for field in fields
                    if field.get("name")
                }

        output_path = _ASSETS_DIR / "metaschema_clean_v2.json"
        output_path.write_text(
            json.dumps(meta, indent=2),
            encoding="utf-8"
        )

        return {
            "ok": True,
            "message": "Successfully updated MetaSchema for Validation"
        }
    except Exception as e:
        return {
            "ok": False,
            "message": str(e)
        }
    