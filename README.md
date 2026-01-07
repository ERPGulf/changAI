# ChangAI — Open-Source AI Assistant for ERPNext & Frappe

**ChangAI** turns your ERPNext data into a natural-language chatbot — ask any business question in plain English and get instant, accurate answers without writing a single SQL query.

Built with RAG, LLM-powered SQL generation, LangGraph orchestration, and strict SQL validation for safe and reliable ERP querying.

## Key Features

- **Accurate Text-to-SQL** — Generates valid, read-only MySQL `SELECT` queries
- **Dual RAG Retrieval** — Separate FAISS indexes for:
  - ERPNext schema (tables, fields, joins, metrics)
  - Master entities (customers, items, suppliers)
- **Entity-Aware Queries** — Exact matching for customer/item names (no guessing)
- **Business Guardrail** — Non-ERP questions are safely handled outside the SQL flow
- **Self-Repairing SQL** — SQLGlot-based validation with guided retries (up to 2)
- **Flexible Deployment** — Run fully local (Ollama) or remote (Replicate/Docker)
- **Stateful Conversations** — Multi-turn chat with memory
- **Secure & Private** — No writes, no schema hallucination, no uncontrolled execution

---

## How It Works

ChangAI clarifies user intent using recent chat history, rewrites the query only when needed, and detects entity or value-based inputs.

A guardrail routes the request to either the ERP SQL pipeline or a non-ERP conversational response.

For ERP queries, it retrieves the required schema and entity context (via RAG), uses this context for LLM-based SQL generation, validates and repairs the SQL, executes read-only `SELECT` queries, and returns results in a clear, human-friendly format.

---

## Models Used

| Component              | Model Used                             | Deployment      |
|------------------------|----------------------------------------|-----------------|
| Embeddings (Schema)    | nomic-ai/modernbert-embed-base         | Local or Remote |
| Embeddings (Entity)    | nomic-ai/modernbert-embed-base         | Local or Remote |
| SQL Generation         | Qwen/Qwen3-4B-Instruct-2507             | Local or Remote |
| DB Result Formatting   | Qwen/Qwen2.5-1.5B-Instruct              | Local or Remote |

---

## Deployment Modes

### Local Mode (Ollama)

- Runs entirely on your local server
- No external API calls
- Best for privacy and on-prem deployments

### Remote Mode (Replicate)

- You host the inference server
- FAISS indexes are mounted inside the container
- Supports scaling and better performance
- **Recommended**: Use **Deployment URL** to avoid cold starts

You can switch modes anytime via **ChangAI Settings** (no code changes required).

---

## Hugging Face Models & Dataset

Hugging Face hosts open, versioned model weights and datasets for reproducible deployments and easy fine-tuning.

**Retrieval & Embedding Model** (Schema + Entity)  
https://huggingface.co/hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned

**Dataset Repository**  
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

### Data Retrieval Process Flow

<p align="center">
  <img src="changai/images/data_retrieval_flow_chart.png" width="750">
</p>

---

## Installation & Setup

### 1. Install ChangAI in Frappe

```bash
bench get-app changai https://github.com/erpgulf/changai
bench --site your-site.local install-app changai
bench migrate
bench restart
```

### 2. Configure ChangAI Settings

Go to **ERPNext → ChangAI Settings**

#### Local Mode

- Uncheck **Remote**
- Ollama URL: `http://localhost:11434`
- LLM Model Name
- Embedding Model Name
- Entity Model Name

#### Remote Mode (Replicate)

- Check **Remote**
- Prediction URL: `https://api.replicate.com/v1/predictions`
- API Token
- LLM Version ID
- Embedder Version ID
- Entity Retriever Version ID
- **Deployment URL** (recommended)

### 3. Build FAISS Indexes (Required)

```python
from changai.changai.api.v2.build_schema_entity_faiss_indexes import build_all_indexes
build_all_indexes()
```

This creates:

```
changai/api/fvs_stores/
├── schema_fvs/
└── entity_fvs/
```

### 4. Remote Inference — Replicate

> Replicate deployments **require Docker containers**.  
> Models are built and pushed using **Cog**.

#### 4.1 Copy Inference Folders

```bash
scp -r replicate_inference user@replicate-server:/workspace/
```

