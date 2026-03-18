# changAI — Open-Source AI Assistant for ERPNext

An open-source AI assistant for ERPNext built on Frappe. Ask business questions in plain English and get instant answers — no SQL needed.

> ⚠️ **Current version is trained on ERPNext modules only.** Like any AI model, it is still learning — it handles a good range of ERPNext queries well but will not get everything right. Accuracy improves over time with more training data and feedback.

**Compatibility:** ERPNext v14 & v15 & v16 · Ubuntu · Python 3.10+

---

## Installation

```bash
# 1. Get the app
bench get-app changai https://github.com/erpgulf/changai

# 2. Install on your site
bench --site your-site.local install-app changai

# 3. Migrate & restart
bench --site your-site.local migrate
bench restart
```

Then search for **changAI Settings** in ERPNext and configure your deployment mode:

- **Local Mode** — schema retrieval runs locally; SQL is generated via Gemini. Uncheck *Remote* and fill in your Gemini credentials.
- **Remote Mode** — schema retrieval and SQL generation both run on Replicate using Qwen3. Check *Remote* and fill in your Replicate API token, prediction URL, and version IDs in the Remote tab.

> 📺 Full setup walkthrough: [YouTube – coming soon](https://youtu.be/twD-4scH-EM)
> Documentation here https://docs.claudion.com/Claudion-Docs/changaisetup

---

## Features

| | |
|---|---|
| **Chat Tab** | Ask ERPNext questions in plain English |
| **Debug Tab** | Inspect pipeline outputs at each stage |
| **Support Tab** | Support interface *(work in progress)* |
| **Train Data Automation** | Auto-generate training data by module |
| **Master Data Schema** | Create and sync schema + master records |
| **Download Embedding Model** | Download updated model to disk — only needed when a model update is released; the model downloads automatically on first install |

---

## How It Works

User query → RAG retrieves relevant tables, fields, and master records → LLM generates SQL → SQL is validated against user permissions via Frappe's `match_conditions` API → result returned in natural language.

| Component | Local | Remote |
|---|---|---|
| Embeddings | `hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned` | `hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned` |
| Schema Retrieval | Local | Replicate |
| SQL Generation | Gemini | Qwen3 (Replicate) |

---

## Contributing

PRs are welcome. Fork → branch from `main` → submit a PR.

Report bugs via [GitHub Issues](https://github.com/ERPGulf/changAI/issues) — include your query, output, any errors, and the Debug tab output.

---

## Links
-     How to setup and configure guide here https://youtu.be/twD-4scH-EM
-     Documentation here https://docs.claudion.com/Claudion-Docs/changaisetup
- 🤗 [Embedding Model](https://huggingface.co/hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned)
- 🤗 [Dataset](https://huggingface.co/datasets/hyrinmansoor/ERP-retrieval-data-modernbert)
- 📧 support@erpgulf.com
- 🌍 [erpgulf.com](https://erpgulf.com)

---

MIT License · Actively maintained · [ERPGulf](https://erpgulf.com)
