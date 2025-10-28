"""
Taskflow - Flask Backend
A task tracker for African community cooperatives
"""

from flask import Flask, render_template, request, jsonify
from datetime import datetime
import json
import os

app = Flask(__name__)

# Data storage (in production, use a proper database)
DATA_FILE = 'tasks.json'

def load_tasks():
    """Load tasks from JSON file"""
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r') as f:
            return json.load(f)
    return []

def save_tasks(tasks):
    """Save tasks to JSON file"""
    with open(DATA_FILE, 'w') as f:
        json.dump(tasks, f, indent=2)

def init_tasks():
    """Initialize with sample data"""
    sample_tasks = [
        {
            "id": 1,
            "title": "Harvest maize in Plot A",
            "description": "Complete harvesting of maize in the north field",
            "priority": "high",
            "assigned_to": "Mwangi Group",
            "status": "pending",
            "due_date": "2025-11-15",
            "category": "Agriculture"
        },
        {
            "id": 2,
            "title": "Microfinance loan repayment",
            "description": "Collect monthly loan repayments from members",
            "priority": "high",
            "assigned_to": "Finance Committee",
            "status": "in_progress",
            "due_date": "2025-10-28",
            "category": "Finance"
        },
        {
            "id": 3,
            "title": "Community market setup",
            "description": "Organize the weekly farmers market",
            "priority": "medium",
            "assigned_to": "Market Committee",
            "status": "pending",
            "due_date": "2025-10-25",
            "category": "Community"
        }
    ]
    
    if not os.path.exists(DATA_FILE):
        save_tasks(sample_tasks)
    return sample_tasks

@app.route('/')
def index():
    """Main dashboard page"""
    return render_template('index.html')

@app.route('/api/tasks', methods=['GET'])
def get_tasks():
    """Get all tasks"""
    tasks = load_tasks()
    return jsonify(tasks)

@app.route('/api/tasks', methods=['POST'])
def create_task():
    """Create a new task"""
    tasks = load_tasks()
    
    new_task = {
        "id": max([t['id'] for t in tasks], default=0) + 1,
        "title": request.json['title'],
        "description": request.json.get('description', ''),
        "priority": request.json.get('priority', 'medium'),
        "assigned_to": request.json.get('assigned_to', 'Unassigned'),
        "status": request.json.get('status', 'pending'),
        "due_date": request.json.get('due_date', ''),
        "category": request.json.get('category', 'General'),
        "created_at": datetime.now().strftime('%Y-%m-%d')
    }
    
    tasks.append(new_task)
    save_tasks(tasks)
    
    return jsonify(new_task), 201

@app.route('/api/tasks/<int:task_id>', methods=['PUT'])
def update_task(task_id):
    """Update an existing task"""
    tasks = load_tasks()
    
    for task in tasks:
        if task['id'] == task_id:
            task.update(request.json)
            save_tasks(tasks)
            return jsonify(task)
    
    return jsonify({"error": "Task not found"}), 404

@app.route('/api/tasks/<int:task_id>', methods=['DELETE'])
def delete_task(task_id):
    """Delete a task"""
    tasks = load_tasks()
    tasks = [t for t in tasks if t['id'] != task_id]
    save_tasks(tasks)
    return '', 204

@app.route('/api/tasks/stats', methods=['GET'])
def get_stats():
    """Get task statistics"""
    tasks = load_tasks()
    
    stats = {
        "total": len(tasks),
        "pending": len([t for t in tasks if t['status'] == 'pending']),
        "in_progress": len([t for t in tasks if t['status'] == 'in_progress']),
        "completed": len([t for t in tasks if t['status'] == 'completed']),
        "high_priority": len([t for t in tasks if t['priority'] == 'high'])
    }
    
    return jsonify(stats)

if __name__ == '__main__':
    # Initialize with sample data if no data file exists
    init_tasks()
    app.run(debug=True, host='0.0.0.0', port=5000)

