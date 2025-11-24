# TaskFlow - Complete Setup Guide

This guide provides step-by-step instructions for setting up the complete TaskFlow DevOps pipeline.

## Prerequisites

Before starting, ensure you have:

1. **AWS Account** with appropriate permissions
2. **GitHub Account** and repository access
3. **Local Development Environment**:
   - Python 3.9+
   - Docker and Docker Compose
   - Terraform >= 1.0
   - Ansible
   - AWS CLI
   - Git

## Step-by-Step Setup

### 1. Local Development Setup

```bash
# Clone repository
git clone <your-repo-url>
cd TaskFlow

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run locally
python app.py
```

### 2. AWS Infrastructure Setup

#### 2.1 Configure AWS CLI

```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter default region (e.g., us-east-1)
# Enter default output format (json)
```

#### 2.2 Create SSH Key Pair

```bash
# Create key pair in AWS
aws ec2 create-key-pair \
  --key-name taskflow-key \
  --query 'KeyMaterial' \
  --output text > taskflow-key.pem

# Set proper permissions
chmod 400 taskflow-key.pem
```

#### 2.3 Configure Terraform

```bash
cd terraform

# Copy example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
# Required:
# - db_password: Secure password for database
# - key_pair_name: taskflow-key (or your key name)
# - aws_region: Your preferred region
```

#### 2.4 Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review plan
terraform plan

# Apply infrastructure
terraform apply

# Save outputs
terraform output > ../terraform-outputs.txt
```

**Important Outputs to Save:**
- `bastion_public_ip`
- `app_vm_private_ip`
- `alb_dns_name`
- `ecr_repository_url`
- `rds_endpoint`

### 3. GitHub Secrets Configuration

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add the following secrets:

| Secret Name | Value | Source |
|------------|-------|--------|
| `AWS_ROLE_ARN` | IAM role ARN (or use access keys) | AWS IAM |
| `AWS_ACCESS_KEY_ID` | AWS access key | AWS IAM |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key | AWS IAM |
| `SSH_PRIVATE_KEY` | Contents of `taskflow-key.pem` | Local file |
| `BASTION_PUBLIC_IP` | From Terraform output | `terraform output bastion_public_ip` |
| `APP_VM_PRIVATE_IP` | From Terraform output | `terraform output app_vm_private_ip` |
| `ECR_REPOSITORY_URL` | From Terraform output | `terraform output ecr_repository_url` |
| `ALB_DNS_NAME` | From Terraform output | `terraform output alb_dns_name` |
| `DB_HOST` | From Terraform output | `terraform output rds_address` |
| `DB_NAME` | Database name | `taskflow` (default) |
| `DB_USER` | Database username | From terraform.tfvars |
| `DB_PASSWORD` | Database password | From terraform.tfvars |

### 4. Configure Branch Protection

1. Go to GitHub repository → Settings → Branches
2. Add rule for `main` branch:
   - ✅ Require pull request before merging
   - ✅ Require approvals: 1
   - ✅ Dismiss stale approvals
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date
   - ✅ Require conversation resolution
   - ✅ Include administrators

### 5. First Deployment

#### Option A: Automated (Recommended)

1. Push code to `main` branch
2. CD pipeline will automatically:
   - Build Docker image
   - Push to ECR
   - Deploy via Ansible

#### Option B: Manual Deployment

```bash
# SSH to bastion
ssh -i taskflow-key.pem ec2-user@<BASTION_PUBLIC_IP>

# From bastion, SSH to app VM
ssh ec2-user@<APP_VM_PRIVATE_IP>

# Configure Ansible inventory
cd ansible
cp inventory.example inventory.ini
# Edit inventory.ini with actual IPs

# Run playbook
ansible-playbook -i inventory.ini playbook.yml \
  -e ecr_repository_url=<ECR_URL> \
  -e image_tag=latest \
  -e aws_region=us-east-1 \
  -e aws_access_key_id=<AWS_KEY> \
  -e aws_secret_access_key=<AWS_SECRET> \
  -e db_host=<DB_HOST> \
  -e db_name=taskflow \
  -e db_user=<DB_USER> \
  -e db_password=<DB_PASSWORD>
```

### 6. Verify Deployment

1. **Check Application Health:**
   ```bash
   curl http://<ALB_DNS_NAME>/health
   ```

2. **Access Application:**
   Open browser: `http://<ALB_DNS_NAME>`

3. **Check Container Status:**
   ```bash
   ssh -i taskflow-key.pem ec2-user@<BASTION_PUBLIC_IP>
   ssh ec2-user@<APP_VM_PRIVATE_IP>
   docker ps
   ```

## Testing the Complete Pipeline

### Test Git-to-Production Flow

1. **Create Feature Branch:**
   ```bash
   git checkout -b test-deployment
   ```

2. **Make a Small Change:**
   ```bash
   # Edit templates/index.html
   # Change "Taskflow" to "Taskflow - Updated"
   ```

3. **Commit and Push:**
   ```bash
   git add .
   git commit -m "Test: Update title for deployment test"
   git push origin test-deployment
   ```

4. **Create Pull Request:**
   - Go to GitHub
   - Create PR from `test-deployment` to `main`
   - Watch CI pipeline run

5. **Merge PR:**
   - After CI passes, merge PR
   - Watch CD pipeline deploy

6. **Verify Change:**
   - Check live URL
   - Verify change appears

## Troubleshooting

### Terraform Issues

**Error: Key pair not found**
```bash
# Create key pair first
aws ec2 create-key-pair --key-name taskflow-key
```

**Error: Insufficient permissions**
- Ensure IAM user has permissions for:
  - EC2, VPC, RDS, ECR, IAM

### Ansible Issues

**Error: SSH connection failed**
- Verify SSH key permissions: `chmod 400 taskflow-key.pem`
- Check security groups allow SSH from your IP
- Verify bastion host is running

**Error: ECR login failed**
- Verify AWS credentials in Ansible
- Check ECR repository exists
- Verify IAM permissions for ECR

### CI/CD Pipeline Issues

**Error: GitHub Actions failing**
- Check all secrets are set correctly
- Verify AWS credentials are valid
- Check workflow logs for specific errors

**Error: Security scan failing**
- Review Trivy/tfsec/Checkov output
- Fix critical vulnerabilities
- Update dependencies if needed

## Cleanup

To destroy infrastructure:

```bash
cd terraform
terraform destroy
```

**Warning:** This will delete all resources including the database!

## Next Steps

1. ✅ Infrastructure deployed
2. ✅ CI/CD pipelines configured
3. ✅ Application deployed
4. 📹 Record video demo
5. 📝 Update README with live URL
6. ✅ Submit project

## Support

For issues or questions:
- Check troubleshooting section
- Review GitHub Actions logs
- Check Terraform/Ansible documentation
- Open GitHub issue

