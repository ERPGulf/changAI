# Prediction interface for Cog ⚙️
# https://cog.run/python
import json
from transformers import (
RobertaTokenizerFast,
RobertaForSequenceClassification,
T5Tokenizer,
T5ForConditionalGeneration,
)
import torch
torch._dynamo.config.suppress_errors = True

import torch
# import cog
# from sentence_transformers import SentenceTransformer,util
# from cog import BasePredictor, Input, Path

# Load the HF_Models Repo IDs.
ROBERTO_REPO = "hyrinmansoor/text2frappe-s1-roberta"
SBERT_REPO = "hyrinmansoor/text2frappe-s2-sbert"
FLANS2_REPO = "hyrinmansoor/text2frappe-s2-flan-field"
FLANS3_REPO = "hyrinmansoor/text2frappe-s3-flan-query"

class Predictor(BasePredictor):
    def setup(self):
        """Load the model into memory to make running multiple predictions efficient"""
        self.tokenizer_s1=RobertaTokenizerFast.from_pretrained(ROBERTO_REPO)
        self.model_s1 = RobertaForSequenceClassification.from_pretrained(ROBERTO_REPO)

        self.sbert = SentenceTransformer(SBERT_REPO)

        self.tokenizer_s2 = T5Tokenizer.from_pretrained(FLANS2_REPO)
        self.model_s2 = T5ForConditionalGeneration.from_pretrained(FLANS2_REPO)

        self.tokenizer_s3 = T5Tokenizer.from_pretrained(FLANS3_REPO)
        self.model_s3 = T5ForConditionalGeneration.from_pretrained(FLANS3_REPO)
        with open("meta.json") as f:
            self.meta=json.load(f)
        # Load Meta and Dcotypes IDs.
        with open("id2label.json") as f:
            self.id2label=json.load(f)

    def predict_doctype(self, question):
        try:
            inputs = self.tokenizer_s1(question, return_tensors="pt", truncation=True)
            with torch.no_grad():
                outputs = self.model_s1(**inputs)
            pred_id = str(outputs.logits.argmax().item())
            predicted_doctype = self.id2label.get(pred_id, "Unknown")
            return predicted_doctype
        except Exception as e:
            return "Unknown"

    def get_top_k_fields(self, question, doctype, k=4):
        try:
            if doctype not in self.meta or "fields" not in self.meta[doctype]:
                return []
            fields = self.meta[doctype]["fields"]
            if not fields:
                return []
            sbert_prompt = f"Doctype: {doctype}\nQuestion: {question}"
            query_emb = self.sbert.encode(sbert_prompt, convert_to_tensor=True)
            field_embs = self.sbert.encode(fields, convert_to_tensor=True)
            sim_scores = util.pytorch_cos_sim(query_emb, field_embs)[0]
            top_k = torch.topk(sim_scores, k=min(k, len(fields)))
            return [fields[i] for i in top_k.indices.tolist()]
        except Exception:
            return []

    def select_fields_with_flan(self, doctype, question, top_fields):
        prompt = (
            f"Instruction: Select only the correct field(s) from the given top fields that answer the question.\n"
            f"Doctype: {doctype}\nQuestion: {question}\nTop Fields: {', '.join(top_fields)}"
        )
        input_ids = self.tokenizer_s2(prompt, return_tensors="pt").input_ids
        output_ids = self.model_s2.generate(input_ids, max_length=64)
        decoded = self.tokenizer_s2.decode(output_ids[0], skip_special_tokens=True)
        # Return as list, split by comma
        return [f.strip() for f in decoded.split(",") if f.strip()]

    def generate_frappe_query(self, doctype, question, fields):
        prompt = (
            f"Generate the correct Frappe query for the given question, using the provided doctype and fields.\n"
            f"Doctype: {doctype}\nQuestion: {question}\nFields: {', '.join(fields)}"
        )
        input_ids = self.tokenizer_s3(prompt, return_tensors="pt").input_ids
        output_ids = self.model_s3.generate(input_ids, max_length=128)
        decoded = self.tokenizer_s3.decode(output_ids[0], skip_special_tokens=False)
        decoded = decoded.replace("<pad>", "").replace("</s>", "").strip()
        return decoded


    def predict(self, user_input: str = Input(description="User question"))->dict:
        question = user_input
        doctype = self.predict_doctype(question)
        top_fields = self.get_top_k_fields(question, doctype)
        selected_fields = self.select_fields_with_flan(doctype, question, top_fields)
        frappe_query = self.generate_frappe_query(doctype, question, selected_fields)
        return {
            "predicted_doctype": doctype,
            "top_fields": top_fields,
            "selected_fields": selected_fields,
            "frappe_query": frappe_query,
            "user_input": question,
        }
