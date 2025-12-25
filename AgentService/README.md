# Helio Agent Service

Cloud-based AI agent backend for Helio clients using FastAPI + LangGraph.

## Architecture

- **Framework**: FastAPI 0.115+
- **Agent Orchestration**: LangChain + LangGraph (Supervisor Pattern)
- **LLM Providers**: Cerebras (free tier), Claude 3.5 Sonnet (pro tier)
- **Language**: Python 3.11+ with type hints

## Project Structure

```
AgentService/
├── app/
│   ├── api/              # API endpoints
│   ├── agents/           # LangGraph orchestrator + app agents
│   ├── prompts/          # Prompt templates
│   ├── services/         # LLM clients, language detection
│   ├── core/             # Logging, errors, utilities
│   └── tests/            # Unit tests
├── .env.example          # Environment variables template
└── requirements.txt      # Python dependencies
```

## Setup

1. Create virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Configure environment:
```bash
cp .env.example .env
# Edit .env with your API keys
```

4. Run server:
```bash
uvicorn app.main:app --reload
```

5. View API docs:
```
http://localhost:8000/docs
```

## API Endpoints

- `POST /api/v1/complete` - Generate AI suggestion
- `GET /health` - Health check

## Development

Run tests:
```bash
pytest
```

Format code:
```bash
black app/
isort app/
```

Lint:
```bash
ruff app/
mypy app/
```

