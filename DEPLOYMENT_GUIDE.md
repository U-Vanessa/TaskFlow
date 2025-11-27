# TaskFlow Deployment Guide

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Infrastructure Setup](#infrastructure-setup)
4. [Application Deployment](#application-deployment)
5. [CI/CD Pipeline](#cicd-pipeline)
6. [Verification](#verification)
7. [Troubleshooting](#troubleshooting)

---

## Overview

This guide walks through the complete deployment of TaskFlow from infrastructure provisioning to live application.

**Deployment Architecture:**
- **IaC Tool**: Terraform
- **Configuration Management**: Ansible
- **Container Registry**: Azure Container Registry (ACR)
- **Compute**: Azure Virtual Machines
- **Database**: Azure Database for PostgreSQL
- **CI/CD**: GitHub Actions

---

## Prerequisites

### Required Tools
- **Azure CLI** v2.50+
- **Terraform** v1.0+
- **Docker Desktop** (for Windows development)
- **Git**
- **Python** 3.11+
- **PowerShell** 5.1+ (Windows)

### Azure Requirements
- Active Azure subscription
- Contributor role on subscription
- Service principal for CI/CD

### GitHub Requirements
- Repository access
- Ability to configure secrets
- Branch protection on `main`

---

## Infrastructure Setup

### Step 1: Authenticate to Azure

```bash
az login
az account set --subscription "Your Subscription Name"
```

### Step 2: Create Service Principal (for CI/CD)

```bash
az ad sp create-for-rbac --name "taskflow-github-actions" \
  --role contributor \
  --scopes /subscriptions/{subscription-id} \
  --sdk-auth
```

Save the JSON output for GitHub secrets.

### Step 3: Generate SSH Key

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/taskflow_azure -C "taskflow-deployment"
```

### Step 4: Deploy Infrastructure with Terraform

```bash
cd terraform

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply infrastructure
terraform apply
```

**Important Outputs to Save:**
- `bastion_public_ip`: For SSH access
- `app_vm_private_ip`: Internal application server
- `app_vm_public_ip`: Public application access
- `acr_login_server`: Container registry URL
- `database_connection_string`: PostgreSQL connection

### Step 5: Verify Infrastructure

```bash
# List created resources
az resource list --resource-group taskflow-rg --output table

# Test SSH to bastion
ssh -i ~/.ssh/taskflow_azure azureuser@<BASTION_IP>

# Test SSH to app VM via bastion
ssh -i ~/.ssh/taskflow_azure -J azureuser@<BASTION_IP> azureuser@10.0.10.4
```

---

## Application Deployment

### Option A: Manual Deployment (Initial Setup)

#### 1. Build and Push Docker Image

```powershell
# Build image
docker build -t taskflowacr67f05626.azurecr.io/taskflow:latest .

# Login to ACR
az acr login --name taskflowacr67f05626

# Push image
docker push taskflowacr67f05626.azurecr.io/taskflow:latest
```

#### 2. Configure Ansible Secrets

Create `ansible/secrets.yml`:

```yaml
---
acr_password: "<ACR_PASSWORD_FROM_AZURE>"
db_password: "<DATABASE_PASSWORD>"
```

Get ACR password:
```bash
az acr credential show --name taskflowacr67f05626 --query "passwords[0].value" -o tsv
```

#### 3. Deploy with Ansible

```powershell
# Run deployment script
.\simple-deploy.ps1
```

Or manually:

```powershell
docker run --rm `
    -v "${PWD}\ansible:/runner" `
    -v "${env:USERPROFILE}\.ssh:/root/.ssh:ro" `
    -e ANSIBLE_HOST_KEY_CHECKING=False `
    quay.io/ansible/ansible-runner:latest `
    ansible-playbook site.yml -i inventory/hosts.yml -e '@secrets.yml'
```

### Option B: Automated Deployment via GitHub Actions

This is triggered automatically on merge to `main` after initial setup.

---

## CI/CD Pipeline

### Step 1: Configure GitHub Secrets

Navigate to: **GitHub Repository → Settings → Secrets and variables → Actions**

Add the following secrets:

| Secret Name | Description | How to Get |
|------------|-------------|------------|
| `AZURE_CREDENTIALS` | Service principal JSON | `az ad sp create-for-rbac --sdk-auth` |
| `SSH_PRIVATE_KEY` | Private key for VMs | Content of `~/.ssh/taskflow_azure` |
| `ACR_PASSWORD` | Registry password | `az acr credential show --name taskflowacr67f05626` |
| `ACR_USERNAME` | Registry username | Usually the ACR name: `taskflowacr67f05626` |
| `DB_PASSWORD` | Database password | From Terraform output or Azure portal |
| `BASTION_HOST` | Bastion IP address | From Terraform output |
| `ANSIBLE_VAULT_PASSWORD` | Vault encryption key | Create a strong random password |

### Step 2: Enable Branch Protection

**GitHub Repository → Settings → Branches → Add rule**

Rule configuration:
- Branch name pattern: `main`
- ✅ Require pull request before merging
- ✅ Require approvals: 1
- ✅ Dismiss stale pull request approvals
- ✅ Require status checks to pass
  - Select: `test`, `build`, `security-scan`
- ✅ Require branches to be up to date
- ✅ Include administrators

### Step 3: Test CI Pipeline

```bash
# Create feature branch
git checkout -b feature/test-deployment

# Make a change (e.g., update README)
echo "Testing CI" >> README.md

# Commit and push
git add .
git commit -m "Test CI pipeline"
git push origin feature/test-deployment
```

**Expected CI Checks:**
- ✅ Linting (flake8)
- ✅ Unit tests
- ✅ Container vulnerability scan (Trivy)
- ✅ Infrastructure scan (tfsec, Checkov)
- ✅ Docker build

### Step 4: Test CD Pipeline

```bash
# Create pull request
gh pr create --title "Test deployment" --body "Testing complete pipeline"

# After approval, merge
gh pr merge --auto --squash

# Watch deployment
gh run watch
```

**Expected CD Steps:**
1. ✅ Security checks (tfsec, Checkov)
2. ✅ Build and push to ACR
3. ✅ Trivy scan on registry image
4. ✅ Ansible deployment to VMs
5. ✅ Health check

---

## Verification

### 1. Check Application Health

```bash
# From local machine
curl http://74.225.145.155:5000

# Should return TaskFlow HTML
```

### 2. Verify Container Status

```bash
# SSH to app VM
ssh -i ~/.ssh/taskflow_azure -J azureuser@<BASTION_IP> azureuser@10.0.10.4

# Check container
docker ps
docker logs taskflow-app

# Test database connectivity
docker exec taskflow-app python -c "import psycopg2; print('DB OK')"
```

### 3. Check Logs

```bash
# Application logs
docker logs taskflow-app --tail 100 --follow

# System logs
journalctl -u docker -f
```

### 4. Database Verification

```bash
# Connect to PostgreSQL
psql "postgresql://taskflowadmin@taskflow-db-67f05626:Mine@123@taskflow-db-67f05626.postgres.database.azure.com/taskflow_db?sslmode=require"

# Check tables
\dt
```

---

## Troubleshooting

### Issue: Ansible "docker_login" module not found

**Cause**: Collection dependencies not installed

**Solution**: Modified `deploy.yml` to use shell commands instead of Ansible modules
- Changed `docker_login` → `docker login` shell command
- Changed `docker_container` → `docker run` shell command

### Issue: "No enabled subscription found"

**Cause**: Not logged in to Azure or subscription not selected

**Solution**:
```bash
az login
az account list --output table
az account set --subscription "<subscription-id>"
```

### Issue: Cannot SSH to App VM

**Cause**: Must use bastion as jump host

**Solution**:
```bash
# Correct command with ProxyJump
ssh -i ~/.ssh/taskflow_azure -J azureuser@<BASTION_IP> azureuser@10.0.10.4
```

### Issue: Container fails to start

**Cause**: Database connection error or environment variables missing

**Solution**:
```bash
# Check container logs
docker logs taskflow-app

# Verify environment variables
docker inspect taskflow-app | grep -A 10 "Env"

# Test database connection
docker exec taskflow-app python -c "
import os
from psycopg2 import connect
db_url = os.getenv('DATABASE_URL')
conn = connect(db_url)
print('Database connected!')
conn.close()
"
```

### Issue: CI pipeline fails on security scan

**Cause**: Critical vulnerabilities detected in image or IaC

**Solution**:
1. Review scan results in GitHub Actions logs
2. Update base image or dependencies
3. Fix Terraform security issues
4. Re-run pipeline

### Issue: Deployment stuck on "Waiting for application"

**Cause**: Port 5000 not accessible or application not starting

**Solution**:
```bash
# Check if port is listening
ssh -J azureuser@<BASTION_IP> azureuser@10.0.10.4 'sudo netstat -tlnp | grep 5000'

# Check NSG rules
az network nsg rule list --resource-group taskflow-rg --nsg-name taskflow-app-nsg --output table

# Verify container status
ssh -J azureuser@<BASTION_IP> azureuser@10.0.10.4 'docker ps -a'
```

---

## Production Best Practices

### 1. Security
- ✅ Use Ansible Vault for secrets
- ✅ Rotate ACR and database passwords regularly
- ✅ Keep base images updated
- ✅ Monitor security scan results
- ✅ Enable Azure Security Center

### 2. Monitoring
- Set up Application Insights
- Configure log analytics
- Create alerts for failures
- Monitor container resource usage

### 3. Backup
- Enable Azure Database automated backups
- Backup application configuration
- Document infrastructure changes

### 4. Disaster Recovery
- Test restore procedures
- Document recovery steps
- Keep infrastructure code version controlled

---

## Next Steps

1. ✅ Set up custom domain name
2. ✅ Configure SSL/TLS certificates
3. ✅ Implement load balancing for HA
4. ✅ Add staging environment
5. ✅ Configure Azure Monitor
6. ✅ Set up alerting rules
7. ✅ Implement log aggregation

---

## Support

- **Documentation**: See [README.md](README.md)
- **Issues**: GitHub Issues tracker
- **Infrastructure Code**: `terraform/` directory
- **Deployment Code**: `ansible/` directory
- **CI/CD Workflows**: `.github/workflows/`
