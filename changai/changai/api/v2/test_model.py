from __future__ import annotations

import json
import os
from typing import Any, Dict, List

import frappe
from frappe import _

# LangChain + FAISS
from langchain_community.vectorstores import FAISS
from langchain_core.embeddings import Embeddings


def to_pos_int(x, default: int = 20, name: str = "value") -> int:
    try:
        v = int(x)
    except (TypeError, ValueError):
        v = default
    if v <= 0:
        raise ValueError(f"{name} must be > 0 (got {v})")
    return v

def topk_tables(vs: FAISS, q: str, k: int = 20) -> List[str]:
    k = to_pos_int(k, default=20, name="topk")
    hits = vs.similarity_search(q, k=k)
    out = []
    for h in hits:
        t = extract_table(h)
        if t:
            out.append(t)
    return out

# Sentence Transformers
from sentence_transformers import SentenceTransformer


# @frappe.whitelist(allow_guest=True)
# def test_model_module_wise(
#     module_name:str,
# ) -> Dict[str, Any]:
#     topk = 20
#     topk = to_pos_int(topk, default=20, name="topk")
#     questions_file_path= f"/files/{module_name}_test.jsonl"
#     model_path= "hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned"
#     file_doc = frappe.get_doc("File", {"file_url": questions_file_path})
#     abs_path = file_doc.get_full_path()
#     with open(abs_path, "r", encoding="utf-8") as f:
#         data = [json.loads(line) for line in f if line.strip()]
#     faiss_doc = frappe.get_doc("File", {"file_name": "index.faiss"})
#     fvs_abs_path = os.path.dirname(faiss_doc.get_full_path())
#     emb = STEmbeddings(model_path)
#     vs = FAISS.load_local(fvs_abs_path, emb, allow_dangerous_deserialization=True)
#     total = correct = skipped = 0
#     wrong = []
#     for row in data:
#         q = (row.get("question") or "").strip()
#         exp = (row.get("expected_top1") or "").strip()
#         if not q or not exp:
#             skipped += 1
#             continue
#         total += 1
#         top_tables = topk_tables(vs, q, k=topk)
#         pred_top1 = top_tables[0] if top_tables else None
#         is_correct = exp in top_tables[:topk]
#         if is_correct:
#             correct += 1
#         else:
#             wrong.append({
#                 "question": q,
#                 "expected_top1": exp,
#                 "pred_top1": pred_top1,
#                 "top_tables": top_tables[:topk],
#             })
#     file_name = f"{module_name}_test.jsonl"
#     wrong_content = "\n".join(json.dumps(row) for row in wrong)
#     existing = frappe.db.get_value("File", {
#     "file_name": ("like", f"{module_name}_test%.jsonl"),
#     "folder": "Home/Test Results"
# }, "name")
#     if existing:
#         frappe.delete_doc("File", existing, ignore_permissions=True)
#     wrong_file_doc = frappe.get_doc({
#             "doctype": "File",
#             "file_name": file_name,
#             "is_private": 0,
#             "content": wrong_content,
#             "folder": "Home/Test Results"
#         }).insert(ignore_permissions=True)

#     return {
#         "total_evaluated": total,
#         "correct": correct,
#         "wrong": len(wrong),
#         "skipped_missing_fields": skipped,
#         "accuracy": round((correct / total) if total else 0.0, 4),
#         "wrong_predictions": {
#             "count": len(wrong),
#             "file_name": wrong_file_doc.name,
#             "file_url": wrong_file_doc.file_url,
#         },
#     }


