#  Taskflow

> Empowering African Community Cooperatives through Digital Task Management

---

##  Project Overview

**Taskflow** is a web-based task tracking application designed specifically for African community cooperatives, including farmers' cooperatives, microfinance groups, savings groups, and community development organizations.


---

## Problem Statement

In many African communities, cooperatives and community groups manage complex workflows spanning agriculture, microfinance, and community services. Traditional pen-and-paper methods or WhatsApp groups lead to:

- **Lost accountability** when tasks slip through the cracks
- **Difficulty tracking** who is responsible for what and when
- **No visibility** into group priorities and progress
- **Communication gaps** between members across different locations
- **Limited reporting** on group activity and achievements

These challenges prevent community groups from operating efficiently and scaling their impact.

**Our Solution:** A simple, accessible task management platform that brings digital organization to African cooperatives, enabling them to track agricultural tasks, financial obligations, community activities, and more - all in one place.

---

##  Target Users

### Primary Users:
1. **Community Cooperatives** - Agricultural groups managing crop cycles, harvests, and farm maintenance
2. **Microfinance Groups** - Savings groups tracking loan repayments, contributions, and financial planning
3. **Community Organizations** - Groups coordinating community events, health initiatives, and education programs
4. **Market Committees** - Organizations managing local markets, vendor coordination, and logistics

### User Personas:
- **Amina** - Maize farmer and cooperative treasurer, needs to track loan repayments and coordinate with other farmers
- **Mwangi** - Community leader organizing weekly markets and community health meetings
- **Fatima** - Microfinance group chairwoman managing 30+ members' contributions and loan distribution

---

##  Core Features

### 1. Task Creation & Management
- Create tasks with title, description, and category
- Set priority levels (low, medium, high)
- Assign tasks to specific groups or individuals
- Add due dates for time-sensitive tasks
- Customizable status tracking (Pending → In Progress → Completed)

### 2. Category-Based Organization
Tasks are organized into categories relevant to cooperative activities:
- **Agriculture** - Crop cycles, harvests, farm maintenance
- **Finance** - Loan repayments, contributions, budgeting
- **Community** - Events, meetings, social initiatives
- **Education** - Training sessions, workshops, learning circles
- **Health** - Health campaigns, clinic visits, vaccination programs
- **Other** - Custom tasks not fitting other categories

### 3. Priority Management
- High priority tasks highlighted prominently
- Visual indicators for urgent vs. routine tasks
- Helps groups focus on critical activities first

### 4. Real-Time Statistics Dashboard
- Total task count
- Pending tasks overview
- In-progress activities
- High-priority items requiring attention
- Helps leadership make data-driven decisions

### 5. Responsive Design
- Works on mobile phones (critical for users with limited PC access)
- Tablet and desktop friendly
- Offline-first approach with JSON data storage

---

##  Technology Stack

### Backend:
- **Python 3.9+** - Modern, readable server-side logic
- **Flask** - Lightweight web framework for Python
- **JSON File Storage** - Simple, portable data persistence

### Frontend:
- **HTML5** - Semantic markup
- **CSS3** - Modern styling with custom properties
- **Vanilla JavaScript** - No framework dependencies, fast and accessible

### Development & Deployment:
- **Git** - Version control
- **GitHub** - Repository hosting and collaboration
- **Docker** (planned for Formative 2) - Containerization
- **Terraform** (planned for Formative 2) - Infrastructure as Code
- **AWS/Cloud** (planned for Formative 3) - Cloud deployment

---

##  Getting Started

### Prerequisites
- Python 3.9 or higher
- pip (Python package installer)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/taskflow.git
   cd taskflow
   ```

2. **Create a virtual environment** (recommended)
   ```bash
   python -m venv venv
   
   # On Windows:
   venv\Scripts\activate
   
   # On macOS/Linux:
   source venv/bin/activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the application**
   ```bash
   python app.py
   ```

5. **Access the application**
   Open your web browser and navigate to:
   ```
   http://localhost:5000
   ```

The application will start with sample data including:
- Maize harvesting task
- Microfinance loan repayment tracking
- Community market organization

---

##  Using the Application

### Creating a Task
1. Fill in the task title (required)
2. Add a description for context
3. Set priority level
4. Choose the appropriate category
5. Assign to a group or individual
6. Set due date if applicable
7. Click "Create Task"

### Managing Tasks
- **Update Status**: Click "Update Status" to cycle through Pending → In Progress → Completed
- **Delete Task**: Click "Delete" to remove completed or cancelled tasks
- **View Stats**: Dashboard shows real-time statistics at the top

### Best Practices
- Use clear, descriptive task titles
- Assign specific groups or individuals for accountability
- Set realistic due dates
- Update status regularly to reflect current progress

