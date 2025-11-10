from typing import TypedDict,List,Dict,Any,Optional
from langgraph.graph import StateGraph,END
# from langgraph_checkpoint_redis import RedisSaver
from langgraph.checkpoint.memory import MemorySaver   #Short Term Memory
from collections import OrderedDict
from typing import Any, Dict, Iterable, List, Tuple, Union
# from changai.changai.api.build_docs import search_faiss, fill_sql_prompt
from sqlglot import exp
import requests, json, re, os
import sqlglot
from langsmith.run_helpers import traceable
import jinja2
from langchain_ollama import OllamaEmbeddings
# import faiss
# from tqdm import tqdm
from time import time
from langchain_community.vectorstores import FAISS
# from langchain.chains import create_history_aware_retriever
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
import frappe
# from langchain.chains import create_history_aware_retriever
# from changai.changai.api.v2.memory import __get_memory, load_history, save_turn
import re, json, requests, frappe
# from langgraph.checkpoint.memory import InMemorySaver
from typing import Dict
from langchain_ollama import ChatOllama
from langchain_core.callbacks import Callbacks 
from langchain_core.caches import BaseCache
from datetime import datetime,timedelta
from langgraph.checkpoint.memory import MemorySaver
# from langgraph.checkpoint.sqlite import SqliteSaver
from langchain_core.messages import HumanMessage, AIMessage
from langchain_community.chat_message_histories import SQLChatMessageHistory
from langchain_core.chat_history import InMemoryChatMessageHistory

from changai.changai.api.v2.store_chats import save_turn,save_message_doc,inject_prompt
LAST_SEEN:Dict[str,datetime]={}
non_erp_res=""
MAX_TOKEN_LIMIT=1500
MAX_WINDOW_TURNS=10
IDLE_EVICT_AFTER=timedelta(hours=6)
# def __llm(base_url:str,model:str) -> ChatOllama:
#     return ChatOllama(base_url=base_url,model=model, temperature=0)

# @frappe.whitelist(allow_guest=True)
# def __get_memory(session_id,base_url: str, model: str) -> ConversationSummaryBufferMemory:
#     mem=MEMORIES.get(session_id)
#     if mem is None:
#         mem=ConversationSummaryBufferMemory(
#             llm=__llm(base_url,model),
#             max_token_limit=MAX_TOKEN_LIMIT,
#             return_messages=True,
#             memory_key="history"
#         )
#         MEMORIES[session_id] = mem
#     LAST_SEEN[session_id]=datetime.utcnow()
#     return mem


# def save_turn(session_id: str, base_url: str, model: str, user_text: str, bot_text: str):
#     mem = __get_memory(session_id, base_url, model)
#     mem.save_context({"input": user_text or ""}, {"output": bot_text or ""})
#     LAST_SEEN[session_id] = datetime.utcnow()

# def load_history(session_id: str, base_url: str, model: str):
#     mem = __get_memory(session_id, base_url, model)
#     return mem.load_memory_variables({}).get("history", [])


# def evict_idle_():
#     now=datetime.utcnow()
#     for sid,seen in list(LAST_SEEN.items()):
#         if now - seen >IDLE_EVICT_AFTER:
#             MEMORIES.pop(sid,None)
#             LAST_SEEN.pop(sid,None)



__vector_store = None

@frappe.whitelist(allow_guest=True)
def get_settings():
    settings=frappe.get_single("ChangAI Settings")
    langsmith_tracing = "true" if settings.langsmith_tracing else "false"
    config={
        "LANGSMITH_TRACING" : langsmith_tracing,
        "LANGSMITH_ENDPOINT" : settings.langsmith_endpoint,
        "LANGSMITH_API_KEY" : settings.langsmith_api_key,
        "LANGSMITH_PROJECT" : settings.langsmith_project,
        "ROOT_PATH":settings.root_path,
        "OLLAMA_URL":settings.ollama_url,
        "OLLAMA_MODEL":settings.ollama_llm_model,
        "EMBED_MODEL":settings.ollama_embed_model,
        "RETAIN_MEM":settings.retain_memory
    }
    return config

