"""CollectAI API — no unauthorized account access or demo financial writes."""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_env: str = "development"
    cors_origins: str = "http://localhost:5173"
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


settings = Settings()
app = FastAPI(title="CollectAI API", version="0.1.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=[s.strip() for s in settings.cors_origins.split(",") if s.strip()],
    allow_credentials=False,
    allow_methods=["GET"],
    allow_headers=["Authorization", "Content-Type"],
)


@app.get("/health", tags=["System"])
def health() -> dict[str, str]:
    return {"status": "ok", "service": "collectai-api", "environment": settings.app_env}