#### 4.2 Build & Push Models

```bash
cd changai_retriever && cog build && cog push r8.im/<username>/changai_retriever
cd ../entity_retriever && cog build && cog push r8.im/<username>/entity_retriever
cd ../changai_qwen3 && cog build && cog push r8.im/<username>/changai_qwen3
```

---

## Deployment Warm-Up (Important)

Before your first real request, warm up the models to avoid cold-start delays.

### Qwen3 Deployment

1. Enable the **Deployment URL**
2. Open the deployment page or Playground
3. Run any simple prompt once

> After this, the model stays warm until the deployment is disabled.

### Retriever Models (Schema & Entity)

Retrievers currently use prediction URLs (not deployments).

For best first-time performance:

- Open each retriever model page
- Run one test prediction once

> In future versions, retrievers will be merged into a single deployment to eliminate this delay.

---

## Test in ChangAI UI

Open **ERPNext → ChangAI** and start asking business questions.

If you encounter issues, please open a GitHub issue with logs.

---

## Roadmap

- Permission-aware SQL (DocPerm, roles)
- Built-in charts and KPIs
- Multilingual responses
- Automated schema & entity generation from live ERPNext data

---

## 📝 Contributions

If you want to contribute to this project and make it better, your help is very welcome!
Contributing is also a great way to learn more about collaborative development on Github, new technologies in AI/ML, insights on ERPNext and their ecosystems and how to make constructive, helpful bug reports, feature requests and the noblest of all contributions: a good, clean pull request.

### How to make a clean pull request

Look for a project's contribution instructions. If there are any, follow them.

- Create a personal fork of the project on Github.
- Clone the fork on your local machine. Your remote repo on Github is called `origin`.
- Add the original repository as a remote called `upstream`.
- If you created your fork a while ago be sure to pull upstream changes into your local repository.
- Create a new branch to work on! Branch from `develop` if it exists, else from `master`.
- Implement/fix your feature, comment your code.
- Follow the code style of the project, including indentation.
- If the project has tests run them!
- Write or adapt tests as needed.
- Add or change the documentation as needed.
- If you're contributing training data, ensure it's clean and well-structured.
- Squash your commits into a single commit with git's [interactive rebase](https://help.github.com/articles/interactive-rebase). Create a new branch if necessary.
- Push your branch to your fork on Github, the remote `origin`.
- From your fork open a pull request in the correct branch. Target the project's `develop` branch if there is one, else go for `master`!

- If the maintainer requests further changes just push them to your branch. The PR will be updated automatically.
- Once the pull request is approved and merged you can pull the changes from `upstream` to your local repo and delete
your extra branch(es).

And last but not least: Always write your commit messages in the present tense. Your commit message should describe what the commit, when applied, does to the code – not what you did to the code.

### Contributing Training Data
Your contributions are not limited to code! We highly encourage and welcome the submission of data for training our models. 
This could include:
- Structured and balanced dataset: Datasets for various models in the correct format including all details.
- Natural language queries: Examples of questions users would ask.
- Corresponding Frappe query examples: The ideal Frappe queries that should be generated from those natural language inputs.
- Metadata improvements: Suggestions or corrections for doctype-fieldname pairs.
High-quality training data is crucial for improving the chatbot's accuracy and expanding its understanding. Please refer to the formats of training datasets of various models used in the pipeline.

---

## 🗣️ Feedback

Your feedback is critical at this stage! 
As there are many known issues and limitations in the release, we encourage you to share all experiences - good or bad - to help us improve faster and smarter.
For better feedback and easier error diagnosis, a **Debug** tab is available. It displays the intermediate outputs of all models used in the pipeline, helping users and contributors trace issues and track model behaviour at each stage.
Please report:

- Natural language input used
- The output generated
- Any errors encountered
- Your metadata file (if relevant)

### 📮 Report issues via:

- **GitHub Issues**: [https://github.com/ERPGulf/ChangAI/issues](https://github.com/ERPGulf/ChangAI/issues)

---

## 📜 License

This project is released under the MIT License. See `LICENSE` for more details.

---

## 🙏 Acknowledgements

* Frappe / ERPNext Team
* ERPGulf Team

---
