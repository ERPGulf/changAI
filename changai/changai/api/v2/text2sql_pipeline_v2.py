from langgraph.graph import StateGraph, END
from collections import OrderedDict
from typing_extensions import TypedDict
from typing import Any, Dict, List, Tuple, Union, Optional, Set
import requests
import json
import yaml
import re
import os
import time
import base64
import sqlglot
from sqlglot import exp
from langsmith.run_helpers import traceable
from langgraph.checkpoint.memory import MemorySaver
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings
from google import genai
from google.genai import types
from changai.changai.api.v2.schema_utils import validate_sql_schema,_load_mapping_data
from google.oauth2 import service_account
from werkzeug.wrappers import Response
from changai.changai.api.v2.helpdesk_api import(
    create_helpdesk_ticket,
    get_user_tickets
)
import jinja2
import frappe
from google.api_core import exceptions as google_exceptions
from changai.changai.api.v2.store_chats import (
    save_turn_2,
    inject_prompt,
)
from huggingface_hub import snapshot_download
from frappe.desk.reportview import build_match_conditions
import shutil
from frappe import _
from pathlib import Path

_ASSETS_DIR = Path(frappe.get_app_path("changai", "changai", "api", "v2", "assets")).resolve()
_PROMPTS_DIR = Path(frappe.get_app_path("changai", "changai", "prompts")).resolve()
CHANGAI_SETTINGS = "ChangAI Settings"
_ALLOWED_EXT = {".json", ".yaml",".j2", ".yml", ".txt", ".md"}

def _safe_join(base: Path, rel: str) -> Path:
    """
    Prevent path traversal. Only allow reading inside base directory.
    """
    p = (base / rel).resolve()
    if base != p and base not in p.parents:
        frappe.throw(_("Unsafe path: {0}").format(rel))
    return p


def read_asset(file_name: str, base: str = "assets") -> Any:
    """
    base:
      - "assets"  -> changai/changai/api/v2/assets
      - "prompts" -> changai/changai/prompts
    """
    file_name = (file_name or "").strip()
    if not file_name:
        frappe.throw(_("file_name is required"))

    ext = Path(file_name).suffix.lower()
    if ext not in _ALLOWED_EXT:
        frappe.throw(_("Unsupported file type: {0}").format(ext))

    if base == "assets":
        root = _ASSETS_DIR
    elif base == "prompts":
        root = _PROMPTS_DIR
    else:
        root = None
    if root is None:
        frappe.throw(_("Invalid base: {0}").format(base))

    path = _safe_join(root, file_name)

    if not path.is_file():
        frappe.throw(_("File not found: {0}").format(str(path)))

    content = path.read_text(encoding="utf-8", errors="replace")

    if ext == ".json":
        try:
            return json.loads(content)
        except json.JSONDecodeError as e:
            frappe.throw(_("Invalid JSON in {0}: {1}").format(str(path), str(e)))
    if ext == ".yaml" or ext == ".yml":
        try:
            return yaml.safe_load(content)
        except yaml.YAMLError as e:
            frappe.throw(_("Invalid YAML in {0}: {1}").format(str(path), str(e)))
    return content

_VS_TABLE = None
_VS_MASTER = None
_EMBEDDER_INSTANCE = None
__vector_store = None
_FULL_FIELDS_VS = None
STATUS_200 = 200
_SUB_VS_CACHE = {}
APPLICATION_JSON = "application/json"
EMBEDDING_ENGINE_NONE_MESSG = "Embedding engine is None. Model not loaded."
MODEL_ID = "gemini-2.5-flash-lite"
RETRY_LIMIT = 2
BACKEND_SERVER_SETTINGS = "Backend Server Settings"
bk = read_asset("business_keywords_v1.json", base="assets")
BUSINESS_KEYWORDS = bk.get("business_keywords", bk)

mapping_data = read_asset("metaschema_clean_v2.json", base="assets")
CONVERSATION_TEMPLATE = read_asset("conversation_template_v2.j2", base="assets")

SQL_PROMPT = read_asset("sql_prompt.txt", base="prompts")
FORMAT_PROMPT = read_asset("user_friendly_prompt.txt", base="prompts")
NON_ERP_PROMPT = read_asset("non_erp_prompt.txt", base="prompts")
SUPPORT_PROMPT = read_asset("support.txt", base="prompts")

FILTER_TABLES = read_asset("filter_tables.txt", base="prompts")
filter_fields = read_asset("filter_fields.txt", base="prompts")


@frappe.whitelist(allow_guest=False)
def download_model():
    frappe.enqueue(
        "changai.changai.api.v2.text2sql_pipeline_v2.download_model_from_ui",  # dot-path to the function
        queue="long",           # use "long" queue for heavy tasks
        timeout=3600,           # 1 hour timeout (in seconds)
        is_async=True,          # run in background (default True)
        job_name="download_model",  # optional: helps track/deduplicate jobs
    )
    return {
        "ok":True,"message":"Model Downloading.."
    }

def _get_model_path():
    site_path = frappe.get_site_path("private", "files", "changai_model")
    return site_path


@frappe.whitelist(allow_guest=False)
def download_model_from_ui():
    global _EMBEDDER_INSTANCE

    model_path = _get_model_path()

    try:
        if os.path.exists(model_path):
            shutil.rmtree(model_path)

        os.makedirs(model_path, exist_ok=True)

        snapshot_download(
            repo_id="hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned",
            local_dir=model_path
        )

        _EMBEDDER_INSTANCE = None
        return {"status": "success", "message": "Embedding model downloaded successfully."}

    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "Embedding Model Download Failed")
        frappe.throw(f"Model download failed: {str(e)}")


def get_embedding_engine():
    global _EMBEDDER_INSTANCE
    
    model_path = _get_model_path()  # check path first, always
    
    if not os.path.exists(model_path):
        _EMBEDDER_INSTANCE = None  # reset if model missing
        frappe.throw(
            _(
                "Go to <b>ChangAI Settings</b> and click <b>'Download Embedding Model'</b>.<br><br>"
                "Watch this documentation tutorial for more detail: "
                "<a href='{0}' target='_blank'>Click here to watch</a>"
            ).format("https://your-docs-url-here.com"),
            title=_("Embedding Model Required")
        )
    
    if _EMBEDDER_INSTANCE is None:
        _EMBEDDER_INSTANCE = HuggingFaceEmbeddings(
            model_name=model_path,
            model_kwargs={"device": "cpu"}
        )
    
    return _EMBEDDER_INSTANCE


def get_settings() -> Dict[str, Any]:
    settings = frappe.get_single(CHANGAI_SETTINGS)
    langsmith_tracing = "true" if settings.langsmith_tracing else "false"
    config = {
        "LANGSMITH_TRACING": langsmith_tracing,
        "LANGSMITH_ENDPOINT": settings.langsmith_endpoint,
        "LANGSMITH_API_KEY": settings.langsmith_api_key,
        "LANGSMITH_PROJECT": settings.langsmith_project,
        "RETAIN_MEM": settings.retain_memory,
        "LLM_VERSION_ID": settings.llm_version_id,
        "EMBED_VERSION_ID": settings.embedder_version_id,
        "API_TOKEN": settings.api_token,
        "REMOTE": bool(settings.remote),
        "deploy_url": settings.deploy_url,
        "entity_retriever": settings.entity_retriever,
        "support_api_url": settings.support_url,
        "get_ticket_details_url": settings.get_ticket_details_url,
        "llm": settings.llm,
        "location": settings.gemini_location,
        "retriever_structure": settings.retriever_structure,
        "gemini_project_id": settings.gemini_project_id,
        "gemini_json_content": settings.gemini_json_content
    }
    return config

class ChangAIConfig:
    @classmethod
    def get(cls):
        if not hasattr(frappe.local, "_changai_config"):
            frappe.clear_document_cache(CHANGAI_SETTINGS)
            frappe.local._changai_config = get_settings()
        return frappe.local._changai_config


