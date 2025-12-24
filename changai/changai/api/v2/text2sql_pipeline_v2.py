import replicate
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
from langchain_core.chat_history import InMemoryChatMessageHistory
from changai.changai.api.v2.store_chats import save_turn_2,save_message_doc,inject_prompt
import time
non_erp_res=""
MAX_TOKEN_LIMIT=1500
import base64
from werkzeug.wrappers import Response
MAX_WINDOW_TURNS=10
__vector_store = None

def get_settings():
    settings=frappe.get_single("ChangAI Settings")
    langsmith_tracing = "true" if settings.langsmith_tracing else "false"
    config={
        "LANGSMITH_TRACING" : langsmith_tracing,
        "LANGSMITH_ENDPOINT" : settings.langsmith_endpoint,
        "LANGSMITH_API_KEY" : settings.langsmith_api_key,
        "LANGSMITH_PROJECT" : settings.langsmith_project,
        "ROOT_PATH":settings.root_path,
        "URL":settings.server_url if settings.remote else settings.ollama_url,
        # "URL": (settings.deploy if settings.deploy else settings.server_url) if settings.remote else settings.ollama_url,
        "LLM":settings.llm,
        "EMBED_MODEL":settings.embedder,
        "RETAIN_MEM":settings.retain_memory,
        "LLM_VERSION_ID":settings.llm_version_id,
        "EMBED_VERSION_ID":settings.embedder_version_id,
        "API_TOKEN":settings.api_token,
        "REMOTE": bool(settings.remote),
        "deploy_url":settings.deploy_url,
        "entity_retriever":settings.entity_retriever
    }
    return config

CONFIG = get_settings()
# LANGSMITH_TRACING=CONFIG["LANGSMITH_TRACING"]
# LANGSMITH_ENDPOINT=CONFIG["LANGSMITH_ENDPOINT"]
# LANGSMITH_API_KEY=CONFIG["LANGSMITH_API_KEY"]
# LANGSMITH_PROJECT=CONFIG["LANGSMITH_PROJECT"]
RETRY_LIMIT=2
BACKEND_SERVER_SETTINGS = "Backend Server Settings"
INDEX_PATH = f"{CONFIG['ROOT_PATH']}/changai/changai/changai/faiss_index_hnsw_v2"
MAPPING_SCHEMA_PATH = f"{CONFIG['ROOT_PATH']}/changai/changai/changai/api/v2/metaschema_clean_v2.json"
SQL_PROMPT_PATH=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/prompts/sql_prompt.txt"
FORMAT_PROMPT_PATH=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/prompts/user_friendly_prompt.txt"
NON_ERP_PROMPT_PATH=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/prompts/non_erp_prompt.txt"
TEMPLATE_PATH=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/templates/conversation_template_v2.j2"
BUSINESS_KEYWORDS_PATH = f"{CONFIG['ROOT_PATH']}/changai/changai/changai/api/v2/business_keywords_v1.json"

@frappe.whitelist(allow_guest=True)
def get_backend_server_settings(*keys):
    """
    Fetch multiple settings from the BACKEND_SERVER_SETTINGS.
    """
    return {
        key: frappe.db.get_single_value(BACKEND_SERVER_SETTINGS, key) for key in keys
    }

@frappe.whitelist(allow_guest=True)
def generate_token_secure(api_key, api_secret, app_key):

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
            # return app_key
            return Response(
                json.dumps(
                    {"message": "Security Parameters are not valid", "user_count": 0}
                ),
                status=401,
                mimetype="application/json",
            )

        client_id = clientID  # Replace with your OAuth client ID
        client_secret = clientSecret  # Replace with your OAuth client secret

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
@frappe.whitelist(allow_guest=False)
def generate_token_secure_for_users(username, password, app_key):
    """
    Generate a secure token for user authentication.
    """
    # frappe.log_error(
    #     title="Login attempt",
    #     message=str(username) + "    " + str(password) + "    " + str(app_key + "  "),
    # )
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
def whoami():
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
    if CONFIG["REMOTE"]:
        return remote_llm_request_deploy_test(prompt=prompt, task=task)
    else:
        return local_llm_request(prompt)

