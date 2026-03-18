<div align="center">

<h1>chang<b>AI</b></h1>

**Open-source AI assistant for ERPNext — ask business questions in plain English, get instant answers. No SQL needed.**

[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE)
[![ERPNext v14+](https://img.shields.io/badge/ERPNext-v14%20%7C%20v15%20%7C%20v16-blue.svg)](https://erpnext.com)
[![Python 3.10+](https://img.shields.io/badge/python-3.10%2B-blue.svg)](https://python.org)
[![Platform](https://img.shields.io/badge/platform-Ubuntu-lightgrey.svg)](https://ubuntu.com)
[![Maintained](https://img.shields.io/badge/status-actively%20maintained-brightgreen.svg)]()

[Setup Guide](https://youtu.be/twD-4scH-EM) · [Documentation](https://docs.claudion.com/Claudion-Docs/changaisetup) · [Report a Bug](https://github.com/ERPGulf/changAI/issues) · [Embedding Model 🤗](https://huggingface.co/hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned)

</div>

---

> **⚠️ Note:** Current version is trained on ERPNext modules only. Like any AI model, it is still learning — it handles a good range of ERPNext queries well but will not get everything right. Accuracy improves over time with more training data and feedback.

---

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Features](#features)
- [How It Works](#how-it-works)
- [Model & Architecture](#model--architecture)
- [Contributing](#contributing)
- [Links](#links)

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

Then search for **changAI Settings** in ERPNext to configure your deployment mode.

---

## Configuration

changAI supports two deployment modes:

### Local Mode
Schema retrieval runs locally; SQL is generated via **Gemini**.

1. Uncheck **Remote** in changAI Settings
2. Enter your Gemini API credentials

### Remote Mode
Both schema retrieval and SQL generation run on **Replicate** using Qwen3.

1. Check **Remote** in changAI Settings
2. Fill in your Replicate API token, prediction URL, and version IDs under the Remote tab

> 📺 **Full walkthrough:** [YouTube Setup Guide](https://youtu.be/twD-4scH-EM)  
> 📖 **Full docs:** [docs.claudion.com](https://docs.claudion.com/Claudion-Docs/changaisetup)

---

## Features

| Feature | Description |
|---|---|
| **Chat Tab** | Ask ERPNext questions in plain English and get instant answers |
| **Debug Tab** | Inspect pipeline outputs at each stage of the query |
| **Support Tab** | Built-in support interface *(work in progress)* |
| **Train Data Automation** | Auto-generate training data by ERPNext module |
| **Master Data Schema** | Create and sync schema + master records |
| **Download Embedding Model** | Download updated model to disk — auto-downloads on first install; only needed again on model updates |

---

## How It Works

```
User Query
    │
    ▼
RAG Retrieval ──── Retrieves relevant tables, fields & master records
    │
    ▼
SQL Generation ─── LLM generates SQL from retrieved schema context
    │
    ▼
Permission Check ── Validated via Frappe's match_conditions API
    │
    ▼
Natural Language ── Result returned as a human-readable answer
```

---

## Model & Architecture

| Component | Local Mode | Remote Mode |
|---|---|---|
| **Embeddings** | `hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned` | `hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned` |
| **Schema Retrieval** | Local | Replicate |
| **SQL Generation** | Gemini | Qwen3 (Replicate) |

---

## Contributing

PRs are welcome.

1. Fork the repository
2. Branch from `main`
3. Submit a pull request

**Reporting bugs:** Open a [GitHub Issue](https://github.com/ERPGulf/changAI/issues) and include:
- Your query
- The output received
- Any error messages
- Debug tab output

---

## Links

| | |
|---|---|
| 📺 Setup Walkthrough | [youtu.be/twD-4scH-EM](https://youtu.be/twD-4scH-EM) |
| 📖 Documentation | [docs.claudion.com](https://docs.claudion.com/Claudion-Docs/changaisetup) |
| 🤗 Embedding Model | [huggingface.co/hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned](https://huggingface.co/hyrinmansoor/changAI-nomic-embed-text-v1.5-finetuned) |
| 🤗 Dataset | [huggingface.co/datasets/hyrinmansoor/ERP-retrieval-data-modernbert](https://huggingface.co/datasets/hyrinmansoor/ERP-retrieval-data-modernbert) |
| 🐛 Issues | [github.com/ERPGulf/changAI/issues](https://github.com/ERPGulf/changAI/issues) |
| 📧 Support | [support@erpgulf.com](mailto:support@erpgulf.com) |
| 🌍 Website | [erpgulf.com](https://erpgulf.com) |

---

<div align="center">

MIT License · Actively maintained · Built by [ERPGulf](https://erpgulf.com)

</div>