CONFIG = get_settings()
RETRY_LIMIT=2
INDEX_PATH = f"{CONFIG['ROOT_PATH']}/changai/changai/changai/faiss_index_hnsw_v2"
MAPPING_SCHEMA_PATH = f"{CONFIG['ROOT_PATH']}/changai/changai/changai/api/v2/metaschema_clean_v2.json"
SQL_PROMPT_PATH=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/prompts/sql_prompt.txt"
FORMAT_PROMPT_PATH=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/prompts/formatting_prompt.txt"
TEMPLATE_PATH=f"{CONFIG['ROOT_PATH']}/changai/changai/changai/templates/conversation_template_v2.j2"
BUSINESS_KEYWORDS_PATH = f"{CONFIG['ROOT_PATH']}/changai/changai/changai/api/v2/business_keywords_v1.json"
GRAPH_DB_PATH = f"{CONFIG['ROOT_PATH']}/changai/changai/changai/runtime/changai_graph.db"
CHAT_DB_PATH = f"{CONFIG['ROOT_PATH']}/changai/changai/changai/runtime/changai_chat.db"

INPROC_HISTORIES: Dict[str, InMemoryChatMessageHistory] = {}
def checkpointer_init():
    if CONFIG["RETAIN_MEM"]:
        return SqliteSaver.from_conn_string(f"sqlite:///{GRAPH_DB_PATH}")
    return MemorySaver()

def _get_chat_history(session_id: str):
    if CONFIG['RETAIN_MEM']:
        return SQLChatMessageHistory(
            session_id=session_id,
            connection_string=f"sqlite:///{CHAT_DB_PATH}",
        )
    # volatile (per-process)
    hist = INPROC_HISTORIES.get(session_id)
    if not hist:
        hist = InMemoryChatMessageHistory()
        INPROC_HISTORIES[session_id] = hist
    return hist
# def save_turn(session_id: str, base_url: str, model: str, user_text: str, bot_text: str):
#     hist = _get_chat_history(session_id)
#     if user_text:
#         hist.add_user_message(user_text)
#     if bot_text:
#         hist.add_ai_message(bot_text)

def load_history(session_id: str, base_url: str, model: str):
    hist = _get_chat_history(session_id)
    return hist.messages[-MAX_WINDOW_TURNS:]

@frappe.whitelist(allow_guest=True)
def contextualize_query(session_id: str, user_input: str):
    SYSTEM_MSG = (
        "You are a query rewriter. "
        "Rewrite the user's latest message into a clear, self-contained question using brief chat history. "
        "Return only the rewritten question text — no explanations, no formatting, no JSON."
    )

    history_msgs = load_history(session_id, CONFIG["OLLAMA_URL"], CONFIG["OLLAMA_MODEL"]) or []
    messages = [{"role": "system", "content": SYSTEM_MSG}]
    for m in history_msgs[-10:]:
        role = "user" if getattr(m, "type", "") == "human" else "assistant"
        messages.append({"role": role, "content": getattr(m, "content", "")})
    messages.append({"role": "user", "content": user_input or ""})

    url = f"{CONFIG['OLLAMA_URL']}/api/chat"
    payload = {
        "model": CONFIG["OLLAMA_MODEL"],
        "messages": messages,
        "stream": False,
        "options": {"temperature": 0, "num_predict": 128},
    }

    try:
        res = requests.post(url, json=payload, timeout=20)
        res.raise_for_status()
        rewritten = (res.json().get("message", {}).get("content") or "").strip()
        # strip accidental fences
        rewritten = re.sub(r"^```.*?```$", "", rewritten, flags=re.S).strip("` \n\"'")
        return rewritten or (user_input or "")
    except Exception:
        return user_input or ""

