from langgraph.graph import StateGraph,END
from collections import OrderedDict
from typing_extensions import TypedDict 
from typing import Any, Dict, Iterable, List, Tuple, Union,Optional
from sqlglot import exp
import requests, json, re, os
import sqlglot
from langsmith.run_helpers import traceable
import jinja2
from langchain_ollama import OllamaEmbeddings
from langchain_community.vectorstores import FAISS
import frappe
from langgraph.checkpoint.memory import MemorySaver
from changai.changai.api.v2.store_chats import save_turn_2,save_message_doc,inject_prompt
non_erp_res=""
import base64
import time
from werkzeug.wrappers import Response
import frappe
from pathlib import Path
from google import genai
from google.genai import types
from langchain_community.embeddings import HuggingFaceEmbeddings
from google.oauth2 import service_account
import frappe
from typing import List, Dict, Any, Optional
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings
import os
import yaml
from typing import Any, Dict, List, Optional
from langchain_core.documents import Document
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings
__vector_store = None
_SCHEMA_VS = None


@frappe.whitelist(allow_guest=False)
def get_settings() -> Dict[str, Any]:
    settings=frappe.get_single("ChangAI Settings")
    langsmith_tracing = "true" if settings.langsmith_tracing else "false"
    config={
        "LANGSMITH_TRACING" : langsmith_tracing,
        "LANGSMITH_ENDPOINT" : settings.langsmith_endpoint,
        "LANGSMITH_API_KEY" : settings.langsmith_api_key,
        "LANGSMITH_PROJECT" : settings.langsmith_project,
        "ROOT_PATH":settings.root_path,
        "URL":settings.prediction_url if settings.remote else settings.ollama_url,
        "LOCAL_LLM":settings.local_llm,
        "LOCAL_SCHEMA_RETRIEVER":settings.local_schema_retriever,
        "RETAIN_MEM":settings.retain_memory,
        "LLM_VERSION_ID":settings.llm_version_id,
        "EMBED_VERSION_ID":settings.embedder_version_id,
        "API_TOKEN":settings.api_token,
        "REMOTE": bool(settings.remote),
        "deploy_url":settings.deploy_url,
        "entity_retriever":settings.entity_retriever,
        "support_api_url":settings.support_url,
        "get_ticket_details_url":settings.get_ticket_details_url,
        "llm":settings.llm,
        "location":settings.gemini_location,
        "retriever_structure":settings.retriever_structure,
        "gemini_file_path":settings.gemini_file_path,
        "gemini_project_id":settings.gemini_project_id

    }
    return config


MODEL_ID = "gemini-2.5-flash-lite"
CONFIG = get_settings()
PROJECT_ID = CONFIG["gemini_project_id"]
KEY_PATH = CONFIG["gemini_file_path"]
RETRY_LIMIT=2
BACKEND_SERVER_SETTINGS = "Backend Server Settings"
INDEX_PATH = f"{CONFIG['ROOT_PATH']}/changai/changai/changai/faiss_index_hnsw_v2"
MAPPING_SCHEMA_PATH = f"{CONFIG['ROOT_PATH']}/changai/changai/changai/api/v2/metaschema_clean_v2.json"
SQL_PROMPT_PATH=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/prompts/sql_prompt.txt"
FORMAT_PROMPT_PATH=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/prompts/user_friendly_prompt.txt"
NON_ERP_PROMPT_PATH=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/prompts/non_erp_prompt.txt"
TEMPLATE_PATH=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/templates/conversation_template_v2.j2"
BUSINESS_KEYWORDS_PATH = f"{CONFIG['ROOT_PATH']}/changai/changai/changai/api/v2/business_keywords_v1.json"
ALLOWED_BASE = CONFIG["ROOT_PATH"]


def _assert_file_inside_base(file_path: str, base_dir: str) -> str:
    base = Path(base_dir).resolve()
    p = Path(file_path).resolve()
    if base != p and base not in p.parents:
        raise ValueError(f"Unsafe path: {p}")
    return str(p)


@frappe.whitelist(allow_guest=False)
def get_backend_server_settings(*keys: str) -> Dict[str, Any]:
    """
    Fetch multiple settings from the BACKEND_SERVER_SETTINGS.
    """
    return {
        key: frappe.db.get_single_value(BACKEND_SERVER_SETTINGS, key) for key in keys
    }