@frappe.whitelist(allow_guest=True)  # nosemgrep: security.guest-whitelisted-method - intentional, validates credentials via OAuth client lookup and Frappe password grant before returning a token
def generate_token_secure(api_key: str, api_secret: str, app_key: str):
    try:
        try:
            app_key = base64.b64decode(app_key).decode("utf-8")
        except Exception:
            return Response(
                json.dumps(
                    {"message": "Security Parameters are not valid", "user_count": 0}
                ),
                status=401,
                mimetype=APPLICATION_JSON,
            )

        doc = frappe.db.get_value(
            "OAuth Client",
            {"app_name": app_key},
            ["name", "client_id", "client_secret", "user"],
            as_dict=True
        )
        if not doc:
            frappe.local.response["http_status_code"] = 401
            return {"ok": False, "error": "OAuth client not found / invalid app_key"}
        if doc.client_id is None:
            return Response(
                json.dumps(
                    {"message": "Security Parameters are not valid", "user_count": 0}
                ),
                status=401,
                mimetype=APPLICATION_JSON,
            )
        url = (
            frappe.local.conf.host_name
            + "/api/method/frappe.integrations.oauth2.get_token"
        )
        payload = {
            "username": api_key,
            "password": api_secret,
            "grant_type": "password",
            "client_id": doc.client_id,
            "client_secret": doc.client_secret,
        }
        response = requests.request("POST", url, data=payload)
        if response.status_code == STATUS_200:
            result_data = json.loads(response.text)
            return Response(
                json.dumps({"data": result_data}),
                status=STATUS_200,
                mimetype=APPLICATION_JSON,
            )
        else:
            frappe.local.response.http_status_code = 401
            return json.loads(response.text)
    except Exception as e:
        return Response(
            json.dumps({"message":str(e), "user_count": 0}),
            status=500,
            mimetype=APPLICATION_JSON,
        )


# Api for  checking user name  using token
@frappe.whitelist(allow_guest=False)
def whoami() -> Dict[str, Any]:
    """This function returns the current session user"""
    try:
        response_content = {
            "user": frappe.session.user,
        }
        frappe.local.response = {
            "data": response_content,
            "http_status_code": STATUS_200,
        }
        return Response(
            json.dumps({"data": response_content}),
            status=STATUS_200,
            mimetype=APPLICATION_JSON,
        )
    except ValueError as ve:
        frappe.throw(ve)


def extract_tables_from_sql(sql: str) -> List[str]:
    """Extract all table names from a SQL query."""
    if not sql:
        return []
    matches = re.findall(r'`(tab[^`]+)`', sql, re.IGNORECASE)
    seen = set()
    tables = []
    for t in matches:
        if t not in seen:
            seen.add(t)
            tables.append(t)
    return tables


def call_model(prompt: str, task: str = "llm") -> Any:
    config = ChangAIConfig.get()
    if config["REMOTE"] and config["llm"] == "QWEN3":
        return remote_llm_request_deploy_test(prompt=prompt, task=task)
    else:
        if config["llm"] == "Gemini":
            return call_gemini(prompt)


def _post_json(url: str, headers: Dict[str, str], payload: Dict[str, Any], timeout: int = 120):
    try:
        res = requests.post(url, headers=headers, json=payload, timeout=timeout)
        ct = (res.headers.get("Content-Type") or "").lower()
        try:
            body = res.json() if APPLICATION_JSON in ct else {"raw_text": res.text}
        except Exception:
            body = {"raw_text": res.text}
        if res.status_code not in (STATUS_200, 201, 202):
            return {"ok": False, "status_code": res.status_code, "body": body}
        return {"ok": True, "status_code": res.status_code, "body": body}
    except requests.exceptions.Timeout:
        return {"ok": False, "status_code": None, "body": {"error": "timeout"}}
    except Exception as e:
        return {"ok": False, "status_code": None, "body": {"error": str(e)}}


def local_llm_request(prompt: str) -> str:
    config = ChangAIConfig.get()
    url = f"{config['URL'].rstrip('/')}/api/generate"
    payload = {"model": config["LOCAL_LLM"], "prompt": prompt, "stream": False}
    resp = _post_json(url, headers={}, payload=payload, timeout=120)
    if not resp.get("ok"):
        return f"Error: local LLM call failed ({resp.get('status_code')}): {resp.get('body')}"
    text = (resp.get("body") or {}).get("response")
    return (text or "").strip() or "Error: Empty response from local LLM."


def _get_gemini_vertex_config(config):
    project_id = (config.get("gemini_project_id") or "").strip()
    credentials_json = (config.get("gemini_json_content") or "").strip()
    location = (config.get("gemini_location") or "").strip()
    return project_id, credentials_json, location


def _throw_missing_vertex_field(project_id: str, location: str, credentials_json: str) -> None:
    if not project_id:
        frappe.throw(
            _("Gemini Project ID is missing.<br><br>Please go to <b>ChangAI Settings</b> and enter your <b>Gemini Project ID</b>."),
            title=_("Missing Gemini Project ID"),
        )
    if not location:
        frappe.throw(
            _("Gemini Location is missing.<br><br>Please go to <b>ChangAI Settings</b> and enter your <b>Gemini Location</b>."),
            title=_("Missing Gemini Location"),
        )
    if not credentials_json:
        frappe.throw(
            _("Service Account Credentials are missing.<br><br>Please go to <b>ChangAI Settings</b> and enter your <b>Service Account Credential</b>."),
            title=_("Missing Service Account Credentials"),
        )


def _build_vertex_gemini_client(project_id: str, location: str, credentials_json: str):
    _throw_missing_vertex_field(project_id, location, credentials_json)

    service_account_info = json.loads(credentials_json)
    creds = service_account.Credentials.from_service_account_info(
        service_account_info,
        scopes=["https://www.googleapis.com/auth/cloud-platform"],
    )
    return genai.Client(
        vertexai=True,
        project=project_id,
        location=location,
        credentials=creds,
    )


def _get_api_key_client(config):
    try:
        api_key = config.get("gemini_api_key")
    except Exception:
        api_key = None

    if not api_key:
        frappe.throw(
            _(
                "Gemini API key is not configured.<br><br>"
                "You have two options to authenticate with Gemini:<br><br>"
                "<b>Option 1 (Free / API Key):</b><br>"
                "Go to <b>ChangAI Settings</b> and enter your <b>Gemini API Key</b>.<br>"
                "Get your free API key from "
                "<a href='https://aistudio.google.com/app/apikey' target='_blank'>Google AI Studio</a>.<br><br>"
                "<b>Option 2 (Vertex AI / Service Account):</b><br>"
                "Fill in <b>Gemini Project ID</b>, <b>Gemini Location</b>, "
                "and <b>Service Account Credentials</b> in <b>ChangAI Settings</b>."
            ),
            title=_("Gemini Authentication Not Configured"),
        )

    return genai.Client(api_key=api_key)


def _build_gemini_client(config):
    project_id, credentials_json, location = _get_gemini_vertex_config(config)

    if project_id or credentials_json or location:
        return _build_vertex_gemini_client(project_id, location, credentials_json)

    return _get_api_key_client(config)


def _build_gemini_contents(prompt: str):
    return [
        {
            "role": "user",
            "parts": [{"text": str(prompt)}],
        }
    ]


def _clean_gemini_response_text(text: str) -> str:
    text = (text or "").strip()
    if text.startswith("```"):
        text = text.replace("```json", "").replace("```", "").strip()
    return text


def _handle_gemini_api_exception(e: Exception) -> None:
    if isinstance(e, google_exceptions.ResourceExhausted):
        frappe.throw(
            _("Gemini API quota exceeded.<br><br>Please wait and try again or upgrade your plan."),
            title=_("Gemini Quota Exceeded"),
        )
    if isinstance(e, google_exceptions.Unauthenticated):
        frappe.throw(
            _("Gemini API key is invalid.<br><br>Please go to <b>ChangAI Settings</b> and enter a valid <b>Gemini API Key</b>."),
            title=_("Invalid Gemini API Key"),
        )
    if isinstance(e, google_exceptions.PermissionDenied):
        frappe.throw(
            _("Gemini API permission denied.<br><br>Please check your API key permissions."),
            title=_("Gemini Permission Denied"),
        )
    if isinstance(e, google_exceptions.InvalidArgument):
        frappe.throw(
            _("Invalid request to Gemini API: {0}").format(str(e)),
            title=_("Gemini Invalid Request"),
        )

    frappe.log_error(frappe.get_traceback(), "Gemini API Unexpected Error")
    frappe.throw(
        _("Gemini API error: {0}").format(str(e)),
        title=_("Gemini API Error"),
    )


def call_gemini(prompt: str) -> Union[str, Dict[str, Any]]:
    try:
        frappe.clear_document_cache(CHANGAI_SETTINGS)
        config = frappe.get_single(CHANGAI_SETTINGS)

        client = _build_gemini_client(config)

        gemini_config = types.GenerateContentConfig(
            system_instruction="You are an ERPNext assistant. Follow the task instructions exactly."
        )
        response = client.models.generate_content(
            model=MODEL_ID,
            config=gemini_config,
            contents=_build_gemini_contents(prompt),
        )
        return _clean_gemini_response_text(response.text)

    except frappe.exceptions.ValidationError:
        raise
    except Exception as e:
        _handle_gemini_api_exception(e)