# @frappe.whitelist(allow_guest=True)
# def forget_session(session_id: str):
#     if PERSIST_CHAT:
#         # SQLChatMessageHistory exposes .clear() in recent versions
#         SQLChatMessageHistory(session_id, f"sqlite:///{CHAT_DB_PATH}").clear()
#     else:
#         INPROC_HISTORIES.pop(session_id, None)
#     return {"ok": True}

@frappe.whitelist(allow_guest=True)
def debug_history(session_id: str):
    hist = _get_chat_history(session_id).messages
    return {
        "session_id": session_id,
        "len": len(hist),
        "last_two": [m.content for m in hist[-2:]],
        "types": [m.type for m in hist],
    }


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
BUSINESS_KEYWORDS=read_json(BUSINESS_KEYWORDS_PATH)["business_keywords"]

if not os.path.exists(INDEX_PATH):
    frappe.logger().warning(f"FAISS index not found at {INDEX_PATH}")
else:
    _emb = OllamaEmbeddings(base_url=CONFIG['OLLAMA_URL'], model=CONFIG['EMBED_MODEL'])
    __vector_store = FAISS.load_local(INDEX_PATH, embeddings=_emb, allow_dangerous_deserialization=True)


# # Shared State
class SQLState(TypedDict,total=False):
    session_id:str
    question: str
    formatted_q:Dict[str,Any]
    hits: List[Any]
    context :str
    sql_prompt:str 
    sql:str
    validation:Dict[str,Any]
    error:Optional[str]
    tries:int
    query_type:str
    non_erp_res:str

# InMemorySaver -> wiped after restart
# checkpointer = MemorySaver()     

def fill_sql_prompt(question: str, context: str) -> str:
    return SQL_PROMPT.format(question=question, context=context)


def guardrail_router(state:SQLState) -> SQLState:
    q=(state.get("formatted_q","")).lower()
    keywords=[kw.lower() for kw in BUSINESS_KEYWORDS]
    is_erp=any(kw in q for kw in keywords)
    return {**state,"query_type":"ERP" if is_erp else "NON_ERP"}


NON_ERP_PROMPT="""You are ChangAI, a friendly assistant.

The user message: {qstn}

If the message is casual or conversational (not ERP related),
reply naturally with a short, polite response (1–2 sentences max).
Avoid technical or formal tone."""

def send_non_erp_request(state:SQLState) -> SQLState:
    prompt=NON_ERP_PROMPT.format(qstn=state.get("question",""))
    url=f"{CONFIG['OLLAMA_URL']}/api/generate"
    payload={
        "model":CONFIG['OLLAMA_MODEL'],
        "prompt":prompt,
        "stream":False
    }
    try:
        r=requests.post(url,json=payload,timeout=120)
        r.raise_for_status()
        data=r.json()
        non_erp_res=(data.get("response") or "").strip()
        return {**state,"prompt":prompt,"non_erp_res":non_erp_res,"error":None}
    except Exception as e:
        return {**state,"non_erp_res": "", "error": f"NON-ERP call failed: {e}"}


def call_llm(state:SQLState) -> SQLState:
    user_qstn=state.get("question")
    session_id=state.get("session_id")
    prompt=inject_prompt(user_qstn,session_id)
    url = f"{CONFIG['OLLAMA_URL']}/api/generate"
    payload = {
        "model":CONFIG["OLLAMA_MODEL"],
        "prompt": prompt,
        "stream": False,
        "options": {"temperature": 0, "num_predict": 128},
    }

    try:
        res = requests.post(url, json=payload)
        res.raise_for_status()
        data=res.json()
        response=(data.get("response") or "").strip()
        return {**state, "formatted_q": response}
    except Exception as e:
        return {**state, "error": str(e),"formatted_q": None}

# # Node 1: Retrive with Fiass Vector Store.
@traceable(name="schema_retriever", run_type="tool")
def schema_retriever(state: SQLState) -> SQLState:
    if "__vector_store" not in globals() or __vector_store is None:
        return {**state, "hits": [],"error":"Vector index unavailable"}
    hits = __vector_store.similarity_search(state["formatted_q"], k=12)
    return {**state, "hits": hits}


