# 🌍 TaskFlow

> **Empowering African Community Cooperatives through Digital Task Management**

[![Live Application](https://img.shields.io/badge/Live-Production-success?style=for-the-badge)](http://74.225.145.155:5000)
[![Azure](https://img.shields.io/badge/Azure-Cloud-0078D4?style=for-the-badge&logo=microsoft-azure)](https://azure.microsoft.com)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-Container-2496ED?style=for-the-badge&logo=docker)](https://www.docker.com/)

---

## 👥 Group 5 Team Members

- **Vanessa Uwonkunda**
- **Sine Shaday**
- **Oluwasijibomi Amatoritshe Athanson**

---

## 🚀 Live Application

**Production URL:** [http://74.225.145.155:5000](http://74.225.145.155:5000)

Deployed on Azure infrastructure with complete CI/CD automation.

---

## 📖 Project Overview

**TaskFlow** is a modern task management system designed specifically for African community cooperatives. It helps organizations manage complex workflows across agriculture, microfinance, and community services—replacing scattered communication channels with a centralized, trackable platform.


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

### DevOps & Infrastructure:
- **Docker** - Containerization with multi-stage builds
- **Terraform** - Infrastructure as Code (Azure deployment)
- **Ansible** - Configuration management and deployment automation
- **GitHub Actions** - CI/CD pipelines
- **Azure** - Cloud infrastructure (VMs, Database, Container Registry)

### Security & Compliance:
- **Trivy** - Container vulnerability scanning
- **tfsec** - Terraform security analysis
- **Checkov** - Infrastructure as Code policy checks
- **Automated scanning** - Integrated into CI/CD pipeline

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
│  │  │  │52.140.96   │  │  Jump   │  │10.0.10.4   │  │     │   │
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

- **Virtual Network**: Isolated network (10.0.0.0/16) with public and private subnets
- **Bastion Host**: Secure jump server for SSH access (52.140.96.216)
- **Application VM**: Docker container host in private subnet (10.0.10.4)
- **Azure Container Registry**: Private Docker image registry
- **PostgreSQL Database**: Managed database service with SSL connections
- **Network Security Groups**: Firewall rules controlling traffic flow

---

## 🚀 Git-to-Production Workflow

### Automated CI/CD Pipeline

1. **Developer pushes code** → Feature branch
2. **CI Pipeline triggers automatically**:
   - Linting (flake8)
   - Unit tests with coverage
   - Container security scanning (Trivy)
   - Infrastructure scanning (tfsec, Checkov)
3. **Pull Request created** → Code review required
4. **All checks pass** → Green checkmarks ✅
5. **Merge to main** → CD Pipeline triggers
6. **Continuous Deployment**:
   - Build Docker image
   - Push to Azure Container Registry
   - Security scans on registry image
   - Ansible deploys to VMs
7. **Application live** → http://74.225.145.155:5000

---

## 🔧 Getting Started

### Local Development

**Prerequisites:**
- Python 3.11+
- Docker Desktop
- Git

**Quick Start:**

```bash
# Clone repository
git clone https://github.com/U-Vanessa/TaskFlow.git
cd TaskFlow

# Create virtual environment
python -m venv .venv
.venv\Scripts\activate  # Windows
# source .venv/bin/activate  # Linux/Mac

# Install dependencies
pip install -r requirements.txt

# Run locally
python app.py

# Access at http://localhost:5000
```

### Docker Development

```bash
# Build image
docker build -t taskflow:local .

# Run container
docker run -d -p 5000:5000 --name taskflow-local taskflow:local

# View logs
docker logs taskflow-local

# Stop container
docker stop taskflow-local && docker rm taskflow-local
```

---

## 🌐 Production Deployment

### Infrastructure Deployment

**Prerequisites:**
- Azure subscription
- Terraform >= 1.0
- Azure CLI

**Deploy infrastructure:**

```bash
cd terraform

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply infrastructure
terraform apply

# Note outputs (IPs, database connection, ACR name)
terraform output
```

### Application Deployment

**Option 1: Automated (Recommended)**

Push to `main` branch → GitHub Actions automatically deploys

**Option 2: Manual**

```powershell
# Windows PowerShell
.\simple-deploy.ps1
```

See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed instructions.

---

## 🔒 DevSecOps Integration

### Security Scanning

**Container Security (Trivy):**
- Scans Docker images for vulnerabilities
- Integrated into CI/CD pipeline
- Results visible in GitHub Security tab

**Infrastructure Security:**
- **tfsec**: Terraform code analysis
- **Checkov**: IaC policy compliance checks
- Automated on every Pull Request

### CI/CD Workflows

**`.github/workflows/ci.yml`** - Runs on PRs:
- Code linting
- Unit tests
- Security scans
- Docker builds

**`.github/workflows/cd.yml`** - Runs on main:
- Security validation
- Image building and scanning
- Automated deployment via Ansible

See [CI_CD_STATUS.md](CI_CD_STATUS.md) for security scan details.

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

## 📁 Project Structure

```
TaskFlow/
├── app.py                      # Flask application
├── Dockerfile                  # Container configuration
├── requirements.txt            # Python dependencies
├── tasks.json                  # Task data storage
│
├── .github/workflows/
│   ├── ci.yml                 # CI pipeline (tests, security scans)
│   └── cd.yml                 # CD pipeline (deployment)
│
├── terraform/
│   ├── main.tf                # Infrastructure definition
│   ├── variables.tf           # Configuration variables
│   └── outputs.tf             # Infrastructure outputs
│
├── ansible/
│   ├── deploy.yml             # Application deployment playbook
│   ├── site.yml               # Main orchestration playbook
│   ├── inventory/hosts.yml    # Server inventory
│   └── secrets.yml.example    # Secrets template
│
├── templates/
│   └── index.html             # Web UI template
│
├── static/
│   ├── styles.css             # Application styles
│   └── app.js                 # Frontend JavaScript
│
├── docs/
│   ├── DEPLOYMENT_GUIDE.md    # Deployment instructions
│   ├── CI_CD_STATUS.md        # Security scan documentation
│   └── VIDEO_RECORDING_GUIDE.md  # Demo video guide
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

##  License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

##  Acknowledgments

- Flask community for the excellent web framework
- African cooperative communities for inspiration
- ALU course instructors for DevOps methodology guidance`n- Open-source security tools (Trivy, tfsec, Checkov)`n`n---`n`n##  Support`n`n- **Live Application**: http://74.225.145.155:5000`n- **Repository**: https://github.com/U-Vanessa/TaskFlow`n- **Issues**: GitHub Issues tracker`n`n---`n`n**Built with  by Group 5 for African Community Cooperatives**