def _build_input_payload(task: str, prompt: str, question: Optional[str],
                          db_result_json: Optional[str], user_message: Optional[str]) -> Dict[str, Any]:
    if task == "format_db":
        return {"task": "format_db", "question": question or "", "db_result_json": db_result_json or "{}"}
    if task == "helpdesk_task":
        return {"task": "helpdesk_task", "user_message": user_message or prompt or ""}
    return {"task": "llm", "user_input": prompt}


def _poll_until_done(get_url: str, headers: Dict) -> Any:
    terminal = {"succeeded", "failed", "canceled"}
    deadline = time.time() + 300
    last = None
    while time.time() < deadline:
        try:
            poll = requests.get(get_url, headers=headers, timeout=120).json()
        except Exception as e:
            poll = {"raw_text": str(e)}
        last = poll
        status = poll.get("status")
        if status in terminal:
            if status == "succeeded":
                return poll.get("output")
            return {"Error": f"Model ended with status {status}", "details": poll}
        time.sleep(2)
    return {"Error": "Polling timed out", "details": last}


def remote_llm_request_deploy_test(
    prompt: str = "",
    task: str = "llm",
    question: Optional[str] = None,
    db_result_json: Optional[str] = None,
    user_message: Optional[str] = None,
) -> Any:
    config = ChangAIConfig.get()
    headers = {
        "Content-Type": APPLICATION_JSON,
        "Prefer": "wait",
        "Authorization": f"Bearer {config['API_TOKEN']}",
    }
    input_payload = _build_input_payload(task, prompt, question, db_result_json, user_message)
    create = _post_json(config["deploy_url"], headers=headers, payload={"input": input_payload}, timeout=120)

    if not create.get("ok"):
        return {"Error": "Create prediction failed", "status_code": create.get("status_code"), "details": create.get("body")}

    get_url = ((create.get("body") or {}).get("urls") or {}).get("get")
    if not get_url:
        return {"Error": "Missing get URL from deploy response", "details": create.get("body")}

    return _poll_until_done(get_url, headers)


def remote_embedder_request(formatted_q: str) -> Union[List[Any], str]:
    config = ChangAIConfig.get()
    payload = {"version": config["EMBED_VERSION_ID"], "input": {"user_input": formatted_q}}
    headers = {
        "Content-Type": APPLICATION_JSON,
        "Prefer": "wait",
        "Authorization": f"Bearer {config['API_TOKEN']}",
    }
    response = _post_json(config["URL"], headers, payload)
    try:
        if response:
            return response["body"]["output"]
    except Exception as e:
        return "Error: " + str(e)


def _safe_strip(v):
    if v is None:
        return ""
    if isinstance(v, (dict, list)):
        return json.dumps(v, ensure_ascii=False, default=str)
    return str(v).strip()


# Shared State
class SQLState(TypedDict, total=False):
    session_id: str
    question: str
    contains_values: bool
    formatted_q: str
    hits: List[Any]
    context: str
    sql: str
    orm: str
    validation: Dict[str, Any]
    error: Optional[str]
    tries: int
    query_type: str
    sql_prompt: str
    formatting_prompt: str
    non_erp_res: str
    entity_cards: List[str]
    entity_raw: Any
    retrieval_mode: str
    top_tables: List[str]
    selected_tables: List[str]
    top_fields: Dict[str, Any]
    selected_fields: str


def fill_sql_prompt(question: str, context: str) -> str:
    return SQL_PROMPT.format(question=question, context=context)


def guardrail_router(state: SQLState) -> SQLState:
    raw_q = state.get("formatted_q") or state.get("question") or ""
    q = str(raw_q).lower().strip()

    safe_keywords: List[str] = []
    for kw in BUSINESS_KEYWORDS:
        try:
            safe_keywords.append(str(kw).lower())
        except Exception:
            continue

    is_erp = any(kw in q for kw in safe_keywords)
    return {**state, "query_type": "ERP" if is_erp else "NON_ERP"}


def send_non_erp_request(state: SQLState) -> SQLState:
    qstn = state.get("formatted_q") or state.get("question")
    if not qstn:
        return {**state, "non_erp_res": "", "error": "No question provided"}
    prompt = NON_ERP_PROMPT.format(question=qstn)
    try:
        response = call_model(prompt, "llm")
        if not response or isinstance(response, dict):
            return {**state, "prompt": prompt, "non_erp_res": "", "error": str(response)}
        return {**state, "prompt": prompt, "non_erp_res": response, "error": None}
    except frappe.exceptions.ValidationError:
        raise
    except Exception as e:
        return {**state, "non_erp_res": "", "error": f"NON-ERP call failed: {e}"}


def _parse_rewrite_response(raw: Any, user_qstn: str) -> Tuple[str, bool]:
    standalone = ""
    contains_values = False
    obj = None

    if isinstance(raw, dict):
        obj = raw
    elif isinstance(raw, str):
        try:
            obj = json.loads(raw.strip())
        except Exception:
            standalone = raw.strip()
    else:
        standalone = str(raw).strip()

    if isinstance(obj, dict):
        standalone = (obj.get("standalone_question") or "").strip() or standalone
        contains_values = bool(obj.get("contains_values"))
    elif isinstance(obj, list) and not standalone:
        standalone = json.dumps(obj)

    return standalone or user_qstn.strip(), contains_values


@traceable(name="rewrite_question", run_type="tool")
def rewrite_question(state: SQLState) -> SQLState:
    user_qstn = state.get("question") or ""
    session_id = state.get("session_id")
    prompt = inject_prompt(user_qstn, session_id)
    try:
        raw = call_model(prompt, "llm")
        standalone, contains_values = _parse_rewrite_response(raw, user_qstn)
        return {
            **state,
            "formatted_q": standalone,
            "contains_values": contains_values,
            "formatting_prompt": prompt,
            "error": None,
        }
    except frappe.exceptions.ValidationError:
        raise
    except Exception as e:
        return {
            **state,
            "error": str(e),
            "formatted_q": "",
            "contains_values": False,
            "formatting_prompt": prompt,
        }

def get_table_vs():
    global _VS_TABLE

    if _VS_TABLE is None:
        emb = get_embedding_engine()
        if emb is None:
            frappe.throw(_(EMBEDDING_ENGINE_NONE_MESSG))

        # get app root dynamically
        app_path = frappe.get_app_path("changai")

        table_vs_path = os.path.join(
            app_path,
            "changai",
            "api",
            "v2",
            "fvs_stores",
            "erpnext",
            "table_fvs"
        )

        if not os.path.exists(table_vs_path):
            frappe.throw(_("FAISS table store not found at {0}").format(table_vs_path))

        _VS_TABLE = FAISS.load_local(
            table_vs_path,
            emb,
            allow_dangerous_deserialization=True
        )

    return _VS_TABLE


def get_table_vs_test():
    global _VS_TABLE

    if _VS_TABLE is None:
        emb = get_embedding_engine()
        if emb is None:
            frappe.throw(_(EMBEDDING_ENGINE_NONE_MESSG))

        table_vs_path = frappe.get_site_path(
            "private", "changai", "fvs_stores", "erpnext", "table_fvs"
        )

        if not os.path.exists(table_vs_path):
            frappe.throw(_("FAISS table store not found at {0}").format(table_vs_path))

        _VS_TABLE = FAISS.load_local(
            table_vs_path,
            emb,
            allow_dangerous_deserialization=True
        )

    return _VS_TABLE


def call_fvs_table_search(q: str) -> List[str]:
    hits = get_table_vs().similarity_search(q, k=15)
    out, seen = [], set()
    for h in hits:
        t = h.metadata.get("table")
        if t and t not in seen:
            seen.add(t)
            out.append(t)
    return out


def _parse_json_list(raw: str) -> List[Any]:
    try:
        data = json.loads(raw)
        return data if isinstance(data, list) else []
    except Exception:
        return []


