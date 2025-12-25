"""
Custom Error Classes
"""


class HelioError(Exception):
    """Base error class for Helio Agent Service"""
    pass


class AgentNotFoundError(HelioError):
    """Raised when requested agent doesn't exist"""
    pass


class LLMError(HelioError):
    """Raised when LLM API call fails"""
    pass


class RateLimitError(HelioError):
    """Raised when user exceeds rate limit"""
    pass

