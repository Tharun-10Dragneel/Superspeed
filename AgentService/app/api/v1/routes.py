"""
API v1 Routes
Main endpoint: POST /api/v1/complete
"""
from fastapi import APIRouter, Depends, HTTPException
import structlog

from app.api.v1.models import CompletionRequest, CompletionResponse
from app.agents.orchestrator import AgentOrchestrator
from app.dependencies import get_orchestrator

logger = structlog.get_logger()
router = APIRouter()


@router.post("/complete", response_model=CompletionResponse)
async def complete_text(
    request: CompletionRequest,
    orchestrator: AgentOrchestrator = Depends(get_orchestrator),
) -> CompletionResponse:
    """
    Main completion endpoint
    Routes request to appropriate agent based on app_name
    """
    try:
        logger.info(
            "completion_request",
            app_name=request.app_name,
            user_tier=request.user_tier,
            input_length=len(request.user_input),
        )
        
        response = await orchestrator.route_request(request)
        
        logger.info(
            "completion_success",
            agent=response.agent_used,
            confidence=response.confidence,
        )
        
        return response
        
    except Exception as e:
        logger.error("completion_failed", error=str(e), exc_info=True)
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/agents")
async def list_agents():
    """List all available agents"""
    return {
        "agents": [
            "gmail", "slack", "discord", "notion", "terminal",
            "vscode", "cursor", "chatgpt", "claude", "excel"
        ],
        "total": 10
    }