def call_embedder(question):
    return remote_embedder_request(question) if CONFIG["REMOTE"] else local_embedder_request(question)


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
    payload = {"model": CONFIG["LLM"], "prompt": prompt, "stream": False}
    resp = _post_json(url, headers={}, payload=payload, timeout=120)
    if not resp.get("ok"):
        return f"Error: local LLM call failed ({resp.get('status_code')}): {resp.get('body')}"
    text = (resp.get("body") or {}).get("response")
    return (text or "").strip() or "Error: Empty response from local LLM."


def return_headers():
    return {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {CONFIG['API_TOKEN']}",
        }


@frappe.whitelist(allow_guest=False)
def create_llm_prediction(prompt: str):
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


def get_llm_prediction(pred_id:str):
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
def remote_llm_request(prompt: str):
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
def remote_llm_request_deploy_test(
    prompt: str = "",
    task: str = "llm",
    question: Optional[str] = None,
    db_result_json: Optional[str] = None,
) -> Any:

    if task == "format_db":
        input_payload: Dict[str, Any] = {
            "task": "format_db",
            "question": question or "",
            "db_result_json": db_result_json or "{}",
        }
    else:
        input_payload = {
            "task": "llm",
            "user_input": prompt,
        }
    payload = {
        "input": input_payload
    }

    headers = {
        "Content-Type": "application/json",
        "Prefer": "wait",
        "Authorization": f"Bearer {CONFIG['API_TOKEN']}",
    }
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
        output = poll.get("output")
        last = poll

        if status in terminal:
            if status == "succeeded":
                return output
            return {
                "Error": f"Model ended with status {status}",
                "details": poll,
            }

        time.sleep(2)

    return {"Error": "Polling timed out", "details": last}



@frappe.whitelist(allow_guest=False)
def remote_embedder_request(formatted_q: str) -> Union[list, str]:
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
        return {"Error":str(e)}


def local_embedder_request(question: str):
    global __vector_store
    if not os.path.exists(INDEX_PATH):
        return []
    if __vector_store is None:
        _emb = OllamaEmbeddings(base_url=CONFIG["URL"], model=CONFIG["EMBED_MODEL"])
        __vector_store = FAISS.load_local(INDEX_PATH, embeddings=_emb, allow_dangerous_deserialization=True)
    return __vector_store.similarity_search(question, k=15)
    

def read_json(path):
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def read_text(path):
    with open(path,"r",encoding="utf-8") as f:
        return f.read()


CONVERSATION_TEMPLATE=read_text(TEMPLATE_PATH)
mapping_data=read_json(MAPPING_SCHEMA_PATH)
SQL_PROMPT=read_text(SQL_PROMPT_PATH)
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
    validation:Dict[str,Any]
    error:Optional[str]
    tries:int
    query_type:str
    sql_prompt:str
    formatting_prompt:str
    non_erp_res:str
    entity_cards: List[str]
    entity_raw: Any

# InMemorySaver -> wiped after restart
# checkpointer = MemorySaver()     


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
            # e.g., list outputs or other types
            standalone = str(raw).strip()

        # If JSON parsed to dict, extract fields
        if isinstance(obj, dict):
            standalone = (obj.get("standalone_question") or "").strip() or standalone
            contains_values = bool(obj.get("contains_values"))
        else:
            # If JSON parsed to list, fallback to string
            if isinstance(obj, list) and not standalone:
                standalone = json.dumps(obj)

        # Final fallback
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


# # Node 1: Retrive with Fiass Vector Store.
@traceable(name="schema_retriever", run_type="tool")
def schema_retriever(state: SQLState) -> SQLState:
    hits = call_embedder(state.get("formatted_q", "") or state.get("question", ""))
    return {**state, "hits": hits}


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
    prompt=fill_sql_prompt(state["formatted_q"],state["context"])
    try:
        response=call_model(prompt, "llm")
        return {**state,"sql_prompt":prompt,"sql":response,"error":None}
    except Exception as e:
        return {**state,"error": f"LLM call failed: {e}","sql_prompt":prompt}


# # Node 4:Validate the SQL Generate with meta schema mapping using SQLGlot
@traceable(name="validate_sql", run_type="tool")
def validate_sql(state: SQLState) -> SQLState:
    sql = (state.get("sql") or "")
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
def call_entity_retriever(qstn: str):
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
        return {**state, "sql": response, "tries": tries, "error": None}
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
        out = call_entity_retriever(q)  # {"raw": ..., "cards": [...]}
        return {
            **state,
            "entity_cards": out.get("cards") or [],
            "entity_raw": out.get("raw"),
        }
    except Exception as e:
        frappe.log_error(f"Entity retriever failed: {e}", "ChangAI Entity Gate")
        return {**state, "entity_cards": [], "entity_raw": {"error": str(e)}}



