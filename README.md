# Frappe Query Generator API (Chatbot Backend)

This is a FastAPI-based backend deployed on Hugging Face Spaces that accepts business-style questions and returns the correct Frappe query using FLAN, SBERT, and RoBERTa models.

Endpoint: `/query` (POST)

**Input:**
```json
{
  "question": "What's the email of the customer John Smith?"
}