@frappe.whitelist(allow_guest=False)
def test_model() -> Dict[str, Any]:
    topk       = 20
    model_path = "hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned"

    # ============================================
    # Load FAISS index once
    # ============================================
    faiss_doc    = frappe.get_doc("File", {"file_name": "index.faiss"})
    fvs_abs_path = os.path.dirname(faiss_doc.get_full_path())
    emb          = STEmbeddings(model_path)
    vs           = FAISS.load_local(fvs_abs_path, emb, allow_dangerous_deserialization=True)

    # ============================================
    # Get ALL validation files
    # ============================================
    val_files = frappe.get_all("File",
        filters={
            "folder"   : "Home/Validation Data",
            "file_name": ["like", "%.jsonl"]
        },
        fields=["file_name", "file_url", "name"]
    )

    if not val_files:
        frappe.throw("No validation files found in Home/Validation Data")

    # ============================================
    # Collect all wrong predictions grouped by module
    # ============================================
    module_wrong  = {}   # { "CRM": [...], "HR": [...] }
    module_stats  = {}   # { "CRM": {total, correct, skipped} }

    for val_file in val_files:
        file_doc = frappe.get_doc("File", val_file["name"])
        abs_path = file_doc.get_full_path()

        try:
            with open(abs_path, "r", encoding="utf-8") as f:
                data = [json.loads(line) for line in f if line.strip()]
        except Exception as e:
            frappe.log_error(f"Could not read {val_file['file_name']}: {str(e)}")
            continue

        for row in data:
            q   = (row.get("question") or "").strip()
            exp = (row.get("expected_top1") or "").strip()
            qid = (row.get("qid") or "").strip()

            # ✅ Extract module from qid e.g. "CRM_001" → "CRM"
            mod_name = qid.rsplit("_", 1)[0] if "_" in qid else "Unknown"

            # Init stats for module
            if mod_name not in module_stats:
                module_stats[mod_name] = {"total": 0, "correct": 0, "skipped": 0}
                module_wrong[mod_name] = []

            if not q or not exp:
                module_stats[mod_name]["skipped"] += 1
                continue

            module_stats[mod_name]["total"] += 1

            top_tables = topk_tables(vs, q, k=topk)
            pred_top1  = top_tables[0] if top_tables else None
            is_correct = exp in top_tables[:topk]

            if is_correct:
                module_stats[mod_name]["correct"] += 1
            else:
                module_wrong[mod_name].append({
                    "qid"          : qid,
                    "question"     : q,
                    "expected_top1": exp,
                    "pred_top1"    : pred_top1,
                    "top_tables"   : top_tables[:topk],
                })

    # ============================================
    # Save wrong predictions module wise
    # ============================================
    overall_results = {}

    for mod_name, wrong in module_wrong.items():
        wrong_content   = "\n".join(json.dumps(row) for row in wrong)
        wrong_file_name = f"{mod_name}_test.jsonl"

        # Delete existing
        existing = frappe.db.get_value("File", {
            "file_name": wrong_file_name,
            "folder"   : "Home/Test Results"
        }, "name")

        if existing:
            frappe.delete_doc("File", existing, ignore_permissions=True)

        # Save new
        wrong_file_doc = frappe.get_doc({
            "doctype"  : "File",
            "file_name": wrong_file_name,
            "is_private": 0,
            "content"  : wrong_content,
            "folder"   : "Home/Test Results"
        }).insert(ignore_permissions=True)

        stats = module_stats[mod_name]
        accuracy = round(
            (stats["correct"] / stats["total"]) if stats["total"] else 0.0, 4
        )

        overall_results[mod_name] = {
            "total_evaluated"       : stats["total"],
            "correct"               : stats["correct"],
            "wrong"                 : len(wrong),
            "skipped_missing_fields": stats["skipped"],
            "accuracy"              : accuracy,
            "wrong_predictions"     : {
                "count"    : len(wrong),
                "file_name": wrong_file_doc.name,
                "file_url" : wrong_file_doc.file_url,
            }
        }

        frappe.publish_realtime("test_progress", {
            "module"  : mod_name,
            "accuracy": accuracy,
            "correct" : stats["correct"],
            "total"   : stats["total"],
        })

    # ============================================
    # Overall summary
    # ============================================
    total_all   = sum(v["total_evaluated"] for v in overall_results.values())
    correct_all = sum(v["correct"] for v in overall_results.values())
    wrong_all   = sum(v["wrong"] for v in overall_results.values())

    return {
        "overall": {
            "total_evaluated": total_all,
            "correct"        : correct_all,
            "wrong"          : wrong_all,
            "accuracy"       : round((correct_all / total_all) if total_all else 0.0, 4),
        },
        "modules": overall_results
    }