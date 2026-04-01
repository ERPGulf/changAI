import random
from decimal import Decimal
from typing import Any, Dict, List, Optional, Set
import frappe
import sqlglot
from sqlglot import exp


EMPTY_RESPONSES = {
    "default": [
        "No matching records were found.",
        "I couldn't find any matching data.",
        "There are no records matching this request.",
        "No results were returned.",
        "Nothing matched the requested criteria.",
    ],
    "time_filtered": [
        "No matching records were found for the selected time period.",
        "There is no data available for that time range.",
        "No results were returned for the requested period.",
    ],
    "status_filtered": [
        "No records were found with the requested status.",
        "There are no matching records in that state.",
        "Nothing matched the requested status filter.",
    ],
    "entity_filtered": [
        "No matching records were found for the requested value.",
        "I couldn't find any records for the specified item.",
        "No data matched the provided name or value.",
    ],
}


def _stable_pick(options: List[str], key: str) -> str:
    if not options:
        return "No matching records were found."
    idx = abs(hash(key)) % len(options)
    return options[idx]


def clean_table_name(name: str) -> str:
    if not name:
        return "Table"
    name = str(name).strip().replace("`", "")
    if name.startswith("tab"):
        name = name[3:]
    name = name.replace("_", " ")
    name = " ".join(name.split())
    return name


def clean_label(name: str) -> str:
    if not name:
        return "Value"
    name = str(name).strip().replace("`", "")
    if "." in name:
        name = name.split(".")[-1]
    name = name.replace("_", " ")
    name = " ".join(name.split())
    return name.title()


def format_number(value: Any) -> str:
    if isinstance(value, bool):
        return "Yes" if value else "No"
    if isinstance(value, int):
        return f"{value:,}"
    if isinstance(value, float):
        if value.is_integer():
            return f"{int(value):,}"
        return f"{value:,.2f}"
    if isinstance(value, Decimal):
        if value == value.to_integral():
            return f"{int(value):,}"
        return f"{float(value):,.2f}"
    return str(value)


def format_value(value: Any) -> str:
    if value is None:
        return "-"
    if isinstance(value, (int, float, Decimal, bool)):
        return format_number(value)
    return str(value)


def safe_parse_sql(sql: str) -> Optional[exp.Expression]:
    try:
        return sqlglot.parse_one(sql, read="mysql")
    except Exception:
        return None


def extract_tables_from_ast(tree: Optional[exp.Expression]) -> List[str]:
    if tree is None:
        return []

    tables: List[str] = []
    seen: Set[str] = set()

    for t in tree.find_all(exp.Table):
        name = t.name
        if name and name not in seen:
            seen.add(name)
            tables.append(name)

    return tables


def extract_columns_from_ast(tree: Optional[exp.Expression]) -> List[str]:
    if tree is None:
        return []

    cols: List[str] = []
    seen: Set[str] = set()

    for c in tree.find_all(exp.Column):
        name = c.name
        if name and name not in seen:
            seen.add(name)
            cols.append(name)

    return cols


def expression_label(expr: exp.Expression) -> str:
    """
    Return the best output label for a SELECT expression.
    Prefers alias, otherwise derives something readable.
    """
    alias = expr.alias_or_name
    if alias:
        return clean_label(alias)

    if isinstance(expr, exp.Column):
        return clean_label(expr.name)

    if isinstance(expr, exp.Count):
        inner = list(expr.find_all(exp.Column))
        if inner:
            return clean_label(f"count_{inner[0].name}")
        return "Count"

    if isinstance(expr, exp.Sum):
        inner = list(expr.find_all(exp.Column))
        if inner:
            return clean_label(f"sum_{inner[0].name}")
        return "Sum"

    if isinstance(expr, exp.Avg):
        inner = list(expr.find_all(exp.Column))
        if inner:
            return clean_label(f"avg_{inner[0].name}")
        return "Average"

    if isinstance(expr, exp.Max):
        inner = list(expr.find_all(exp.Column))
        if inner:
            return clean_label(f"max_{inner[0].name}")
        return "Maximum"

    if isinstance(expr, exp.Min):
        inner = list(expr.find_all(exp.Column))
        if inner:
            return clean_label(f"min_{inner[0].name}")
        return "Minimum"

    text = expr.sql(dialect="mysql")
    return clean_label(text)


