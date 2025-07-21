import os
import frappe
import requests



@frappe.whitelist(allow_guest=True)
def run_query(query):
    try:
        if not query:
            return {"error": "Query not provided."}

        result = eval(query)
        return {"success": True, "data":result}

    except Exception as e:
        return {"success": False, "error": str(e)}


@frappe.whitelist(allow_guest=True)
def generate_query(user_input):
    try:
        API_URL = "https://hyrinmansoor-changai.hf.space/query"
        response = requests.post(
            API_URL,
            headers={"Content-Type": "application/json"},
            json={"user_input": user_input},
            timeout=10
        )
        json_data = response.json()
        res = json_data.get("response", {})
        query = res.get("query")
        doctype = res.get("predicted_doctype")
        top_fields = res.get("top_fields")
        selected_fields = res.get("selected_fields")

        if not query:
            return {"success": False, "error": "Query not found in model response."}

        result = run_query(query)
        return {
            "success": result.get("success"),
            "data": result.get("data"),
            "message": {
                "query": query,
                "predicted_doctype": doctype,
                "top_fields": top_fields,
                "selected_fields": selected_fields,
                "error": result.get("error") if not result.get("success") else None
            }
        }

    except requests.exceptions.HTTPError as http_err:
        return {"success": False, "error": str(http_err)}
    except Exception as e:
        return {"success": False, "error": str(e)}