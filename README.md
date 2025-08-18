#  ERP Chatbot - Alpha Release  
**Changai - ERPNext Natural Language Interface**

Welcome to the **alpha version** of Changai - an AI-powered assistant that converts natural language queries into executable Frappe queries, executes them, and returns results in human-friendly language, using a fine-tuned multi-model pipeline. Built to simplify ERP access for business users with no technical knowledge.

> ⚠️ This release is intended for internal testing and feedback only.  

> Please read the known issues section carefully before use.

---

## ✨ Features

* Natural language → ERPNext query conversion
* Multi-model NLP pipeline (**Hugging Face models**)
* Local inference **or** remote inference via **Replicate API**
* Jinja2-based templates for conversational responses
* Extendable for new doctypes and queries
* Built-in dataset + Colab training workflows
* Conversational handling for small talk and ERP queries

---

### 💬 Conversational Handling

Changai seamlessly manages both casual interactions and ERP-related queries.

Small talk (e.g., greetings) is handled through predefined responses.

ERP queries are identified using business keywords and spelling correction.

Valid queries are processed by the prediction pipeline, which generates and executes the corresponding Frappe query.

Responses are returned in a natural, conversational format for better user experience.

## 🧠 Pipeline & Models

Changai uses **four fine-tuned Hugging Face models**, trained in **Google Colab** and deployed locally or on Replicate:

| Stage                            | Model                                                     | Role                                 |
| -------------------------------- | --------------------------------------------------------- | ------------------------------------ |
| **1. Doctype Detection**         | `hyrinmansoor/text2frappe-s1-roberta` *(RoBERTa)*         | Detect target ERPNext Doctype        |
| **2. Relevant Field Prediction** | `hyrinmansoor/text2frappe-s2-sbert` *(SBERT)*             | Suggest semantically relevant fields |
| **3. Exact Field Selection**     | `hyrinmansoor/text2frappe-s2-flan-field` *(Flan-T5 base)* | Select metadata-validated fields     |
| **4. Query Generation**          | `hyrinmansoor/text2frappe-s3-flan-query` *(Flan-T5 base)* | Generate executable SQL query        |

---

## ⚙️ What It Does

* Understands natural ERP-related questions like:
  *“How many contacts do we have?”*
* Distinguishes **small talk, complete & incomplete queries**
* Identifies the right **Doctype**
* Predicts relevant **fields**
* Generates valid Frappe queries using **`frappe.db.sql`**
* Formats output using **Jinja2 templates** for natural replies

---

## 🧾 Conversational Templates

Responses are formatted with **Jinja2 templates** for human-friendly answers.

Example:

* **Template:** `"There are {{ count }} contacts registered in the system."`
* **Output:** `"There are 154 contacts registered in the system."`

---

## ✅ Currently Supported Query types

This alpha release supports a **limited set of queries** reliably:

✔ Examples:

* Get all employees.
* How many sales invoices were issued in the last quarter?
* How many sales invoices are there?
* How many sales invoices have discounts?
* How many Sales invoices are unpaid?
* How many companies do we have?
* How many contacts do we have?
* Get the address of supplier `SUP-0002`.
* How many primary contacts exist in the system?
* List purchase orders with discount above 10,000.
* How many routings are currently disabled?
* How many contacts are linked to companies?


---
🚀 Deployment

Changai’s models are containerized with Docker and packaged using Cog for reproducible inference.
They are deployed on Replicate, where each version runs in an isolated environment and is accessible via the Replicate API.

The serving logic is defined in predict.py (model loading, inference, query generation).

Using cog push, the models are published to Replicate under a unique version ID.

## 🛠️ Installation Guide

### 1. 🔹 Local Development (Training / Testing)

```bash
git clone https://github.com/ERPGulf/changai.git
cd changai

# Create environment
python3 -m venv venv
source venv/bin/activate   # macOS/Linux
venv\Scripts\activate      # Windows

# Install dependencies
pip install -r requirements.txt
```

➡️ Train models in **Google Colab (GPU recommended)**.
➡️ Export trained weights to local or Docker.

---

### 2. 🔹 Run via Replicate (Inference / Production)

1. Install **Cog**

   ```bash
   pip install cog
   ```

2. Login

   ```bash
   replicate login
   ```

3. Push model

   ```bash
   cog push r8.im/<username>/<model-name>
   ```

4. Call API

**Python**

```python
import replicate

output = replicate.run(
    "your-username/erp-chatbot:VERSION_ID",
    input={"question": "How many sales invoices last month?"}
)
print(output)
```

**cURL**

```bash
curl -s \
  -H "Authorization: Token $REPLICATE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"input": {"question": "Get all employees"}}' \
  https://api.replicate.com/v1/predictions
```

---

## 🚀 Usage

Run locally:

```bash
python app.py
```

**Sample Input:**

```json
{
  "question": "How many contacts do we have?",
  "meta_file_path": "metadata.csv"
}
```

**Sample Response:**

```json
{
  "query": "frappe.db.sql(\"SELECT COUNT(name) FROM `tabContact`\")",
  "doctype": "Contact",
  "fields": ["count(name)"],
  "data": {"count": 154},
  "query_data": "There are {{ count }} contacts in the system."
}
```

💬 Final output:

> "There are 154 contacts in the system."

---

## 📄 Metadata Format

Metadata file (CSV/JSON) must list **valid doctype-fieldname pairs**.

**CSV Example**

| doctype        | fieldname        |
| -------------- | ---------------- |
| Company        | name             |
| Company        | industry         |
| Contact        | email\_id        |
| Purchase Order | discount\_amount |

⚠️ Must exclude layout fields (e.g. Section Break, Tab, etc.)

---

## ⚠️ Known Issues

* ❗ **Query Errors**: e.g. `IndexError`, `Unknown column`, `Invalid field name`
* 🧠 **Field Prediction**: may hallucinate non-existent fields
* 📄 **Doctype Coverage**: limited to trained doctypes only
* 📦 **Metadata Dependency**: requires clean, correct metadata file

➡️ Fixes in progress:

* Stronger metadata validation
* User-friendly error handling
* Expanded doctype/query support

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

- **GitHub Issues**: [https://github.com/ERPGulf/changai/issues](https://github.com/ERPGulf/changai/issues)

---

## 📜 License

This project is released under the MIT License. See `LICENSE` for more details.

---

## 🙏 Acknowledgements

* Frappe / ERPNext Team
* ERPGulf Team

---

> \*"We're building not just a chatbot, but a bridge between language and logic. Thank you for testing and shaping it with us!"\*

```