def call_retrieve_multi_line(user_question: str) -> Dict[str, Any]:
    try:
        top_tables = call_fvs_table_search(user_question)
        table_prompt = FILTER_TABLES.replace("{user_question}", user_question)
        table_prompt = table_prompt.replace("{table_list}", json.dumps(top_tables, ensure_ascii=False))
        selected_raw = call_gemini(table_prompt)
        selected_tables = _parse_json_list(selected_raw)
        top_set = set(top_tables)
        selected_tables = [t for t in selected_tables if t in top_set]
        if not selected_tables:
            return {"selected_fields": {}, "selected_tables": [], "top_tables": top_tables}
        fields_candidates = {}
        for table in selected_tables:
            fields_candidates[table] = call_fvs_field_search(
                user_question,
                table_name=table,
                selected_tables=selected_tables,
                k=40
            )
        field_prompt = filter_fields.replace("{user_question}", user_question)
        field_prompt = field_prompt.replace("{fields_tables}", json.dumps(fields_candidates, ensure_ascii=False))
        selected_raw = call_gemini(field_prompt)
        try:
            selected_map = json.loads(selected_raw) if isinstance(selected_raw, str) else {}
        except Exception:
            selected_map = {}
        return {
            "selected_fields": json.dumps(selected_map, ensure_ascii=False),
            "selected_tables": selected_tables,
            "top_tables": top_tables,
            "top_fields": fields_candidates,
        }
    except frappe.exceptions.ValidationError:
        raise
    except Exception as e:
        return {"selected_fields": {}, "selected_tables": [], "top_tables": [], "error": str(e)}


def get_full_fields_vs():
    global _FULL_FIELDS_VS

    if _FULL_FIELDS_VS is None:
        emb = get_embedding_engine()
        if emb is None:
            frappe.throw(_(EMBEDDING_ENGINE_NONE_MESSG))
        app_root = frappe.get_app_path("changai")
        full_fields_vs_path = os.path.join(
            app_root,
            "changai", "api", "v2", "fvs_stores", "erpnext", "schema_fvs"
        )

        if not os.path.isdir(full_fields_vs_path):
            frappe.throw(_("Vector store path not found: {0}").format(full_fields_vs_path))

        _FULL_FIELDS_VS = FAISS.load_local(
            full_fields_vs_path,
            emb,
            allow_dangerous_deserialization=True
        )

    return _FULL_FIELDS_VS


def get_full_fields_vs_test():
    global _FULL_FIELDS_VS

    if _FULL_FIELDS_VS is None:
        emb = get_embedding_engine()
        if emb is None:
            frappe.throw(_(EMBEDDING_ENGINE_NONE_MESSG))

        full_fields_vs_path = frappe.get_site_path(
            "private", "changai", "fvs_stores", "erpnext", "schema_fvs"
        )

        if not os.path.isdir(full_fields_vs_path):
            frappe.throw(_("Vector store path not found: {0}").format(full_fields_vs_path))

        _FULL_FIELDS_VS = FAISS.load_local(
            full_fields_vs_path,
            emb,
            allow_dangerous_deserialization=True
        )

    return _FULL_FIELDS_VS


def get_sub_vs(selected_tables: List[str]) -> Optional[FAISS]:
    """Build sub-index ONCE per unique selected_tables set (cached)."""
    key = tuple(sorted([t for t in selected_tables if isinstance(t, str)]))
    if not key:
        return None

    global _SUB_VS_CACHE
    if key in _SUB_VS_CACHE:
        return _SUB_VS_CACHE[key]

    full_vs = get_full_fields_vs()
    emb = get_embedding_engine()

    selected_set = set(key)
    doc_dict = getattr(full_vs.docstore, "_dict", {})
    docs = []
    for d in doc_dict.values():
        meta = getattr(d, "metadata", {}) or {}
        if meta.get("table") in selected_set:
            docs.append(d)
    sub = FAISS.from_documents(docs, emb)
    _SUB_VS_CACHE[key] = sub
    return sub


def call_fvs_field_search(
    user_question: str,
    table_name: str,
    selected_tables: List[str],
    k: int = 40,
) -> List[Dict[str, Any]]:
    if not user_question or not table_name:
        return []
    sub_vs = get_sub_vs(selected_tables)
    if sub_vs is None:
        return []
    hits = sub_vs.similarity_search(user_question, k=min(60, max(40, k)))
    results: List[Dict[str, Any]] = []
    seen = set()
    for d in hits:
        meta = getattr(d, "metadata", {}) or {}
        tbl = meta.get("table")
        fld = meta.get("field")
        if tbl != table_name:
            continue
        key = (tbl, fld)
        if key in seen:
            continue
        seen.add(key)
        row = {
            "field": fld,
        }
        if meta.get("join_hint"):
            row["join_hint"] = meta.get("join_hint")
        if meta.get("options"):
            row["options"] = meta.get("options")

        results.append(row)
        if len(results) >= k:
            break
    return results


# Node 1: Retrive with Fiass Vector Store.
@traceable(name="schema_retriever", run_type="tool")
def schema_retriever(state: SQLState) -> SQLState:
    config = ChangAIConfig.get()
    try:
        if config["REMOTE"]:
            hits = remote_embedder_request(state.get("formatted_q", "") or state.get("question", ""))
            return {**state, "hits": hits}
        else:
            out = call_retrieve_multi_line(state.get("formatted_q") or state.get("question") or "")
            return {
                **state,
                "retrieval_mode": "multi",
                "top_tables": out.get("top_tables", []),
                "top_fields": out.get("top_fields", {}),
                "selected_fields": out.get("selected_fields", ""),
                "selected_tables": out.get("selected_tables", []),
            }
    except frappe.exceptions.ValidationError:
        raise
    except Exception as e:
        return {**state, "error": f"Schema retrieval failed: {e}"}


# # Node 2: Build schema context from hits - for SQL Prompt
@traceable(name="hits_to_prompt_context", run_type="tool")
def hits_to_prompt_context(state:SQLState) -> SQLState:
    ctx=hits_to_schema_context(state["hits"],title="SCHEMA CONTEXT",max_fields_per_table=25)
    entity_context=state.get("entity_cards", [])
    full_context = ctx

    if entity_context:
        full_context += "\n\nENTITY_CARDS:\n"
        full_context += "\n".join(entity_context)

    return {
        **state,
        "context": full_context
    }


# # Node 3:Generate the SQL Prompt and call LLM(Ollama Http)
@traceable(name="generate_sql", run_type="tool")
def generate_sql(state:SQLState) -> SQLState:
    selected_fields = state.get("selected_fields") or ""
    entity_cards = state.get("entity_cards") or []
    entity_block = ""
    config = ChangAIConfig.get()
    formatted_q = state.get("formatted_q")
    if not formatted_q:
        return {**state, "sql": "", "orm": "", "error": "No question to generate SQL for", "sql_prompt": ""}
    if entity_cards:
        entity_block = "\n\nENTITY_CARDS:\n" + "\n".join(str(c) for c in entity_cards)
    if config["retriever_structure"]=="multi line":
        context = (selected_fields or "") + (entity_block or "")
        prompt = fill_sql_prompt(formatted_q, context)
    else:
        prompt=fill_sql_prompt(formatted_q,state["context"])
    try:
        response=call_model(prompt)
        if not response:
            return {**state, "error": "Empty response from LLM", "sql_prompt": prompt}
        if isinstance(response, str):
            response = json.loads(response)
        sql = response.get("sql", "")
        orm = response.get("orm", "")
        return {**state,"sql_prompt":prompt,"sql":sql,"orm":orm,"error":None}
    except frappe.exceptions.ValidationError:
        raise
    except Exception as e:
        return {**state,"error": f"LLM call failed: {e}","sql_prompt":prompt}


# # Node 4:Validate the SQL Generate with meta schema mapping using SQLGlot
@traceable(name="validate_sql", run_type="tool")
def validate_sql(state: SQLState) -> SQLState:
    sql = clean_sql(state.get("sql") or "")
    if not sql:
        return {
            **state,
            "validation": {
                "ok": False,
                "unknown_tables": [],
                "unknown_columns": [],
                "ambiguous_columns": [],
                "details": {
                    "parse_error": sql or "Empty SQL from LLM"
                },
            },
        }

    val = validate_sql_against_mapping(sql, mapping_data, dialect="mysql")
    return {**state, "validation": val}


@frappe.whitelist(allow_guest=False)
def remote_entity_embedder(q: str) -> Union[list, str]:
    config = ChangAIConfig.get()
    payload = {"version": config["entity_retriever"], "input": {"query": q}}
    headers = {
        "Content-Type": APPLICATION_JSON,
        "Prefer": "wait",
        "Authorization": f"Bearer {config['API_TOKEN']}",
    }
    response = _post_json(config["URL"], headers, payload)
    return response


