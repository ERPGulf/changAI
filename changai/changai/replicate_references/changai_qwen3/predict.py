from typing import Any, Dict
from cog import BasePredictor, Input
import json
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

MAIN_MODEL_ID = "Qwen/Qwen3-4B-Instruct-2507"
FORMATTER_MODEL_ID = "Qwen/Qwen2.5-1.5B-Instruct"

MAX_NEW_TOKENS_LLM = 256
MAX_NEW_TOKENS_FORMATTER = 180


class Predictor(BasePredictor):
    def setup(self) -> None:
        self.main_tokenizer = None
        self.main_model = None

        self.fmt_tokenizer = None
        self.fmt_model = None


    def _ensure_main_loaded(self) -> None:
        """Load Qwen3-4B once (for rewrite + SQL)."""
        if self.main_model is None or self.main_tokenizer is None:
            self.main_tokenizer = AutoTokenizer.from_pretrained(
                MAIN_MODEL_ID,
                use_fast=True,
            )
            self.main_model = AutoModelForCausalLM.from_pretrained(
                MAIN_MODEL_ID,
                torch_dtype="auto",
                device_map="auto",
            )

    def _ensure_formatter_loaded(self) -> None:
        """Load Qwen 1.5B once (for DB result formatting)."""
        if self.fmt_model is None or self.fmt_tokenizer is None:
            self.fmt_tokenizer = AutoTokenizer.from_pretrained(
                FORMATTER_MODEL_ID,
                use_fast=True,
            )
            self.fmt_model = AutoModelForCausalLM.from_pretrained(
                FORMATTER_MODEL_ID,
                torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32,
                device_map="auto",
            )

    # ---------- Helpers ----------

    def _run_main_llm(self, user_input: str, max_new_tokens: int = MAX_NEW_TOKENS_LLM) -> str:
        """
        Generic helper that runs Qwen3-4B for:
        - rewriting based on history
        - generating SQL
        (prompt decides the actual behavior)
        """
        self._ensure_main_loaded()

        messages = [
            {"role": "user", "content": user_input}
        ]

        text = self.main_tokenizer.apply_chat_template(
            messages,
            tokenize=False,
            add_generation_prompt=True,
        )

        model_inputs = self.main_tokenizer(
            [text],
            return_tensors="pt"
        ).to(self.main_model.device)

        with torch.no_grad():
            generated_ids = self.main_model.generate(
                **model_inputs,
                max_new_tokens=int(max_new_tokens),
            )

        output_ids = generated_ids[0][len(model_inputs.input_ids[0]):]
        content = self.main_tokenizer.decode(
            output_ids,
            skip_special_tokens=True
        )
        return content.strip()

    def _run_formatter_llm(self, question: str, db_result: Any,
                           max_new_tokens: int = MAX_NEW_TOKENS_FORMATTER) -> str:
        """
        Helper that runs Qwen 1.5B to convert raw DB result into a
        short, friendly, human-readable answer.
        """
        self._ensure_formatter_loaded()

        user_content = f"""
INSTRUCTIONS:
- You convert raw database results into a short, friendly, human-readable answer.
- You may use BOTH: (1) the user question and (2) the DB result JSON to form the answer.
- Use ONLY the values shown in the JSON. NEVER invent missing fields or numbers.
- Keep the answer brief (1–6 lines).
- DO NOT say "No results found." here. The database is NOT empty.
- If the question asks for a last / top / highest / total item, interpret based on the JSON rows.

QUESTION:
{question}

DATABASE_RESULT_JSON:
{json.dumps(db_result, ensure_ascii=False)}

OUTPUT:
Write a clear final answer for the user based strictly on the JSON above.
        """

        messages = [
            {"role": "user", "content": user_content}
        ]

        prompt = self.fmt_tokenizer.apply_chat_template(
            messages,
            tokenize=False,
            add_generation_prompt=True,
        )

        inputs = self.fmt_tokenizer(prompt, return_tensors="pt").to(self.fmt_model.device)

        with torch.inference_mode():
            out = self.fmt_model.generate(
                **inputs,
                max_new_tokens=int(max_new_tokens),
                do_sample=False,
                temperature=0.2,
                repetition_penalty=1.05,
            )

        gen = out[0][inputs["input_ids"].shape[-1]:]
        return self.fmt_tokenizer.decode(gen, skip_special_tokens=True).strip()

    def predict(
        self,
        task: str = Input(
            description="Type of operation: 'llm' for rewrite/SQL, 'format_db' for DB result formatting",
            default="llm",
            choices=["llm", "format_db"],
        ),
        user_input: str = Input(
            description="General prompt for rewrite / SQL generation (used when task='llm')",
            default="",
        ),
        question: str = Input(
            description="Original user question (used when task='format_db')",
            default="",
        ),
        db_result_json: str = Input(
            description="Database result as JSON string (used when task='format_db')",
            default="{}",
        ),
    ) -> Any:
        """
        - task='llm'       -> uses Qwen3-4B and returns a plain string.
        - task='format_db' -> uses Qwen 1.5B and returns {'answer': ..., 'error': ...?}.
        """
        if task == "llm":
            if not user_input:
                return "Error: user_input is required when task='llm'."
            result = self._run_main_llm(user_input=user_input)
            return result
        if task == "format_db":
            try:
                db_result = json.loads(db_result_json) if db_result_json else {}
            except Exception as e:
                return {
                    "answer": "Invalid database result format. Unable to parse JSON.",
                    "error": str(e),
                }

            if (
                db_result is None
                or db_result == {}
                or (isinstance(db_result, list) and len(db_result) == 0)
            ):
                # You can customise this message
                return {"answer": "No results found."}

            answer = self._run_formatter_llm(
                question=question,
                db_result=db_result,
                max_new_tokens=MAX_NEW_TOKENS_FORMATTER,
            )
            return {"answer": answer}

        # Safety fallback
        return f"Error: unknown task '{task}'. Use 'llm' or 'format_db'."