@frappe.whitelist(allow_guest=True)
def generate_token_secure(api_key: str, api_secret: str, app_key: str):

    try:
        try:
            app_key = base64.b64decode(app_key).decode("utf-8")
        except Exception as e:
            return Response(
                json.dumps(
                    {"message": "Security Parameters are not valid", "user_count": 0}
                ),
                status=401,
                mimetype="application/json",
            )

        clientID, clientSecret, clientUser = frappe.db.get_value(
            "OAuth Client",
            {"app_name": app_key},
            ["client_id", "client_secret", "user"],
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

        if clientID is None:
            return Response(
                json.dumps(
                    {"message": "Security Parameters are not valid", "user_count": 0}
                ),
                status=401,
                mimetype="application/json",
            )

        client_id = clientID  # Replace with your OAuth client ID
        client_secret = clientSecret

        url = (
            frappe.local.conf.host_name
            + "/api/method/frappe.integrations.oauth2.get_token"
        )

        payload = {
            "username": api_key,
            "password": api_secret,
            "grant_type": "password",
            "client_id": client_id,
            "client_secret": client_secret,
        }
        files = []
        headers = {"Content-Type": "application/json"}

        response = requests.request("POST", url, data=payload, files=files)

        if response.status_code == 200:

            result_data = json.loads(response.text)

            return Response(
                json.dumps({"data": result_data}),
                status=200,
                mimetype="application/json",
            )

        else:

            frappe.local.response.http_status_code = 401
            return json.loads(response.text)

    except Exception as e:

        return Response(
            json.dumps({"message":str(e), "user_count": 0}),
            status=500,
            mimetype="application/json",
        )


#api for user token
@frappe.whitelist(allow_guest=True)
def generate_token_secure_for_users(username: str, password: str, app_key: str) -> Dict[str, Any]:
    """
    Generate a secure token for user authentication.
    """
    try:
        try:
            app_key = base64.b64decode(app_key).decode("utf-8")
        except ValueError as ve:
            return generate_error_response(
                INVALID_SECURITY_PARAMETERS, error=str(ve), status = STATUS_401
            )
        client_id_value, client_secret_value = get_oauth_client(app_key)
        if client_id_value is None:
            return generate_error_response(
                INVALID_SECURITY_PARAMETERS, None, status = STATUS_401
            )
        client_id = client_id_value  # Replace with your OAuth client ID
        client_secret = client_secret_value  # Replace with your OAuth client secret
        url = frappe.local.conf.host_name + OAUTH_TOKEN_URL
        payload = {
            "username": username,
            "password": password,
            "grant_type": "password",
            "client_id": client_id,
            "client_secret": client_secret,
        }
        files = []
        response = requests.request("POST", url, data=payload, files=files, timeout=10)
        qid = frappe.get_all(
            "User",
            fields=[
                FIELD_NAME_AS_ID,
                FULL_NAME_ALIAS,
                MOBILE_NO_ALIAS,
            ],
            filters={"email": ["like", username]},
        )
        if response.status_code == STATUS_200:
            result_data = response.json()
            result_data["refresh_token"] = "XXXXXXX"
            result = {
                "token": result_data,
                "user": qid[0] if qid else {},
            }
            frappe.local.response = {
                "data": result_data,
                "http_status_code": STATUS_200,
            }
            return generate_success_response(result, status=STATUS_200)
        else:
            frappe.local.response.http_status_code = STATUS_401
            return json.loads(response.text)
    except ValueError as ve:
        return generate_error_response(ERROR, error=str(ve), status=STATUS_500)


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
        return generate_success_response(response_content, STATUS_200)
    except ValueError as ve:
        frappe.throw(ve)


@frappe.whitelist(allow_guest=False)
def call_model(prompt: str, task: str = "llm") -> Any:
    if CONFIG["REMOTE"] and CONFIG["llm"]=="QWEN3":
        return remote_llm_request_deploy_test(prompt=prompt, task=task)
    elif CONFIG["llm"]=="Gemini":
        return call_gemini(prompt)
    return local_llm_request(prompt)


def call_embedder(question: str) -> Any:
    return remote_embedder_request(question) if CONFIG["REMOTE"]  else local_embedder_request(question)


def _post_json(url: str, headers: Dict[str, str], payload: Dict[str, Any], timeout: int = 120):
    try:
        res = requests.post(url, headers=headers, json=payload, timeout=timeout)
        ct = (res.headers.get("Content-Type") or "").lower()
        try:
            body = res.json() if "application/json" in ct else {"raw_text": res.text}
        except Exception:
            body = {"raw_text": res.text}
        if res.status_code not in (200, 201,202):
            return {"ok": False, "status_code": res.status_code, "body": body}
        return {"ok": True, "status_code": res.status_code, "body": body}
    except requests.exceptions.Timeout:
        return {"ok": False, "status_code": None, "body": {"error": "timeout"}}
    except Exception as e:
        return {"ok": False, "status_code": None, "body": {"error": str(e)}}


def local_llm_request(prompt: str) -> str:
    url = f"{CONFIG['URL'].rstrip('/')}/api/generate"
    payload = {"model": CONFIG["LOCAL_LLM"], "prompt": prompt, "stream": False}
    resp = _post_json(url, headers={}, payload=payload, timeout=120)
    if not resp.get("ok"):
        return f"Error: local LLM call failed ({resp.get('status_code')}): {resp.get('body')}"
    text = (resp.get("body") or {}).get("response")
    return (text or "").strip() or "Error: Empty response from local LLM."


def return_headers() -> Dict[str, str]:
    return {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {CONFIG['API_TOKEN']}",
        }


@frappe.whitelist(allow_guest=False)
def create_llm_prediction(prompt: str) -> Dict[str, Any]:
    payload = {
        "version": CONFIG["LLM_VERSION_ID"],
        "input": {"user_input": prompt},
    }

    headers = return_headers()
    try:
        resp = _post_json(CONFIG["URL"], headers=headers, payload=payload, timeout=120)
    except Exception as e:
        return {"ok": False, "error": "Request failed", "exception": repr(e)}

    status_code = resp.get("status_code") or resp.get("body", {}).get("status_code")
    body = resp.get("body") if isinstance(resp.get("body"), dict) else resp
    if status_code not in (200, 201, 202):
        return {
            "ok": False,
            "error": "Submit failed",
            "status_code": status_code,
        }

    pred_id = (body or {}).get("id")
    status = (body or {}).get("status")

    if not pred_id:
        return {
            "ok": False,
            "error": "Missing prediction id from response",
            "status_code": status_code,
        }

    return {"ok": True, "pred_id": pred_id, "status": status}


def get_llm_prediction(pred_id: str) -> Dict[str, Any]:
    try:
        poll_url=f"{CONFIG['URL']}/{pred_id}"
        resp=requests.get(poll_url,headers=return_headers(),timeout=120)
        if resp.status_code!=200:
            return {
                "ok":False,
                "error":f"Poll failed: {resp.status_code}"
            }
        data=resp.json()
        status=data.get("status")
        output=data.get("output")
        error=data.get("error")
        return{
            "ok":True,
            "status":status,
            "output":output,
            "error":error

        }
    except Exception as e:
        return {"ok": False, "error": str(e)}


@frappe.whitelist(allow_guest=False)
def remote_llm_request(prompt: str) -> Any:
    payload = {
        "version": CONFIG["LLM_VERSION_ID"],
        "input": {"user_input": prompt},
    }
    headers = {
        "Content-Type": "application/json",
        "Prefer": "wait",
        "Authorization": f"Bearer {CONFIG['API_TOKEN']}",
    }

    create = _post_json(CONFIG["URL"], headers=headers, payload=payload, timeout=120)
    if not create.get("ok"):
        return {
            "Error": "Create prediction failed",
            "status_code": create.get("status_code"),
            "details": create.get("body"),
        }

    body = create.get("body") or {}
    pred_id = body.get("id")
    if not pred_id:
        return {"Error": "Missing prediction id", "details": body}

    poll_url = f"{CONFIG['URL'].rstrip('/')}/{pred_id}"
    terminal = {"succeeded", "failed", "canceled"}
    deadline = time.time() + 300
    last = None

    while time.time() < deadline:
        poll_resp = requests.get(poll_url, headers=headers, timeout=120)
        try:
            poll = poll_resp.json()
        except Exception:
            poll = {"raw_text": poll_resp.text}

        if poll_resp.status_code != 200:
            return {"Error": "Polling failed", "status_code": poll_resp.status_code, "details": poll}

        status = poll.get("status")
        output = poll.get("output")
        err = poll.get("error")
        last = {"status": status, "error": err}

        if status in terminal:
            if status == "succeeded":
                return output
            return {"Error": f"Model ended with status {status}", "details": poll}

    return {"Error": "Polling timeout", "last": last}


@frappe.whitelist(allow_guest=False)
def call_gemini(prompt: str) -> Union[str, Dict[str, Any]]:
    try:
        # Authenticate once
        creds = service_account.Credentials.from_service_account_file(
            KEY_PATH, 
            scopes=['https://www.googleapis.com/auth/cloud-platform']
        )

        # Initialize the Client once
        client = genai.Client(
            vertexai=True,
            project=PROJECT_ID,
            location=CONFIG["location"],
            credentials=creds
        )
        # Set System Instruction
        config = types.GenerateContentConfig(
            system_instruction="You are an ERPNext assistant.Follow the task instructions exactly.",
        )
        contents = [
            {
                "role": "user",
                "parts": [{"text": str(prompt)}]
            }
        ]

        response = client.models.generate_content(
            model=MODEL_ID,
            config=config,
            contents=contents
        )
        text = (response.text or "").strip()
        if text.startswith("```"):
            text = text.replace("```json", "").replace("```", "").strip()

        return text


    except Exception as e:
        return {
            "error": str(e)
        }


@frappe.whitelist(allow_guest=False)
def remote_llm_request_deploy_test(
    prompt: str = "",
    task: str = "llm",
    question: Optional[str] = None,
    db_result_json: Optional[str] = None,
    user_message: Optional[str] = None,
) -> Any:
    if task == "format_db":
        input_payload: Dict[str, Any] = {
            "task": "format_db",
            "question": question or "",
            "db_result_json": db_result_json or "{}",
        }

    elif task == "helpdesk_task":
        input_payload = {
            "task": "helpdesk_task",
            "user_message": user_message or prompt or "",
        }

    else:
        input_payload = {
            "task": "llm",
            "user_input": prompt,
        }

    payload = {"input": input_payload}

    headers = {
        "Content-Type": "application/json",
        "Prefer": "wait",
        "Authorization": f"Bearer {CONFIG['API_TOKEN']}",
    }

    # ---------------- Create prediction ----------------
    create = _post_json(CONFIG["deploy_url"], headers=headers, payload=payload, timeout=120)
    if not create.get("ok"):
        return {
            "Error": "Create prediction failed",
            "status_code": create.get("status_code"),
            "details": create.get("body"),
        }

    data = create.get("body") or {}
    urls = data.get("urls") or {}
    get_url = urls.get("get")
    if not get_url:
        return {
            "Error": "Missing get URL from deploy response",
            "details": data,
        }

    terminal = {"succeeded", "failed", "canceled"}
    deadline = time.time() + 300
    last = None

    while time.time() < deadline:
        poll_res = requests.get(get_url, headers=headers, timeout=120)
        try:
            poll = poll_res.json()
        except Exception:
            poll = {"raw_text": poll_res.text}

        status = poll.get("status")
        last = poll

        if status in terminal:
            if status == "succeeded":
                return poll.get("output")
            return {"Error": f"Model ended with status {status}", "details": poll}

        time.sleep(2)

    return {"Error": "Polling timed out", "details": last}


@frappe.whitelist(allow_guest=False)
def remote_embedder_request(formatted_q: str) -> Union[List[Any], str]:
    payload = {"version": CONFIG["EMBED_VERSION_ID"], "input": {"user_input": formatted_q}}
    headers = {
        "Content-Type": "application/json",
        "Prefer": "wait",
        "Authorization": f"Bearer {CONFIG['API_TOKEN']}",
    }
    result = None
    response = _post_json(CONFIG["URL"], headers, payload)
    try:
        if response:
            result = response["body"]["output"]
            return result
    except Exception as e:
        return "Error: " + str(e)


def local_embedder_request(question: str) -> List[Any]:
    global __vector_store
    if not os.path.exists(INDEX_PATH):
        return []
    if __vector_store is None:
        _emb = OllamaEmbeddings(base_url=CONFIG["URL"], model=CONFIG["LOCAL_SCHEMA_RETRIEVER"])
        __vector_store = FAISS.load_local(INDEX_PATH, embeddings=_emb, allow_dangerous_deserialization=True)
    return __vector_store.similarity_search(question, k=15)
    

def read_json(path: str) -> Dict[str, Any]:
    safe_path = _assert_file_inside_base(path, ALLOWED_BASE)
    with open(safe_path, "r", encoding="utf-8") as f:
        return json.load(f)


def read_text(path: str) -> str:
    safe_path = _assert_file_inside_base(path, ALLOWED_BASE)
    with open(safe_path, "r", encoding="utf-8") as f:
        return f.read()


CONVERSATION_TEMPLATE=read_text(TEMPLATE_PATH)
mapping_data=read_json(MAPPING_SCHEMA_PATH)
SQL_PROMPT=read_text(SQL_PROMPT_PATH)
FILTER_TABLES=read_text("/opt/hyrin/frappe-bench/apps/changai/changai/changai/prompts/filter_tables.txt")
filter_fields=read_text("/opt/hyrin/frappe-bench/apps/changai/changai/changai/prompts/filter_fields.txt")
FORMAT_PROMPT=read_text(FORMAT_PROMPT_PATH)
NON_ERP_PROMPT=read_text(NON_ERP_PROMPT_PATH)
BUSINESS_KEYWORDS=read_json(BUSINESS_KEYWORDS_PATH)["business_keywords"]


# # Shared State
class SQLState(TypedDict,total=False):
    session_id:str
    question: str
    contains_values:bool
    formatted_q:str
    hits: List[Any]
    context :str
    sql:str
    orm:str
    validation:Dict[str,Any]
    error:Optional[str]
    tries:int
    query_type:str
    sql_prompt:str
    formatting_prompt:str
    non_erp_res:str
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


def send_non_erp_request(state:SQLState) -> SQLState:
    qstn=state.get("formatted_q") or state.get("question")
    prompt=NON_ERP_PROMPT.format(question=qstn)
    try:
        response=call_model(prompt,"llm") 
        return {**state,"prompt":prompt,"non_erp_res":response,"error":None}
    except Exception as e:
        return {**state,"non_erp_res": "", "error": f"NON-ERP call failed: {e}"}


@traceable(name="rewrite_question", run_type="tool")
def rewrite_question(state: SQLState) -> SQLState:
    user_qstn = state.get("question") or ""
    session_id = state.get("session_id")
    prompt = inject_prompt(user_qstn, session_id)
    try:
        raw = call_model(prompt, "llm")
        standalone = ""
        contains_values = False
        obj = None

        if isinstance(raw, dict):
            obj = raw
        elif isinstance(raw, str):
            s = raw.strip()
            try:
                obj = json.loads(s)
            except Exception:
                obj = None
                standalone = s
        else:
            standalone = str(raw).strip()

        if isinstance(obj, dict):
            standalone = (obj.get("standalone_question") or "").strip() or standalone
            contains_values = bool(obj.get("contains_values"))
        else:
            if isinstance(obj, list) and not standalone:
                standalone = json.dumps(obj)
        standalone = standalone or user_qstn.strip()
        return {
            **state,
            "formatted_q": standalone,
            "contains_values": contains_values,
            "formatting_prompt": prompt,
            "error": None,
        }

    except Exception as e:
        return {
            **state,
            "error": str(e),
            "formatted_q": "",
            "contains_values": False,
            "formatting_prompt": prompt,
        }

emb=HuggingFaceEmbeddings(model_name="hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned")

vs = FAISS.load_local(
    "/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/v2/table_only_fvs",
    emb,
    allow_dangerous_deserialization=True
)

def call_fvs_table_search(q: str) -> List[str]:
    hits = vs.similarity_search(q, k=15)
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


@frappe.whitelist(allow_guest=False)
def call_retriev_multi_line(user_question: str) -> Dict[str, Any]:
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
    return {"selected_fields": json.dumps(selected_map, ensure_ascii=False),"top_tables":top_tables,"top_fields":fields_candidates}


_FIELDS_EMB = None
_FULL_FIELDS_VS = None
_SUB_VS_CACHE = {}

FULL_FIELDS_VS_PATH = "/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/v2/business_only_schema_fvs"


def get_fields_embedder():
    global _FIELDS_EMB
    if _FIELDS_EMB is None:
        _FIELDS_EMB = HuggingFaceEmbeddings(
            model_name="hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned"
        )
    return _FIELDS_EMB


def get_full_fields_vs():
    global _FULL_FIELDS_VS
    if _FULL_FIELDS_VS is None:
        emb = get_fields_embedder()
        _FULL_FIELDS_VS = FAISS.load_local(
            FULL_FIELDS_VS_PATH,
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
    emb = get_fields_embedder()

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

    # Reduce k from 200 -> ~60 (you only need 40)
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


# # Node 1: Retrive with Fiass Vector Store.
@traceable(name="schema_retriever", run_type="tool")
def schema_retriever(state: SQLState) -> SQLState:
    if CONFIG["retriever_structure"]=="single line":
        hits = call_embedder(state.get("formatted_q", "") or state.get("question", ""))
        return {**state, "hits": hits}
    else:
        out = call_retriev_multi_line(state.get("formatted_q") or state.get("question") or "")
        return {
            **state,
            "retrieval_mode": "multi",
            "top_tables": out.get("top_tables", []),
            "top_fields": out.get("top_fields", {}),
            "selected_fields": out.get("selected_fields", ""),
            "selected_tables": out.get("selected_tables", []),
        }


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
    if entity_cards:
        entity_block = "\n\nENTITY_CARDS:\n" + "\n".join(map(str, entity_cards))
    if CONFIG["retriever_structure"]=="multi line":
        context = (selected_fields or "") + (entity_block or "")
        prompt = fill_sql_prompt(state["formatted_q"], context)
    else:
        prompt=fill_sql_prompt(state["formatted_q"],state["context"])
    try:
        # response=call_model(prompt, "llm")
        response=call_model(prompt)
        if isinstance(response, str):
            response = json.loads(response)
        sql = response.get("sql", "")
        orm = response.get("orm", "")
        return {**state,"sql_prompt":prompt,"sql":sql,"orm":orm,"error":None}
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
    payload = {"version": CONFIG["entity_retriever"], "input": {"query": q}}
    headers = {
        "Content-Type": "application/json",
        "Prefer": "wait",
        "Authorization": f"Bearer {CONFIG['API_TOKEN']}",
    }
    result = None
    response = _post_json(CONFIG["URL"], headers, payload)
    return response


@frappe.whitelist(allow_guest=False)
def call_entity_retriever(qstn: str) -> Dict[str, Any]:
    response = remote_entity_embedder(qstn)

    if not response.get("ok"):
        frappe.log_error(f"Entity retriever failed: {response.get('body')}", "ChangAI Entity Retriever")
        return {"raw": response, "cards": []}

    body = response.get("body") or {}
    output = body.get("output") or {}
    results = output.get("results") or []

    cards = [r.get("entity_label") for r in results if r.get("entity_label")]

    return {"raw": body, "cards": cards}


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

    patched_prompt = state["sql_prompt"] + "\n\n#VALIDATION HINTS\n" + "\n".join(f"-{h}" for h in hints)

    try:
        response = call_model(patched_prompt,"llm")
        if isinstance(response, str):
            response = json.loads(response)
            sql = response.get("sql", "")
            orm = response.get("orm", "")
        return {**state, "sql": sql, "tries": tries, "error": None}
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
    return "DIRECT" if CONFIG.get("retriever_structure") == "multi line" else "CONTEXT"


def route_guardrail(state: SQLState) -> str:
    return "ERP" if state.get("query_type") == "ERP" else "NON_ERP"


def clean_sql(s: Any) -> str:
    if isinstance(s, dict):
        s = s.get("output") or s.get("sql") or s.get("text") or json.dumps(s, ensure_ascii=False, default=str)
    elif isinstance(s, list):
        s = "\n".join([str(x) for x in s])  # no map()
    else:
        s = str(s) if s is not None else ""

    s = s.strip()
    s = re.sub(r"^\s*```(?:sql)?\s*", "", s, flags=re.I)
    s = re.sub(r"\s*```\s*$", "", s)
    s = re.sub(r"^\s*sql\s*\n", "", s, flags=re.I)
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

from sqlglot import exp
import sqlglot
from typing import Dict, List
from typing import Dict, List, Any, Set, Tuple
import sqlglot
from sqlglot import exp
from typing import Any, Dict, List, Tuple, Set
import sqlglot
from sqlglot import exp

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
        "details": {
            "from_tables": [],
            "alias_to_table": {},
            "derived_aliases": [],
            "select_aliases": [],  # ✅ added (optional, but useful for debugging)
        },
    }

    try:
        ast = sqlglot.parse_one(sql_text, read=dialect)
    except Exception as e:
        result["ok"] = False
        result["details"]["parse_error"] = str(e)
        return result

    base_tables: List[str] = []
    alias_to_table: Dict[str, str] = {}

    for t in ast.find_all(exp.Table):
        name = t.name
        if not name:
            continue
        base_tables.append(name)

        a = t.args.get("alias")
        if a and a.name:
            alias_to_table[a.name] = name

    base_tables = list(dict.fromkeys(base_tables))
    result["details"]["from_tables"] = base_tables
    result["details"]["alias_to_table"] = alias_to_table

    unknown_tables = [t for t in base_tables if t not in mapping]
    if unknown_tables:
        result["ok"] = False
        result["unknown_tables"] = unknown_tables

    derived_aliases: Set[str] = set()
    for sq in ast.find_all(exp.Subquery):
        a = sq.args.get("alias")
        if a and a.name:
            derived_aliases.add(a.name)
    for cte in ast.find_all(exp.CTE):
        a = cte.args.get("alias")
        if a and a.name:
            derived_aliases.add(a.name)

    result["details"]["derived_aliases"] = sorted(derived_aliases)

    # ✅ NEW: collect SELECT projection aliases (e.g. COUNT(*) AS invoice_count)
    select_aliases: Set[str] = set()
    for sel in ast.find_all(exp.Select):
        for proj in sel.expressions:
            if isinstance(proj, exp.Alias):
                if proj.alias:  # alias is a string
                    select_aliases.add(proj.alias)

    result["details"]["select_aliases"] = sorted(select_aliases)

    unknown_cols: List[Tuple[str, str]] = []
    ambiguous: Set[str] = set()
    base_tables_set = set(base_tables)

    for col in ast.find_all(exp.Column):
        col_name = col.name
        qual = col.table  # qualifier (alias or table), may be None
        if not col_name:
            continue

        if qual:
            q = str(qual)

            # If referencing a derived table alias, skip schema validation here
            if q in derived_aliases:
                continue

            if q in mapping:
                if col_name not in mapping[q]:
                    unknown_cols.append((f"{q}.{col_name}", q))
                continue

            if q in alias_to_table:
                real_table = alias_to_table[q]
                if real_table in mapping and col_name not in mapping[real_table]:
                    unknown_cols.append((f"{q}.{col_name}", real_table))
                continue

            unknown_cols.append((f"{q}.{col_name}", None))

        else:
            # ✅ NEW: if unqualified identifier matches a SELECT alias, allow it
            # This fixes ORDER BY invoice_count / HAVING invoice_count, etc.
            if col_name in select_aliases:
                continue

            candidates = [t for t in base_tables_set if col_name in mapping.get(t, [])]
            if len(candidates) == 0:
                unknown_cols.append((col_name, None))
            elif len(candidates) > 1:
                ambiguous.add(col_name)

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
workflow.add_edge("generate_sql","validate_sql")
workflow.add_conditional_edges("validate_sql",router,{"repair":"repair_sql","end":END})
workflow.add_edge("repair_sql","validate_sql")
checkpointer=MemorySaver()
app=workflow.compile(checkpointer=checkpointer)


@frappe.whitelist(allow_guest=False)
def execute_query(sql: str, orm: str) -> Any:
    """
    Execute only SELECT SQL when sql is provided.
    (Your old code checked orm but executed sql.)
    """
    try:
        if sql:
            # if not str(sql).lower().strip().startswith("select"):
            #     frappe.throw(_("Only SELECT queries are allowed."))
            return frappe.db.sql(sql, as_dict=True)
        return []
    except Exception as e:
        return {"error": f"SQL Execution Failed: {e}"}


@frappe.whitelist(allow_guest=False)
def execute_query_1(mode: str, sql: str, orm: Optional[Dict[str, Any]]) -> Any:
    try:
        mode = (mode or "").lower().strip()

        if mode == "sql":
            if not (sql or "").lower().strip().startswith("select"):
                frappe.throw(_("Only SELECT queries are allowed."))
            return frappe.db.sql(sql, as_dict=True)

        if mode == "orm":
            if not isinstance(orm, dict):
                frappe.throw(_("ORM query must be JSON object."))

            doctype = orm.get("doctype")
            filters = orm.get("filters")
            fields = orm.get("fields")

            return frappe.get_all(doctype, filters=filters, fields=fields)

        frappe.throw(_("Mode must be 'sql' or 'orm'."))

    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "Query Execution Failed")
        return {"error": str(e)}


