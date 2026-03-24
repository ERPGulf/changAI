from typing import Any, Dict, Optional
from cog import BasePredictor, Input
import json
import re
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

MAIN_MODEL_ID = "hyrinmansoor/qwen3-4b-instruct-2507"
FORMATTER_MODEL_ID = "hyrinmansoor/qwen2.5-1.5b-instruct"

MAX_NEW_TOKENS_LLM = 256
MAX_NEW_TOKENS_FORMATTER = 180
MAX_NEW_TOKENS_HELPDESK = 120


class Predictor(BasePredictor):
    def setup(self) -> None:
        self.main_tokenizer = None
        self.main_model = None

        self.fmt_tokenizer = None
        self.fmt_model = None

    # ---------------- Loaders ----------------

    def _ensure_main_loaded(self) -> None:
        if self.main_model is None or self.main_tokenizer is None:
            self.main_tokenizer = AutoTokenizer.from_pretrained(
                MAIN_MODEL_ID, use_fast=True
            )
            self.main_model = AutoModelForCausalLM.from_pretrained(
                MAIN_MODEL_ID,
                torch_dtype="auto",
                device_map="auto",
            )

    def _ensure_formatter_loaded(self) -> None:
        if self.fmt_model is None or self.fmt_tokenizer is None:
            self.fmt_tokenizer = AutoTokenizer.from_pretrained(
                FORMATTER_MODEL_ID, use_fast=True
            )
            self.fmt_model = AutoModelForCausalLM.from_pretrained(
                FORMATTER_MODEL_ID,
                torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32,
                device_map="auto",
            )

    # ---------------- Helpers ----------------

    def _run_main_llm(
        self, user_input: str, max_new_tokens: int = MAX_NEW_TOKENS_LLM
    ) -> str:
        """Runs Qwen3-4B (rewrite/SQL etc.)."""
        self._ensure_main_loaded()
        messages = [{"role": "user", "content": user_input}]
        text = self.main_tokenizer.apply_chat_template(
            messages, tokenize=False, add_generation_prompt=True
        )

        model_inputs = self.main_tokenizer([text], return_tensors="pt").to(
            self.main_model.device
        )
        with torch.no_grad():
            generated_ids = self.main_model.generate(
                **model_inputs, max_new_tokens=int(max_new_tokens)
            )

        output_ids = generated_ids[0][len(model_inputs.input_ids[0]) :]
        return self.main_tokenizer.decode(output_ids, skip_special_tokens=True).strip()

    def _run_formatter_llm(self, prompt: str, max_new_tokens: int) -> str:
        """Runs Qwen2.5-1.5B (formatting + classification tasks)."""
        self._ensure_formatter_loaded()

        messages = [{"role": "user", "content": prompt}]
        chat_prompt = self.fmt_tokenizer.apply_chat_template(
            messages, tokenize=False, add_generation_prompt=True
        )
        inputs = self.fmt_tokenizer(chat_prompt, return_tensors="pt").to(
            self.fmt_model.device
        )

        with torch.inference_mode():
            out = self.fmt_model.generate(
                **inputs,
                max_new_tokens=int(max_new_tokens),
                do_sample=False,
                temperature=0.2,
                repetition_penalty=1.05,
            )

        gen = out[0][inputs["input_ids"].shape[-1] :]
        return self.fmt_tokenizer.decode(gen, skip_special_tokens=True).strip()

    def _extract_first_json(self, text: str) -> Optional[Dict[str, Any]]:
        """Try hard to parse a JSON object from model output."""
        if not text:
            return None
        text = text.strip()

        # direct parse
        try:
            obj = json.loads(text)
            return obj if isinstance(obj, dict) else None
        except Exception:
            pass

        # extract first {...}
        m = re.search(r"\{.*\}", text, flags=re.DOTALL)
        if not m:
            return None
        try:
            obj = json.loads(m.group(0))
            return obj if isinstance(obj, dict) else None
        except Exception:
            return None

    def _helpdesk_task_prompt(self, user_message: str) -> str:
        # IMPORTANT: escaped braces ({{ }}) because this is an f-string
        return f"""
You are an ERPNext / Frappe Helpdesk classifier.

Return ONLY valid JSON. No extra text.

Decide:
- CREATE_TICKET: user reports a problem, error, request for support, or something not working; or asks to create/open/raise a ticket.
- TICKET_DETAILS: user asks about ONE existing ticket and explicitly mentions an id/number (e.g., "ticket 29", "case #29", "status of 29").
- GET_USER_TICKETS: user asks to list/show their tickets (e.g., "my tickets", "all my tickets", "open tickets", "tickets I raised").
- UNKNOWN: unclear or unrelated.

Output format (STRICT):
{{
  "task_flag": "CREATE_TICKET" | "TICKET_DETAILS" | "GET_USER_TICKETS" | "UNKNOWN",
  "ticket_id": <integer or null>,
  "confidence": 0.0-1.0,
  "reason": "<one short sentence>"
}}

Rules:
- ticket_id MUST be null unless the user explicitly provided a number.
- Never invent ids.
- For CREATE_TICKET / GET_USER_TICKETS / UNKNOWN: ticket_id must be null.

USER MESSAGE:
{user_message}
""".strip()

    def _db_formatter_prompt(self, question: str, db_result: Any) -> str:
        return f"""
INSTRUCTIONS:
- Convert raw database results into a short, friendly, human-readable answer.
- You may use BOTH: (1) the user question and (2) the DB result JSON to form the answer.
- Use ONLY values present in the JSON. NEVER invent numbers or fields.
- Keep the answer brief (1–6 lines).
- If the question asks for last/top/highest/total, interpret based strictly on the JSON rows.

QUESTION:
{question}

DATABASE_RESULT_JSON:
{json.dumps(db_result, ensure_ascii=False, default=str)}

OUTPUT:
Write a clear final answer for the user based strictly on the JSON above.
""".strip()

    # ---------------- Predict ----------------

   def _handle_llm_task(self, user_input: str) -> Any:
    if not user_input:
        return "Error: user_input is required when task='llm'."
    return self._run_main_llm(user_input=user_input)


