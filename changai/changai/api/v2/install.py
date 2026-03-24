import frappe
import os
from frappe import _
import shutil
from huggingface_hub import snapshot_download


def after_install():
    try:
        model_path = frappe.get_app_path("changai","changai","model")
        _download_embedding_model(model_path)
        frappe.log_error("Model downloaded successfully after install", "ChangAI Model")
    except Exception:
        frappe.log_error(frappe.get_traceback(), "ChangAI: Embedding Model Auto-Download Failed")


def after_migrate():
    try:
        _download_embedding_model()
        frappe.log_error("Model downloaded successfully after migrate", "ChangAI Model")
    except Exception:
        frappe.log_error(frappe.get_traceback(), "ChangAI: Model Download Failed on Migrate")


def _download_embedding_model():
    model_path = frappe.get_site_path("private", "files", "changai_model")
    
    if os.path.exists(model_path):
        shutil.rmtree(model_path)

    os.makedirs(model_path, exist_ok=True)

    snapshot_download(
        repo_id="hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned",
        local_dir=model_path
    )