# # Node 2: Build schema context from hits - for SQL Prompt
@traceable(name="hits_to_prompt_context", run_type="tool")
def hits_to_prompt_context(state:SQLState) -> SQLState:
    ctx=hits_to_schema_context(state["hits"],title="SCHEMA CONTEXT",max_fields_per_table=25)
    return {**state,"context":ctx}


# # Node 3:Generate the SQL Prompt and call LLM(Ollama Http)
@traceable(name="generate_sql", run_type="tool")
def generate_sql(state:SQLState) -> SQLState:
    prompt=fill_sql_prompt(state["formatted_q"],state["context"])
    url=f"{CONFIG['OLLAMA_URL']}/api/generate"
    payload={
        "model":CONFIG['OLLAMA_MODEL'],
        "prompt":prompt,
        "stream":False
    }
    try:
        r=requests.post(url,json=payload,timeout=120)
        r.raise_for_status()
        data=r.json()
        sql=(data.get("response") or "").strip()
        return {**state,"prompt":prompt,"sql":sql,"error":None}
    except Exception as e:
        return {**state,"error": f"LLM call failed: {e}"}


# # Node 4:Validate the SQL Generate with meta schema mapping using SQLGlot
@traceable(name="validate_sql", run_type="tool")
def validate_sql(state: SQLState) -> SQLState:
    sql=state.get("sql") or ""
    if not sql.upper().startswith("SELECT"):
        return {**state,"validation":{"ok":False,"details":{"parse_error":"Not a SELECT Query"}}}
    val = validate_sql_against_mapping(sql,mapping_data,dialect="mysql")
    return {**state,"validation":val}


# # Node 5:Repair Loop :Simple prompt for one more try.
@traceable(name="repair_sqlquery", run_type="tool")
def repair_sqlquery(state:SQLState)->SQLState:
    hints: List[str] = []
    tries=int(state.get("tries") or 0)+1
    val=state.get("validation",{})
    unknown_tables=val.get("unknown_tables",[])
    unknown_cols=val.get("unknown_columns",[])
    ambiguous=val.get("ambiguous_columns",[])
    if unknown_tables:
        hints.append(f"Unknown tables:{unknown_tables}.Use only tables in context")
    if unknown_cols:
        hints.append(f"Unknown Columns:{unknown_cols}.Use only fields listed for each tables from the context")
    if ambiguous:
        hints.append(f"Ambiguous columns(qualify them):{ambiguous}")
    patched_prompt=state["prompt"]+"\n\n#VALIDATION HINTS\n"+"\n".join(f"-{h}" for h in hints)
    # print(patched_prompt)
    payload={"model":CONFIG['OLLAMA_MODEL'],"prompt":patched_prompt,"stream":False,"options": {"temperature": 0,},}
    url=f"{CONFIG['OLLAMA_URL']}/api/generate"
    try:
        r=requests.post(url,json=payload,timeout=120)
        r.raise_for_status()
        data=r.json()
        # print(data)
        sql=(data.get("response") or "").strip()
        return {**state,"sql":sql,"tries":tries,"error":None}

    except Exception as e:
        return {**state,"error":f"Repair call failed {e}"}



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
        "unknown_columns": [],      # list of (column, table_context or None)
        "ambiguous_columns": [],    # list of column names
        "details": {}
    }

    # Parse
    try:
        ast = sqlglot.parse_one(sql_text, read=dialect)
        # print(ast)
    except Exception as e:
        result["ok"] = False
        result["details"]["parse_error"] = str(e)
        return result

    # Collect referenced tables (as they appear in SQL, including backticks)
    tables = []
    for t in ast.find_all(exp.Table):
        name = t.name  # identifier only (no catalog/db)
        if name:
            tables.append(name)

    # De-dup & check tables
    tables = list(dict.fromkeys(tables))
    unknown_tables = [t for t in tables if t not in mapping]
    if unknown_tables:
        result["ok"] = False
        result["unknown_tables"] = unknown_tables

    # Build quick reverse index for column → tables that contain it
    col_to_tables = {}
    for tbl, cols in mapping.items():
        for c in cols:
            col_to_tables.setdefault(c, set()).add(tbl)

    # Collect column refs
    # If column has qualifier (table alias/name), use it; else check ambiguity
    from_tables = set(tables)  # tables actually in this query’s FROM/JOIN
    ambiguous = set()
    unknown_cols = []

    for col in ast.find_all(exp.Column):
        col_name = col.name
        qualifier = col.table  # table/alias (if present)
        if not col_name:
            continue

        if qualifier:
            # Qualified column → check against that table or alias
            qual = str(qualifier)
            # If alias used, try to resolve alias -> base table (simple heuristic)
            # Get aliased names from the AST
            base_table_for_alias = None
            for j in ast.find_all(exp.Alias):
                # not every Alias is a table alias; but sqlglot uses TableAlias for FROM
                pass
            # Simple approach: accept qualifier as a table name as-is
            table_name = qual.strip("`")
            if table_name in mapping:
                if col_name not in mapping[table_name]:
                    unknown_cols.append((col_name, table_name))
            else:
                # If qualifier isn't a table in mapping, try to see if it's an alias of a real table
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
                    # Unknown qualifier (alias/table)
                    unknown_cols.append((f"{qual}.{col_name}", None))
        else:
            # Unqualified: check which of the FROM tables have this column
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

    # Some helpful context
    result["details"]["from_tables"] = tables
    return result


