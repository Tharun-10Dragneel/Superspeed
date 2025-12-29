"""
Language Detection and Bridge Service
Detects Hindi/Hinglish and translates to English
"""
import re
from typing import Literal


class LanguageDetectionService:
    """Detect input language and provide translation hints"""
    
    # Common Hinglish/Hindi patterns
    HINDI_PATTERNS = [
        r'[\u0900-\u097F]+',  # Devanagari script
        r'\b(hai|hoon|kya|nahi|acha|thik|kar|karo|kya|kaise)\b',  # Common Hinglish words
    ]
    
    def detect_language(self, text: str) -> Literal["english", "hindi", "hinglish", "unknown"]:
        """Detect if text is English, Hindi, Hinglish, or unknown"""
        
        # Check for Devanagari script
        if re.search(self.HINDI_PATTERNS[0], text):
            return "hindi"
        
        # Check for common Hinglish patterns
        hinglish_count = sum(1 for pattern in self.HINDI_PATTERNS[1:] if re.search(pattern, text, re.IGNORECASE))
        
        if hinglish_count >= 2:
            return "hinglish"
        
        # Default to English
        return "english" if text.isascii() else "unknown"
    
    def needs_translation(self, detected_lang: str, output_lang: str) -> bool:
        """Check if translation is needed"""
        return detected_lang in ["hindi", "hinglish"] and output_lang == "english"
    
    def get_translation_instruction(self, detected_lang: str, output_lang: str) -> str:
        """Generate instruction for LLM to translate"""
        if not self.needs_translation(detected_lang, output_lang):
            return ""
        
        return f"\n\n[IMPORTANT: The user wrote in {detected_lang}. Translate their intent to {output_lang} and provide the completion in {output_lang}.]"


