import csv
import re
import os
import unicodedata
from dataclasses import dataclass
import json
import frappe
from typing import Dict, List, Optional, Set, Tuple, Any
from rapidfuzz import process

@dataclass
class ResponseEntry:
    category: str
    user_input: str
    response: str
    priority: int = 100
    is_active: bool = True


class IntelligentStaticResponder:
    def __init__(self, csv_file: str):
        self.csv_file = csv_file
        self.entries: List[ResponseEntry] = []
        self.responses_by_key: Dict[str, List[ResponseEntry]] = {}
        self.keys: List[str] = []

        alias_path = os.path.join(
            frappe.get_app_path("changai"),
            "changai",
            "api",
            "v2",
            "assets",
            "changai_alias_map.json"
        )

        with open(alias_path, "r", encoding="utf-8") as f:

            alias_map = json.load(f)

        self.en_alias_map = alias_map["english"]
        self.ar_alias_map = alias_map["arabic"]
                # Safe categories for broader partial matching
        self.safe_categories_for_partial = {
                    "greeting",
                    "support",
                    "identity",
                    "thanks",
                    "goodbye",
                }

        # Small stopword sets to avoid weak overlap scoring
        self.en_stopwords = {
            "the", "a", "an", "is", "are", "am", "i", "you", "me",
            "my", "your", "to", "for", "of", "and", "or", "please"
        }

        self.ar_stopwords = {
            "في", "من", "على", "الى", "إلى", "عن", "و", "يا", "هل", "ما", "ماذا"
        }

        self._load_csv()

    # -----------------------------
    # CSV loading
    # -----------------------------

    def _load_csv(self) -> None:
        self.entries.clear()
        self.responses_by_key.clear()
        self.keys.clear()

        with open(self.csv_file, mode="r", encoding="utf-8-sig") as f:
            reader = csv.DictReader(f)
            for row in reader:
                category = (row.get("category") or "").strip().lower()
                user_input = (row.get("user_input") or "").strip()
                response = (row.get("response") or "").strip()

                if not user_input or not response:
                    continue

                priority_raw = (row.get("priority") or "100").strip()
                is_active_raw = (row.get("is_active") or "1").strip()

                try:
                    priority = int(priority_raw)
                except ValueError:
                    priority = 100

                is_active = str(is_active_raw).strip() in {"1", "true", "True", "yes", "YES"}

                if not is_active:
                    continue

                normalized_key = self.preprocess(user_input)

                entry = ResponseEntry(
                    category=category,
                    user_input=normalized_key,
                    response=response,
                    priority=priority,
                    is_active=is_active,
                )

                self.entries.append(entry)
                self.responses_by_key.setdefault(normalized_key, []).append(entry)

        self.keys = list(self.responses_by_key.keys())
    def get_response(self, user_input: str) -> Dict[str, Any]:
        clean_input = self.preprocess(user_input)
        if not clean_input:
            return self._empty_result()

        # 1. Exact
        result = self._exact_match(clean_input)
        if result:
            return result

        # 2. Partial token subset
        result = self._partial_match(clean_input)
        if result:
            return result

        # 3. Token overlap
        result = self._token_overlap_match(clean_input)
        if result:
            return result

        # 4. Fuzzy
        result = self._fuzzy_match(clean_input)
        if result:
            return result

        return self._empty_result()

    def _exact_match(self, clean_input: str) -> Optional[Dict[str, Any]]:
        entries = self.responses_by_key.get(clean_input)
        if not entries:
            return None

        best = self._choose_best_entry(entries)
        return self._build_result(
            matched=True,
            response=best.response,
            category=best.category,
            match_type="exact",
            matched_key=best.user_input,
            score=100,
        )

    def _partial_match(self, clean_input: str) -> Optional[Dict[str, Any]]:
        input_tokens = self._meaningful_tokens(clean_input)
        if not input_tokens:
            return None

        candidates: List[Tuple[ResponseEntry, float]] = []

        for key, entries in self.responses_by_key.items():
            key_tokens = self._meaningful_tokens(key)
            if not key_tokens:
                continue

            best_entry = self._choose_best_entry(entries)

            if best_entry.category not in self.safe_categories_for_partial:
                continue

            if input_tokens.issubset(key_tokens):
                coverage = len(input_tokens) / max(len(key_tokens), 1)

                # Prefer closest-size phrase + higher priority
                score = (coverage * 100) + min(best_entry.priority / 100.0, 5)
                candidates.append((best_entry, score))

        if not candidates:
            return None

        candidates.sort(key=lambda x: (x[1], x[0].priority), reverse=True)
        best_entry, best_score = candidates[0]

        return self._build_result(
            matched=True,
            response=best_entry.response,
            category=best_entry.category,
            match_type="partial",
            matched_key=best_entry.user_input,
            score=round(best_score, 2),
        )

    def _token_overlap_match(self, clean_input: str) -> Optional[Dict[str, Any]]:
        input_tokens = self._meaningful_tokens(clean_input)
        if not input_tokens:
            return None

        candidates: List[Tuple[ResponseEntry, float]] = []

        for key, entries in self.responses_by_key.items():
            key_tokens = self._meaningful_tokens(key)
            if not key_tokens:
                continue

            best_entry = self._choose_best_entry(entries)

            common = input_tokens & key_tokens
            if not common:
                continue

            precision = len(common) / len(input_tokens)
            recall = len(common) / len(key_tokens)
            overlap_score = (0.7 * precision) + (0.3 * recall)

            min_threshold = 0.85 if len(input_tokens) <= 2 else 0.75

            if overlap_score >= min_threshold:
                final_score = (overlap_score * 100) + min(best_entry.priority / 100.0, 5)
                candidates.append((best_entry, final_score))

        if not candidates:
            return None

        candidates.sort(key=lambda x: (x[1], x[0].priority), reverse=True)
        best_entry, best_score = candidates[0]

        return self._build_result(
            matched=True,
            response=best_entry.response,
            category=best_entry.category,
            match_type="token_overlap",
            matched_key=best_entry.user_input,
            score=round(best_score, 2),
        )

    def _fuzzy_match(self, clean_input: str) -> Optional[Dict[str, Any]]:
        if not self.keys:
            return None

        result = process.extractOne(clean_input, self.keys)
        if not result:
            return None

        best_key = result[0]
        score = result[1]
        entries = self.responses_by_key.get(best_key, [])
        if not entries:
            return None

        best_entry = self._choose_best_entry(entries)

        # stricter thresholds for short inputs
        token_count = len(clean_input.split())

        if self._contains_arabic(clean_input):
            threshold = 90 if token_count <= 2 else 85
        else:
            threshold = 92 if token_count <= 2 else 86

        if score < threshold:
            return None

        return self._build_result(
            matched=True,
            response=best_entry.response,
            category=best_entry.category,
            match_type="fuzzy",
            matched_key=best_entry.user_input,
            score=score,
        )

    # -----------------------------
    # Helpers
    # -----------------------------

    def preprocess(self, text: str) -> str:
        text = self._normalize_unicode(text)
        text = self._normalize_arabic(text)
        text = self._normalize_english(text)
        text = self._apply_aliases(text)
        text = self._normalize_spaces(text)
        return text.strip()

    def _normalize_unicode(self, text: str) -> str:
        text = unicodedata.normalize("NFKC", text)
        return text.lower().strip()

    def _normalize_english(self, text: str) -> str:
        # remove punctuation but keep Arabic/English letters/numbers/spaces
        text = re.sub(r"[^\w\s\u0600-\u06FF]", " ", text)
        return text

    def _normalize_arabic(self, text: str) -> str:
        # remove tatweel
        text = text.replace("ـ", "")

        # remove Arabic diacritics
        arabic_diacritics = re.compile(r"""
            ّ|َ|ً|ُ|ٌ|ِ|ٍ|ْ|ـ
        """, re.VERBOSE)
        text = re.sub(arabic_diacritics, "", text)

        # normalize common Arabic letter variants
        replacements = {
            "أ": "ا",
            "إ": "ا",
            "آ": "ا",
            "ى": "ي",
            "ة": "ه",
            "ؤ": "و",
            "ئ": "ي",
        }
        for old, new in replacements.items():
            text = text.replace(old, new)

        return text

    def _normalize_spaces(self, text: str) -> str:
        text = re.sub(r"\s+", " ", text)
        return text.strip()

    def _apply_aliases(self, text: str) -> str:
        # phrase-level aliases first
        phrase_aliases = {
            "who r you": "who are you",
            "what are you": "who are you",
            "منو انت": "من انت",
            "السلامعليكم": "السلام عليكم",
        }

        for old, new in phrase_aliases.items():
            text = text.replace(old, new)

        words = text.split()
        mapped_words = []

        for word in words:
            if self._is_arabic_word(word):
                mapped_words.append(self.ar_alias_map.get(word, word))
            else:
                mapped_words.append(self.en_alias_map.get(word, word))

        return " ".join(mapped_words)

    def _meaningful_tokens(self, text: str) -> Set[str]:
        tokens = set(text.split())
        filtered = set()

        for token in tokens:
            if self._is_arabic_word(token):
                if token not in self.ar_stopwords and len(token) > 1:
                    filtered.add(token)
            else:
                if token not in self.en_stopwords and len(token) > 1:
                    filtered.add(token)

        return filtered

    def _choose_best_entry(self, entries: List[ResponseEntry]) -> ResponseEntry:
        # Prefer:
        # 1. higher priority
        # 2. longer trigger phrase (more specific)
        # 3. stable order otherwise
        return sorted(
            entries,
            key=lambda e: (e.priority, len(e.user_input.split())),
            reverse=True
        )[0]

    def _contains_arabic(self, text: str) -> bool:
        return bool(re.search(r"[\u0600-\u06FF]", text))

    def _is_arabic_word(self, word: str) -> bool:
        return bool(re.search(r"[\u0600-\u06FF]", word))

    def _build_result(
        self,
        matched: bool,
        response: Optional[str],
        category: Optional[str],
        match_type: Optional[str],
        matched_key: Optional[str],
        score: Optional[float],
    ) -> Dict[str, Any]:
        return {
            "matched": matched,
            "response": response,
            "category": category,
            "match_type": match_type,
            "matched_key": matched_key,
            "score": score,
        }

    def _empty_result(self) -> Dict[str, Any]:
        return {
            "matched": False,
            "response": None,
            "category": None,
            "match_type": None,
            "matched_key": None,
            "score": None,
        }
    
def handle_non_erp_query(user_input: str) -> dict:
    csv_path = os.path.join(
        frappe.get_app_path("changai"),
        "changai",
        "api",
        "v2",
        "assets",
        "non_erp.csv"
    )


    responder = IntelligentStaticResponder(csv_path)

    static_result = responder.get_response(user_input)

    if static_result["matched"]:
        return {
            "kind": "NON_ERP_STATIC",
            "data": static_result["response"]
        }

    # fallback to your normal non-ERP AI flow

    return {
        "kind": "NON_ERP_AI",
        "data": "Hello Iam ChangAI, I am here to assist you with your queries."
    }