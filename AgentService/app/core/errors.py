"""
Custom Error Classes
"""


class SuperspeedError(Exception):
    """Base error class for Superspeed Agent Service"""
    pass


class AgentNotFoundError(SuperspeedError):
    """Raised when requested agent doesn't exist"""
    pass


class LLMError(SuperspeedError):
    """Raised when LLM API call fails"""
    pass


class RateLimitError(SuperspeedError):
    """Raised when user exceeds rate limit"""
    pass


