"""
Gmail Agent - Professional Email Communication
Pillar: Communication Polisher
"""
from app.agents.base import BaseAgent
from app.prompts.templates import GMAIL_SYSTEM_PROMPT


class GmailAgent(BaseAgent):
    """Agent for Gmail email composition"""
    
    @property
    def agent_name(self) -> str:
        return "gmail"
    
    @property
    def system_prompt(self) -> str:
        return GMAIL_SYSTEM_PROMPT

