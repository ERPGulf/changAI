# predict.py
from typing import List, Dict, Any
from pathlib import Path

import torch
from cog import BasePredictor, Input
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS

# Path to the FAISS index folder inside the repo / container
ENTITY_INDEX_PATH = Path(__file__).parent / "Entity_fvs"
ENTITY_INDEX_NAME = "index"   # must match index_name used in save_local()


class Predictor(BasePredictor):
    def setup(self) -> None:
        # Lazy init (same idea as schema retriever)
        self.emb = None
        self.entity_vs = None
        self.PREFIX = "search_query: "

    def _ensure_loaded(self) -> None:
        """Load embeddings + FAISS index once, on first use."""
        if self.entity_vs is not None:
            return

        device = "cuda" if torch.cuda.is_available() else "cpu"

        # Use the SAME embedder + settings as schema retriever
        self.emb = HuggingFaceEmbeddings(
            model_name="hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned",
            model_kwargs={
                "device": device,
                "trust_remote_code": True,
            },
            encode_kwargs={"normalize_embeddings": True},
        )

        self.entity_vs = FAISS.load_local(
            folder_path=str(ENTITY_INDEX_PATH),
            embeddings=self.emb,
            allow_dangerous_deserialization=True,
            index_name=ENTITY_INDEX_NAME,
        )

    def _format_entity_label(self, meta: Dict[str, Any]) -> str:
        key = meta.get("entity_key")
        if not key:
            return ""
        return f"[ENTITY_CARD] {key}"

    def predict(
        self,
        query: str = Input(description="User question / text to find entities for."),
        top_k: int = Input(
            description="Number of entities to retrieve.",
            default=5,
            ge=1,
            le=50,
        ),
    ) -> Dict[str, Any]:
        # Ensure models + index are loaded
        self._ensure_loaded()

        full_query = f"{self.PREFIX}{query}"

        # If you want scores too, use the _with_score variant:
        docs_with_scores = self.entity_vs.similarity_search_with_score(
            full_query, k=top_k
        )

        results: List[Dict[str, Any]] = []
        for doc, score in docs_with_scores:
            meta = doc.metadata or {}
            results.append({
            "entity_label": self._format_entity_label(meta),
            "entity_key": meta.get("entity_key"),
            })

        return {"results":results}