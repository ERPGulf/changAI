#  ERP Chatbot - Alpha Release  
**Changai - ERPNext Natural Language Interface**

Welcome to the **alpha version** of Changai - an AI-powered assistant that converts natural language queries into executable Frappe queries, executes them, and returns results in human-friendly language, using a fine-tuned multi-model pipeline. Built to simplify ERP access for business users with no technical knowledge.

> ⚠️ This release is intended for internal testing and feedback only.  

> Please read the known issues section carefully before using.

---

## 📌 Table of Contents

- \[What It Does](#-what-it-does)  
- \[Currently Supported Queries](#-currently-supported-queries)  
- \[Known Issues and Limitations](#-known-issues-and-limitations)  
- \[Installation](#-installation)  
- \[Usage](#-usage)  
- \[Metadata Format](#-metadata-format)  
- \[Feedback](#-feedback)
- \[Contributions](#-contributions)
---

## ⚙️ What It Does

- Understands natural questions like \_"How many contacts do we have?"\_  
- Distinguishes types of inputs - small talk, complete and incomplete questions
- Identifies the appropriate **Doctype**  
- Predicts relevant **fields** 
- Generates valid **Frappe database queries** such as:  
    - `frappe.get\_list`
    - `frappe.db.get\_value`
    - `frappe.get\_all`
    - `frappe.db.sql`
    - `frappe.db.exists`
- Formats results using **Jinja2-based conversational templates** to make output responses more human-friendly.

---

## 🧾 Conversational Templates with Jinja2

To generate human-readable responses, we use **Jinja2 templates** that render the raw query results into conversational outputs.  
This makes the chatbot responses feel more natural and business-friendly.

Example:
> Template: `"There are {{ count }} contacts registered in the system."`  
> Output: `"There are 154 contacts registered in the system."`

Templates are defined in the `/templates` directory and are applied after Frappe query execution.  
You can customize responses easily by editing the templates without touching the model logic.

---

## ✅ Currently Supported Queries

This alpha release reliably supports a **small, pre-approved set of queries**. Others may work, but are not guaranteed.

#### ✔ Examples that work:
- How many companies do we have?  
- How many contacts do we have?  
- Get the address of supplier `SUP-0002`.  
- How many primary contacts exist in the system?  
- List purchase orders with discount above 10,000.  
- How many routings are currently disabled?  
- How many contacts are linked to companies?  
- Get all employees.

---

## ⚠️ Known Issues and Limitations

> 💡 These issues are expected during the alpha phase.

### ❗ Query Errors
Some queries may result in exceptions such as:
- `IndexError`
- `Unknown column`
- `Invalid field name`

These usually stem from inaccurate field prediction or incomplete metadata validation.

### 🧠 Field Prediction Issues
- The model may **hallucinate non-existent fields**, even with a clean metadata file.
- Better alignment with metadata is in progress.

### 📄 Doctype Support Issues
- The model is currently trained with **standard doctypes** in the metadata file.
- Better alignment with other doctypes is in progress.

### 📦 Meta File Required

The chatbot **requires a clean, correct metadata file** (CSV or JSON).  
It must:
- Include only valid doctype-fieldname pairs
- **Exclude layout fields** (e.g. Section Break, Tab, Column Break, etc.)
- Follow consistent formatting

### 🔧 Partial Query Method Support
The chatbot attempts to generate:
- `frappe.get\_list`
- `frappe.db.get\_value`
- `frappe.db.exists`
- `frappe.get\_all`
- `frappe.db.sql`

However, due to ongoing refinement, **some queries may still fail**.

### 🛠 Fixes In Progress
- More accurate field prediction using metadata
- Cleaner, user-friendly error messages
- Fallback suggestions on failure
- Expanded query style and intent support
- Widen support for all doctypes

---

## 🧰 Installation

### 1. Clone the repo

```bash
git clone https://github.com/ERPGulf/changai.git
cd changai
```

### 2. Create and activate environment
Using Conda:
```bash
conda create -n erp-bot python=3.11
conda activate erp-bot
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

---

## 🚀 Usage
### Run the main script

```bash
python app.py
```
### Sample API input:
```json
{
    "question": "How many contacts do we have?",
    "meta\_file\_path": "metadata.csv"
}
```
### Sample response:
```json
{
    "query": "frappe.db.sql(\"SELECT COUNT(name) FROM `tabContact`\")",
    "doctype": "Contact",
    "top fields": {},
    "fields": ["count(name)"],
    "query_data": "There are {{ count }} contacts in the system.",
    "data": {
        "count": 154
    }
}
```
💬 **Final output**:  
> "There are 154 contacts in the system."
---

## 🧾 Metadata Format
Your metadata file (CSV or JSON) must follow this structure:

### CSV Format
| doctype        | fieldname       |
| -------------- | --------------- |
| Company        | name            |
| Company        | industry        |
| Contact        | email_id        |
| Purchase Order | discount_amount |

>Make sure the metadata provided is clean.

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
