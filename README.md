# ChangAI — Open-Source AI Assistant for ERPNext & Frappe

**ChangAI** turns your ERPNext data into a natural-language chatbot — ask any business question in plain English and get instant, accurate answers without writing a single SQL query.

Built with RAG, LLM-powered SQL generation, LangGraph orchestration, and strict SQL validation for safe and reliable ERP querying.

## 🚀 Features

✅ **Chat Tab** – Ask queries about ERPNext directly  
✅ **Support Tab** – Support interface *(Work in Progress – not yet in working mode)*  
✅ **Debug Tab** – For developers to inspect outcomes at different pipeline stages  
✅ **Train Data Automation** – Button in changAI Settings to automate training data setup  
✅ **Master Data Schema Button** – Create and update master data records and schema  
✅ **Download Embedding Model** – One-click button in Settings to download the embedding model to disk  

## How It Works

we pass the schema and master data to a local model trained on erpnext modules so when a user typesa query we pass that to this model RAG model retreieves the releavnt tables fields and master records from the schema and amster datat fiel to write acuurate sql queries once we get this fields and tables we generate sql with a help of a llm mdel and execute this sql query by checking the user permissions with the help of batch match condtion butin api

Training Data creaetion :
we provided a button in the training tab in changai setting doctype where we a have button to clcik to create train data u can choose modules from the modules table and generate by proving size also we have shcema button which updates and genrate schema and also we have a master datat button to update master datat last mdoifed 

---

## Models Used

| Component              | Model Used                             | Deployment      |
|------------------------|----------------------------------------|-----------------|
| Embeddings  | hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned        | Local or Remote |
| SQL Generation         | Qwen/Qwen    or Gemini       | Local or Remote |

---

## Deployment Modes

### Local Mode (Ollama)

- Runs entirely on your local server  for schema retreiveal and genaret sql qiwth the help fo the gemini
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

## Installation & Setup

### 1. Install ChangAI in Frappe

```bash
bench get-app changai https://github.com/erpgulf/changai
bench --site your-site.local install-app changai
bench --site yoursite.example.com migrate
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