def _parse_db_result_json(self, db_result_json: str) -> Any:
    return json.loads(db_result_json) if db_result_json else {}


def _is_empty_db_result(self, db_result: Any) -> bool:
    return (
        db_result is None
        or db_result == {}
        or (isinstance(db_result, list) and len(db_result) == 0)
    )


def _handle_format_db_task(self, question: str, db_result_json: str) -> Dict[str, Any]:
    try:
        db_result = self._parse_db_result_json(db_result_json)
    except Exception as e:
        return {
            "answer": "Invalid database result format. Unable to parse JSON.",
            "error": str(e),
        }

    if self._is_empty_db_result(db_result):
        return {"answer": "No results found."}

    prompt = self._db_formatter_prompt(question=question, db_result=db_result)
    answer = self._run_formatter_llm(
        prompt=prompt,
        max_new_tokens=MAX_NEW_TOKENS_FORMATTER,
    )
    return {"answer": answer}


def _normalize_helpdesk_flag(self, flag: Any) -> str:
    allowed = {"CREATE_TICKET", "TICKET_DETAILS", "GET_USER_TICKETS", "UNKNOWN"}
    return flag if flag in allowed else "UNKNOWN"


def _normalize_helpdesk_ticket_id(self, flag: str, ticket_id: Any) -> Optional[int]:
    if isinstance(ticket_id, bool):
        ticket_id = None

    if isinstance(ticket_id, str) and ticket_id.strip().isdigit():
        ticket_id = int(ticket_id.strip())

    if not isinstance(ticket_id, int):
        ticket_id = None

    if flag != "TICKET_DETAILS":
        return None

    return ticket_id


def _normalize_helpdesk_confidence(self, confidence: Any) -> float:
    try:
        confidence = float(confidence)
    except Exception:
        confidence = 0.5

    return max(0.0, min(1.0, confidence))


def _handle_empty_helpdesk_message(self) -> Dict[str, Any]:
    return {
        "task_flag": "UNKNOWN",
        "ticket_id": None,
        "confidence": 0.0,
        "reason": "Empty message.",
    }


def _handle_invalid_helpdesk_response(self, raw: str) -> Dict[str, Any]:
    return {
        "task_flag": "UNKNOWN",
        "ticket_id": None,
        "confidence": 0.2,
        "reason": "Model returned non-JSON.",
        "raw": raw[:300],
    }


def _handle_helpdesk_task(self, user_message: str) -> Dict[str, Any]:
    if not user_message or not user_message.strip():
        return self._handle_empty_helpdesk_message()

    prompt = self._helpdesk_task_prompt(user_message=user_message.strip())
    raw = self._run_formatter_llm(
        prompt=prompt,
        max_new_tokens=MAX_NEW_TOKENS_HELPDESK,
    )

    obj = self._extract_first_json(raw)
    if not obj:
        return self._handle_invalid_helpdesk_response(raw)

    flag = self._normalize_helpdesk_flag(obj.get("task_flag"))
    ticket_id = self._normalize_helpdesk_ticket_id(flag, obj.get("ticket_id"))
    confidence = self._normalize_helpdesk_confidence(obj.get("confidence"))

    return {
        "task_flag": flag,
        "ticket_id": ticket_id,
        "confidence": confidence,
    }


def predict(
    self,
    task: str = Input(
        description="Operation: 'llm' (rewrite/SQL), 'format_db' (friendly answer), 'helpdesk_task' (ticket intent)",
        default="llm",
        choices=["llm", "format_db", "helpdesk_task"],
    ),
    user_input: str = Input(
        description="Prompt for rewrite / SQL generation (task='llm')",
        default="",
    ),
    question: str = Input(
        description="Original user question (task='format_db')",
        default="",
    ),
    db_result_json: str = Input(
        description="Database result as JSON string (task='format_db')",
        default="{}",
    ),
    user_message: str = Input(
        description="User message to classify (task='helpdesk_task')",
        default="",
    ),
) -> Any:
    if task == "llm":
        return self._handle_llm_task(user_input)

    if task == "format_db":
        return self._handle_format_db_task(question, db_result_json)

    if task == "helpdesk_task":
        return self._handle_helpdesk_task(user_message)

    return {"error": f"Unknown task '{task}'"}