def hits_to_schema_context(
    hits: Union[List[Any],Dict, str],
    title: str = "SCHEMA CONTEXT",
    max_fields_per_table: int = 20,
    sort_sections: bool = True,
    show_entity_filters_yaml: bool = True
) -> str:

    def _to_txt_md(doc: Any) -> Tuple[str, Dict]:
        if hasattr(doc, "page_content"):
            return getattr(doc, "page_content", "") or "", getattr(doc, "metadata", {}) or {}
        # dict
        if isinstance(doc, dict):
            return doc.get("text", "") or "", doc.get("metadata", {}) or {}
        # str
        if isinstance(doc, str):
            return doc, {}
        return "", {}

    docs = []
    if isinstance(hits, (dict, str)) or hasattr(hits, "page_content"):
        docs.append(_to_txt_md(hits))
    else:
        for d in (hits or []):
            docs.append(_to_txt_md(d))

    # # --- helpers ---
    def _parse_tag(txt: str, tag: str) -> str:
        m = re.search(rf"\[{re.escape(tag)}\]\s*(.+?)(?:\s*\||\s*$)", txt or "")
        return m.group(1).strip() if m else ""

    def _infer_type(txt: str) -> str:
        if not (txt or "").startswith("["): return ""
        order = [
            ("TABLE","table"), ("FIELD","field"), ("JOIN","join"),
            ("METRIC","metric"), ("ENUM","enum"), ("PERIOD","period"),
            ("CURRENCY","currency"), ("ENTITY","entity")
        ]
        for tg, tp in order:
            if txt.startswith(f"[{tg}]"): return tp
        return ""

    # # --- accumulators ---
    tables: List[str] = []
    fields_by_table: Dict[str, List[str]] = OrderedDict()
    joins: List[str] = []
    metrics: List[Tuple[str, str, str]] = []  # (metric_name, expression, table)
    periods: List[str] = []
    currencies: List[str] = []
    enums: OrderedDict[str, str] = OrderedDict()
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
            if mtbl: _add_table(mtbl)
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
            # field may be in metadata or embedded in [ENUM] table.field
            fld = md.get("field")
            if not fld:
                ef = _parse_tag(txt, "ENUM")
                if "." in ef:
                    tbl = tbl or ef.split(".", 1)[0].strip()
                    fld = ef.split(".", 1)[1].strip()
            if tbl: _add_table(tbl)
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
                # parse [FILTERS] key=v1,v2; key2=v3
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
            fields_by_table[t] = sorted(fields_by_table[t], key=lambda s: s.split(".",1)[1])
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
workflow.add_node("call_llm",call_llm)
workflow.add_node("guardrail_router",guardrail_router)
workflow.add_node("retrieve",schema_retriever)
workflow.add_node("build_context",hits_to_prompt_context)
workflow.add_node("generate_sql",generate_sql)
workflow.add_node("validate_sql",validate_sql)
workflow.add_node("repair_sql",repair_sqlquery)
workflow.add_node("send_non_erp_request",send_non_erp_request)

