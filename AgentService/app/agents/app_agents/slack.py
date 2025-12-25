"""
Slack Agent - Team Communication
Pillar: Communication Polisher
"""
from app.agents.base import BaseAgent
from app.prompts.templates import SLACK_SYSTEM_PROMPT


class SlackAgent(BaseAgent):
    """Agent for Slack message composition"""
    
    @property
    def agent_name(self) -> str:
        return "slack"
    
    @property
    def system_prompt(self) -> str:
        return SLACK_SYSTEM_PROMPT