# @frappe.whitelist(allow_guest=False)
# def get_master_vs():
#     global _VS_MASTER
#     if _VS_MASTER is None:
#         emb = get_embedding_engine()
#         if emb is None:
#             frappe.throw(_(EMBEDDING_ENGINE_NONE_MESSG))
#         app_path = frappe.get_app_path("changai")
#         master_vs_path = os.path.join(app_path, "changai", "api", "v2", "fvs_stores", "erpnext", "masterdata_fvs")
#         if not os.path.exists(master_vs_path):
#             frappe.throw(_("FAISS MASTER store not found at {0}").format(master_vs_path))
#         _VS_MASTER = FAISS.load_local(master_vs_path, emb, allow_dangerous_deserialization=True)
#     return _VS_MASTER


@frappe.whitelist(allow_guest=False)
def get_master_vs():
    global _VS_MASTER

    if _VS_MASTER is None:
        emb = get_embedding_engine()
        if emb is None:
            frappe.throw(_(EMBEDDING_ENGINE_NONE_MESSG))

        master_vs_path = frappe.get_site_path(
            "private", "changai", "fvs_stores", "erpnext", "masterdata_fvs"
        )

        if not os.path.exists(master_vs_path):
            frappe.throw(_("FAISS MASTER store not found at {0}.Please click on Update Master Data button in Training tab in ChangAI Settings").format(master_vs_path))

        _VS_MASTER = FAISS.load_local(
            master_vs_path,
            emb,
            allow_dangerous_deserialization=True
        )

    return _VS_MASTER

@frappe.whitelist()
def local_entity_embedder(q: str) -> List[Dict[str, Any]]:
    hits = get_master_vs().similarity_search(q, k=4)
    out, seen = [], set()
    for h in hits:
        entity_type = h.metadata.get("entity_type")
        entity_id = h.metadata.get("entity_id")
        key = (entity_type, entity_id)
        if entity_type and key not in seen:
            seen.add(key)
            out.append({"entity_type": entity_type, "entity_id": entity_id})
    return out

@frappe.whitelist(allow_guest=False)
def call_entity_retriever(qstn: str) -> Dict[str, Any]:
    config = ChangAIConfig.get()
    if config["REMOTE"] and config["llm"] == "QWEN3":

        response = remote_entity_embedder(qstn)

        if not response.get("ok"):
            frappe.log_error(f"Entity retriever failed: {response.get('body')}", "ChangAI Entity Retriever")
            return {"raw": response, "cards": []}

        body = response.get("body") or {}
        output = body.get("output") or {}
        results = output.get("results") or []

        cards = [r.get("entity_label") for r in results if r.get("entity_label")]

        return {"raw": body, "cards": cards}
    else:
        results = local_entity_embedder(qstn)
        cards = [f"{r['entity_type']}:{r['entity_id']}" for r in results if r.get("entity_type")]
        return {"raw": results, "cards": cards}


# # Node 5:Repair Loop :Simple prompt for one more try.
@traceable(name="repair_sqlquery", run_type="tool")
def repair_sqlquery(state: SQLState) -> SQLState:
    hints: List[str] = []
    tries = int(state.get("tries") or 0) + 1
    val = state.get("validation", {})
    unknown_tables = val.get("unknown_tables", [])
    unknown_cols = val.get("unknown_columns", [])
    ambiguous = val.get("ambiguous_columns", [])

    if unknown_tables:
        hints.append(f"Unknown tables:{unknown_tables}.Use only tables in context")
    if unknown_cols:
        hints.append(f"Unknown Columns:{unknown_cols}.Use only fields listed for each tables from the context")
    if ambiguous:
        hints.append(f"Ambiguous columns(qualify them):{ambiguous}")
    sql_prompt = state.get("sql_prompt")
    if not sql_prompt:
        return {**state, "tries": tries, "error": "No SQL prompt to repair from"}
    patched_prompt = sql_prompt + "\n\n#VALIDATION HINTS\n" + "\n".join(f"-{h}" for h in hints)

    try:
        response = call_model(patched_prompt,"llm")
        if isinstance(response, str):
            try:
                response = json.loads(response)
            except json.JSONDecodeError:
                return {**state, "tries": tries, "error": f"{response[:200]}"}

        if not response or not isinstance(response, dict):
            return {**state, "tries": tries, "error": "Repair: empty or invalid response from LLM"}

        sql = response.get("sql", "")
        return {**state, "sql": sql, "tries": tries, "error": None}
    except frappe.exceptions.ValidationError:
        raise
    except Exception as e:
        return {**state, "tries": tries, "error": f"Repair call failed {e}"}


@traceable(name="detect_specific_entities", run_type="tool")
def detect_specific_entities(state: SQLState) -> SQLState:
    if not state.get("contains_values"):
        return {**state, "entity_cards": [], "entity_raw": None}

    q = (state.get("formatted_q") or "").strip()
    if not q:
        return {**state, "entity_cards": [], "entity_raw": None}

    try:
        out = call_entity_retriever(q)
        return {
            **state,
            "entity_cards": out.get("cards") or [],
            "entity_raw": out.get("raw"),
        }
    except Exception as e:
        frappe.log_error(f"Entity retriever failed: {e}", "ChangAI Entity Gate")
        return {**state, "entity_cards": [], "entity_raw": {"error": str(e)}}


def route_after_entities(state: SQLState) -> str:
    config = ChangAIConfig.get()
    return "DIRECT" if config.get("retriever_structure") == "multi line" else "CONTEXT"


def route_guardrail(state: SQLState) -> str:
    return "ERP" if state.get("query_type") == "ERP" else "NON_ERP"

def clean_sql(s: Any) -> str:
    if isinstance(s, dict):
        s = s.get("output") or s.get("sql") or s.get("text") or json.dumps(s, ensure_ascii=False, default=str)
    elif isinstance(s, list):
        s = "\n".join(str(x) for x in s)
    else:
        s = "" if s is None else str(s)

    s = s.strip()

    if s.startswith("```"):
        first_newline = s.find("\n")
        if first_newline != -1:
            header = s[:first_newline].strip().lower()
            if header in {"```", "```sql"}:
                s = s[first_newline + 1 :].lstrip()

    stripped = s.rstrip()
    if stripped.endswith("```"):
        stripped = stripped[:-3].rstrip()
    s = stripped

    if s[:3].lower() == "sql" and (len(s) == 3 or s[3].isspace()):
        s = s[3:].lstrip()

    return s.strip()


# # Router to decide next stage:
@traceable(name="router", run_type="tool")
def router(state:SQLState) -> str:
    if state.get("error"):
        return "end"
    val=state.get("validation",{})
    if val.get("ok"):
        return "end"
    tries=int(state.get("tries") or 0)
    if tries < RETRY_LIMIT:
        return "repair"
    return "end"


def _parse_sql_ast(sql_text: str, dialect: str):
    try:
        return sqlglot.parse_one(sql_text, read=dialect), None
    except Exception as e:
        return None, str(e)


def _extract_tables(ast) -> Tuple[List[str], Dict[str, str]]:
    base_tables = []
    alias_to_table = {}
    for t in ast.find_all(exp.Table):
        if not t.name:
            continue
        base_tables.append(t.name)
        a = t.args.get("alias")
        if a and a.name:
            alias_to_table[a.name] = t.name
    return list(dict.fromkeys(base_tables)), alias_to_table


def _extract_derived_aliases(ast) -> Set[str]:
    derived = set()
    for sq in ast.find_all(exp.Subquery):
        a = sq.args.get("alias")
        if a and a.name:
            derived.add(a.name)
    for cte in ast.find_all(exp.CTE):
        a = cte.args.get("alias")
        if a and a.name:
            derived.add(a.name)
    return derived


def _extract_select_aliases(ast) -> Set[str]:
    aliases = set()
    for sel in ast.find_all(exp.Select):
        for proj in sel.expressions:
            if isinstance(proj, exp.Alias) and proj.alias:
                aliases.add(proj.alias)
    return aliases


def _validate_qualified_col(col_name: str, qual: str, mapping: Dict,
                              alias_to_table: Dict, derived_aliases: Set) -> Optional[Tuple]:
    if col_name == "*" or qual in derived_aliases:
        return None
    if qual in mapping:
        if col_name not in mapping[qual]:
            return (f"{qual}.{col_name}", qual)
        return None
    if qual in alias_to_table:
        real = alias_to_table[qual]
        if real in mapping and col_name not in mapping[real]:
            return (f"{qual}.{col_name}", real)
        return None
    return (f"{qual}.{col_name}", None)


