from __future__ import annotations

import json
from typing import Any, Dict, List

import frappe
from frappe import _

# LangChain + FAISS
from langchain_community.vectorstores import FAISS
from langchain_core.embeddings import Embeddings


import cv2
from frappe.utils.data import add_to_date, get_time, getdate
from erpnext import get_region
from pyqrcode import create as qr_create
import base64
from base64 import b64encode
import io
import os


import frappe
from frappe.desk.reportview import build_match_conditions


@frappe.whitelist(allow_guest=False)
def create_qr_code(doc,method):
    """Create QR Code after inserting Employee"""
    if not hasattr(doc, 'custom_qr_code'):
    	return

    fields = frappe.get_meta("Employee").fields
    auth_client_name = frappe.db.get_value("OAuth Client", {}, "name")
    if auth_client_name:
        auth_client = frappe.get_doc("OAuth Client", auth_client_name)
    else:
        frappe.throw("No OAuth Client found")
    app_name = auth_client.app_name
    if not app_name:
        frappe.throw(_('App name missing in OAuth Client'))

    app_key = base64.b64encode(app_name.encode()).decode("utf-8")

    for field in fields:
        if field.fieldname == 'custom_qr_code' and field.fieldtype == 'Attach Image':

            company_name = frappe.db.get_value('Company', doc.company, 'company_name')
            if not company_name:
                frappe.throw(_('Company name missing for {} in the company document'.format(doc.company)))

            if not doc.name:
                frappe.throw(_('Employee code missing in the document'))

            if not doc.first_name:
                frappe.throw(_('First name missing for {} in the document'.format(doc.name)))

            last_name = doc.last_name if doc.last_name else ""

            # if not doc.custom_photo_:
            # 	frappe.throw(_('Photo missing for {} in the document'.format(doc.name)))

            if not doc.custom_restrict_location and doc.custom_restrict_location != 0:
                frappe.throw(_('Restrict Location missing for {} in the document'.format(doc.name)))

            if not doc.user_id:
                frappe.throw(_('User ID missing for {} in the document'.format(doc.name)))

            if not frappe.local.conf.host_name:
                frappe.throw(_('API URL (host_name) is missing in site config'))

            if not app_key:
                frappe.throw(_('App key could not be generated'))

            cleaned = (
                f"Company: {company_name}"
                f" Employee_Code: {doc.name}"
                f" Full_Name: {doc.first_name}  {last_name}"
                f" Photo: {doc.image}"
                f" Restrict Location: {doc.custom_restrict_location}"
                f" User_id: {doc.user_id}"
                f" API: {frappe.local.conf.host_name}"
                f" App_key: {app_key}"
            )

            base64_string = b64encode(cleaned.encode()).decode()

            qr_image = io.BytesIO()
            url = qr_create(base64_string, error='L')
            url.png(qr_image, scale=2, quiet_zone=1)

            filename = f"QR-CODE-{doc.name}.png".replace(os.path.sep, "__")
            _file = frappe.get_doc({
                "doctype": "File",
                "file_name": filename,
                "content": qr_image.getvalue(),
                "is_private": 0
            })

            _file.save()

            doc.db_set('custom_qr_code', _file.file_url)
            doc.notify_update()

            break


@frappe.whitelist(allow_guest=False)
def test_create_qr_code(employee_id: str):
    doc = frappe.get_doc("Employee", employee_id)
    try:
        create_qr_code(doc, None)
        return "QR Code created"
    except Exception as e:
        return {"ok":False,"error":str(e)}



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


import json
import time
from google import genai
from google.genai import types
from google.oauth2 import service_account
from changai.changai.api.v2.train_data_api import _get_gemini_client
@frappe.whitelist(allow_guest=True)
def run_hallucination_test():
    # 3. Upload the Schema File
    client=_get_gemini_client()
    uploaded_file = client.files.upload(file="/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/v2/test_gemini_schema.text")
    
    # Wait for the file to be processed
    while uploaded_file.state.name == "PROCESSING":
        print("Waiting for file processing...")
        time.sleep(2)
        uploaded_file = client.files.get(name=uploaded_file.name)

    print(f"File ready: {uploaded_file.uri}")

    # 4. Generate Content with Strict Instructions
    prompt = """
    TASK: Generate exactly 2 training records in JSON format based ONLY on the provided schema file.
    STRICT CONSTRAINTS:
    1. USE ONLY tables and fields explicitly defined in the attached schema file.
    2. If a user query asks for a concept (like 'Price' or 'Cost') that is NOT in the schema file, you MUST NOT invent a field. Use 'NOT_FOUND' or skip that specific field in the 'positives' list.
    3. Do not use generic ERPNext knowledge. Only use the provided 'custom_...' fields if they exist in the file.
    4. ANCHOR STYLE: Use messy, business-casual human language (e.g., 'where is the stuff', 'who did this').
    REQUIRED JSON FORMAT:
    [
      {
        "anchor": "The messy human question here",
        "positives": [
          "[TABLE] tabName | desc: purpose",
          "[FIELD] fieldname | [TABLE] tabName | desc: purpose",
          "[LINK] tabA -> tabB ON field | desc: connection"
        ]
      }
    ]
    OUTPUT ONLY THE RAW JSON ARRAY. NO MARKDOWN. NO EXPLANATION.
    """

    print("\n--- Sending Prompt to Gemini ---")
    response = client.models.generate_content(
        model="gemini-2.0-flash-lite",
        contents=[
            uploaded_file,
            types.Content(role="user", parts=[types.Part.from_text(prompt)])
        ],
        config=types.GenerateContentConfig(
            system_instruction="Strictly adhere to the attached file. No hallucinations.",
            temperature=0.0,
            response_mime_type="application/json"
        )
    )
    return response.text
