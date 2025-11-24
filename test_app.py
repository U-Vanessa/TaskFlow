"""
Basic tests for TaskFlow application
These tests can be expanded as needed
"""

import pytest
import json
import os
import sys
from app import app, load_tasks, save_tasks

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

@pytest.fixture
def client():
    """Create a test client"""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

@pytest.fixture
def cleanup_tasks():
    """Cleanup tasks.json after tests"""
    original_exists = os.path.exists('tasks.json')
    yield
    if not original_exists and os.path.exists('tasks.json'):
        os.remove('tasks.json')

def test_health_endpoint(client):
    """Test health check endpoint"""
    response = client.get('/health')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'healthy'

def test_get_tasks_empty(client, cleanup_tasks):
    """Test getting tasks when none exist"""
    if os.path.exists('tasks.json'):
        os.remove('tasks.json')
    response = client.get('/api/tasks')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert isinstance(data, list)

def test_create_task(client, cleanup_tasks):
    """Test creating a new task"""
    task_data = {
        'title': 'Test Task',
        'description': 'This is a test task',
        'priority': 'high',
        'category': 'Test',
        'assigned_to': 'Test User',
        'status': 'pending'
    }
    response = client.post('/api/tasks',
                          data=json.dumps(task_data),
                          content_type='application/json')
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data['title'] == 'Test Task'
    assert 'id' in data

def test_get_stats(client, cleanup_tasks):
    """Test getting task statistics"""
    response = client.get('/api/tasks/stats')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert 'total' in data
    assert 'pending' in data
    assert 'in_progress' in data
    assert 'high_priority' in data

def test_index_page(client):
    """Test main index page loads"""
    response = client.get('/')
    assert response.status_code == 200
    assert b'Taskflow' in response.data

if __name__ == '__main__':
    pytest.main([__file__, '-v'])

