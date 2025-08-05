import nltk
from nltk.tokenize import word_tokenize

nltk.download("punkt", quiet=True)

# Predefined pleasantry phrases and responses (prioritize full phrases)
pleasantry_responses = {
    "how are you": "I'm doing great, thanks for asking! How about you?",
    "what's up": "Not much, just chilling! What's good with you?",
    "good morning": "Morning! Hope your day's off to a great start!",
    "good evening": "Evening! How's your night going?",
    "how's it going": "All good here! How's it going with you?",
    "nice to see you": "Right back at you! Great to connect!",
    "howdy": "Howdy! What's the vibe today?",
    "what's new": "Just hanging out, ready to chat! What's new with you?",
    "hope you're well": "Thanks! I'm awesome, and I hope you are too!",
    "long time no see": "Wow, it's been a while! Good to catch up!",
    "greetings": "Greetings! What's on your mind today?",
    # Single-word greetings (lower priority)
    "hello": "Hi! Nice to hear from you!",
    "hi": "Hey there! What's up?",
    "hey": "Yo! Good to see you!",
    "yo": "Yo, what's good?",
}

# Predefined business query keywords (to avoid pleasantry responses)
business_keywords = [
    "how many customers",
    "customer count",
    "number of customers",
    "Get all contacts?",
    "sales data",
    "report",
    "inventory",
]


def respond_to_greeting(text):
    # Tokenize input text (lowercase for case-insensitive matching)
    text_lower = text.lower()
    tokens = word_tokenize(text_lower)
    text_joined = " ".join(tokens)

    # Check for business queries first
    for business_query in business_keywords:
        if business_query in text_joined:
            return 0

    # Check for exact or near-exact pleasantry matches
    for pleasantry, response in pleasantry_responses.items():
        if pleasantry in text_joined:
            # Ensure single-word greetings (e.g., "hello") are only matched if no other words suggest a query
            if len(pleasantry.split()) == 1 and len(tokens) > 2:
                continue  # Skip single-word greetings if input is longer (likely a query)
            return response

    # Default response for unrecognized inputs
    return response


# Test cases
test_inputs = [
    "Hello, how are you?",
    "What's up?",
    "Good morning!",
    "How's it going?",
    "Yo, long time no see!",
    "hello how many customers we have",
    "how many customers we have",
    "hello",
    "hi there",
]

for input_text in test_inputs:
    print(f"Input: {input_text}")
    print(f"Response: {respond_to_greeting(input_text)}\n")
