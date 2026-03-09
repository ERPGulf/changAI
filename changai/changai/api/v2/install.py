# In your_app/install.py or hooks.py after_install function

import frappe
import os
import shutil
import subprocess

def after_install():
    """
    Automatically download embedding model after app installation
    """
    try:
        _download_embedding_model()
        frappe.msgprint("ChangAI embedding model downloaded successfully.")
    except Exception:
        frappe.log_error(frappe.get_traceback(), "ChangAI: Embedding Model Auto-Download Failed")
        frappe.msgprint(
            "ChangAI installed, but embedding model download failed. "
            "Please go to ChangAI Settings and click 'Download Embedding Model' manually.",
            indicator="orange"
        )


def _download_embedding_model():
    """
    Shared logic for downloading the embedding model.
    Used by both after_install and download_model_from_ui.
    """
    model_url = "https://huggingface.co/hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned"
    model_path = frappe.get_app_path("changai", "changai", "model")
    app_base = frappe.get_app_path("changai")

    # Security check
    resolved = os.path.realpath(model_path)
    if not resolved.startswith(os.path.realpath(app_base)):
        frappe.throw("Invalid model path: outside app directory.")

    if os.path.exists(model_path):
        shutil.rmtree(model_path)

    os.makedirs(os.path.dirname(model_path), exist_ok=True)

    subprocess.run(
        ["git", "clone", model_url, model_path],
        check=True,
        shell=False
    )