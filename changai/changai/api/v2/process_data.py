# from vertexai.generative_models import GenerativeModel, GenerationConfig
# import time,secrets
# from google.oauth2 import service_account
# from frappe import _
# from google.genai import types
# from google.api_core import exceptions as google_exceptions
# from google import genai
# import frappe,json

# MAX_RETRIES = 5
# REQUEST_DELAY = 30
# BASE_BACKOFF = 2.0
# MAX_BACKOFF = 60.0
# CHANGAI_SETTINGS = "ChangAI Settings"


# def _get_gemini_client():
#     settings = frappe.get_single(CHANGAI_SETTINGS)
#     json_content = (settings.get("gemini_json_content") or "").strip()
#     project_id = (settings.get("gemini_project_id") or "").strip()
#     location = (settings.get("location") or "us-central1").strip()

#     if not json_content:
#         frappe.throw(_("Gemini Service Account JSON is missing."), title=_("Missing Gemini Configuration"))
#     if not project_id:
#         frappe.throw(_("Gemini Project ID is missing."), title=_("Missing Gemini Configuration"))

#     try:
#         service_account_info = json.loads(json_content)
#     except json.JSONDecodeError as e:
#         frappe.throw(_("Gemini Service Account JSON is invalid: {0}").format(str(e)), title=_("Invalid Gemini JSON"))

#     creds = service_account.Credentials.from_service_account_info(
#         service_account_info,
#         scopes=['https://www.googleapis.com/auth/cloud-platform']
#     )
#     return genai.Client(
#         vertexai=True,
#         project=project_id,
#         location=location,
#         credentials=creds,
#     )


# def _sleep_backoff(attempt: int, base: float = BASE_BACKOFF, cap: float = MAX_BACKOFF):
#     delay = min(cap, base * (2 ** attempt))
#     delay = delay * (0.7 + secrets.randbelow(1000) / 1000 * 0.6)
#     time.sleep(delay)
# def generate_anchors():
#     client=_get_gemini_client()
#     raw=None
#     for attempt in range(MAX_RETRIES):
#         try:
#             cfg = types.GenerateContentConfig(
#                 temperature=0.9,
#                 max_output_tokens=8192,
#                 system_instruction=system_instruction,
#             )

#             response = client.models.generate_content(
#                 model="gemini-2.5-flash-lite",
#                 contents=contents,
#                 config=cfg,
#             )
#             raw = (response.text or "").strip()

#             if REQUEST_DELAY:
#                 time.sleep(REQUEST_DELAY)

#             break

#         except google_exceptions.ResourceExhausted:
#             frappe.log_error(
#                 "Gemini quota exceeded",
#                 "Gemini Rate Limit (429) - sleeping 30s",
#             )
#             time.sleep(30)
#             _sleep_backoff(attempt)

#         except google_exceptions.Unauthenticated:
#             frappe.log_error("Gemini auth failed", "Gemini Authentication Error")
#             return ""

#         except google_exceptions.GoogleAPIError as e:
#             frappe.log_error(str(e), "Gemini API Error")
#             _sleep_backoff(attempt)

#         except Exception as e:
#             frappe.log_error(
#                 title="Gemini generate_content.test failed",
#                 message=f"{str(e)}\n\nContents: {json.dumps(contents)[:8000] if contents else 'N/A'}",
#             )
#             _sleep_backoff(attempt)

#     return raw or ""