---

##  Project Structure

```
taskflow/
│
├── app.py                    # Flask backend application
├── requirements.txt          # Python dependencies
├── tasks.json                # Data storage (auto-generated)
│
├── templates/
│   └── index.html           # Main dashboard template
│
├── static/
│   ├── styles.css           # Application styling
│   └── app.js               # Frontend JavaScript logic
│
├── .github/
│   └── CODEOWNERS           # Code ownership configuration
│
├── .gitignore               # Git ignore rules
├── LICENSE                  # MIT License
└── README.md               # This file

```

---

##  Security Features

### Repository Security:
- ✅ Comprehensive `.gitignore` file preventing sensitive data commits
- ✅ Environment variable exclusions (`.env`, `secrets.yml`)
- ✅ Dependency directory exclusions (`venv/`, `node_modules/`)
- ✅ IDE-specific file exclusions

### Branch Protection (GitHub Configuration Required):
The `main` branch must be configured with protection rules:
- Require pull request before merging
- Require minimum 1 approval
- Dismiss stale approvals when new commits are pushed
- Require status checks to pass before merging
- Require branches to be up to date before merging
- Require conversation resolution before merging
- Include administrators (enforce for everyone)

**Configuration:** GitHub repository → Settings → Branches → Add protection rule for `main`

---

## 👥 Team Structure

### Roles (Example - customize based on your team):

- **Team Lead**: [Name] - Project coordination and documentation
- **Backend Developer**: [Name] - Flask API and database logic
- **Frontend Developer**: [Name] - UI/UX design and JavaScript functionality
- **DevOps Engineer**: [Name] - CI/CD, containerization, and deployment

---

##  Development Roadmap

### Completed (Formative 1):
- ✅ Project ideation and planning
- ✅ Initial functional application
- ✅ Task CRUD operations
- ✅ Statistics dashboard
- ✅ Repository security setup
- ✅ GitHub Projects board

### Upcoming (Formative 2):
-  Docker containerization
-  CI/CD pipeline with GitHub Actions
-  Infrastructure as Code with Terraform
-  Database migration (SQLite/PostgreSQL)

### Future Enhancements:
-  Email notifications for task assignments
-  Advanced analytics and reporting
-  Mobile app version
-  Real-time collaboration features
-  Multi-language support (Swahili, French, etc.)

---

##  Contributing

This is a course project. Contributions are welcome through:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request for review

All pull requests require at least one team member's approval before merging.

---

##  GitHub Projects Board

Development is tracked using GitHub Projects (Kanban board):
- **Backlog**: Planned features and tasks
- **In Progress**: Currently being worked on
- **Done**: Completed items

**Minimum Requirements:**
- 8-10 items minimum
- Use user stories format: "As a [user type], I want [goal] so that [benefit]"
- Include both feature and DevOps tasks
- Assign tasks to team members
- Add labels (feature, bug, devops, security)
- Organize into columns: Backlog → In Progress → Done

---

##  API Documentation

### Endpoints:

#### `GET /api/tasks`
Returns all tasks
**Response:**
```json
[
  {
    "id": 1,
    "title": "Harvest maize in Plot A",
    "description": "Complete harvesting of maize in the north field",
    "priority": "high",
    "assigned_to": "Mwangi Group",
    "status": "pending",
    "due_date": "2025-11-15",
    "category": "Agriculture"
  }
]
```

#### `POST /api/tasks`
Creates a new task
**Request Body:**
```json
{
  "title": "Task title",
  "description": "Task description",
  "priority": "medium",
  "assigned_to": "Group name",
  "status": "pending",
  "due_date": "2025-11-20",
  "category": "Agriculture"
}
```

#### `PUT /api/tasks/<id>`
Updates an existing task
**Request Body:** Same as POST, include fields to update

#### `DELETE /api/tasks/<id>`
Deletes a task

#### `GET /api/tasks/stats`
Returns task statistics
**Response:**
```json
{
  "total": 10,
  "pending": 5,
  "in_progress": 3,
  "completed": 2,
  "high_priority": 1
}
```

---

##  Troubleshooting

### Issue: Cannot run the application
- **Solution**: Ensure Python 3.9+ is installed and virtual environment is activated

### Issue: Port 5000 already in use
- **Solution**: Change the port in `app.py`:
  ```python
  app.run(debug=True, host='0.0.0.0', port=5001)
  ```

### Issue: Tasks not persisting
- **Solution**: Check that `tasks.json` file is writable and not in `.gitignore`

---

##  License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

##  Acknowledgments

- Flask community for the excellent web framework
- African cooperative communities for inspiration
- Course instructors for DevOps methodology guidance

---


