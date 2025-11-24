# Taskflow

> Empowering African Community Cooperatives through Digital Task Management

---

## Group Members (Group 5)

- Vanessa Uwonkunda
- Sine Shaday
- Oluwasijibomi Amatoritshe Athanson

---

## Project Overview

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

## Live Application

🌐 **Live Application URL:** [https://your-alb-dns-name.us-east-1.elb.amazonaws.com](https://your-alb-dns-name.us-east-1.elb.amazonaws.com)

> **Note:** Update this URL with your actual Application Load Balancer DNS name after deploying infrastructure.

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         Internet                                │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ HTTP/HTTPS
                             │
                    ┌────────▼────────┐
                    │  Application    │
                    │  Load Balancer  │
                    │   (Public)      │
                    └────────┬────────┘
                             │
                             │ Port 5000
                             │
        ┌────────────────────┴────────────────────┐
        │                                          │
        │         VPC (10.0.0.0/16)               │
        │                                          │
        │  ┌────────────────────────────────────┐ │
        │  │   Public Subnet 1 (10.0.1.0/24)    │ │
        │  │  ┌──────────────────────────────┐  │ │
        │  │  │   Bastion Host (Jumpbox)    │  │ │
        │  │  │   - SSH Access              │  │ │
        │  │  │   - Public IP                │  │ │
        │  │  └──────────────────────────────┘  │ │
        │  └────────────────────────────────────┘ │
        │                                          │
        │  ┌────────────────────────────────────┐ │
        │  │  Private Subnet 1 (10.0.10.0/24)   │ │
        │  │  ┌──────────────────────────────┐  │ │
        │  │  │   Application VM             │  │ │
        │  │  │   - Docker + Docker Compose   │  │ │
        │  │  │   - TaskFlow Container        │  │ │
        │  │  │   - Private IP Only           │  │ │
        │  │  └──────────────────────────────┘  │ │
        │  └────────────────────────────────────┘ │
        │                                          │
        │  ┌────────────────────────────────────┐ │
        │  │  Private Subnet 2 (10.0.11.0/24)   │ │
        │  │  ┌──────────────────────────────┐  │ │
        │  │  │   RDS PostgreSQL Database   │  │ │
        │  │  │   - Encrypted Storage        │  │ │
        │  │  │   - Multi-AZ (Production)    │  │ │
        │  │  └──────────────────────────────┘  │ │
        │  └────────────────────────────────────┘ │
        │                                          │
        └──────────────────────────────────────────┘
                             │
                             │
                    ┌────────▼────────┐
                    │   AWS ECR       │
                    │  (Container     │
                    │   Registry)     │
                    └─────────────────┘
```

### Infrastructure Components

1. **VPC (Virtual Private Cloud)**: Isolated network environment
2. **Public Subnets**: Host bastion host with internet access
3. **Private Subnets**: Host application VM and database (no direct internet access)
4. **Bastion Host**: Secure SSH gateway to access private resources
5. **Application VM**: Runs Docker containers with TaskFlow application
6. **RDS Database**: Managed PostgreSQL database
7. **Application Load Balancer**: Distributes traffic to application VMs
8. **ECR (Elastic Container Registry)**: Private Docker image repository
9. **Security Groups**: Network-level firewall rules

---

## Technology Stack

### Backend:
- **Python 3.9+** - Modern, readable server-side logic
- **Flask** - Lightweight web framework for Python
- **JSON File Storage** - Simple, portable data persistence (can be upgraded to PostgreSQL)

### Frontend:
- **HTML5** - Semantic markup
- **CSS3** - Modern styling with custom properties
- **Vanilla JavaScript** - No framework dependencies, fast and accessible

### DevOps & Infrastructure:
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **Terraform** - Infrastructure as Code (IaC)
- **Ansible** - Configuration management and deployment
- **GitHub Actions** - CI/CD pipelines
- **AWS** - Cloud infrastructure (EC2, VPC, RDS, ECR, ALB)
- **Trivy** - Container security scanning
- **tfsec** - Terraform security scanning
- **Checkov** - Infrastructure security scanning

---

## Core Features

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

## Getting Started

### Prerequisites

- Python 3.9 or higher
- pip (Python package installer)
- Docker and Docker Compose (for containerized deployment)
- AWS CLI (for cloud deployment)
- Terraform >= 1.0 (for infrastructure provisioning)
- Ansible (for configuration management)

### Local Development Setup

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

### Docker Development Setup

1. **Build and run with Docker Compose**
   ```bash
   docker-compose up --build
   ```

2. **Access the application**
   ```
   http://localhost:5000
   ```

---

## Infrastructure Setup (Production)

### Step 1: Configure AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter your default region (e.g., us-east-1)
```

### Step 2: Create SSH Key Pair

```bash
# Create key pair in AWS
aws ec2 create-key-pair --key-name taskflow-key --query 'KeyMaterial' --output text > taskflow-key.pem
chmod 400 taskflow-key.pem
```

### Step 3: Configure Terraform Variables

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

Required variables in `terraform.tfvars`:
- `db_password`: Secure database password
- `key_pair_name`: Name of your AWS key pair (e.g., "taskflow-key")
- `aws_region`: Your preferred AWS region

### Step 4: Deploy Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

After deployment, note the outputs:
- `bastion_public_ip`: SSH to bastion host
- `alb_dns_name`: Public URL for your application
- `ecr_repository_url`: Docker registry URL
- `rds_endpoint`: Database connection endpoint

### Step 5: Configure GitHub Secrets

Add the following secrets to your GitHub repository (Settings → Secrets and variables → Actions):

- `AWS_ROLE_ARN`: AWS IAM role ARN for GitHub Actions (or use access keys)
- `AWS_ACCESS_KEY_ID`: AWS access key
- `AWS_SECRET_ACCESS_KEY`: AWS secret key
- `SSH_PRIVATE_KEY`: Contents of your `taskflow-key.pem` file
- `BASTION_PUBLIC_IP`: Public IP of bastion host (from Terraform output)
- `APP_VM_PRIVATE_IP`: Private IP of application VM (from Terraform output)
- `ECR_REPOSITORY_URL`: ECR repository URL (from Terraform output)
- `ALB_DNS_NAME`: Application Load Balancer DNS name (from Terraform output)
- `DB_HOST`: RDS endpoint (from Terraform output)
- `DB_NAME`: Database name (default: taskflow)
- `DB_USER`: Database username
- `DB_PASSWORD`: Database password

### Step 6: Manual First Deployment (Optional)

If you want to test deployment manually before setting up CD:

```bash
# SSH to bastion host
ssh -i taskflow-key.pem ec2-user@<BASTION_PUBLIC_IP>

# From bastion, SSH to app VM
ssh ec2-user@<APP_VM_PRIVATE_IP>

# On app VM, configure and deploy
cd /opt/taskflow
# Follow Ansible playbook steps manually or run playbook
```

---

## CI/CD Pipeline

### Continuous Integration (CI)

The CI pipeline runs on every Pull Request and includes:

1. **Code Linting**: Flake8 and Pylint checks
2. **Testing**: Unit tests (when available)
3. **Docker Build**: Builds container image
4. **Container Security Scan**: Trivy scans for vulnerabilities
5. **Infrastructure Security Scan**: tfsec and Checkov scan Terraform code

**CI Workflow**: `.github/workflows/ci.yml`

### Continuous Deployment (CD)

The CD pipeline runs on merge to `main` branch:

1. **Build & Push**: Builds Docker image and pushes to ECR
2. **Security Scan**: Final security scan before deployment
3. **Deploy**: Runs Ansible playbook to deploy to production VM
4. **Verify**: Health check to confirm deployment success

**CD Workflow**: `.github/workflows/cd.yml`

### Git-to-Production Flow

1. Create a feature branch
2. Make code changes
3. Create Pull Request → CI pipeline runs automatically
4. Review and merge PR → CD pipeline deploys automatically
5. Changes appear on live application

---

## Project Structure

```
taskflow/
│
├── app.py                    # Flask backend application
├── requirements.txt          # Python dependencies
├── Dockerfile                # Docker image definition
├── docker-compose.yml        # Docker Compose configuration
│
├── templates/
│   └── index.html           # Main dashboard template
│
├── static/
│   ├── styles.css           # Application styling
│   └── app.js               # Frontend JavaScript logic
│
├── terraform/               # Infrastructure as Code
│   ├── main.tf              # Main Terraform configuration
│   ├── variables.tf         # Variable definitions
│   ├── outputs.tf           # Output values
│   ├── terraform.tfvars.example  # Example variables
│   └── .gitignore           # Terraform ignore rules
│
├── ansible/                 # Configuration Management
│   ├── playbook.yml         # Main Ansible playbook
│   ├── docker-compose.prod.yml.j2  # Production compose template
│   ├── inventory.example    # Example inventory file
│   ├── ansible.cfg          # Ansible configuration
│   └── requirements.yml     # Ansible dependencies
│
├── .github/
│   └── workflows/
│       ├── ci.yml           # CI pipeline
│       └── cd.yml           # CD pipeline
│
├── .gitignore               # Git ignore rules
├── LICENSE                  # MIT License
└── README.md               # This file
```

---

## Security Features

### Repository Security:
- Comprehensive `.gitignore` file preventing sensitive data commits
- Environment variable exclusions (`.env`, `secrets.yml`)
- Dependency directory exclusions (`venv/`, `node_modules/`)
- IDE-specific file exclusions

### Infrastructure Security:
- Private subnets for application and database
- Security groups with least-privilege access
- Encrypted RDS storage
- Private container registry (ECR)
- Bastion host for secure SSH access

### DevSecOps:
- Automated container image scanning (Trivy)
- Infrastructure as Code scanning (tfsec, Checkov)
- CI pipeline fails on critical vulnerabilities
- Automated security checks in deployment pipeline

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

## Using the Application

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

## Development Roadmap

### Completed:
- ✅ Project ideation and planning
- ✅ Initial functional application
- ✅ Task CRUD operations
- ✅ Statistics dashboard
- ✅ Repository security setup
- ✅ Docker containerization
- ✅ Infrastructure as Code (Terraform)
- ✅ Configuration Management (Ansible)
- ✅ CI/CD pipelines with security scanning
- ✅ Automated deployment pipeline

### Future Enhancements:
- Database migration from JSON to PostgreSQL
- User authentication and authorization
- Multi-tenant support for multiple cooperatives
- Mobile app (React Native)
- Offline synchronization
- Advanced reporting and analytics
- Email/SMS notifications

---

## Troubleshooting

### Issue: Cannot run the application locally
- **Solution**: Ensure Python 3.9+ is installed and virtual environment is activated

### Issue: Port 5000 already in use
- **Solution**: Change the port in `app.py`:
  ```python
  app.run(debug=True, host='0.0.0.0', port=5001)
  ```

### Issue: Tasks not persisting
- **Solution**: Check that `tasks.json` file is writable and not in `.gitignore`

### Issue: Terraform apply fails
- **Solution**: 
  - Verify AWS credentials are configured
  - Check that key pair exists in AWS
  - Ensure you have necessary IAM permissions
  - Review Terraform error messages

### Issue: Ansible playbook fails
- **Solution**:
  - Verify SSH key has correct permissions (chmod 400)
  - Check that bastion host is accessible
  - Ensure app VM is reachable from bastion
  - Verify AWS credentials are set correctly

### Issue: CI/CD pipeline fails
- **Solution**:
  - Check GitHub Secrets are configured correctly
  - Verify AWS credentials in secrets
  - Review workflow logs for specific errors
  - Ensure branch protection allows status checks

---

## Contributing

This is a course project. Contributions are welcome through:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request for review

All pull requests require at least one team member's approval before merging.

---

## GitHub Projects Board

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

## Final Presentation

### Video Demo Requirements

Record a 10-15 minute video demonstrating:

1. **Code Change**: Make a small change (e.g., change button text)
2. **Pull Request**: Create PR and show CI checks running
3. **Security Scans**: Show Trivy, tfsec, and Checkov results
4. **Merge**: Merge the PR
5. **CD Pipeline**: Show CD pipeline deploying automatically
6. **Live Change**: Show the change appearing on the live application URL

### Submission Checklist

Before submitting, verify:

- [x] Terraform directory contains all `.tf` files
- [x] Ansible directory contains playbook
- [x] CI pipeline runs linting, tests, and security scans
- [x] CI pipeline scans both Docker image and Terraform code
- [x] CI pipeline is required to pass before merging to main
- [x] CD pipeline pushes image to private ECR
- [x] CD pipeline runs Ansible playbook as final deployment step
- [x] README.md includes live URL and architecture diagram
- [ ] Video demo shows entire Git-to-Production flow

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Flask community for the excellent web framework
- African cooperative communities for inspiration
- Course instructors for DevOps methodology guidance
- AWS for cloud infrastructure services
- HashiCorp for Terraform
- Ansible community for configuration management tools

---

## Contact

For questions or issues, please open an issue in the GitHub repository.
