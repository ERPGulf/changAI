import frappe
import os
from frappe import _
import shutil
from huggingface_hub import snapshot_download


def after_install():
    try:
        model_path = frappe.get_app_path("changai","changai" "model")
        _download_embedding_model(model_path)
        frappe.log_error("Model downloaded successfully after install", "ChangAI Model")
    except Exception:
        frappe.log_error(frappe.get_traceback(), "ChangAI: Embedding Model Auto-Download Failed")


def after_migrate():
    try:
        model_path = frappe.get_app_path("changai","changai" "model")
        _download_embedding_model(model_path)
        frappe.log_error("Model downloaded successfully after migrate", "ChangAI Model")
    except Exception:
        frappe.log_error(frappe.get_traceback(), "ChangAI: Model Download Failed on Migrate")


def _download_embedding_model(model_path):
    app_base = frappe.get_app_path("changai")
    resolved = os.path.realpath(model_path)

    frappe.log_error(f"model_path: {model_path}\nresolved: {resolved}\napp_base: {app_base}", "ChangAI Model Debug")

    if not resolved.startswith(os.path.realpath(app_base)):
        frappe.throw(_("Invalid model path: outside app directory."))

    if os.path.exists(model_path):
        shutil.rmtree(model_path)
        frappe.log_error(f"Existing model removed: {model_path}", "ChangAI Model Debug")

    os.makedirs(model_path, exist_ok=True)
    frappe.log_error("Starting snapshot_download...", "ChangAI Model Debug")

    snapshot_download(
        repo_id="hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned",
        local_dir=model_path
    )

    frappe.log_error(f"Download complete. Files: {os.listdir(model_path)}", "ChangAI Model Debug")