def route_guardrail(state:SQLState):
    return "ERP" if state.get("query_type")=="ERP" else "NON_ERP"


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


def validate_sql_against_mapping(sql_text: str, mapping: Dict[str, List[str]], dialect: str = "mysql"):
    result = {
        "ok": True,
        "unknown_tables": [],
        "unknown_columns": [],
        "ambiguous_columns": [],
        "details": {}
    }
    try:
        ast = sqlglot.parse_one(sql_text, read=dialect)
    except Exception as e:
        result["ok"] = False
        result["details"]["parse_error"] = str(e)
        return result

    tables = []
    for t in ast.find_all(exp.Table):
        name = t.name
        if name:
            tables.append(name)

    tables = list(dict.fromkeys(tables))
    unknown_tables = [t for t in tables if t not in mapping]
    if unknown_tables:
        result["ok"] = False
        result["unknown_tables"] = unknown_tables

    col_to_tables = {}
    for tbl, cols in mapping.items():
        for c in cols:
            col_to_tables.setdefault(c, set()).add(tbl)

    from_tables = set(tables)
    ambiguous = set()
    unknown_cols = []

    for col in ast.find_all(exp.Column):
        col_name = col.name
        qualifier = col.table
        if not col_name:
            continue

        if qualifier:
            qual = str(qualifier)
            base_table_for_alias = None
            for j in ast.find_all(exp.Alias):
                pass
            table_name = qual.strip("`")
            if table_name in mapping:
                if col_name not in mapping[table_name]:
                    unknown_cols.append((col_name, table_name))
            else:
                resolved = False
                for sub in ast.find_all(exp.From):
                    for source in sub.find_all(exp.Table):
                        alias = source.args.get("alias")
                        if alias and alias.name == qual and source.name in mapping:
                            if col_name not in mapping[source.name]:
                                unknown_cols.append((col_name, source.name))
                            resolved = True
                            break
                    if resolved:
                        break
                if not resolved:
                    unknown_cols.append((f"{qual}.{col_name}", None))
        else:
            candidates = [t for t in from_tables if col_name in mapping.get(t, [])]
            if len(candidates) == 0:
                unknown_cols.append((col_name, None))
            elif len(candidates) > 1:
                ambiguous.add(col_name)
            # if exactly 1 → fine

    if unknown_cols or ambiguous:
        result["ok"] = False
        result["unknown_columns"] = unknown_cols
        result["ambiguous_columns"] = sorted(ambiguous)
    result["details"]["from_tables"] = tables
    return result


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
                lines.append(f"    Filters:")
                for k, v in filt.items():
                    vv = ", ".join(map(str, v)) if isinstance(v, (list, tuple)) else str(v)
                    lines.append(f"      {k}: {vv}")
            else:
                lines.append(f"  - Entity: {ent}, Filters: {filt if filt else '{}'}")

    while lines and not lines[-1].strip():
        lines.pop()

    return "\n".join(lines)


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
workflow.add_edge("detect_entities", "build_context")
workflow.add_edge("build_context", "generate_sql")   
workflow.add_edge("generate_sql","validate_sql")
workflow.add_conditional_edges("validate_sql",router,{"repair":"repair_sql","end":END})
workflow.add_edge("repair_sql","validate_sql")
checkpointer=MemorySaver()
app=workflow.compile(checkpointer=checkpointer)


#to execute the sql returned inside frappe
@frappe.whitelist(allow_guest=False)
def execute_query(query:str):
    # q = (query or "").strip()
    # if not q.upper().startswith("SELECT") or ";" in q:
    #     return {"error": "Only a single SELECT statement is allowed."}
    try:
        result=frappe.db.sql(query,as_dict=True)
        return result
    except Exception as e:
        return {"error":f"SQL Execution Failed : {e}"}


@frappe.whitelist(allow_guest=False)
def format_data(qstn, sql_data):
    if isinstance(sql_data, (dict, list)):
        db_result_json = json.dumps(sql_data, ensure_ascii=False, default=str)
    else:
        db_result_json = str(sql_data) if sql_data is not None else "{}"

    output = remote_llm_request_deploy_test(
        prompt="",
        task="format_db",
        question=qstn,
        db_result_json=db_result_json,
    )

    if isinstance(output, dict):
        if output.get("Error"):
            return {
                "answer": "Sorry, I couldn't format the data right now.",
                "error": output
            }
        answer = output.get("answer") or output.get("text") or json.dumps(output)
    else:
        answer = str(output)

    return {"answer": answer}
