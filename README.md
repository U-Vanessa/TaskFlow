#  Taskflow

> Empowering African Community Cooperatives through Digital Task Management

---
## Group Members (Group 5)

-Vanessa Uwonkunda

-Sine Shaday

-Oluwasijibomi Amatoritshe Athanson


##  Project Overview

**Taskflow** helps African community cooperatives organize work across agriculture, finance, and community services. It replaces scattered chats and paper notes with a simple, trackable task board.


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
=======
### Problem (Why this matters)
- Hard to track responsibilities and deadlines
- Low visibility into priorities and progress
- Communication gaps across teams

---

##  Target Users
- Community cooperatives (agriculture)
- Microfinance/savings groups
- Community organizations and market committees

---

##  Core Features (MVP)
- Create tasks with title, description, priority, category, due date
- Assign to a person/group; update status (Pending → In Progress → Completed)
- Statistics: total, pending, in-progress, high-priority
- Responsive UI (mobile friendly)

---

##  Tech Stack
- Backend: Python 3.9+, Flask
- Frontend: HTML5, CSS3, Vanilla JavaScript
- Storage: JSON file (simple local persistence)

---

##  Run Locally
Prerequisites: Python 3.9+, pip
>>>>>>> bea7384 (update README)

```bash
git clone https://github.com/YOUR_USERNAME/taskflow.git
cd taskflow
python -m venv venv
venv\Scripts\activate   # macOS/Linux: source venv/bin/activate
pip install -r requirements.txt
python app.py
# Open http://localhost:5000
```

---


##  Security Features

### Repository Security:
-  Comprehensive `.gitignore` file preventing sensitive data commits
-  Environment variable exclusions (`.env`, `secrets.yml`)
-  Dependency directory exclusions (`venv/`, `node_modules/`)
-  IDE-specific file exclusions

### Branch Protection (GitHub Configuration Required):
The `main` branch must be configured with protection rules:
- Require pull request before merging
- Require minimum 1 approval
- Dismiss stale approvals when new commits are pushed
- Require status checks to pass before merging
- Require branches to be up to date before merging
- Require conversation resolution before merging
- Include administrators (enforce for everyone)


---



##  Development Roadmap

### Completed :
-  Project ideation and planning
-  Initial functional application
-  Task CRUD operations
-  Statistics dashboard
-  Repository security setup
-  GitHub Projects board




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

##  Docker Setup (Formative 2)

This project is fully containerized for consistent development and deployment across all environments.

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) (version 20.10 or higher)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 2.0 or higher)

### Quick Start with Docker

#### Option 1: Using Docker Compose (Recommended)
```bash
# Build and start the container
docker-compose up --build

# Or run in detached mode (background)
docker-compose up -d

# View logs
docker-compose logs -f

# Stop containers
docker-compose down
```

Access the application at: **http://localhost:5000**

#### Option 2: Using Docker Directly
```bash
# Build the Docker image
docker build -t taskflow:latest .

# Run the container
docker run -p 5000:5000 taskflow:latest
```

### Docker Commands Reference

```bash
# Build and start services
docker-compose up --build

# Start in background
docker-compose up -d

# Stop all services
docker-compose down

# View running containers
docker-compose ps

# View logs
docker-compose logs -f web

# Execute commands inside container
docker-compose exec web bash

# Remove all containers and volumes
docker-compose down -v

# Rebuild after code changes
docker-compose up --build
```

### Docker Architecture

- **Base Image**: `python:3.11-slim` for smaller image size
- **Security**: Runs as non-root user (appuser)
- **Health Checks**: Monitors application status
- **Networks**: Custom bridge network for service isolation
- **Volumes**: Mounted for hot-reload during development

### Files Structure
```
TaskFlow/
├── Dockerfile              # Container build instructions
├── docker-compose.yml      # Multi-container orchestration
├── .dockerignore          # Excludes unnecessary files from build
└── .github/
    └── workflows/
        └── ci.yml         # Continuous Integration pipeline
```

### Troubleshooting Docker

**Port already in use:**
```bash
# Change port in docker-compose.yml
ports:
  - "5001:5000"  # Use 5001 on host instead
```

**Container won't start:**
```bash
# Check logs for errors
docker-compose logs web

# Verify health status
docker-compose ps
```

**Permission errors:**
```bash
# On Linux, add user to docker group
sudo usermod -aG docker $USER
# Log out and back in
```

---

##  License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

##  Acknowledgments

- Flask community for the excellent web framework
- African cooperative communities for inspiration
- Course instructors for DevOps methodology guidance

---

=======
##  Security & Repo Setup 
- `.gitignore` excludes venv, caches, IDE files, secrets, logs
- Protect `main` branch (GitHub → Settings → Branches → Add rule):
  - Require pull request and 1 approval
  - Dismiss stale approvals; require conversation resolution
  - Require status checks (for future CI) and up‑to‑date branches
  - Include administrators
- GitHub Projects board (Kanban): Backlog, In Progress, Done with 8–10 items using user stories


---

## 📄 License
MIT — see [LICENSE](LICENSE)
>>>>>>> bea7384 (update README)