@frappe.whitelist(allow_guest=False)
def send_support_message(message: str) -> Any:
    url = CONFIG["support_api_url"]
    res = requests.post(url, json={"message": message}, timeout=15)
    return res.json()


@frappe.whitelist(allow_guest=False)
def get_ticket_details(tid: Union[int, str]) -> Any:
    url = CONFIG["get_ticket_details_url"]
    res = requests.post(url, json={"ticket_id": tid}, timeout=15)
    return res.json()


@frappe.whitelist(allow_guest=False)
def support_bot(message: str) -> Dict[str, Any]:
    output = remote_llm_request_deploy_test(
        task="helpdesk_task",
        prompt="",
        question=None,
        db_result_json=None,
        user_message=message
    )

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
            created = send_support_message(message)
            return {"kind": "CREATE_TICKET", "data": created}

        except Exception as e:
            return {"Error":str(e)}
    if task_flag == "TICKET_DETAILS":
        if not ticket_id:
            return {
                "kind": "TICKET_DETAILS",
                "error": "Ticket id missing. Please say like: ticket 29"
            }
        try:
            details = get_ticket_details(ticket_id)
            return {"kind": "TICKET_DETAILS", "data": details}
        except Exception as e:
            return {"Error":str(e)}

    if task_flag == "GET_USER_TICKETS":
        tickets = get_ticket_details()
        return {"kind": "GET_USER_TICKETS", "data": tickets}

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
    # frappe.db.commit() removed
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


