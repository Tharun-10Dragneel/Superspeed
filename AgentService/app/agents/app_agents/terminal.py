"""
Terminal Agent - Command Line Wizard
Pillar: Command Line & Data Wizard
"""
from app.agents.base import BaseAgent
from app.prompts.templates import TERMINAL_SYSTEM_PROMPT


class TerminalAgent(BaseAgent):
    """Agent for Terminal command generation"""
    
    @property
    def agent_name(self) -> str:
        return "terminal"
    
    @property
    def system_prompt(self) -> str:
        return TERMINAL_SYSTEM_PROMPT

