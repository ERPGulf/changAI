import spacy
# nlp = spacy.load("en_core_web_sm")
# s1=nlp("get the names of employees")
# s2=nlp("How many employees")

# s1_verbs=" ".join([token.lemma_ for token in s1 if token.pos_ == "VERB"])
# s1_adjs=" ".join([token.lemma_ for token in s1 if token.pos_ == "ADJ"])
# s1_nouns=" ".join([token.lemma_ for token in s1 if token.pos_ == "NOUN"])

# s2_verbs=" ".join([token.lemma_ for token in s2 if token.pos_ == "VERB"])
# s2_adjs=" ".join([token.lemma_ for token in s2 if token.pos_ == "ADJ"])
# s2_nouns=" ".join([token.lemma_ for token in s2 if token.pos_ == "NOUN"])

# print(nlp(s1_adjs).similarity(nlp(s2_adjs)))
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings
embeddings = HuggingFaceEmbeddings(
                model_name="nomic-ai/nomic-embed-text-v1.5",
                model_kwargs={
                    "device": "cpu",
                    "trust_remote_code": True,
                },
                encode_kwargs={"normalize_embeddings": True},
            )
vs = FAISS.load_local("/opt/hyrin/frappe-bench/apps/changai/changai/changai/api/v2/faiss_hnsw_vector_index", embeddings, allow_dangerous_deserialization=True)

docs = vs.similarity_search("Who are the customers who purchased items containing ‘Pen’ today?", k=20)
for d in docs:
    print(d.metadata.get("table"), d.metadata.get("type"), d.page_content[:120])
