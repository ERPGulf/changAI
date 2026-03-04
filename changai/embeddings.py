import frappe
import os
import subprocess
import shutil
from langchain_huggingface import HuggingFaceEmbeddings

_EMBEDDER_INSTANCE = None


@frappe.whitelist()
def download_model_from_ui():
    """
    Force re-download embedding model
    - Deletes existing model folder
    - Clones fresh copy
    - Resets RAM singleton
    """
    global _EMBEDDER_INSTANCE

    model_url = "https://huggingface.co/hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned"

    # apps/changai/changai/models/nomic-embed
    model_path = frappe.get_app_path(
        "changai", "changai", "models", "nomic-embed"
    )

    try:
        if os.path.exists(model_path):
            shutil.rmtree(model_path)

        os.makedirs(os.path.dirname(model_path), exist_ok=True)

        subprocess.run(
            ["git", "clone", model_url, model_path],
            check=True
        )

        _EMBEDDER_INSTANCE = None

        return {
            "status": "success",
            "message": "Embedding model downloaded successfully."
        }

    except Exception as e:
        frappe.log_error(
            frappe.get_traceback(),
            "Embedding Model Download Failed"
        )
        frappe.throw(f"Download failed: {str(e)}")


def get_embedding_engine():
    """
    Disk → RAM loader (Lazy Singleton)
    """
    global _EMBEDDER_INSTANCE

    if _EMBEDDER_INSTANCE is None:
        model_path = frappe.get_app_path(
            "changai", "changai", "models", "nomic-embed"
        )

        if not os.path.exists(model_path):
            frappe.throw(
                "Embedding model not found. "
                "Go to ChangAI Settings and click 'Download Embedding Model'."
            )

        # Heavy load — happens ONCE per worker
        _EMBEDDER_INSTANCE = HuggingFaceEmbeddings(
            model_name=model_path,
            model_kwargs={"device": "cpu"}
        )

    return _EMBEDDER_INSTANCE