def hits_to_schema_context(
    hits: Union[List[Any], Dict, str],
    title: str = "SCHEMA CONTEXT",
    max_fields_per_table: int = 20,
    sort_sections: bool = True,
    show_entity_filters_yaml: bool = True
) -> str:
    if isinstance(hits, dict) and "message" in hits and isinstance(hits["message"], list):
        hits = hits["message"]

    def _to_txt_md(doc: Any) -> Tuple[str, Dict]:
        if isinstance(doc, dict):
            return doc.get("text", "") or "", doc.get("metadata", {}) or {}
        # plain string
        if isinstance(doc, str):
            return doc, {}
        return "", {}

    docs: List[Tuple[str, Dict]] = []
    if isinstance(hits, (dict, str)) or hasattr(hits, "page_content"):
        docs.append(_to_txt_md(hits))
    else:
        # list of docs
        for d in (hits or []):
            docs.append(_to_txt_md(d))

    # --- helpers ---
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

    # --- accumulators ---
    tables: List[str] = []
    fields_by_table: Dict[str, List[str]] = OrderedDict()
    joins: List[str] = []
    metrics: List[Tuple[str, str, str]] = []  # (metric_name, expression, table)
    periods: List[str] = []
    currencies: List[str] = []
    enums: "OrderedDict[str, str]" = OrderedDict()
    entities: List[Tuple[str, Dict]] = []

    def _add_table(t: str):
        if t and t not in tables:
            tables.append(t)
            if t not in fields_by_table:
                fields_by_table[t] = []

    def _add_field(tbl: str, fld: str):
        if tbl and fld:
            _add_table(tbl)
            fq = f"{tbl}.{fld}"
            if fq not in fields_by_table[tbl]:
                fields_by_table[tbl].append(fq)

    # --- parse each doc ---
    for txt, md in docs:
        dtype = md.get("type") or _infer_type(txt)

        if dtype == "table":
            tbl = md.get("table") or _parse_tag(txt, "TABLE")
            _add_table(tbl)

        elif dtype == "field":
            tbl = md.get("table") or _parse_tag(txt, "TABLE")
            fld = md.get("field") or _parse_tag(txt, "FIELD").split(" (", 1)[0]
            _add_field(tbl, fld)

        elif dtype == "join":
            on = md.get("on") or _parse_tag(txt, "ON")
            if on and on not in joins:
                joins.append(on)

        elif dtype == "metric":
            mname = md.get("name") or _parse_tag(txt, "METRIC")
            mexpr = md.get("expression") or _parse_tag(txt, "EXPR")
            mtbl  = md.get("table") or _parse_tag(txt, "TABLE")
            if mtbl:
                _add_table(mtbl)
            if mname:
                tup = (mname, mexpr or "", mtbl or "")
                if tup not in metrics:
                    metrics.append(tup)

        elif dtype == "period":
            pname = md.get("name") or _parse_tag(txt, "PERIOD")
            if pname and pname not in periods:
                periods.append(pname)

        elif dtype == "currency":
            code = md.get("code") or _parse_tag(txt, "CURRENCY")
            if code and code not in currencies:
                currencies.append(code)

        elif dtype == "enum":
            tbl = md.get("table") or _parse_tag(txt, "TABLE")
            fld = md.get("field")
            if not fld:
                ef = _parse_tag(txt, "ENUM")
                if "." in ef:
                    tbl = tbl or ef.split(".", 1)[0].strip()
                    fld = ef.split(".", 1)[1].strip()
            if tbl:
                _add_table(tbl)
            if tbl and fld:
                key = f"{tbl}.{fld}"
                vals = md.get("values")
                if vals is None:
                    vals = _parse_tag(txt, "VALUES")
                if isinstance(vals, (list, tuple)):
                    vals = ", ".join(map(str, vals))
                if key not in enums:
                    enums[key] = vals or ""
                _add_field(tbl, fld)

        elif dtype == "entity":
            ent_name = md.get("entity") or _parse_tag(txt, "ENTITY") or "Entity"
            filt = md.get("filters")
            if filt is None:
                filt_txt = _parse_tag(txt, "FILTERS")
                filt = {}
                if filt_txt:
                    for part in [p.strip() for p in filt_txt.split(";") if p.strip()]:
                        if "=" in part:
                            k, v = part.split("=", 1)
                            vals = [x.strip() for x in v.split(",") if x.strip()]
                            filt[k.strip()] = vals
            entities.append((ent_name, filt or {}))

    # --- deterministic ordering ---
    if sort_sections:
        tables.sort()
        for t in list(fields_by_table.keys()):
            if t not in tables:
                tables.append(t)
        for t in fields_by_table:
            fields_by_table[t] = sorted(fields_by_table[t], key=lambda s: s.split(".", 1)[1])
        joins.sort()
        metrics.sort(key=lambda x: x[0])
        periods.sort()
        currencies.sort()
        enums = OrderedDict(sorted(enums.items(), key=lambda kv: kv[0]))

    # --- build context lines ---
    lines: List[str] = [title]

    for tbl in tables:
        lines.append(f"Table: {tbl}")
        lines.append("Fields:")
        flds = fields_by_table.get(tbl, [])
        if flds:
            cap = flds[:max_fields_per_table]
            lines.extend([f"  - {f}" for f in cap])
            if len(flds) > max_fields_per_table:
                lines.append(f"  # +{len(flds) - max_fields_per_table} more")
        else:
            lines.append("  -")
        lines.append("")

    if joins:
        lines.append("Join:")
        lines.extend([f"  {j}" for j in joins])
        lines.append("")

    if metrics:
        lines.append("Metrics:")
        for mname, mexpr, mtbl in metrics:
            suffix = f"  # table: {mtbl}" if mtbl else ""
            if mexpr:
                lines.append(f"  - {mname}: {mexpr}{suffix}")
            else:
                lines.append(f"  - {mname}{suffix}")
        lines.append("")

    if periods:
        lines.append("Periods:")
        lines.extend([f"  - {p}" for p in periods])
        lines.append("")

    if currencies:
        lines.append("Currencies:")
        lines.extend([f"  - {c}" for c in currencies])
        lines.append("")

    if enums:
        lines.append("Enums:")
        for key, vals in enums.items():
            lines.append(f"  - {key}: {vals}" if vals else f"  - {key}")
        lines.append("")

    if entities:
        lines.append("Entities:")
        for ent, filt in entities:
            if show_entity_filters_yaml and isinstance(filt, dict) and filt:
                lines.append(f"  - Entity: {ent}")
                lines.append("    Filters:")
                for k, v in filt.items():
                    vv = ", ".join(map(str, v)) if isinstance(v, (list, tuple)) else str(v)
                    lines.append(f"      {k}: {vv}")
            else:
                lines.append(f"  - Entity: {ent}, Filters: {filt if filt else '{}'}")

    while lines and not lines[-1].strip():
        lines.pop()
    return "\n".join(lines)