def _validate_unqualified_col(col_name: str, base_tables_set: Set,
                               mapping: Dict, select_aliases: Set,
                               unknown_cols: List, ambiguous: Set):
    if col_name in select_aliases:
        return
    candidates = [t for t in base_tables_set if col_name in mapping.get(t, [])]
    if len(candidates) == 0:
        unknown_cols.append((col_name, None))
    elif len(candidates) > 1:
        ambiguous.add(col_name)


def _validate_columns(ast, mapping: Dict, alias_to_table: Dict,
                       derived_aliases: Set, select_aliases: Set,
                       base_tables_set: Set) -> Tuple[List, Set]:
    unknown_cols: List[Tuple[str, str]] = []
    ambiguous: Set[str] = set()
    for col in ast.find_all(exp.Column):
        if not col.name:
            continue
        if col.table:
            result = _validate_qualified_col(
                col.name, str(col.table), mapping, alias_to_table, derived_aliases
            )
            if result:
                unknown_cols.append(result)
        else:
            _validate_unqualified_col(
                col.name, base_tables_set, mapping, select_aliases, unknown_cols, ambiguous
            )
    return unknown_cols, ambiguous


def validate_sql_against_mapping(
    sql_text: str,
    mapping: Dict[str, List[str]],
    dialect: str = "mysql"
) -> Dict[str, Any]:
    result = {
        "ok": True,
        "unknown_tables": [],
        "unknown_columns": [],
        "ambiguous_columns": [],
        "details": {"from_tables": [], "alias_to_table": {}, "derived_aliases": [], "select_aliases": []},
    }

    ast, parse_error = _parse_sql_ast(sql_text, dialect)
    if parse_error:
        result["ok"] = False
        result["details"]["parse_error"] = parse_error
        return result

    base_tables, alias_to_table = _extract_tables(ast)
    derived_aliases = _extract_derived_aliases(ast)
    select_aliases = _extract_select_aliases(ast)

    result["details"]["from_tables"] = base_tables
    result["details"]["alias_to_table"] = alias_to_table
    result["details"]["derived_aliases"] = sorted(derived_aliases)
    result["details"]["select_aliases"] = sorted(select_aliases)

    unknown_tables = [t for t in base_tables if t not in mapping]
    if unknown_tables:
        result["ok"] = False
        result["unknown_tables"] = unknown_tables

    unknown_cols, ambiguous = _validate_columns(
        ast, mapping, alias_to_table, derived_aliases, select_aliases, set(base_tables)
    )
    if unknown_cols or ambiguous:
        result["ok"] = False
        result["unknown_columns"] = unknown_cols
        result["ambiguous_columns"] = sorted(ambiguous)

    return result



# Building the Workflow Graph
workflow=StateGraph(SQLState)
workflow.add_node("rewrite_question",rewrite_question)
workflow.add_node("guardrail_router",guardrail_router)
workflow.add_node("retrieve",schema_retriever)
workflow.add_node("detect_entities", detect_specific_entities)
workflow.add_node("build_context",hits_to_prompt_context)
workflow.add_node("generate_sql",generate_sql)
workflow.add_node("validate_sql",validate_sql)
workflow.add_node("repair_sql",repair_sqlquery)
workflow.add_node("send_non_erp_request",send_non_erp_request)
workflow.set_entry_point("rewrite_question")
workflow.add_edge("rewrite_question", "guardrail_router")
workflow.add_conditional_edges("guardrail_router",route_guardrail,{"ERP":"retrieve","NON_ERP":"send_non_erp_request"})
workflow.add_edge("send_non_erp_request", END)
workflow.add_edge("retrieve","detect_entities")
workflow.add_conditional_edges("detect_entities", route_after_entities, {"CONTEXT":"build_context","DIRECT":"generate_sql"})
workflow.add_edge("build_context", "generate_sql")
workflow.add_edge("generate_sql",END)
# workflow.add_conditional_edges("validate_sql",router,{"repair":"repair_sql","end":END})
# workflow.add_edge("repair_sql","validate_sql")
checkpointer=MemorySaver()
app=workflow.compile(checkpointer=checkpointer)

def _build_match_conditions(doctypes: List[str]) -> str:
    conditions = []
    for t in doctypes:
        doctype = t[3:] if t.startswith("tab") else t
        cond = build_match_conditions(doctype)
        if cond:
            conditions.append(cond)
    return " AND ".join(conditions) if conditions else ""


def _append_conditions(sql: str, combined: str) -> str:
    if "where" in sql.lower():
        return sql + f" AND {combined}"
    return sql + f" WHERE {combined}"


def execute_query(sql: str, doctypes: List[str]) -> Any:
    try:
        if not sql:
            return []
        if not str(sql).lower().strip().startswith("select"):
            frappe.throw(_("Only SELECT queries are allowed."))
        combined = _build_match_conditions(doctypes)
        if combined:
            sql = _append_conditions(sql, combined)
        return frappe.db.sql(sql, as_dict=True)
    except Exception as e:
        return {"error": f"SQL Execution Failed: {e}"}


@frappe.whitelist(allow_guest=False)
def support_bot(message: str) -> Dict[str, Any]:
    user_email = frappe.session.user
    full_name = frappe.get_value("User", frappe.session.user, "full_name")
    prompt = SUPPORT_PROMPT.format(user_message=message)
    raw = call_gemini(prompt)
    output = json.loads(raw)
    task_flag = (output.get("task_flag") or "UNKNOWN").strip()
    ticket_id = output.get("ticket_id")

    # normalize ticket_id
    if isinstance(ticket_id, str) and ticket_id.isdigit():
        ticket_id = int(ticket_id)
    if not isinstance(ticket_id, int):
        ticket_id = None

    # 2) route by task
    if task_flag == "CREATE_TICKET":
        try:
            created = create_helpdesk_ticket(message,full_name,user_email)
            return created

        except Exception as e:
            return {"Error":str(e)}
    if task_flag == "TICKET_DETAILS":
        if not ticket_id:
            return {
                "kind": "TICKET_DETAILS",
                "error": "Ticket id missing. Please say like: ticket 29"
            }
        try:
            details = get_user_tickets(ticket_id)
            return details
        except Exception as e:
            return {"Error":str(e)}

    if task_flag == "GET_USER_TICKETS":
        tickets = get_user_tickets()
        return tickets

    return {"kind": "UNKNOWN", "message": "Please describe the issue or provide a ticket number."}


def save_logs(
    user_question: Optional[str] = None,
    formatted_q: Optional[str] = None,
    context: Optional[str] = None,
    sql: Optional[str] = None,
    val: Any = None,
    result: Any = None,
    tries: Optional[int] = None,
    err: Any = None,
    formatted_result: Any = None,
) -> str:
    def to_json_if_needed(v: Any) -> Any:
        if isinstance(v, (dict, list)):
            return json.dumps(v, default=str, ensure_ascii=False)
        return v

    doc = frappe.new_doc("ChangAI Logs")
    doc.user_question = user_question
    doc.rewritten_question = formatted_q
    doc.schema_retrieved = to_json_if_needed(context)
    doc.sql_generated = to_json_if_needed(sql)
    doc.validation = to_json_if_needed(val)
    doc.tries = tries
    doc.error = to_json_if_needed(err)
    doc.result = to_json_if_needed(result)
    doc.formatted_result = to_json_if_needed(formatted_result)
    doc.insert(ignore_permissions=True)
    return doc.name


@frappe.whitelist(allow_guest=False)
def format_data_conversationally(user_data: Any) -> str:
    env = jinja2.Environment(
        autoescape=True,
        trim_blocks=True,
        lstrip_blocks=True,
        extensions=["jinja2.ext.do"],
    )
    template = env.from_string(CONVERSATION_TEMPLATE)
    return template.render(data=user_data)


@frappe.whitelist(allow_guest=False)
def format_data(qstn: str, sql_data: Any) -> Dict[str, str]:
    if isinstance(sql_data, (dict, list)):
        db_result_json = json.dumps(sql_data, ensure_ascii=False, default=str)
    else:
        db_result_json = str(sql_data) if sql_data is not None else "{}"

    prompt = f"""
INSTRUCTIONS:
- Convert raw database results into a short, friendly, human-readable answer.
- You may use BOTH: (1) the user question and (2) the DB result JSON to form the answer.
- Use ONLY values present in the JSON. NEVER invent numbers or fields.
- Keep the answer brief (1–6 lines).
- If the question asks for last/top/highest/total, interpret based strictly on the JSON rows.

QUESTION:
{qstn}

DATABASE_RESULT_JSON:
{db_result_json}

OUTPUT:
Write a clear final answer for the user based strictly on the JSON above.
"""
    output = call_model(prompt=prompt)
    answer = str(output)
    return {"answer": answer}

