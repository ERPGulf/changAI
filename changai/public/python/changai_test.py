import json
import os
import requests
from dotenv import load_dotenv

# === STEP 1: Load environment variables ===
load_dotenv()  # ✅ Load .env before using os.getenv
API_KEY = os.getenv("HUGGINGFACE_API_KEY")

# === STEP 2: Load id2label mapping ===
with open(
    "/opt/hyrin/frappe-bench/apps/changai/changai/changai/stage_datasets/stage1_roberta/id2doc_label.json",
    "r",
    encoding="utf-8",
) as f:
    id2label = json.load(f)

# === STEP 3: Hugging Face API Config ===
S1_API_URL = "https://api-inference.huggingface.co/models/hyrinmansoor/text2frappe-s1-roberta"
HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}

# === STEP 4: Query the Hugging Face inference API ===
def query_huggingface_model(question):
    payload = {"inputs": question, "parameters": {"top_k": 1}}
    try:
        response = requests.post(S1_API_URL, headers=HEADERS, json=payload, timeout=30)
        response.raise_for_status()
        output = response.json()

        if isinstance(output, list) and len(output) > 0 and "label" in output[0]:
            pred_id = output[0]["label"].replace("LABEL_", "")
            predicted_doctype = id2label.get(pred_id, "Unknown Doctype")
            return {"success": True, "doctype": predicted_doctype}

        return {"success": False, "error": "Unexpected model output format."}

    except requests.exceptions.RequestException as e:
        return {"success": False, "error": str(e)}

# === STEP 5: Frappe-style wrapper ===
def run_in_frappe(user_input):
    if not user_input:
        return {"success": False, "error": "No user input provided."}

    s1_result = query_huggingface_model(user_input)
    if not s1_result.get("success"):
        return {"success": False, "error": s1_result.get("error", "Stage 1 failed.")}

    predicted_doctype = s1_result["doctype"]
    return {
        "success": True,
        "response": f"📄 Detected Doctype: {predicted_doctype}\n(This is from Stage 1 only.)"
    }

# === STEP 6: Main block for local testing ===
if __name__ == "__main__":
    test_question = "Where do I add the charges for repairing an asset?"
    result = run_in_frappe(test_question)
    print(json.dumps(result, indent=2))
