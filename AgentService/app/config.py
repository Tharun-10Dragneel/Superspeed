"""
Configuration Management using Pydantic Settings
Environment-based config with validation
"""
from pydantic_settings import BaseSettings
from pydantic import Field


class Settings(BaseSettings):
    """Application settings loaded from environment variables"""
    
    # API Configuration
    app_name: str = "Helio Agent Service"
    app_version: str = "0.1.0"
    debug: bool = False
    
    # Server
    host: str = "0.0.0.0"
    port: int = 8000
    
    # LLM Configuration
    cerebras_api_key: str = Field(..., env="CEREBRAS_API_KEY")
    anthropic_api_key: str | None = Field(None, env="ANTHROPIC_API_KEY")
    
    # Model Selection
    free_tier_model: str = "llama3.1-8b"  # Cerebras free tier
    pro_tier_model: str = "llama-3.3-70b"  # Cerebras pro tier
    
    # Rate Limiting
    free_tier_daily_limit: int = 25
    pro_tier_daily_limit: int = -1  # Unlimited
    
    # Logging
    log_level: str = "INFO"
    
    class Config:
        env_file = ".env"
        case_sensitive = False


settings = Settings()

