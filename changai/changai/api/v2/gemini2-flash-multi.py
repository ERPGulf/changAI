from google import genai
from google.genai import types
from google.oauth2 import service_account

# 1. Configuration
PROJECT_ID = "chat-with-dialogflow"
KEY_PATH = "/home/erpgulf/gemini-key.json"
MODEL_ID = "gemini-3-flash-preview"  # Updated model ID

# 2. Your List of Questions
QUESTIONS = [
    "SQL for ERPNext: Total sales by 'Item Group' in tabSales Invoice Item.",
    "SQL for ERPNext: List all users who have not logged in for 30 days from tabUser.",
    "SQL for ERPNext: Find duplicate 'Supplier Name' in tabSupplier."
]

def run_multi_flash_test():
    try:
        # Authenticate once
        creds = service_account.Credentials.from_service_account_file(
            KEY_PATH, 
            scopes=['https://www.googleapis.com/auth/cloud-platform']
        )

        # Initialize the Client once
        client = genai.Client(
            vertexai=True,
            project=PROJECT_ID,
            location="global",
            credentials=creds
        )

        # Set System Instruction
        config = types.GenerateContentConfig(
            system_instruction="You are a MariaDB expert for ERPNext. Return ONLY raw SQL.",
            # Flash is fast, but we can set thinking to minimal for even more speed
            thinking_config=types.ThinkingConfig(thinking_level="minimal")
        )

        print(f"Starting Multi-Question Test with {MODEL_ID}...\n")

        for i, qn in enumerate(QUESTIONS, 1):
            print(f"[{i}/3] Processing: {qn}")
            
            response = client.models.generate_content(
                model=MODEL_ID,
                config=config,
                contents=qn
            )

            print(f"Flash Result {i}:")
            print("-" * 30)
            print(response.text.strip())
            print("-" * 30 + "\n")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    run_multi_flash_test()
