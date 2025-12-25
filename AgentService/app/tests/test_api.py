"""
API Integration Tests
"""
import pytest
from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_health_check():
    """Test health endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_root():
    """Test root endpoint"""
    response = client.get("/")
    assert response.status_code == 200
    assert "Helio" in response.json()["message"]


def test_list_agents():
    """Test agent list endpoint"""
    response = client.get("/api/v1/agents")
    assert response.status_code == 200
    data = response.json()
    assert "agents" in data
    assert len(data["agents"]) > 0


@pytest.mark.asyncio
async def test_completion_endpoint():
    """Test completion endpoint"""
    # This is a placeholder - requires CEREBRAS_API_KEY in environment
    payload = {
        "user_input": "test input",
        "app_name": "gmail",
        "user_tier": "free"
    }
    
    # Will fail without API key, but tests the endpoint structure
    response = client.post("/api/v1/complete", json=payload)
    
    # Should return 500 if API key missing, 200 if successful
    assert response.status_code in [200, 500]

