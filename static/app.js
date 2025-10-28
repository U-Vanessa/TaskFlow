// Taskflow - JavaScript

let tasks = [];

// Initialize the app
document.addEventListener('DOMContentLoaded', function() {
    loadTasks();
    
    // Form submission
    document.getElementById('taskForm').addEventListener('submit', handleFormSubmit);
});

// Load tasks from API
async function loadTasks() {
    try {
        const response = await fetch('/api/tasks');
        tasks = await response.json();
        renderTasks();
        updateStats();
    } catch (error) {
        console.error('Error loading tasks:', error);
    }
}

// Handle form submission
async function handleFormSubmit(e) {
    e.preventDefault();
    
    const formData = {
        title: document.getElementById('title').value,
        description: document.getElementById('description').value,
        priority: document.getElementById('priority').value,
        assigned_to: document.getElementById('assigned_to').value,
        status: document.getElementById('status').value,
        due_date: document.getElementById('due_date').value,
        category: document.getElementById('category').value
    };
    
    try {
        const response = await fetch('/api/tasks', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        });
        
        if (response.ok) {
            loadTasks();
            document.getElementById('taskForm').reset();
            alert('Task created successfully!');
        }
    } catch (error) {
        console.error('Error creating task:', error);
        alert('Error creating task');
    }
}

// Render tasks on the page
function renderTasks() {
    const tasksGrid = document.getElementById('tasksGrid');
    
    if (tasks.length === 0) {
        tasksGrid.innerHTML = `
            <div class="empty-state" style="grid-column: 1/-1;">
                <h2>No Tasks Yet</h2>
                <p>Create your first task to get started!</p>
            </div>
        `;
        return;
    }
    
    tasksGrid.innerHTML = tasks.map(task => `
        <div class="task-card">
            <span class="task-priority priority-${task.priority}">${task.priority.toUpperCase()}</span>
            <span class="task-status status-${task.status}">${task.status.replace('_', ' ').toUpperCase()}</span>
            <h3>${task.title}</h3>
            <p class="description">${task.description || 'No description'}</p>
            <div class="task-info">
                <span class="info-badge">Assigned: ${task.assigned_to}</span>
                <span class="info-badge">Category: ${task.category}</span>
                ${task.due_date ? `<span class="info-badge">Due: ${task.due_date}</span>` : ''}
            </div>
            <div class="task-actions">
                <button class="btn btn-secondary btn-small" onclick="updateTaskStatus(${task.id})">
                    Update Status
                </button>
                <button class="btn btn-danger btn-small" onclick="deleteTask(${task.id})">
                    Delete
                </button>
            </div>
        </div>
    `).join('');
}

// Update task status
async function updateTaskStatus(taskId) {
    const task = tasks.find(t => t.id === taskId);
    const currentStatus = task.status;
    
    let newStatus;
    if (currentStatus === 'pending') {
        newStatus = 'in_progress';
    } else if (currentStatus === 'in_progress') {
        newStatus = 'completed';
    } else {
        newStatus = 'pending';
    }
    
    try {
        const response = await fetch(`/api/tasks/${taskId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ status: newStatus })
        });
        
        if (response.ok) {
            loadTasks();
        }
    } catch (error) {
        console.error('Error updating task:', error);
    }
}

// Delete task
async function deleteTask(taskId) {
    if (!confirm('Are you sure you want to delete this task?')) {
        return;
    }
    
    try {
        const response = await fetch(`/api/tasks/${taskId}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            loadTasks();
        }
    } catch (error) {
        console.error('Error deleting task:', error);
    }
}

// Update statistics
async function updateStats() {
    try {
        const response = await fetch('/api/tasks/stats');
        const stats = await response.json();
        
        document.getElementById('totalTasks').textContent = stats.total;
        document.getElementById('pendingTasks').textContent = stats.pending;
        document.getElementById('inProgressTasks').textContent = stats.in_progress;
        document.getElementById('highPriorityTasks').textContent = stats.high_priority;
    } catch (error) {
        console.error('Error loading stats:', error);
    }
}