def _collect_docs(hits: Union[List[Any], Dict, str]) -> List[Tuple[str, Dict]]:
    def _to_txt_md(doc: Any) -> Tuple[str, Dict]:
        if isinstance(doc, dict):
            return doc.get("text", "") or "", doc.get("metadata", {}) or {}
        if isinstance(doc, str):
            return doc, {}
        return "", {}

    if isinstance(hits, dict) and "message" in hits and isinstance(hits["message"], list):
        hits = hits["message"]

    if isinstance(hits, (dict, str)) or hasattr(hits, "page_content"):
        return [_to_txt_md(hits)]
    return [_to_txt_md(d) for d in (hits or [])]


def _parse_tag(txt: str, tag: str) -> str:
    m = re.search(rf"\[{re.escape(tag)}\]\s*(.+?)(?:\s*\||\s*$)", txt or "")
    return m.group(1).strip() if m else ""


def _infer_type(txt: str) -> str:
    if not (txt or "").startswith("["):
        return ""
    order = [
        ("TABLE", "table"), ("FIELD", "field"), ("JOIN", "join"),
        ("METRIC", "metric"), ("ENUM", "enum"), ("PERIOD", "period"),
        ("CURRENCY", "currency"), ("ENTITY", "entity")
    ]
    for tg, tp in order:
        if txt.startswith(f"[{tg}]"):
            return tp
    return ""


class _SchemaAccumulator:
    def __init__(self):
        self.tables: List[str] = []
        self.fields_by_table: Dict[str, List[str]] = OrderedDict()
        self.joins: List[str] = []
        self.metrics: List[Tuple[str, str, str]] = []
        self.periods: List[str] = []
        self.currencies: List[str] = []
        self.enums: OrderedDict = OrderedDict()
        self.entities: List[Tuple[str, Dict]] = []

    def add_table(self, t: str):
        if t and t not in self.tables:
            self.tables.append(t)
            if t not in self.fields_by_table:
                self.fields_by_table[t] = []

    def add_field(self, tbl: str, fld: str):
        if tbl and fld:
            self.add_table(tbl)
            fq = f"{tbl}.{fld}"
            if fq not in self.fields_by_table[tbl]:
                self.fields_by_table[tbl].append(fq)

    def add_join(self, on: str):
        if on and on not in self.joins:
            self.joins.append(on)

    def add_metric(self, mname: str, mexpr: str, mtbl: str):
        if mtbl:
            self.add_table(mtbl)
        if mname:
            tup = (mname, mexpr or "", mtbl or "")
            if tup not in self.metrics:
                self.metrics.append(tup)

    def add_period(self, pname: str):
        if pname and pname not in self.periods:
            self.periods.append(pname)

    def add_currency(self, code: str):
        if code and code not in self.currencies:
            self.currencies.append(code)

    def add_enum(self, tbl: str, fld: str, vals: Any):
        if tbl:
            self.add_table(tbl)
        if tbl and fld:
            key = f"{tbl}.{fld}"
            if isinstance(vals, (list, tuple)):
                vals = ", ".join([str(v) for v in vals])
            if key not in self.enums:
                self.enums[key] = vals or ""
            self.add_field(tbl, fld)

    def add_entity(self, ent_name: str, filt: Dict):
        self.entities.append((ent_name, filt or {}))

    def sort(self):
        self.tables.sort()
        for t in self.fields_by_table:
            if t not in self.tables:
                self.tables.append(t)
        for t in self.fields_by_table:
            self.fields_by_table[t] = sorted(
                self.fields_by_table[t], key=lambda s: s.split(".", 1)[1]
            )
        self.joins.sort()
        self.metrics.sort(key=lambda x: x[0])
        self.periods.sort()
        self.currencies.sort()
        self.enums = OrderedDict(sorted(self.enums.items(), key=lambda kv: kv[0]))


def _process_enum(txt: str, md: Dict, acc: _SchemaAccumulator):
    tbl = md.get("table") or _parse_tag(txt, "TABLE")
    fld = md.get("field")
    if not fld:
        ef = _parse_tag(txt, "ENUM")
        if "." in ef:
            tbl = tbl or ef.split(".", 1)[0].strip()
            fld = ef.split(".", 1)[1].strip()
    vals = md.get("values")
    if vals is None:
        vals = _parse_tag(txt, "VALUES")
    acc.add_enum(tbl, fld, vals)


def _process_entity(txt: str, md: Dict, acc: _SchemaAccumulator):
    ent_name = md.get("entity") or _parse_tag(txt, "ENTITY") or "Entity"
    filt = md.get("filters")
    if filt is None:
        filt_txt = _parse_tag(txt, "FILTERS")
        filt = {}
        if filt_txt:
            for part in [p.strip() for p in filt_txt.split(";") if p.strip()]:
                if "=" in part:
                    k, v = part.split("=", 1)
                    filt[k.strip()] = [x.strip() for x in v.split(",") if x.strip()]
    acc.add_entity(ent_name, filt)


def _get_table_name(txt: str, md: Dict) -> str:
    return md.get("table") or _parse_tag(txt, "TABLE")


def _get_field_name(txt: str, md: Dict) -> str:
    return md.get("field") or _parse_tag(txt, "FIELD").split(" (", 1)[0]


def _process_table_doc(txt: str, md: Dict, acc: _SchemaAccumulator) -> None:
    acc.add_table(_get_table_name(txt, md))


def _process_field_doc(txt: str, md: Dict, acc: _SchemaAccumulator) -> None:
    acc.add_field(_get_table_name(txt, md), _get_field_name(txt, md))


def _process_join_doc(txt: str, md: Dict, acc: _SchemaAccumulator) -> None:
    acc.add_join(md.get("on") or _parse_tag(txt, "ON"))


def _process_metric_doc(txt: str, md: Dict, acc: _SchemaAccumulator) -> None:
    acc.add_metric(
        md.get("name") or _parse_tag(txt, "METRIC"),
        md.get("expression") or _parse_tag(txt, "EXPR"),
        _get_table_name(txt, md),
    )


def _process_period_doc(txt: str, md: Dict, acc: _SchemaAccumulator) -> None:
    acc.add_period(md.get("name") or _parse_tag(txt, "PERIOD"))


def _process_currency_doc(txt: str, md: Dict, acc: _SchemaAccumulator) -> None:
    acc.add_currency(md.get("code") or _parse_tag(txt, "CURRENCY"))


_DOC_PROCESSORS = {
    "table": _process_table_doc,
    "field": _process_field_doc,
    "join": _process_join_doc,
    "metric": _process_metric_doc,
    "period": _process_period_doc,
    "currency": _process_currency_doc,
    "enum": _process_enum,
    "entity": _process_entity,
}


def _process_doc(txt: str, md: Dict, acc: _SchemaAccumulator) -> None:
    dtype = md.get("type") or _infer_type(txt)
    processor = _DOC_PROCESSORS.get(dtype)
    if processor:
        processor(txt, md, acc)


def _append_table_lines(
    lines: List[str],
    acc: _SchemaAccumulator,
    max_fields_per_table: int,
) -> None:
    for tbl in acc.tables:
        lines.append(f"Table: {tbl}")
        lines.append("Fields:")
        fields = acc.fields_by_table.get(tbl, [])

        if not fields:
            lines.append("  -")
            lines.append("")
            continue

        lines.extend(f"  - {field}" for field in fields[:max_fields_per_table])

        extra_count = len(fields) - max_fields_per_table
        if extra_count > 0:
            lines.append(f"  # +{extra_count} more")

        lines.append("")


def _append_simple_section(lines: List[str], title: str, items: List[str]) -> None:
    if not items:
        return

    lines.append(f"{title}:")
    lines.extend(f"  - {item}" for item in items)
    lines.append("")


def _append_metric_lines(lines: List[str], acc: _SchemaAccumulator) -> None:
    if not acc.metrics:
        return

    lines.append("Metrics:")
    for metric_name, metric_expr, metric_table in acc.metrics:
        suffix = f"  # table: {metric_table}" if metric_table else ""
        line = f"  - {metric_name}: {metric_expr}{suffix}" if metric_expr else f"  - {metric_name}{suffix}"
        lines.append(line)
    lines.append("")


