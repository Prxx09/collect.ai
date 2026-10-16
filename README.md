# CollectAI

Unified Agentic Collections & Quality Assurance Platform.

> **Demo-only MVP.** All borrowers, accounts, payments, commitments, and outreach are synthetic. No real-world calls or financial transactions are enabled.

## Architecture
- `services/api`: FastAPI application with tenant-aware, read-only sample-account endpoints.
- `services/voice-worker`: reserved for LiveKit streaming agent.
- `services/qa-engine`: deterministic compliance and execution evaluation.
- `supabase/migrations`: tenant-scoped PostgreSQL schema with row-level security.
- `policies/demo-india`: illustrative policy configuration; **not legal advice**.

## Local API
Requires Python 3.11+.

```bash
python -m venv .venv
# Windows: .venv\Scripts\activate
# macOS/Linux: source .venv/bin/activate
pip install -r services/api/requirements.txt
uvicorn app.main:app --app-dir services/api --reload
pytest services/api/tests
```

Visit `http://127.0.0.1:8000/docs`. Only the health endpoint is available until Supabase is configured. Database-backed routes require the configured connection and authentication.

## Milestones
1. Foundation: schema, API contracts, tenant controls, synthetic dataset.
2. React portal and case timeline.
3. Real-time browser Voice Lab.
4. Transactional collections actions.
5. Independent QA and adversarial tests.
6. Deployment and integration.

See [architecture](docs/architecture.md) and [security notes](docs/security.md).