def extract_select_output_labels(tree: Optional[exp.Expression]) -> List[str]:
    if tree is None:
        return []

    if not isinstance(tree, exp.Select):
        select = tree.find(exp.Select)
    else:
        select = tree

    if select is None:
        return []

    labels: List[str] = []
    for projection in select.expressions:
        labels.append(expression_label(projection))

    return labels


def sql_signals(tree: Optional[exp.Expression]) -> Dict[str, Any]:
    if tree is None:
        return {
            "has_group_by": False,
            "has_order_by": False,
            "has_limit": False,
            "aggregate_count": 0,
            "has_where": False,
            "tables": [],
            "columns": [],
            "select_labels": [],
        }

    tables = extract_tables_from_ast(tree)
    columns = extract_columns_from_ast(tree)
    select_labels = extract_select_output_labels(tree)

    aggregate_count = sum(
        1
        for _ in tree.find_all((exp.Count, exp.Sum, exp.Avg, exp.Min, exp.Max))
    )

    has_group_by = tree.args.get("group") is not None
    has_order_by = tree.args.get("order") is not None
    has_limit = tree.args.get("limit") is not None
    has_where = tree.args.get("where") is not None

    return {
        "has_group_by": has_group_by,
        "has_order_by": has_order_by,
        "has_limit": has_limit,
        "aggregate_count": aggregate_count,
        "has_where": has_where,
        "tables": tables,
        "columns": columns,
        "select_labels": select_labels,
    }


# =========================================================
# EMPTY RESULT BUCKETING FROM SQL
# =========================================================

def infer_empty_bucket(sql: str, tree: Optional[exp.Expression], columns: List[str]) -> str:
    sql_u = (sql or "").upper()
    cols = " ".join(columns).lower()

    if any(x in sql_u for x in ["CURDATE()", "YEAR(", "MONTH(", "DATE(", "BETWEEN", "NOW()", "LAST_DAY("]):
        return "time_filtered"

    if any(x in sql_u for x in ["DOCSTATUS", "STATUS", "OUTSTANDING_AMOUNT", " IS NULL", " IS NOT NULL"]):
        return "status_filtered"

    if any(x in cols for x in ["customer", "supplier", "employee", "item", "warehouse"]):
        return "entity_filtered"

    if tree:
        ast_cols = extract_columns_from_ast(tree)
        if any(x in " ".join(ast_cols).lower() for x in ["customer", "supplier", "employee", "item", "warehouse"]):
            return "entity_filtered"

    return "default"


def pick_empty_response(sql: str, tree: Optional[exp.Expression], columns: List[str]) -> str:
    bucket = infer_empty_bucket(sql, tree, columns)
    options = EMPTY_RESPONSES.get(bucket, EMPTY_RESPONSES["default"])
    return _stable_pick(options, f"{bucket}:{sql}:{','.join(columns)}")


def classify_response_type(
    sql: str,
    tree: Optional[exp.Expression],
    row_count: int,
    columns: List[str],
    sample_rows: List[Dict[str, Any]],
) -> str:
    sig = sql_signals(tree)
    col_count = len(columns)

    if row_count == 0:
        return "empty"

    if row_count == 1 and col_count == 1:
        return "scalar"

    if row_count == 1 and col_count > 1:
        return "single_record"

    if sig["has_group_by"] and sig["has_order_by"] and sig["has_limit"]:
        return "ranked_grouped_list"

    if sig["has_order_by"] and sig["has_limit"]:
        return "ranked_list"

    if sig["has_group_by"]:
        if sig["aggregate_count"] >= 2:
            return "comparison_table"
        return "grouped_summary"

    if col_count == 1:
        return "single_column_list"

    if row_count <= 10 and col_count <= 5:
        return "small_table"

    return "large_table"


# =========================================================
# LABEL RESOLUTION
# =========================================================