@frappe.whitelist(allow_guest=False)
def debug_entity_retriever(q: str):
    resp = remote_entity_embedder(q)   # this returns {"ok":..., "body":...}
    return {
        "query": q,
        "raw_response": resp,
        "parsed_entity_cards": call_entity_retriever(q),
    }


# Run
@frappe.whitelist(allow_guest=False)
def run_text2sql_pipeline(user_question: str, chat_id: str):
    q = (user_question or "")
    config = {
        "configurable": {"thread_id": chat_id},
        "run_name": "changai_text2sql_graph",
        "run_type": "graph",
        "tags": ["changai", "rag", "sql"],
        "metadata": {"tenant": "demo"},
    }
    initial_state: SQLState = {
        "question": q,
        "session_id":chat_id
    }
    final: SQLState = app.invoke(initial_state, config=config)
    entity_debug = {
    "contains_values": final.get("contains_values"),
    "entity_cards": final.get("entity_cards") or [],
}
    type_ = final.get("query_type") or "NON_ERP"
    if type_ == "NON_ERP":
        non_erp_res = (final.get("non_erp_res") or "").strip()
        formatted_q = (final.get("formatted_q") or "").strip()
        err = final.get("error")

        if not err and non_erp_res:
            try:
                save_turn_2(
                    session_id=chat_id,
                    user_text=formatted_q,
                    bot_text=non_erp_res
                )
                save_logs(
                    user_question=user_question,
                    formatted_q=formatted_q,
                    result=non_erp_res
                )
            except Exception as e:
                frappe.log_error(f"Failed to save NON_ERP logs: {e}", "ChangAI Logs")

        return {
            "Question": user_question,
            "Formatted-Question": formatted_q,
            "Bot": non_erp_res,
        }

    sql  = clean_sql(final.get("sql"))or ""
    orm  = clean_sql(final.get("orm"))or ""
    fields=(final.get("selected_fields") or "").strip()
    formatted_q = (final.get("formatted_q") or "").strip()
    formatting_prompt = (final.get("formatting_prompt") or "")
    sql_prompt = (final.get("sql_prompt") or "")
    val = final.get("validation") or {}
    ok = bool(val.get("ok"))
    if not ok or not sql.upper().startswith("SELECT"):
        context = (final.get("context") or final.get("selected_fields") or "")[:800]
        tries = int(final.get("tries") or 0)
        err = final.get("error")
        return {
            "Question":user_question,
            "Formatted_Question":formatted_q,
            "Context": context,
            "SQL": sql,
            "Validation": val,
            "EntityDebug": entity_debug,
            "Tries": tries,
            "Error": err or "SQL not valid or missing",
            "Result": [],
            "Bot": "I couldn’t produce a valid SQL yet. Please try rephrasing.",
        }
    sql_result = execute_query(sql,orm)
    context = (final.get("context") or final.get("selected_fields") or "")[:800]
    contains_values=final.get("contains_values") or ""
    tries = int(final.get("tries") or 0)
    top_tables=final.get("top_tables") or ""
    top_fields=final.get("top_fields") or ""
    err = final.get("error")
    formatted_result = format_data(formatted_q,sql_result)
    if not err:
        try:
            save_turn_2(session_id=chat_id,user_text=formatted_q,bot_text=formatted_result)
            save_logs(user_question=user_question,formatted_q=formatted_q,context=context,sql=sql,val=val,result=sql_result,formatted_result=formatted_result)
        except Exception as e:
            return e
    return {
        "Question":user_question,
        # "SQLPrompt":sql_prompt,
        "top_tables":top_tables,
        "top_fields":top_fields,
        "contains_values":contains_values,
        "SQL": sql,
        "ORM":orm,
        # "Validation": val,
        # "Tries": tries,
        # "Error": err,
        # "Result": result,
        "EntityDebug": entity_debug,
        "Bot": formatted_result
    }


@frappe.whitelist(allow_guest=False)
def call_gemini_1(prompt: str) -> Union[str, Dict[str, Any]]:
    creds = service_account.Credentials.from_service_account_file(
        KEY_PATH,
        scopes=["https://www.googleapis.com/auth/cloud-platform"],
    )
    client = genai.Client(
        vertexai=True,
        project=PROJECT_ID,
        location=CONFIG["location"],
        credentials=creds,
    )
    cfg = types.GenerateContentConfig(
        system_instruction="You are an ERPNext assistant. Follow the task instructions exactly.",
    )
    contents = [{"role": "user", "parts": [{"text": str(prompt)}]}]
    response = client.models.generate_content(model=MODEL_ID, config=cfg, contents=contents)
    text = (response.text or "").strip()
    if text.startswith("```"):
        text = text.replace("```json", "").replace("```", "").strip()
    return text