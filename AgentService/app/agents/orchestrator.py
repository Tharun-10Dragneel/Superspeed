"""
Agent Orchestrator - Router Pattern
Routes requests to appropriate app-specific agent
"""
import structlog
from typing import Dict

from app.api.v1.models import CompletionRequest, CompletionResponse
from app.agents.base import BaseAgent
from app.agents.app_agents.gmail import GmailAgent
from app.agents.app_agents.slack import SlackAgent
from app.agents.app_agents.terminal import TerminalAgent
from app.services.llm_client import LLMService
from app.services.language import LanguageDetectionService

logger = structlog.get_logger()


class AgentOrchestrator:
    """
    Supervisor pattern orchestrator
    Routes requests to specialized agents based on app_name
    """
    
    def __init__(self, llm_service: LLMService, language_service: LanguageDetectionService):
        self.llm_service = llm_service
        self.language_service = language_service
        
        # Initialize all agents
        self.agents: Dict[str, BaseAgent] = {
            "gmail": GmailAgent(llm_service),
            "slack": SlackAgent(llm_service),
            "terminal": TerminalAgent(llm_service),
            # TODO: Add more agents
            # "discord": DiscordAgent(llm_service),
            # "notion": NotionAgent(llm_service),
            # "vscode": VSCodeAgent(llm_service),
        }
    
    async def route_request(self, request: CompletionRequest) -> CompletionResponse:
        """
        Main routing logic
        1. Detect language (if needed)
        2. Select appropriate agent
        3. Process request
        """
        # Language detection
        if not request.input_language:
            detected_lang = self.language_service.detect_language(request.user_input)
            request.input_language = detected_lang
            logger.info("language_detected", lang=detected_lang)
        
        # Route to agent
        app_name_lower = request.app_name.lower()
        agent = self.agents.get(app_name_lower)
        
        if not agent:
            logger.warning("agent_not_found", app_name=request.app_name)
            # Fallback to generic agent
            agent = self.agents["gmail"]  # Generic communication agent as fallback
        
        # Process request
        response = await agent.process(request)
        
        return response