def resolved_output_labels(
    tree: Optional[exp.Expression],
    sample_rows: List[Dict[str, Any]],
    explicit_columns: Optional[List[str]] = None,
) -> List[str]:
    """
    Prefer actual row keys if present.
    If not, fall back to SELECT-derived labels from SQL AST.
    """
    if explicit_columns:
        return [clean_label(c) for c in explicit_columns]

    if sample_rows:
        return [clean_label(c) for c in sample_rows[0].keys()]

    sql_labels = extract_select_output_labels(tree)
    if sql_labels:
        return sql_labels

    return []


# =========================================================
# RENDERERS
# =========================================================

def render_scalar(
    sql: str,
    tree,
    labels: List[str],
    sample_rows: List[Dict[str, Any]],
) -> str:
    if not sample_rows:
        return "No results were returned."

    row = sample_rows[0]
    key = list(row.keys())[0]
    value = format_value(row[key])

    # detect COUNT from AST
    count_expr = next(tree.find_all(exp.Count), None) if tree else None

    if count_expr:
        tables = extract_tables_from_ast(tree)
        if tables:
            table_name = clean_table_name(tables[0])
            return f"Total {table_name.lower()}s: {value}."

        col_node = next(count_expr.find_all(exp.Column), None)
        if col_node:
            label = clean_label(col_node.name)
            return f"Total {label.lower()}s: {value}."

        return f"Total count: {value}."

    # detect SUM
    sum_expr = next(tree.find_all(exp.Sum), None) if tree else None
    if sum_expr:
        col_node = next(sum_expr.find_all(exp.Column), None)
        if col_node:
            label = clean_label(col_node.name)
            return f"Total {label.lower()}: {value}."
        return f"Total: {value}."

    # detect AVG
    avg_expr = next(tree.find_all(exp.Avg), None) if tree else None
    if avg_expr:
        col_node = next(avg_expr.find_all(exp.Column), None)
        if col_node:
            label = clean_label(col_node.name)
            return f"Average {label.lower()}: {value}."
        return f"Average value: {value}."

    # fallback
    label = labels[0] if labels else clean_label(key)
    return f"{label}: {value}."

def render_single_record(
    labels: List[str],
    sample_rows: List[Dict[str, Any]],
) -> str:
    row = sample_rows[0]
    keys = list(row.keys())

    parts = []
    for idx, key in enumerate(keys):
        label = labels[idx] if idx < len(labels) else clean_label(key)
        parts.append(f"{label}: {format_value(row[key])}")

    return "\n".join(parts)


def render_ranked_list(
    labels: List[str],
    sample_rows: List[Dict[str, Any]],
    intro: str,
) -> str:
    lines = [intro]

    for i, row in enumerate(sample_rows, 1):
        row_keys = list(row.keys())
        parts = []
        for idx, key in enumerate(row_keys):
            label = labels[idx] if idx < len(labels) else clean_label(key)
            parts.append(f"{label}: {format_value(row[key])}")
        lines.append(f"{i}. " + " | ".join(parts))

    return "\n".join(lines)


def render_single_column_list(
    labels: List[str],
    sample_rows: List[Dict[str, Any]],
) -> str:
    lines = [f"Here are the matching {labels[0].lower() if labels else 'values'}:"]
    for i, row in enumerate(sample_rows, 1):
        key = list(row.keys())[0]
        lines.append(f"{i}. {format_value(row[key])}")
    return "\n".join(lines)


def render_table_like(
    labels: List[str],
    sample_rows: List[Dict[str, Any]],
    row_count: int,
    intro: Optional[str] = None,
) -> str:
    if intro is None:
        intro = f"Returned {row_count} records. Showing first {len(sample_rows)}:"

    lines = [intro]
    for i, row in enumerate(sample_rows, 1):
        row_keys = list(row.keys())
        parts = []
        for idx, key in enumerate(row_keys):
            label = labels[idx] if idx < len(labels) else clean_label(key)
            parts.append(f"{label}: {format_value(row[key])}")
        lines.append(f"{i}. " + " | ".join(parts))

    return "\n".join(lines)

