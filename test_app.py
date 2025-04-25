from app import app

def test_ping():
    tester = app.test_client()
    response = tester.get('/ping')
    assert response.status_code == 200
    assert response.json == {"status": "ok"}