workflow.set_entry_point("call_llm")
workflow.add_edge("call_llm", "guardrail_router")
workflow.add_conditional_edges("guardrail_router",route_guardrail,{"ERP":"retrieve","NON_ERP":"send_non_erp_request"})
workflow.add_edge("send_non_erp_request", END)
workflow.add_edge("retrieve","build_context")
workflow.add_edge("build_context","generate_sql")
workflow.add_edge("generate_sql","validate_sql")
# conditional edge after validation
# go to repair sql node.If repair function returns repair else END
workflow.add_conditional_edges("validate_sql",router,{"repair":"repair_sql","end":END})
#after repair,go back to validate
workflow.add_edge("repair_sql","validate_sql")

# optional memory/persistence
checkpointer=MemorySaver()
app=workflow.compile(checkpointer=checkpointer)
# app=workflow.compile()

# Run
    # initial_state=SQLState(question="show all sales invoices?")
    # config = {
    #     "run_name": "changai_text2sql_graph",
    #     "run_type": "graph",          # ✅ Main workflow = graph
    #     "tags": ["changai", "rag", "sql"],
    #     "metadata": {"tenant": "demo"}
    # }
    # t0 = time()
    # final=app.invoke(initial_state,config=config)
    # t1=time()
    # print(f"⏱️ Retrieval time: {(t1 - t0)*1000:.2f} ms")

    # print("Question:",final["question"])
    # print("\n---- Context(truncated) ----")
    # print(final["context"][:800],".....\n")
    # print("---- SQL -----")
    # print(final.get("sql"))
    # print("\n---- Validation ----")
    # print(final.get("validation"))
    # print("\n Tries",final.get("tries",0),"Error:",final.get("error"))


@frappe.whitelist(allow_guest=True)
def execute_query(query:str):
    # q = (query or "").strip()
    # if not q.upper().startswith("SELECT") or ";" in q:
    #     frappe.throw("Only single SELECT statements are allowed.")
    try:
        result=frappe.db.sql(query,as_dict=True)
        return result
    except Exception as e:
        return {"error":f"SQL Execution Failed : {e}"}

@frappe.whitelist(allow_guest=True)
def format_data(qstn,sql,data):
    payload={
        "model":"gemma3:270m",
        "prompt":FRIENDLY_PROMPT.format(question=qstn,sql=sql,data=data),
        "stream":False
    }
    try:
        res=requests.post(f"{CONFIG['OLLAMA_URL']}/api/generate",json=payload,timeout=120)
        res.raise_for_status()
        pretty_text=res.json().get("response","").strip()
        return {"text": pretty_text}
    except Exception as e:
        return {"text": f"Unable to format response quickly.{e}"}


@frappe.whitelist(allow_guest=True)
def format_data_conversationally(user_data):
    """
    Formats user data using the single, powerful conversational Jinja2 template.
    """
    env = jinja2.Environment(
        trim_blocks=True, lstrip_blocks=True, extensions=["jinja2.ext.do"]
    )
    template = env.from_string(CONVERSATION_TEMPLATE)
    return template.render(data=user_data)


@frappe.whitelist(allow_guest=True)
def test(chat_id):
    config = {
        "configurable": {"thread_id": chat_id},
        "run_name": "changai_text2sql_graph",
        "run_type": "graph",
        "tags": ["changai", "rag", "sql"],
        "metadata": {"tenant": "demo"},
    }
    st = app.get_state(config)
    checkpoint_id = getattr(st, "checkpoint_id", None)
    return {"checkpoint_id":checkpoint_id}
