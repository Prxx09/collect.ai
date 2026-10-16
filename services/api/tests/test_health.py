from fastapi.testclient import TestClient
from app.main import app

def test_health():
    response = TestClient(app).get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"

def test_no_unprotected_account_route():
    response = TestClient(app).get("/api/accounts")
    assert response.status_code == 404
