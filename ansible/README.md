# TaskFlow Ansible Deployment

## Prerequisites

1. **Ansible Installation** (on your local machine):
   ```powershell
   python -m pip install --user pipx
   python -m pipx ensurepath
   # Restart shell or update PATH
   pipx install --include-deps ansible
   ```

2. **Install Ansible Collections**:
   ```bash
   cd ansible
   ansible-galaxy collection install -r requirements.yml
   ```

3. **SSH Key Setup**:
   - Ensure your SSH key `~/.ssh/taskflow_azure` exists
   - Test bastion connection: `ssh -i ~/.ssh/taskflow_azure azureuser@52.140.96.216`

4. **Azure Container Registry Credentials**:
   ```bash
   # Get ACR password
   az acr credential show --name taskflowacr67f05626 --resource-group taskflow-rg --query "passwords[0].value" -o tsv
   ```

5. **Create Ansible Vault** (for secrets):
   ```bash
   cd ansible
   ansible-vault create secrets.yml
   ```
   
   Add the following content:
   ```yaml
   ---
   acr_password: "YOUR_ACR_PASSWORD_HERE"
   db_password: "Mine@123"
   ```

## Deployment Commands

### 1. Test Connectivity
```bash
cd ansible
ansible all -m ping
```

### 2. Setup Bastion Host
```bash
ansible-playbook setup-bastion.yml
```

### 3. Deploy Application
```bash
# With vault password prompt
ansible-playbook deploy.yml --ask-vault-pass -e @secrets.yml

# Or with vault password file
ansible-playbook deploy.yml --vault-password-file ~/.ansible_vault_pass -e @secrets.yml
```

### 4. Full Deployment (Bastion + App)
```bash
ansible-playbook site.yml --ask-vault-pass -e @secrets.yml
```

### 5. Health Check
```bash
ansible-playbook health-check.yml
```

## Directory Structure

```
ansible/
├── ansible.cfg                 # Ansible configuration
├── requirements.yml            # Required collections
├── inventory/
│   └── hosts.yml              # Inventory with bastion & app servers
├── deploy.yml                  # Main deployment playbook
├── setup-bastion.yml          # Bastion configuration
├── site.yml                   # Orchestration playbook
├── health-check.yml           # Health check playbook
├── secrets.yml                # Encrypted secrets (create with vault)
└── secrets.yml.example        # Example secrets file

```

## Common Tasks

### Build and Push Docker Image to ACR
```bash
# Login to ACR
az acr login --name taskflowacr67f05626

# Build image
docker build -t taskflowacr67f05626.azurecr.io/taskflow:latest .

# Push to ACR
docker push taskflowacr67f05626.azurecr.io/taskflow:latest
```

### Deploy New Version
```bash
# After pushing new image to ACR
ansible-playbook deploy.yml --ask-vault-pass -e @secrets.yml
```

### SSH to App VM via Bastion
```bash
ssh -J azureuser@52.140.96.216 azureuser@10.0.10.4 -i ~/.ssh/taskflow_azure
```

## Troubleshooting

### Check if Docker is installed
```bash
ansible app_servers -m shell -a "docker --version"
```

### View container logs
```bash
ansible app_servers -m shell -a "docker logs taskflow-app" -b
```

### Restart application
```bash
ansible app_servers -m shell -a "docker restart taskflow-app" -b
```

### Test database connection from app VM
```bash
ansible app_servers -m shell -a "pg_isready -h taskflow-db-67f05626.postgres.database.azure.com -U taskflowadmin"
```

## CI/CD Integration

To integrate with GitHub Actions, see `.github/workflows/ci.yml` for automated deployment pipeline.

## Variables

Key variables are defined in `inventory/hosts.yml`:
- `acr_login_server`: taskflowacr67f05626.azurecr.io
- `acr_name`: taskflowacr67f05626
- `db_host`: taskflow-db-67f05626.postgres.database.azure.com
- `db_name`: taskflow
- `db_user`: taskflowadmin
- `app_port`: 5000

Secrets (stored in vault):
- `acr_password`: ACR admin password
- `db_password`: Database password

## Security Notes

1. **Never commit unencrypted secrets** to git
2. Use `ansible-vault` for all sensitive data
3. SSH keys should have proper permissions (600)
4. Rotate ACR and database passwords regularly
5. Consider using Azure Key Vault for production
