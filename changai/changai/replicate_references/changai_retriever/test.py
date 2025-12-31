from pathlib import Path
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS

INDEX_DIR = Path("/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/v2/faiss_hnsw_vector_index")

emb = HuggingFaceEmbeddings(
    model_name="nomic-ai/nomic-embed-text-v1.5",
    model_kwargs={"device": "cpu", "trust_remote_code": True},
    encode_kwargs={"normalize_embeddings": True},
)

vs = FAISS.load_local(
    folder_path=str(INDEX_DIR),
    embeddings=emb,
    allow_dangerous_deserialization=True,
    index_name="index",
)

print("ntotal:", vs.index.ntotal)

queries = [
    "show all employees","show all item names","suppliers",
    "show today's sales invoices",
    "how much did we spend on purchases last month",
    "which customer has highest outstanding",
]

for q in queries:
    print("\n=== QUERY:", q)
    hits = vs.similarity_search(q, k=5)
    for i, d in enumerate(hits, 1):
        table = d.metadata.get("table")
        card_type = d.metadata.get("type")      # 'table' or 'field'
        field = d.metadata.get("field")        # only present for field cards

        print(
            f"{i}. type={card_type} "
            f"| table={table} "
            f"| field={field} "
        )