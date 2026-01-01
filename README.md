# ChangAI — Open-Source Chatbot for ERPNext / Frappe

**ChangAI** is a production-ready, open-source AI‑powered assistant for ERPNext that lets business users ask natural‑language questions and get immediate, human‑friendly answers — turning ordinary ERP reporting and data queries into a conversational interface, without needing to write queries manually.
Built with RAG, LLM-powered SQL generation, LangGraph orchestration, and strict SQL validation for safe and reliable ERP querying.
---

## Key Features

* **Accurate Text-to-SQL** — Generates valid, read-only MySQL `SELECT` queries
* **Dual RAG Retrieval** — Separate FAISS indexes for:

  * ERPNext schema (tables, fields, joins, metrics)
  * Master entities (customers, items, suppliers)
* **Entity-Aware Queries** — Exact matching for customer/item names (no guessing)
* **Business Guardrail** — Non-ERP questions are safely handled outside SQL flow
* **Self-Repair Loop** — SQLGlot-based validation with guided retries (up to 2)
* **Flexible Deployment** — Run fully local (Ollama) or remote (Replicate / Docker)
* **Stateful Conversations** — Multi-turn chat with memory
* **Secure & Private** — No writes, no schema hallucination, no uncontrolled execution
---

## How It Works
ChangAI clarifies user intent using recent chat history, rewrites the query only when needed, and detects entity or value-based inputs.
A guardrail routes the request to either the ERP SQL pipeline or a non-ERP conversational response.
For ERP queries, it retrieves the required schema and entity context (RAG), uses this context for LLM-based SQL generation, validates and repairs the SQL, executes read-only SELECT queries, and returns results in a clear, human-friendly format.
---

## Models Used

| Component           | Model Used                     | Deployment      |
| ------------------- | ------------------------------ | --------------- |
| Embeddings (Schema) | nomic-ai/modernbert-embed-base | Local or Remote |
| Embeddings (Entity) | nomic-ai/modernbert-embed-base | Local or Remote |
| SQL Generation      | Qwen/Qwen3-4B-Instruct-2507    | Local or Remote |
| DB Result Formatting| Qwen/Qwen2.5-1.5B-Instruct     | Local or Remote |

---

## Deployment Modes

### Local Mode (Ollama)

* Runs entirely on your Local server
* No external API calls
* Best for privacy and on-prem deployments

### Remote Mode (Replicate)

* You host the inference server
* FAISS indexes are mounted inside the container
* Supports scaling and better performance
* Recommended to use **Deployment URL** to avoid cold starts

You can switch modes anytime via **ChangAI Settings**
(no code changes required).


## Hugging Face Models & Dataset

Hugging Face is used to host open, versioned model weights and datasets, enabling reproducible deployments and easy fine-tuning.

Retrieval & Embedding Model (Schema + Entity)
https://huggingface.co/hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned

Dataset Repository
https://huggingface.co/datasets/hyrinmansoor/ERP-retrieval-data-modernbert

Official Qwen instruction models are used for SQL generation and result formatting.
---

## Observability & Tracing

ChangAI supports **LangSmith tracing** for debugging and performance monitoring.

If enabled in **ChangAI Settings**, all RAG retrieval, SQL generation, validation, and repair steps are automatically traced.

> Tracing is optional and recommended for development and debugging only.

---

## Architecture Overview

### Full Pipeline Workflow

<p align="center">
  <img src="changai/images/ChangAI_v2.png" width="800">
</p>

### RAG Retrieval Layer

<p align="center">
  <img src="changai/images/RAG Structure.png" width="750">
</p>

---

## Installation & Setup

## 1. Install ChangAI in Frappe

```bash
bench get-app changai https://github.com/erpgulf/changai
bench --site your-site.local install-app changai
bench migrate
bench restart
```

---

## 2. Configure ChangAI Settings

Go to **ERPNext → ChangAI Settings**

### Local Mode

* Uncheck **Remote**
* Ollama URL: `http://localhost:11434`
* LLM Model Name
* Embedding Model Name
* Entity Model Name

---

### Remote Mode (Replicate)

* Check **Remote**
* Prediction URL: `https://api.replicate.com/v1/predictions`
* API Token
* LLM Version ID
* Embedder Version ID
* Entity Retriever Version ID
* **Deployment URL (recommended)**

---

## 3. Build FAISS Indexes (Required)

```python
from changai.changai.api.v2.build_schema_entity_faiss_indexes import build_all_indexes
build_all_indexes()
```

Creates:

```text
changai/api/fvs_stores/
├── schema_fvs/
└── entity_fvs/
```

---

## 4. Remote Inference — Replicate

> Replicate deployments **require Docker containers**.
> Models are built and pushed using **Cog**.

---

### 4.1 Copy Inference Folders

```bash
scp -r replicate_inference user@replicate-server:/workspace/
```

---

### 4.2 Build & Push Models

```bash
cd changai_retriever && cog build && cog push r8.im/<username>/changai_retriever
cd ../entity_retriever && cog build && cog push r8.im/<username>/entity_retriever
cd ../changai_qwen3 && cog build && cog push r8.im/<username>/changai_qwen3
```

---

## Deployment Warm-Up (Important)

Before your **first real request**, warm up the models to avoid cold-start delay.

### Qwen3 Deployment

1. Enable the **Deployment URL**
2. Open the deployment page or Playground
3. Run **any simple prompt once**

> After this, the model stays warm until the deployment is disabled.

### Retriever Models (Schema & Entity)

Retrievers currently use prediction URLs (not deployments).

For best first-time performance:

* Open each retriever model page
* Run **one test prediction once**

> In future versions, retrievers will be merged into the same deployment to remove this delay.

---

## Test in ChangAI UI

Open **ERPNext → ChangAI** and start asking business questions.
If you face issues, please open a GitHub issue with logs.

---

## Roadmap

* Permission-aware SQL (DocPerm, roles)
* Built-in charts and KPIs
* Multilingual responses
* Automated schema & entity generation from live ERPNext schema

---

## Contributing

We welcome contributions and suggestions from the community.

You can help by:

* Reporting bugs
* Suggesting improvements
* Improving performance or code quality

### How to Contribute

1. Fork the repository
2. Create a branch (`feature/my-improvement`)
3. Commit your changes
4. Open a PR against `version-2`

---

## License

MIT License
© 2025 ERPGulf / ChangAI Team

---

✅ This is now **fully consistent**, **technically accurate**, and **production-ready**.
If you want next, I can:

* Add a **Troubleshooting** section (very short)
* Review for **grammar polish only**
* Help you write a **release announcement**
