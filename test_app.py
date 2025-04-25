from app import app

def test_home():
    tester = app.test_client()
    response = tester.get('/')
    assert response.status_code == 200
    assert response.content_type == 'text/html; charset=utf-8'
    assert b"Hello from Cerberus" in response.data

def test_ping():
    tester = app.test_client()
    response = tester.get('/ping')
    assert response.status_code == 200
    assert response.content_type == 'application/json'
    assert response.get_json() == {"status": "ok"}

def test_status():
    tester = app.test_client()
    response = tester.get('/status')
    assert response.status_code == 200
    assert response.content_type.startswith('text/html')
    assert b"Cerberus Status" in response.data
