"""
Unit tests for TaskFlow application
"""

import pytest
import json
import os
import sys

# Add parent directory to path to import app
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import app, init_tasks, save_tasks, load_tasks


@pytest.fixture
def client():
    """Create a test client for the Flask app"""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client


@pytest.fixture
def sample_tasks():
    """Create sample tasks for testing"""
    return [
        {
            "id": 1,
            "title": "Test Task 1",
            "description": "Test description",
            "priority": "high",
            "assigned_to": "Test User",
            "status": "pending",
            "due_date": "2025-12-31",
            "category": "Testing"
        }
    ]


def test_index_route(client):
    """Test that the index route returns 200"""
    response = client.get('/')
    assert response.status_code == 200


def test_get_tasks(client, sample_tasks):
    """Test getting all tasks"""
    # Save sample tasks
    save_tasks(sample_tasks)
    
    response = client.get('/api/tasks')
    assert response.status_code == 200
    
    data = json.loads(response.data)
    assert isinstance(data, list)
    assert len(data) >= 1


def test_create_task(client):
    """Test creating a new task"""
    new_task = {
        "title": "New Test Task",
        "description": "New test description",
        "priority": "medium",
        "assigned_to": "Test User",
        "status": "pending",
        "due_date": "2025-12-31",
        "category": "Testing"
    }
    
    response = client.post('/api/tasks',
                          data=json.dumps(new_task),
                          content_type='application/json')
    
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data['title'] == new_task['title']
    assert 'id' in data


def test_get_stats(client, sample_tasks):
    """Test getting task statistics"""
    save_tasks(sample_tasks)
    
    response = client.get('/api/tasks/stats')
    assert response.status_code == 200
    
    data = json.loads(response.data)
    assert 'total' in data
    assert 'pending' in data
    assert 'completed' in data


def test_update_task(client, sample_tasks):
    """Test updating an existing task"""
    save_tasks(sample_tasks)
    
    updated_data = {"status": "completed"}
    response = client.put('/api/tasks/1',
                         data=json.dumps(updated_data),
                         content_type='application/json')
    
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'completed'


def test_delete_task(client, sample_tasks):
    """Test deleting a task"""
    save_tasks(sample_tasks)
    
    response = client.delete('/api/tasks/1')
    assert response.status_code == 204


def test_update_nonexistent_task(client):
    """Test updating a task that doesn't exist"""
    response = client.put('/api/tasks/9999',
                         data=json.dumps({"status": "completed"}),
                         content_type='application/json')
    
    assert response.status_code == 404