def _append_enum_lines(lines: List[str], acc: _SchemaAccumulator) -> None:
    if not acc.enums:
        return

    lines.append("Enums:")
    for key, values in acc.enums.items():
        lines.append(f"  - {key}: {values}" if values else f"  - {key}")
    lines.append("")


def _format_filter_value(value: Any) -> str:
    if isinstance(value, (list, tuple)):
        return ", ".join(str(item) for item in value)
    return str(value)


def _append_entity_lines(
    lines: List[str],
    acc: _SchemaAccumulator,
    show_entity_filters_yaml: bool,
) -> None:
    if not acc.entities:
        return

    lines.append("Entities:")
    for entity, filters in acc.entities:
        if show_entity_filters_yaml and isinstance(filters, dict) and filters:
            lines.append(f"  - Entity: {entity}")
            lines.append("    Filters:")
            for key, value in filters.items():
                lines.append(f"      {key}: {_format_filter_value(value)}")
            continue

        lines.append(f"  - Entity: {entity}, Filters: {filters if filters else '{}'}")


def _trim_trailing_blank_lines(lines: List[str]) -> None:
    while lines and not lines[-1].strip():
        lines.pop()


def _build_context_lines(
    acc: _SchemaAccumulator,
    title: str,
    max_fields_per_table: int,
    show_entity_filters_yaml: bool,
) -> List[str]:
    lines: List[str] = [title]

    _append_table_lines(lines, acc, max_fields_per_table)

    if acc.joins:
        lines.append("Join:")
        lines.extend(f"  {join}" for join in acc.joins)
        lines.append("")

    _append_metric_lines(lines, acc)
    _append_simple_section(lines, "Periods", acc.periods)
    _append_simple_section(lines, "Currencies", acc.currencies)
    _append_enum_lines(lines, acc)
    _append_entity_lines(lines, acc, show_entity_filters_yaml)

    _trim_trailing_blank_lines(lines)
    return lines


def hits_to_schema_context(
    hits: Union[List[Any], Dict, str],
    title: str = "SCHEMA CONTEXT",
    max_fields_per_table: int = 20,
    sort_sections: bool = True,
    show_entity_filters_yaml: bool = True
) -> str:
    acc = _SchemaAccumulator()
    for txt, md in _collect_docs(hits):
        _process_doc(txt, md, acc)
    if sort_sections:
        acc.sort()
    lines = _build_context_lines(acc, title, max_fields_per_table, show_entity_filters_yaml)
    return "\n".join(lines)


@frappe.whitelist(allow_guest=False)
def debug_entity_retriever(q: str):
    resp = remote_entity_embedder(q)   # this returns {"ok":..., "body":...}
    return {
        "query": q,
        "raw_response": resp,
        "parsed_entity_cards": call_entity_retriever(q),
    }


def _invoke_pipeline(user_question: str, chat_id: str):
    initial_state: SQLState = {"question": user_question or "", "session_id": chat_id}
    config = {
        "configurable": {"thread_id": chat_id},
        "run_name": "changai_text2sql_graph",
        "run_type": "graph",
        "tags": ["changai", "rag", "sql"],
        "metadata": {"tenant": "demo"},
    }
    try:
        return app.invoke(initial_state, config=config), None
    except frappe.exceptions.ValidationError as e:
        clean_msg = re.sub(r'<[^>]+>', '', str(e))
        return None, {"Bot": clean_msg, "error": clean_msg}
    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "ChangAI Pipeline Invoke Error")
        return None, {"Bot": "⚠️ An unexpected error occurred. Please try again.", "error": str(e)}


def _handle_non_erp(final: SQLState, user_question: str, chat_id: str) -> Dict:
    non_erp_res = _safe_strip(final.get("non_erp_res", ""))
    formatted_q = _safe_strip(final.get("formatted_q", ""))
    err = final.get("error")

    if not non_erp_res:
        if err:
            frappe.log_error(err, "ChangAI NON_ERP Error")
        return {
            "Question": user_question,
            "Formatted-Question": formatted_q,
            "Bot": err if err else "⚠️ Could not get a response. Please try again.",
        }

    if not err and non_erp_res:
        try:
            save_turn_2(session_id=chat_id, user_text=formatted_q, bot_text=non_erp_res)
            save_logs(user_question=user_question, formatted_q=formatted_q, result=non_erp_res)
        except Exception as e:
            frappe.log_error(f"Failed to save NON_ERP logs: {e}", "ChangAI Logs")

    return {"Question": user_question, "Formatted-Question": formatted_q, "Bot": non_erp_res}


def _get_sql_error_message(err: Any, val: Dict) -> str:
    if err:
        frappe.log_error(err, "ChangAI SQL Pipeline Error")
        return "⚠️ The model encountered an error generating your query. Please try again."

    error_text = (val.get("error") or "").strip()

    if not error_text:
        return "⚠️ Could not process your request. Please try rephrasing."

    if "Empty SQL from LLM" in error_text:
        return "⚠️ The model could not generate a SQL query for your question. Please try rephrasing."

    if "does not exist in schema" in error_text:
        return f"⚠️ The model generated an invalid table reference. {error_text}"

    if "could not be resolved" in error_text:
        return f"⚠️ The model generated an invalid field reference. {error_text}"

    if "parse" in error_text.lower() or "syntax" in error_text.lower() or "expected" in error_text.lower():
        return "⚠️ The model generated invalid SQL syntax. Please try rephrasing."

    return f"⚠️ The model generated an invalid query. {error_text}"


def _handle_sql_result(final: SQLState, sql: str, orm: str, formatted_q: str, fields: str,
                       selected_tables: List, val: Dict, entity_debug: Dict,
                       user_question: str, chat_id: str) -> Dict:
    try:
        extracted_tables = extract_tables_from_sql(sql)
        sql_result = execute_query(sql, extracted_tables)
    except Exception as e:
        return {"ok": False, "error": f"SQL Execution Failed: {e}"}

    context = (final.get("context") or final.get("selected_fields") or "")[:800]
    contains_values = final.get("contains_values") or ""
    err = final.get("error")
    formatted_result = format_data(formatted_q, sql_result)

    if not err:
        try:
            save_turn_2(session_id=chat_id, user_text=formatted_q, bot_text=formatted_result)
            save_logs(user_question=user_question, formatted_q=formatted_q, context=context,
                      sql=sql, val=val, result=sql_result, formatted_result=formatted_result)
        except Exception as e:
            return {"error": str(e)}

    return {
        "Question": user_question,
        "SQL": sql,
        "ORM": orm,
        "Tables": selected_tables,
        "Fields": fields,
        "Entity Values present ?": contains_values,
        "Validation": val,
        "Error": err,
        "result":sql_result,
        "EntityDebug": entity_debug,
        "Bot": formatted_result,
    }


@frappe.whitelist(allow_guest=False)
def run_text2sql_pipeline(user_question: str, chat_id: str) -> Dict:
    final, err_response = _invoke_pipeline(user_question, chat_id)
    if err_response:
        return err_response

    entity_debug = {
        "contains_values": final.get("contains_values"),
        "entity_cards": final.get("entity_cards") or [],
    }

    if (final.get("query_type") or "NON_ERP") == "NON_ERP":
        return _handle_non_erp(final, user_question, chat_id)

    sql = clean_sql(final.get("sql")) or ""
    res=validate_sql_schema(sql)
    orm = clean_sql(final.get("orm")) or ""
    formatted_q = _safe_strip(final.get("formatted_q") or "")
    selected_tables = final.get("selected_tables") or []
    fields = _safe_strip(final.get("selected_fields") or "")
    # val = final.get("validation") or {}
    err = final.get("error")

    if not res.get("ok") or not sql.upper().startswith("SELECT"):
        context = (final.get("context") or final.get("selected_fields") or "")[:800]
        return {
            "Question": user_question,
            "Formatted_Question": formatted_q,
            "Context": context,
            "Tables": selected_tables,
            "Fields": fields,
            "SQL": sql,
            "Validation": res,
            "EntityDebug": entity_debug,
            "Tries": int(final.get("tries") or 0),
            "Error": err or "SQL not valid or missing",
            "Result": [],
            "Bot": _get_sql_error_message(err, res),
        }

    return _handle_sql_result(final, sql, orm, formatted_q, fields,selected_tables, res, entity_debug, user_question, chat_id)
