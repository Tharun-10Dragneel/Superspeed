"""
Dependency Injection for FastAPI
Provides shared instances of services
"""
from functools import lru_cache

from app.services.llm_client import LLMService
from app.services.language import LanguageDetectionService
from app.agents.orchestrator import AgentOrchestrator


@lru_cache()
def get_llm_service() -> LLMService:
    """Get singleton LLM service instance"""
    return LLMService()


@lru_cache()
def get_language_service() -> LanguageDetectionService:
    """Get singleton language detection service"""
    return LanguageDetectionService()


@lru_cache()
def get_orchestrator() -> AgentOrchestrator:
    """Get singleton agent orchestrator"""
    llm_service = get_llm_service()
    language_service = get_language_service()
    return AgentOrchestrator(llm_service, language_service)

