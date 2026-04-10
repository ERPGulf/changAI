import re
import os
import unicodedata
import json
import time
import threading
import pickle
from dataclasses import dataclass
from typing import Dict, List, Optional, Set, Tuple, Any

import frappe
from rapidfuzz import process, fuzz


@dataclass
class ResponseEntry:
    category: str
    user_input: str
    response: str
    priority: int = 100
    is_active: bool = True


class IntelligentStaticResponder:
    def __init__(self, json_file: str, alias_path: str):
        t0 = time.time()

        self.json_file = json_file
        self.entries: List[ResponseEntry] = []
        self.responses_by_key: Dict[str, List[ResponseEntry]] = {}
        self.keys: List[str] = []

        self._arabic_diacritics_re = re.compile(r"[ّ َ ً ُ ٌ ِ ٍ ْ ـ]")
        self._non_word_re = re.compile(r"[^\w\s\u0600-\u06FF]")
        self._spaces_re = re.compile(r"\s+")
        self._arabic_detect_re = re.compile(r"[\u0600-\u06FF]")

        t1 = time.time()
        with open(alias_path, "r", encoding="utf-8") as f:
            alias_map = json.load(f)
        print(f"[non_erp] alias json load: {time.time() - t1:.4f}s")

        t2 = time.time()
        self.en_alias_map = self._flatten_alias_groups(alias_map["english"]["aliases"])
        self.ar_alias_map = self._flatten_alias_groups(alias_map["arabic"]["aliases"])
        print(f"[non_erp] alias flatten: {time.time() - t2:.4f}s")

        self.en_brand_aliases = {
            k: v for k, v in self.en_alias_map.items()
            if v in {"changai", "erpgulf"}
        }
        self.ar_brand_aliases = {
            k: v for k, v in self.ar_alias_map.items()
            if v in {"changai", "erpgulf"}
        }

        self.safe_categories_for_partial = {
            "greeting", "support", "identity", "thanks", "goodbye",
        }

        self.en_stopwords = {
            "the", "a", "an", "is", "are", "am", "i", "you", "me",
            "my", "your", "to", "for", "of", "and", "or", "please"
        }

        self.ar_stopwords = {
            "في", "من", "على", "الى", "إلى", "عن", "و", "يا", "هل", "ما", "ماذا"
        }

        self.phrase_aliases = {
            "who r you": "who are you",
            "what are you": "who are you",
            "who r u": "who are you",
            "what r u": "what are you",
            "how r u": "how are you",
            "hw r u": "how are you",
            "ho r u": "how are you",
            "منو انت": "من انت",
            "مين انت": "من انت",
            "السلامعليكم": "السلام عليكم",
            "سلام عليكم": "السلام عليكم",
        }

        t3 = time.time()
        self._load_data()
        print(f"[non_erp] data load: {time.time() - t3:.4f}s")

        t4 = time.time()
        self._key_tokens: Dict[str, Set[str]] = {
            key: self._meaningful_tokens(key)
            for key in self.responses_by_key
        }
        print(f"[non_erp] key token build: {time.time() - t4:.4f}s")

        print(f"[non_erp] responder init total: {time.time() - t0:.4f}s")

    def _flatten_alias_groups(self, grouped_aliases: Dict[str, Dict[str, str]]) -> Dict[str, str]:
        flat: Dict[str, str] = {}
        for group_map in grouped_aliases.values():
            for k, v in group_map.items():
                flat[str(k).lower().strip()] = str(v).lower().strip()
        return flat

    def _pickle_cache_path(self) -> str:
        base, _ = os.path.splitext(self.json_file)
        return base + ".cache.pkl"

    def _can_use_pickle_cache(self, cache_path: str) -> bool:
        if not os.path.exists(cache_path):
            return False
        return os.path.getmtime(cache_path) >= os.path.getmtime(self.json_file)

    def _load_data(self) -> None:
        cache_path = self._pickle_cache_path()

        if self._can_use_pickle_cache(cache_path):
            self._load_from_pickle(cache_path)
            return
        self._build_from_json()
        self._write_pickle_cache(cache_path)

    def _build_from_json(self) -> None:
        self.entries.clear()
        self.responses_by_key.clear()
        self.keys.clear()

        with open(self.json_file, "r", encoding="utf-8") as f:
            rows = json.load(f)

        processed_rows = []

        for row in rows:
            category = str(row.get("category", "")).strip().lower()
            user_input = str(row.get("user_input", "")).strip()
            response = str(row.get("response", "")).strip()

            if not user_input or not response:
                continue

            try:
                priority = int(row.get("priority", 100))
            except (ValueError, TypeError):
                priority = 100

            is_active = bool(row.get("is_active", True))
            if not is_active:
                continue

            # JSON is already assumed normalized/clean
            normalized_key = user_input

            entry = ResponseEntry(
                category=category,
                user_input=normalized_key,
                response=response,
                priority=priority,
                is_active=is_active,
            )
            self.entries.append(entry)
            self.responses_by_key.setdefault(normalized_key, []).append(entry)

            processed_rows.append({
                "category": category,
                "user_input": normalized_key,
                "response": response,
                "priority": priority,
                "is_active": is_active,
            })

        self.keys = list(self.responses_by_key.keys())
        self._processed_rows_for_pickle = processed_rows

    def _write_pickle_cache(self, cache_path: str) -> None:
        rows = getattr(self, "_processed_rows_for_pickle", None)
        if rows is None:
            return

        with open(cache_path, "wb") as f:
            pickle.dump(rows, f, protocol=pickle.HIGHEST_PROTOCOL)

    def _load_from_pickle(self, cache_path: str) -> None:
        self.entries.clear()
        self.responses_by_key.clear()
        self.keys.clear()

        with open(cache_path, "rb") as f:
            rows = pickle.load(f)

        for row in rows:
            entry = ResponseEntry(
                category=row["category"],
                user_input=row["user_input"],
                response=row["response"],
                priority=row["priority"],
                is_active=row["is_active"],
            )
            self.entries.append(entry)
            self.responses_by_key.setdefault(entry.user_input, []).append(entry)

        self.keys = list(self.responses_by_key.keys())

    def get_response(self, user_input: str) -> Dict[str, Any]:
        clean_input = self.preprocess(user_input)

        res = self._exact_match(clean_input)
        if res:
            return res

        res = self._partial_match(clean_input)
        if res:
            return res

        res = self._token_overlap_match(clean_input)
        if res:
            return res

        res = self._fuzzy_match(clean_input)
        if res:
            return res

        return self._empty_result()

    def _exact_match(self, clean_input: str) -> Optional[Dict[str, Any]]:
        entries = self.responses_by_key.get(clean_input)
        if not entries:
            return None
        best = self._choose_best_entry(entries)
        return self._build_result("exact", best, 100)

    def _partial_match(self, clean_input: str) -> Optional[Dict[str, Any]]:
        input_tokens = self._meaningful_tokens(clean_input)
        if not input_tokens:
            return None

        threshold = 0.80 if len(input_tokens) <= 2 else 0.7
        candidates: List[Tuple[ResponseEntry, float]] = []

        for key, entries in self.responses_by_key.items():
            best_entry = self._choose_best_entry(entries)
            if best_entry.category not in self.safe_categories_for_partial:
                continue

            key_tokens = self._key_tokens.get(key, set())
            if not key_tokens:
                continue

            common = input_tokens & key_tokens
            if not common:
                continue

            precision = len(common) / len(input_tokens)
            recall = len(common) / len(key_tokens)
            score_ratio = (0.7 * precision) + (0.3 * recall)

            if score_ratio < threshold:
                continue

            score = (score_ratio * 100) + min(best_entry.priority / 100.0, 5)
            candidates.append((best_entry, score))

        if not candidates:
            return None

        best_entry, best_score = max(candidates, key=lambda x: (x[1], x[0].priority))
        return self._build_result("partial", best_entry, round(best_score, 2))

    def _token_overlap_match(self, clean_input: str) -> Optional[Dict[str, Any]]:
        input_tokens = self._meaningful_tokens(clean_input)
        if not input_tokens:
            return None

        min_threshold = 0.85 if len(input_tokens) <= 2 else 0.75
        candidates: List[Tuple[ResponseEntry, float]] = []

        for key, entries in self.responses_by_key.items():
            key_tokens = self._key_tokens.get(key, set())
            if not key_tokens:
                continue

            common = input_tokens & key_tokens
            if not common:
                continue

            precision = len(common) / len(input_tokens)
            recall = len(common) / len(key_tokens)
            overlap_score = (0.7 * precision) + (0.3 * recall)

            if overlap_score >= min_threshold:
                best_entry = self._choose_best_entry(entries)
                final_score = (overlap_score * 100) + min(best_entry.priority / 100.0, 5)
                candidates.append((best_entry, final_score))

        if not candidates:
            return None

        best_entry, best_score = max(candidates, key=lambda x: (x[1], x[0].priority))
        return self._build_result("token_overlap", best_entry, round(best_score, 2))

    def _fuzzy_match(self, clean_input: str) -> Optional[Dict[str, Any]]:
        if not self.keys:
            return None

        result = process.extractOne(clean_input, self.keys, scorer=fuzz.ratio)
        if not result:
            return None

        best_key, score, *_ = result
        entries = self.responses_by_key.get(best_key, [])
        if not entries:
            return None

        best_entry = self._choose_best_entry(entries)
        token_count = len(clean_input.split())

        if self._contains_arabic(clean_input):
            threshold = 90 if token_count <= 2 else 85
        else:
            threshold = 92 if token_count <= 2 else 86

        if score < threshold:
            return None

        return self._build_result("fuzzy", best_entry, score)

    def preprocess(self, text: str) -> str:
        text = self._normalize_unicode(text)
        text = self._normalize_arabic(text)
        text = self._normalize_english(text)
        text = self._normalize_spaces(text)
        text = self._apply_aliases(text)
        text = self._normalize_spaces(text)
        return text.strip()

    def _normalize_unicode(self, text: str) -> str:
        return unicodedata.normalize("NFKC", text or "").lower().strip()

    def _normalize_english(self, text: str) -> str:
        return self._non_word_re.sub(" ", text)

    def _normalize_arabic(self, text: str) -> str:
        text = text.replace("ـ", "")
        text = self._arabic_diacritics_re.sub("", text)
        for old, new in (("أ", "ا"), ("إ", "ا"), ("آ", "ا"), ("ى", "ي"), ("ة", "ه"), ("ؤ", "و"), ("ئ", "ي")):
            text = text.replace(old, new)
        return text

    def _normalize_spaces(self, text: str) -> str:
        return self._spaces_re.sub(" ", text).strip()

    def _apply_aliases(self, text: str) -> str:
        if not text:
            return text

        for old, new in self.phrase_aliases.items():
            text = text.replace(old, new)

        phrase_fuzzy = self._fuzzy_lookup_alias(
            text,
            self.phrase_aliases,
            threshold=84 if not self._contains_arabic(text) else 93,
        )
        if phrase_fuzzy:
            text = phrase_fuzzy

        words = text.split()
        mapped_words: List[str] = []

        for word in words:
            if self._is_arabic_word(word):
                exact = self.ar_alias_map.get(word)
                if exact:
                    mapped_words.append(exact)
                    continue

                brand = self._fuzzy_lookup_alias(word, self.ar_brand_aliases, 88)
                if brand:
                    mapped_words.append(brand)
                    continue

                fuzzy_word = self._fuzzy_lookup_alias(word, self.ar_alias_map, 91)
                mapped_words.append(fuzzy_word if fuzzy_word else word)
            else:
                exact = self.en_alias_map.get(word)
                if exact:
                    mapped_words.append(exact)
                    continue

                brand = self._fuzzy_lookup_alias(word, self.en_brand_aliases, 80)
                if brand:
                    mapped_words.append(brand)
                    continue

                thr = 70 if len(word) <= 6 else 90
                fuzzy_word = self._fuzzy_lookup_alias(word, self.en_alias_map, thr)
                mapped_words.append(fuzzy_word if fuzzy_word else word)

        return " ".join(mapped_words)

    def _fuzzy_lookup_alias(self, text: str, alias_map: Dict[str, str], threshold: int) -> Optional[str]:
        if not text or not alias_map:
            return None
        result = process.extractOne(text, alias_map.keys(), scorer=fuzz.ratio)
        if result and result[1] >= threshold:
            return alias_map[result[0]]
        return None

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
        return max(entries, key=lambda e: (e.priority, len(e.user_input.split())))

    def _contains_arabic(self, text: str) -> bool:
        return bool(self._arabic_detect_re.search(text))

    def _is_arabic_word(self, word: str) -> bool:
        return bool(self._arabic_detect_re.search(word))

    def _build_result(self, match_type: str, entry: ResponseEntry, score: float) -> Dict[str, Any]:
        return {
            "matched": True,
            "response": entry.response,
            "category": entry.category,
            "match_type": match_type,
            "matched_key": entry.user_input,
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


# ---------------------------
# Global singleton + locks
# ---------------------------

_responder: Optional[IntelligentStaticResponder] = None
_responder_lock = threading.Lock()

REDIS_READY_KEY = "changai:non_erp:ready"
REDIS_WARM_AT_KEY = "changai:non_erp:warmed_at"
REDIS_BUILD_LOCK_KEY = "changai:non_erp:build_lock"


def _asset_paths() -> Tuple[str, str]:
    base = os.path.join(frappe.get_app_path("changai"), "changai", "api", "v2", "assets")
    return (
        os.path.join(base, "non_erp_combined.processed.json"),
        os.path.join(base, "changai_alias_map.json"),
    )


def _build_responder() -> IntelligentStaticResponder:
    json_file, alias_path = _asset_paths()
    return IntelligentStaticResponder(json_file=json_file, alias_path=alias_path)


def _get_responder() -> IntelligentStaticResponder:
    global _responder

    if _responder is not None:
        return _responder

    with _responder_lock:
        if _responder is not None:
            return _responder

        t0 = time.time()
        _responder = _build_responder()
        print(f"[non_erp] _get_responder build: {time.time() - t0:.4f}s")
        return _responder


def warm_non_erp_responder(force: bool = False) -> Dict[str, Any]:
    cache = frappe.cache()

    if not force and cache.get_value(REDIS_READY_KEY):
        return {
            "ok": True,
            "message": "already warm",
            "redis_ready": True,
        }

    lock = cache.lock(REDIS_BUILD_LOCK_KEY, timeout=300)
    got_lock = lock.acquire(blocking=False)
    if not got_lock:
        return {
            "ok": True,
            "message": "warm already in progress",
            "redis_ready": bool(cache.get_value(REDIS_READY_KEY)),
        }

    try:
        if not force and cache.get_value(REDIS_READY_KEY):
            return {
                "ok": True,
                "message": "already warm after lock check",
                "redis_ready": True,
            }

        t0 = time.time()
        responder = _get_responder()
        elapsed = time.time() - t0

        cache.set_value(REDIS_READY_KEY, 1)
        cache.set_value(REDIS_WARM_AT_KEY, frappe.utils.now())

        return {
            "ok": True,
            "message": "warm completed",
            "init_seconds": round(elapsed, 4),
            "entries": len(responder.entries),
            "keys": len(responder.keys),
            "redis_ready": True,
            "warmed_at": cache.get_value(REDIS_WARM_AT_KEY),
        }
    finally:
        lock.release()


def clear_non_erp_responder() -> Dict[str, Any]:
    global _responder
    with _responder_lock:
        _responder = None

    cache = frappe.cache()
    cache.delete_value(REDIS_READY_KEY)
    cache.delete_value(REDIS_WARM_AT_KEY)

    return {"ok": True, "message": "non-erp responder cleared"}


def non_erp_debug_times(user_input: str = "hey whatsapp") -> Dict[str, Any]:
    t0 = time.time()
    responder = _get_responder()
    get_responder_seconds = time.time() - t0

    t1 = time.time()
    result = responder.get_response(user_input)
    matcher_seconds = time.time() - t1

    total_seconds = time.time() - t0

    return {
        "ok": True,
        "input": user_input,
        "get_responder_seconds": round(get_responder_seconds, 6),
        "matcher_seconds": round(matcher_seconds, 6),
        "total_seconds": round(total_seconds, 6),
        "matched": result.get("matched"),
        "match_type": result.get("match_type"),
        "matched_key": result.get("matched_key"),
    }


def handle_non_erp_query(user_input: str) -> dict:
    t0 = time.time()
    responder = _get_responder()
    get_responder_seconds = time.time() - t0
    print(f"[non_erp] _get_responder: {get_responder_seconds:.6f}s")

    t1 = time.time()
    static_result = responder.get_response(user_input)
    matcher_seconds = time.time() - t1
    print(f"[non_erp] matcher only: {matcher_seconds:.6f}s")

    total_seconds = time.time() - t0
    print(f"[non_erp] total: {total_seconds:.6f}s")

    if static_result["matched"]:
        return {
            "kind": "NON_ERP_STATIC",
            "data": static_result["response"],
            "debug": {
                "get_responder_seconds": round(get_responder_seconds, 6),
                "matcher_seconds": round(matcher_seconds, 6),
                "total_seconds": round(total_seconds, 6),
            }
        }

    return {
        "kind": "NON_ERP_AI",
        "data": "Hello I am ChangAI, I am here to assist you with your queries.",
        "debug": {
            "get_responder_seconds": round(get_responder_seconds, 6),
            "matcher_seconds": round(matcher_seconds, 6),
            "total_seconds": round(total_seconds, 6),
        }
    }

handle_non_erp_query("Hye whtassap??>s;wd")