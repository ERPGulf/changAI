from typing import List, Dict, Any
from cog import BasePredictor, Input
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS
from pathlib import Path
import torch

INDEX_PATH = Path(__file__).parent / "fvs3"
INDEX_NAME = "index"


class Predictor(BasePredictor):
    def setup(self) -> None:
        # Light setup; heavy stuff is lazy-loaded
        self.emb = None
        self.vs = None

    def _ensure_loaded(self) -> None:
        """Load embeddings + FAISS index once, on first use."""
        if self.vs is None:
            device = "cuda" if torch.cuda.is_available() else "cpu"

            self.emb = HuggingFaceEmbeddings(
                model_name="hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned",
                model_kwargs={
                    "device": device,
                    "trust_remote_code": True,
                },
                encode_kwargs={"normalize_embeddings": True},
            )

            self.vs = FAISS.load_local(
                folder_path=str(INDEX_PATH),
                embeddings=self.emb,
                allow_dangerous_deserialization=True,
                index_name=INDEX_NAME,
            )

    def predict(
        self,
        user_input: str = Input(description="Query text"),
        k: int = Input(description="Top-K results", default=15),
    ) -> List[Dict[str, Any]]:
        # Make sure things are loaded
        self._ensure_loaded()

        # IMPORTANT: use same prefix scheme as training
        query = f"search_query: {user_input}"

        hits = self.vs.similarity_search(query, k=k)
        return [
            {"text": doc.page_content, "metadata": doc.metadata}
            for doc in hits
        ]