# Run
@frappe.whitelist(allow_guest=True)
def run_text2sql_pipeline(user_question: str, chat_id: str):
    q = (user_question or "").strip()

    config = {
        "configurable": {"thread_id": chat_id},
        "run_name": "changai_text2sql_graph",
        "run_type": "graph",
        "tags": ["changai", "rag", "sql"],
        "metadata": {"tenant": "demo"},
    }

    # pull prior state (works only if you compiled with a checkpointer)
    st = app.get_state(config)
    # prior_chat = []
    # if st and getattr(st, "values", None):
    #     prior_chat = st.values.get("chat", []) or []
    # # run graph
    initial_state: SQLState = {
        "question": q,
        "session_id":chat_id
    }
    final: SQLState = app.invoke(initial_state, config=config)

    # router result
    type_ = final.get("query_type") or "NON_ERP"
    if type_ == "NON_ERP":
        non_erp_res = (final.get("non_erp_res") or "").strip()
        formatted_q = (final.get("formatted_q") or "").strip()

        # new_chat = prior_chat + [
        #     {"role": "user", "content": q},
        #     {"role": "assistant", "content": non_erp_res},
        # ]
        # keep the in-graph chat memory short
        # if len(new_chat) > 40:
        #     new_chat = new_chat[-40:]

        # app.update_state(config, {"chat": new_chat})
        try:
            save_turn(session_id=chat_id,
                    user_text=formatted_q,
                    bot_text=non_erp_res)
        except Exception as e:
            return e
        return {"Bot": non_erp_res}

    # ERP path
    sql = (final.get("sql") or "").strip()
    formatted_q = (final.get("formatted_q") or "").strip()
    val = final.get("validation") or {}
    ok = bool(val.get("ok"))

    if not ok or not sql.upper().startswith("SELECT"):
        # don’t execute invalid SQL; surface debug info
        context = (final.get("context") or "")[:800]
        tries = int(final.get("tries") or 0)
        err = final.get("error")
        return {
            "Question":user_question,
            "Formatted-Question":formatted_q,
            "Context": context,
            "SQL": sql,
            "Validation": val,
            "Tries": tries,
            "Error": err or "SQL not valid or missing",
            "Result": [],
            "Bot": "I couldn’t produce a valid SQL yet. Please try rephrasing.",
        }

    # safe to execute
    result = execute_query(sql)
    context = (final.get("context") or "")[:800]
    tries = int(final.get("tries") or 0)
    err = final.get("error")

    # format for user
    formatted_result = format_data_conversationally(result)

    # # update chat state
    # new_chat = prior_chat + [
    #     {"role": "user", "content": q},
    #     {"role": "assistant", "content": formatted_result},
    # ]
    # if len(new_chat) > 40:
    #     new_chat = new_chat[-40:]
    # app.update_state(config, {"chat": new_chat})
    try:
        save_turn(session_id=chat_id,
                    user_text=formatted_q,
                    bot_text=formatted_result)
    except Exception as e:
        return e
    
    return {
        "Question":user_question,
        "Formatted_Question":formatted_q,
        "Context": context,
        "SQL": sql,
        "Validation": val,
        "Tries": tries,
        "Error": err,
        "Result": result,
        "Bot": formatted_result,
    }


# if __name__== "__main__":
#         print(f"⏱️ Retrieval time: {(t1 - t0)*1000:.2f} ms")
#         print("Question:",final["question"])
#         print("\n---- Context(truncated) ----")
#         print(final["context"][:800],".....\n")
#         print("---- SQL -----")
#         print(final.get("sql"))
#         print("\n---- Validation ----")
#         print(final.get("validation"))
#         print("\n Tries",final.get("tries",0),"Error:",final.get("error"))
#         sql=final.get("sql")
#         data=execute_query(sql)
#         print(data)

# result=execute_query("SELECT * FROM `tabCustomer`;")
# print(result)