def render_grouped_summary(
    tree,
    sample_rows: List[Dict[str, Any]],
) -> str:
    if not sample_rows:
        return "No data available."

    # assume first column = dimension, second = metric
    keys = list(sample_rows[0].keys())

    if len(keys) < 2:
        return render_table_like([], sample_rows, len(sample_rows))

    dim_key = keys[0]
    metric_key = keys[1]

    dim_label = clean_label(dim_key)
    metric_label = clean_label(metric_key)

    # clean metric label (remove brackets issue)
    metric_label = metric_label.replace(")", "").strip()

    lines = [f"{metric_label} by {dim_label.lower()}:\n"]

    for row in sample_rows:
        dim_val = format_value(row.get(dim_key))
        metric_val = format_value(row.get(metric_key))
        lines.append(f"{dim_val}: {metric_val}")

    return "\n".join(lines)

def render_response(
    response_type: str,
    sql: str,
    tree: Optional[exp.Expression],
    row_count: int,
    columns: List[str],
    labels: List[str],
    sample_rows: List[Dict[str, Any]],
) -> str:
    if response_type == "empty":
        return pick_empty_response(sql, tree, columns)

    if response_type == "scalar":
        return render_scalar(labels, sample_rows)

    if response_type == "single_record":
        return render_single_record(labels, sample_rows)

    if response_type == "ranked_grouped_list":
        return render_ranked_list(labels, sample_rows, intro="Here are the top grouped results:")

    if response_type == "ranked_list":
        return render_ranked_list(labels, sample_rows, intro="Here are the top results:")

    if response_type == "grouped_summary":
        return render_grouped_summary(tree, sample_rows)

    if response_type == "comparison_table":
        return render_table_like(labels, sample_rows, row_count)

    if response_type == "single_column_list":
        return render_single_column_list(labels, sample_rows)

    if response_type == "small_table":
        return render_table_like(labels, sample_rows, row_count)

    source_tables = extract_tables_from_ast(tree)
    source_names = [clean_table_name(t) for t in source_tables]
    if source_names:
        intro = f"Returned {row_count} records from {', '.join(source_names)}."
    else:
        intro = f"Returned {row_count} records. Showing first {len(sample_rows)}:"

    return render_table_like(labels, sample_rows, row_count, intro=intro)


def format_sql_response(
    sql: str,
    row_count: int,
    sample_rows: List[Dict[str, Any]],
    columns: Optional[List[str]] = None,
) -> Dict[str, Any]:
    """
    Main entry for formatting SQL responses.

    Inputs:
      sql         -> executed SQL query string
      row_count   -> total number of rows returned
      sample_rows -> first few rows only, not full result
      columns     -> optional explicit result columns

    Returns:
      dict with response_type, formatted_answer, tables, fields, labels
    """
    tree = safe_parse_sql(sql)

    if columns is None:
        if sample_rows:
            columns = list(sample_rows[0].keys())
        else:
            columns = extract_select_output_labels(tree)

    labels = resolved_output_labels(tree, sample_rows, columns)

    response_type = classify_response_type(
        sql=sql,
        tree=tree,
        row_count=row_count,
        columns=columns,
        sample_rows=sample_rows,
    )

    formatted_answer = render_response(
        response_type=response_type,
        sql=sql,
        tree=tree,
        row_count=row_count,
        columns=columns,
        labels=labels,
        sample_rows=sample_rows,
    )

    source_tables = [clean_table_name(t) for t in extract_tables_from_ast(tree)]
    source_fields = [clean_label(c) for c in extract_columns_from_ast(tree)]

    return {
        "response_type": response_type,
        "formatted_answer": formatted_answer,
        "row_count": row_count,
        "sample_size": len(sample_rows),
        "columns": columns,
        "labels": labels,
        "source_tables": source_tables,
        "source_fields": source_fields,
    }

@frappe.whitelist(allow_guest=True)
def test(sql, sample_rows):
    row_count = len(sample_rows)
    result = format_sql_response(sql, row_count, sample_rows)
    return result


