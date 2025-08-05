import string
import difflib
import re

def trigrams(word):
    """Generate trigrams for a word with padding."""
    word = '  ' + word.lower() + ' '
    return set(word[i:i+3] for i in range(len(word) - 2))

def trigram_similarity(a, b):
    """Calculate Jaccard similarity on trigrams between a and b."""
    trigrams_a = trigrams(a)
    trigrams_b = trigrams(b)
    if not trigrams_a or not trigrams_b:
        return 0.0
    return len(trigrams_a & trigrams_b) / len(trigrams_a | trigrams_b)

def edit_distance_similarity(a, b):
    """Similarity ratio based on edit distance."""
    return difflib.SequenceMatcher(None, a, b).ratio()

def preserve_case(original, corrected):
    """Match the case pattern of the original word."""
    if original.isupper():
        return corrected.upper()
    elif original.istitle():
        return corrected.capitalize()
    elif original.islower():
        return corrected.lower()
    else:
        return corrected

def correct_word(word, vocabulary, trigram_threshold=0.4, edit_threshold=0.6):
    """
    Correct a word by trigram similarity with fallback to edit distance.
    - Leaves codes (with both letters & numbers) as-is.
    - Preserves punctuation & capitalization.
    """
    prefix = ''.join(ch for ch in word if ch in string.punctuation)
    suffix = ''.join(ch for ch in word[::-1] if ch in string.punctuation)[::-1]
    core_word = word.strip(string.punctuation)

    if not core_word:
        return word  # Only punctuation, return as-is

    word_lower = core_word.lower()

    # Skip correction for codes like EMP-0001
    if any(ch.isdigit() for ch in word_lower) and any(ch.isalpha() for ch in word_lower):
        return prefix + core_word + suffix

    # Trigram similarity
    candidates = [(v, trigram_similarity(word_lower, v)) for v in vocabulary]
    best_trigram, best_tri_score = max(candidates, key=lambda x: x[1])

    if best_tri_score >= trigram_threshold:
        corrected = best_trigram
    else:
        # Edit distance fallback
        edit_candidates = [(v, edit_distance_similarity(word_lower, v)) for v in vocabulary]
        best_edit, best_edit_score = max(edit_candidates, key=lambda x: x[1])
        if best_edit_score >= edit_threshold:
            corrected = best_edit
        else:
            return prefix + core_word + suffix  # No good match, return as-is

    corrected_final = preserve_case(core_word, corrected)
    return prefix + corrected_final + suffix

def tokenize(text):
    """Tokenize input text preserving punctuation as separate tokens."""
    return re.findall(r"\b\w+[-']?\w*\b|\S", text)

def correct_query(query, vocabulary, trigram_threshold=0.4, edit_threshold=0.6):
    """
    Corrects an entire user query string using the given vocabulary.
    Returns: corrected (spelling-normalized) query.
    """
    words = tokenize(query)
    corrected_words = [
        correct_word(w, vocabulary, trigram_threshold, edit_threshold)
        for w in words
    ]
    return ' '.join(corrected_words)

# Example usage:
if __name__ == "__main__":
    vocabulary = [
        "what", "is", "the", "how", "do", "i", "you", "have", "has", "can", "we", "are", "my", "your", "on", "in", "to", "of", "for", "with", "left", "from", "when", "will",
                "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday",
        "today", "tomorrow", "yesterday", "month", "week", "year", "last", "next","give", "and", "are", "there", "do", "any", "is", "of", "this", "month", "friday", "names",
        "employee", "employees", "project", "projects", "manager", "customer", "customers", "invoice", "invoices", "status", "amount", "salary", "leaves", "leave", "paid", "unpaid", "approved", "pending", "contact", "number", "details",
        "assigned", "active", "total", "list", "show", "fetch", "display", "sum", "record", "records", "report",

        # Commands
        "apply", "check", "view", "get", "see", "update", "submit", "request", "cancel", "delete",

        # Numbers / examples / codes
        "many", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "si-0001", "emp-0001", "emp-0042", "inv-0023"
    ]
vocabulary = [
        "what", "is", "the", "how", "do", "i", "you", "have", "has", "can", "we", "are", "my", "your", "on", "in", "to", "of", "for", "with", "left", "from", "when", "will",
         "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday",
        "today", "tomorrow", "yesterday", "month", "week", "year", "last", "next","give", "and", "are", "there", "do", "any", "is", "of", "this", "month", "friday", "names",
        "employee", "employees", "project", "projects", "manager", "customer", "customers", "invoice", "invoices", "status", "amount", "salary", "leaves", "leave", "paid", "unpaid", "approved", "pending", "contact", "number", "details",
        "assigned", "active", "total", "list", "show", "fetch", "display", "sum", "record", "records", "report",
        "apply", "check", "view", "get", "see", "update", "submit", "request", "cancel", "delete",
        "many", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "si-0001", "emp-0001", "emp-0042", "inv-0023"
    ]

test_queries = [
    "How mny employss we have?",
    "List al slaes invoces.",
    "Shwo me the total nummber of custmers.",
    "Waht is the satus of INV-0023?",
    "how many paind leavs do I hav left?",
    "Show detalis of EMP-0001.",
    "Giv me al customer namess.",
    "whats the totl outstandig ammount?",
    "List all emplyoees an their numbers.",
    "Can I aplay for leav on Fryday?",
    "wht is the sum of salries for all emplyees?",
    "Show activ prjects asigned to me.",
    "do i hav any leavs left for this mnth?",
    "how maney employeess ar their?",
    "Shwo sales invoics with thier statsus"
]
for query in test_queries:
    print("Original:", query)
    print("Corrected:", correct_query(query, vocabulary))
    print("-" * 50)

