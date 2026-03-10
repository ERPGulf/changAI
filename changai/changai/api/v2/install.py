import frappe
import os
import shutil
from huggingface_hub import snapshot_download


def after_install():
    try:
        _download_embedding_model()
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
    app_base = frappe.get_app_path("changai")
    model_path = frappe.get_app_path("changai", "changai", "model")
    resolved = os.path.realpath(model_path)

    # Security check
    if not resolved.startswith(os.path.realpath(app_base)):
        frappe.throw("Invalid model path: outside app directory.")

    # Always replace
    if os.path.exists(model_path):
        shutil.rmtree(model_path)

    os.makedirs(model_path, exist_ok=True)

    snapshot_download(
        repo_id="hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned",
        local_dir=model_path
    )