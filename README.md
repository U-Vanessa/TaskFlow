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

## 🌐 Live Application

**Production URL:** http://74.225.145.155:5000

The application is deployed on Azure infrastructure and automatically updates on every merge to `main` branch.

---

## 🏗️ Architecture

### Infrastructure Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         Azure Cloud                              │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              Virtual Network (10.0.0.0/16)              │   │
│  │                                                           │   │
│  │  ┌──────────────────┐         ┌──────────────────┐     │   │
│  │  │  Public Subnet   │         │  Private Subnet  │     │   │
│  │  │  (10.0.1.0/24)   │         │  (10.0.10.0/24)  │     │   │
│  │  │                  │         │                  │     │   │
│  │  │  ┌────────────┐  │         │  ┌────────────┐  │     │   │
│  │  │  │  Bastion   │  │ SSH     │  │   App VM   │  │     │   │
│  │  │  │   Host     │──┼────────>│  │ (Docker)   │  │     │   │
│  │  │  │52.140.96   │  │  Proxy  │  │10.0.10.4   │  │     │   │
│  │  │  │   .216     │  │         │  │            │  │     │   │
│  │  │  └────────────┘  │         │  └────┬───────┘  │     │   │
│  │  │        ▲         │         │       │          │     │   │
│  │  └────────┼─────────┘         └───────┼──────────┘     │   │
│  │           │                            │                │   │
│  └───────────┼────────────────────────────┼────────────────┘   │
│              │                            │                    │
│      ┌───────┴─────────┐         ┌────────▼───────────┐       │
│      │  Azure Container│         │  PostgreSQL        │       │
│      │   Registry      │         │   Database         │       │
│      │  (taskflowacr)  │         │ (taskflow-db)      │       │
│      └─────────────────┘         └────────────────────┘       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                            ▲
                            │
                    ┌───────┴────────┐
                    │  GitHub Actions │
                    │   CI/CD Pipeline│
                    └─────────────────┘
```

### Components

- **Virtual Network**: Isolated network with public and private subnets
- **Bastion Host**: Jump server for secure SSH access (52.140.96.216)
- **Application VM**: Runs Docker container in private subnet (10.0.10.4)
- **Azure Container Registry**: Private Docker image registry
- **PostgreSQL Database**: Managed database service
- **Network Security Groups**: Firewall rules controlling traffic

---

## 🚀 Deployment Pipeline

### Git-to-Production Workflow

1. **Developer pushes code** to feature branch
2. **CI Pipeline** triggers:
   - Linting (flake8)
   - Unit tests with coverage
   - Container image scanning (Trivy)
   - Infrastructure scanning (tfsec, Checkov)
3. **Pull Request** created to `main`
4. **Code Review** and approval required
5. **Merge to main** triggers **CD Pipeline**:
   - Build Docker image
   - Push to Azure Container Registry
   - Run security scans
   - Deploy via Ansible to VMs
6. **Application live** at http://74.225.145.155:5000

### DevSecOps Integration

**Security Scans (CI)**:
- **Trivy**: Container vulnerability scanning
- **tfsec**: Terraform security analysis
- **Checkov**: Infrastructure as Code policy checks
- Build **fails** on HIGH/CRITICAL vulnerabilities

**Continuous Deployment (CD)**:
- Automated deployment on merge to `main`
- Infrastructure provisioned via Terraform
- Configuration managed by Ansible
- Zero-downtime deployments

---

## 🛠️ Setup Instructions

### Prerequisites

- Azure subscription
- Terraform >= 1.0
- Docker Desktop
- Python 3.11+
- Ansible (via Docker)

### Local Development

1. **Clone repository**:
   ```bash
   git clone https://github.com/U-Vanessa/TaskFlow.git
   cd TaskFlow
   ```

2. **Create virtual environment**:
   ```bash
   python -m venv .venv
   .venv\Scripts\activate  # Windows
   source .venv/bin/activate  # Linux/Mac
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Run locally**:
   ```bash
   python app.py
   ```
   Visit http://localhost:5000

### Infrastructure Deployment

1. **Navigate to Terraform directory**:
   ```bash
   cd terraform
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Create infrastructure**:
   ```bash
   terraform plan
   terraform apply
   ```

4. **Note outputs** (Bastion IP, App VM IP, ACR name, Database connection)

### Application Deployment

1. **Configure secrets**:
   - Copy `ansible/secrets.yml.example` to `ansible/secrets.yml`
   - Add ACR password and database credentials

2. **Run deployment** (Windows):
   ```powershell
   .\simple-deploy.ps1
   ```

3. **Verify deployment**:
   - Visit http://<APP_VM_PUBLIC_IP>:5000
   - Check application health

### GitHub Actions Setup

Configure the following secrets in GitHub repository settings:

- `AZURE_CREDENTIALS`: Azure service principal JSON
- `SSH_PRIVATE_KEY`: Private key for VM access
- `ACR_PASSWORD`: Container registry password
- `ACR_USERNAME`: Container registry username (usually ACR name)
- `DB_PASSWORD`: PostgreSQL database password
- `BASTION_HOST`: Bastion server IP address
- `ANSIBLE_VAULT_PASSWORD`: Vault encryption password (optional)

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

