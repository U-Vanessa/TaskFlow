# TaskFlow - Deployment Checklist

Use this checklist to ensure all components are properly configured before submission.

## Infrastructure as Code (IaC) ✅

- [x] Terraform directory exists with all required files
  - [x] `main.tf` - Main infrastructure configuration
  - [x] `variables.tf` - Variable definitions
  - [x] `outputs.tf` - Output values
  - [x] `terraform.tfvars.example` - Example variables file
  - [x] `.gitignore` - Terraform ignore rules

- [x] All 6 required components provisioned:
  - [x] VPC with public and private subnets
  - [x] Application VM in private subnet
  - [x] Bastion Host in public subnet
  - [x] Managed Database (RDS PostgreSQL)
  - [x] Security Groups/Network Security Groups
  - [x] Private Container Registry (ECR)

- [x] Terraform code is modular (separate files)
- [x] Terraform code runs without errors (test with `terraform plan`)

## Configuration Management (Ansible) ✅

- [x] Ansible directory exists with playbook
  - [x] `playbook.yml` - Main playbook
  - [x] `docker-compose.prod.yml.j2` - Production template
  - [x] `inventory.example` - Example inventory
  - [x] `ansible.cfg` - Ansible configuration

- [x] Playbook configures VM:
  - [x] Installs Docker
  - [x] Installs Docker Compose
  - [x] Installs required packages
  - [x] Deploys application

## DevSecOps Integration ✅

- [x] CI pipeline includes security scanning:
  - [x] Container Image Scanning (Trivy)
  - [x] Infrastructure as Code Scanning (tfsec)
  - [x] Infrastructure as Code Scanning (Checkov)

- [x] CI pipeline fails on critical vulnerabilities
- [x] CI pipeline runs on Pull Requests
- [x] CI pipeline includes linting and testing

## Continuous Deployment (CD) ✅

- [x] CD workflow exists (`.github/workflows/cd.yml`)
- [x] CD workflow triggers on merge to `main` branch
- [x] CD workflow runs all CI checks first
- [x] CD workflow builds Docker image
- [x] CD workflow pushes to private ECR (not Docker Hub)
- [x] CD workflow authenticates to cloud provider
- [x] CD workflow runs Ansible playbook
- [x] CD workflow deploys new image automatically

## Documentation ✅

- [x] README.md updated with:
  - [x] Architecture diagram (ASCII/text format)
  - [x] Live URL placeholder (to be updated after deployment)
  - [x] Complete setup instructions
  - [x] Infrastructure components explained
  - [x] CI/CD pipeline documentation
  - [x] Troubleshooting section

- [x] SETUP.md created with detailed setup guide
- [x] DEPLOYMENT_CHECKLIST.md (this file)

## GitHub Configuration ✅

- [x] Branch protection configured for `main`:
  - [x] Require pull request before merging
  - [x] Require minimum 1 approval
  - [x] Require status checks to pass
  - [x] Require branches to be up to date
  - [x] Include administrators

- [x] GitHub Secrets configured:
  - [x] AWS credentials
  - [x] SSH private key
  - [x] Infrastructure IPs and endpoints
  - [x] Database credentials
  - [x] ECR repository URL

## Application Files ✅

- [x] Dockerfile created and tested
- [x] docker-compose.yml created
- [x] Application code is functional
- [x] Health check endpoint (`/health`) implemented
- [x] Test file created (`test_app.py`)

## Pre-Submission Verification

### Infrastructure Verification

```bash
# Verify Terraform can plan
cd terraform
terraform init
terraform plan

# Verify infrastructure is deployed (if already deployed)
terraform output
```

### CI Pipeline Verification

1. Create a test branch
2. Make a small change
3. Create Pull Request
4. Verify CI pipeline runs:
   - [ ] Linting passes
   - [ ] Tests pass
   - [ ] Docker build succeeds
   - [ ] Container scan runs
   - [ ] IaC scan runs
   - [ ] All checks pass

### CD Pipeline Verification

1. Merge PR to `main`
2. Verify CD pipeline runs:
   - [ ] Builds Docker image
   - [ ] Pushes to ECR
   - [ ] Runs Ansible playbook
   - [ ] Deployment succeeds
   - [ ] Application is accessible

### Live Application Verification

- [ ] Application is accessible via ALB DNS name
- [ ] Health check endpoint responds: `http://<ALB_DNS>/health`
- [ ] Main page loads: `http://<ALB_DNS>/`
- [ ] Can create tasks
- [ ] Can view tasks
- [ ] Statistics display correctly

## Video Demo Checklist

Before recording your 10-15 minute video, ensure:

- [ ] You can demonstrate:
  1. [ ] Making a code change (e.g., button text)
  2. [ ] Creating a Pull Request
  3. [ ] CI checks running (lint, test, security scans)
  4. [ ] Merging the PR
  5. [ ] CD pipeline deploying automatically
  6. [ ] Change appearing on live URL

- [ ] Video shows:
  - [ ] Full Git-to-Production workflow
  - [ ] Security scans running
  - [ ] Deployment process
  - [ ] Live application with changes

## Submission Checklist

Before submitting on Canvas:

- [ ] GitHub Repository URL is ready
- [ ] Live Application URL is updated in README.md
- [ ] Video demo is recorded and uploaded (YouTube, Loom, etc.)
- [ ] All code is committed and pushed
- [ ] All secrets are configured (but not committed!)
- [ ] Infrastructure is deployed and running
- [ ] Application is accessible

## Submission Text Entry

When submitting on Canvas, paste this in the text box:

```
Live Application URL: http://your-alb-dns-name.us-east-1.elb.amazonaws.com

Final Presentation Video Link: [Your video URL]
```

## Post-Submission

After submission, you may want to:

- [ ] Keep infrastructure running for grading period
- [ ] Monitor costs (consider stopping if not needed)
- [ ] Document any issues encountered
- [ ] Clean up resources after grading (use `terraform destroy`)

## Cost Management

**Important:** AWS resources incur costs. Monitor your usage:

- EC2 instances (bastion + app VM): ~$15-30/month
- RDS database: ~$15-30/month
- ALB: ~$16/month
- ECR: Minimal (storage + transfer)
- Data transfer: Variable

**Total estimated cost:** ~$50-100/month

**To minimize costs:**
- Use t3.micro instances
- Use db.t3.micro for RDS
- Stop instances when not testing
- Destroy infrastructure after submission

## Support Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Ansible AWS Guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

---

**Last Updated:** 2025-11-24
**Status:** Ready for Implementation

