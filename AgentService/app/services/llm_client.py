"""
LLM Client Service - Cerebras Integration (Free Tier)
Ultra-fast inference: 2500+ tokens/sec
"""
import os
from typing import Literal, Protocol
from pydantic import BaseModel
from cerebras.cloud.sdk import Cerebras

from app.config import settings


class LLMResponse(BaseModel):
    """Standardized LLM response"""
    content: str
    model: str
    tokens: int | None = None


class LLMClient(Protocol):
    """Protocol for LLM clients"""
    async def complete(self, prompt: str, model: str) -> LLMResponse:
        ...


class CerebrasClient:
    """Cerebras Inference API - Ultra-fast inference (2500+ t/s)"""
    
    def __init__(self, api_key: str):
        self.client = Cerebras(api_key=api_key)
    
    async def complete(self, prompt: str, model: str = "llama3.1-8b") -> LLMResponse:
        """
        Cerebras delivers 2,500+ tokens/sec on Llama models
        Free tier: llama3.1-8b
        Pro tier: llama-3.3-70b
        """
        response = self.client.chat.completions.create(
            messages=[
                {"role": "system", "content": "You are Superspeed, an intelligent text completion assistant."},
                {"role": "user", "content": prompt}
            ],
            model=model,
            stream=False,
            max_completion_tokens=1024,
            temperature=0.7,
            top_p=0.95,
        )
        
        return LLMResponse(
            content=response.choices[0].message.content,
            model=model,
            tokens=response.usage.total_tokens if response.usage else None
        )


class LLMService:
    """Facade for LLM provider selection based on tier"""
    
    def __init__(self):
        self.cerebras = CerebrasClient(settings.cerebras_api_key)
    
    async def complete(self, prompt: str, tier: str = "free") -> LLMResponse:
        """Route to appropriate model based on tier"""
        if tier == "free":
            return await self.cerebras.complete(prompt, settings.free_tier_model)
        else:
            # Pro tier: use faster/better model
            return await self.cerebras.complete(prompt, settings.pro_tier_model)


