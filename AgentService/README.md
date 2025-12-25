# Helio Agent Service

**Multi-agent backend for intelligent text completion across all apps**

## Architecture

- **Framework**: FastAPI (Python 3.11+)
- **Agent System**: LangGraph supervisor pattern with app-specific agents
- **LLM Provider**: Cerebras Inference API (2500+ tokens/sec, free tier)
- **Deployment**: Docker + uvicorn

## Project Structure

```
AgentService/
├── app/
│   ├── api/v1/          # API routes and models
│   ├── agents/          # Agent orchestration
│   │   ├── app_agents/  # App-specific agents (Gmail, Slack, Terminal, etc.)
│   │   ├── base.py      # BaseAgent abstract class
│   │   └── orchestrator.py  # Supervisor router
│   ├── services/        # LLM client, language detection
│   ├── prompts/         # Agent system prompts
│   ├── core/            # Logging, errors, utilities
│   └── main.py          # FastAPI app entry point
├── requirements.txt
├── Dockerfile
└── .env.example
```

## Setup

### 1. Install Dependencies

```bash
cd AgentService
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 2. Configure Environment

```bash
cp .env.example .env
# Edit .env and add your CEREBRAS_API_KEY
```

### 3. Run Development Server

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

API will be available at:
- **Docs**: http://localhost:8000/docs
- **Health**: http://localhost:8000/health

## API Usage

### POST /api/v1/complete

```json
{
  "user_input": "need report by friday urgent",
  "app_name": "gmail",
  "context": "Re: Q4 Report",
  "user_tier": "free",
  "output_language": "english"
}
```

**Response:**

```json
{
  "suggestion": "Could you please send me the report by Friday? This is time-sensitive. Thank you!",
  "agent_used": "gmail",
  "confidence": 0.85,
  "detected_input_lang": "english"
}
```

## Adding New Agents

1. Create agent file in `app/agents/app_agents/your_agent.py`
2. Inherit from `BaseAgent`
3. Define `agent_name` and `system_prompt`
4. Add system prompt to `app/prompts/templates.py`
5. Register agent in `orchestrator.py`

Example:

```python
# app/agents/app_agents/discord.py
from app.agents.base import BaseAgent
from app.prompts.templates import DISCORD_SYSTEM_PROMPT

class DiscordAgent(BaseAgent):
    @property
    def agent_name(self) -> str:
        return "discord"
    
    @property
    def system_prompt(self) -> str:
        return DISCORD_SYSTEM_PROMPT
```

## Testing

```bash
pytest app/tests/
```

## Docker Deployment

```bash
docker build -t helio-agent-service .
docker run -p 8000:8000 --env-file .env helio-agent-service
```

## Performance

- **Latency**: ~200-500ms (Cerebras ultra-fast inference)
- **Throughput**: 2500+ tokens/sec
- **Rate Limits**:
  - Free tier: 25 completions/day
  - Pro tier: Unlimited

## Roadmap

- [ ] Add 10 more agents (Discord, Notion, VSCode, Cursor, Excel, etc.)
- [ ] Implement user-specific tone/style learning
- [ ] Add caching layer (Redis)
- [ ] Implement rate limiting middleware
- [ ] Add monitoring (Sentry, Prometheus)
- [ ] Switch to async Cerebras client for better performance