# to format the data returned afer execution using jinj2 template
@frappe.whitelist(allow_guest=False)
def format_data_conversationally(user_data):
    """
    Formats user data using the single, powerful conversational Jinja2 template.
    """
    env = jinja2.Environment(
        trim_blocks=True, lstrip_blocks=True, extensions=["jinja2.ext.do"]
    )
    template = env.from_string(CONVERSATION_TEMPLATE)
    return template.render(data=user_data)


def save_logs(
    user_question=None,
    formatted_q=None,
    context=None,
    sql=None,
    val=None,
    result=None,
    tries=None,
    err=None,
    formatted_result=None,
):
    def to_json_if_needed(v):
        if isinstance(v, (dict, list)):
            return json.dumps(v, default=str)
        return v
    val = to_json_if_needed(val)
    result = to_json_if_needed(result)
    err = to_json_if_needed(err)
    context = to_json_if_needed(context)
    formatted_result = to_json_if_needed(formatted_result)
    doc = frappe.new_doc("ChangAI Logs")
    doc.user_question = user_question
    doc.rewritten_question = formatted_q
    doc.schema_retrieved = context
    doc.sql_generated = sql
    doc.validation = val
    doc.tries = tries
    doc.error = err
    doc.result = result
    doc.formatted_result = formatted_result
    doc.insert(ignore_permissions=True)
    frappe.db.commit()
    return doc.name


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
    "entity_raw": final.get("entity_raw"),
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

    sql = (final.get("sql") or "").strip()
    formatted_q = (final.get("formatted_q") or "").strip()
    formatting_prompt = (final.get("formatting_prompt") or "")
    sql_prompt = (final.get("sql_prompt") or "")
    val = final.get("validation") or {}
    ok = bool(val.get("ok"))
    if not ok or not sql.upper().startswith("SELECT"):
        context = (final.get("context") or "")[:800]
        tries = int(final.get("tries") or 0)
        err = final.get("error")
        return {
            "Question":user_question,
            "Formatted_Question":formatted_q,
            "Context": context,
            "SQLPrompt":sql_prompt,
            "Reformatting_Prompt":formatting_prompt,
            "SQL": sql,
            "Validation": val,
            "EntityDebug": entity_debug,
            "Tries": tries,
            "Error": err or "SQL not valid or missing",
            "Result": [],
            "Bot": "I couldn’t produce a valid SQL yet. Please try rephrasing.",
        }
    
    result = execute_query(sql)
    context = (final.get("context") or "")[:800]
    tries = int(final.get("tries") or 0)
    err = final.get("error")
    formatted_result = format_data(formatted_q,result)
    bot_answer = formatted_result
    if not err:
        try:
            save_turn_2(session_id=chat_id,user_text=formatted_q,bot_text=formatted_result)
            save_logs(user_question=user_question,formatted_q=formatted_q,context=context,sql=sql,val=val,result=result,formatted_result=formatted_result)
        except Exception as e:
            return e
    return {
        "Question":user_question,
        # "Reformatting_Prompt":formatting_prompt,
        # "Formatted_Question":formatted_q,
        # "Context": context,
        # "SQLPrompt":sql_prompt,
        "SQL": sql,
        "Validation": val,
        "Tries": tries,
        "Error": err,
        "Result": result,
        # "EntityDebug": entity_debug,
        "Bot": bot_answer,
    }


@frappe.whitelist(allow_guest=False)
def respond_from_cache(user_question:str):
    if user_question:
        doc=frappe.db.get_value("ChangAI Logs",{"user_question":user_question},["sql_generated","result"],as_dict=False)
        return doc



@frappe.whitelist(allow_guest=False)
def test_rewrite_question(user_question: str, chat_id: str):
    state: SQLState = {
        "question": user_question,
        "session_id": chat_id,
    }

    out = rewrite_question(state)
    return out

@frappe.whitelist(allow_guest=False)
def debug_entity_retriever(q: str):
    resp = remote_entity_embedder(q)   # this returns {"ok":..., "body":...}
    return {
        "query": q,
        "raw_response": resp,
        "parsed_entity_cards": call_entity_retriever(q),
    }
