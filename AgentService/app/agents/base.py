"""
Base Agent Class
All app-specific agents inherit from this
"""
from abc import ABC, abstractmethod
from typing import Protocol

from app.api.v1.models import CompletionRequest, CompletionResponse
from app.services.llm_client import LLMService


class BaseAgent(ABC):
    """Abstract base class for all agents"""
    
    def __init__(self, llm_service: LLMService):
        self.llm_service = llm_service
    
    @property
    @abstractmethod
    def agent_name(self) -> str:
        """Agent identifier"""
        pass
    
    @property
    @abstractmethod
    def system_prompt(self) -> str:
        """App-specific system prompt"""
        pass
    
    async def process(self, request: CompletionRequest) -> CompletionResponse:
        """
        Main processing method
        1. Build prompt with system instructions
        2. Call LLM
        3. Return formatted response
        """
        # Build full prompt
        full_prompt = self._build_prompt(request)
        
        # Get LLM completion
        llm_response = await self.llm_service.complete(
            full_prompt,
            tier=request.user_tier
        )
        
        # Return formatted response
        return CompletionResponse(
            suggestion=llm_response.content.strip(),
            agent_used=self.agent_name,
            confidence=0.85,  # TODO: Implement confidence scoring
            detected_input_lang=request.input_language,
        )
    
    def _build_prompt(self, request: CompletionRequest) -> str:
        """Build complete prompt with system + user input"""
        parts = [
            self.system_prompt,
            "",
            f"User input: {request.user_input}",
        ]
        
        if request.context:
            parts.append(f"Context: {request.context}")
        
        return "\n".join(parts)

