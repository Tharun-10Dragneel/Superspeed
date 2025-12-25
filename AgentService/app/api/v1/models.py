"""
Pydantic Models for API Request/Response
"""
from pydantic import BaseModel, Field
from typing import Literal


class CompletionRequest(BaseModel):
    """Request model for /complete endpoint"""
    
    user_input: str = Field(..., description="User's raw input text")
    app_name: str = Field(..., description="Application name (e.g., 'gmail', 'slack', 'terminal')")
    context: str | None = Field(None, description="Optional surrounding context")
    cursor_position: int | None = Field(None, description="Cursor position in the text")
    user_tier: Literal["free", "pro"] = Field("free", description="User subscription tier")
    user_id: str | None = Field(None, description="User ID for tracking")
    
    # Language Bridge fields
    input_language: str | None = Field(None, description="Detected or explicit input language")
    output_language: str = Field("english", description="Desired output language")


class CompletionResponse(BaseModel):
    """Response model for /complete endpoint"""
    
    suggestion: str = Field(..., description="AI-generated completion/suggestion")
    agent_used: str = Field(..., description="Which agent handled this request")
    confidence: float = Field(..., description="Confidence score 0-1")
    detected_input_lang: str | None = Field(None, description="Detected input language")
    reasoning: str | None = Field(None, description="Optional reasoning for debugging")


class HealthResponse(BaseModel):
    """Health check response"""
    status: Literal["healthy", "degraded", "unhealthy"]
    version: str
    service: str

