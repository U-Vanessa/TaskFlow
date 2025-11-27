# TaskFlow - Quick Start with Ansible

This guide will help you deploy TaskFlow to Azure using Ansible.

## 🚀 Quick Start (5 minutes)

### Step 1: Install Ansible (Windows)

```powershell
# Install pipx
python -m pip install --user pipx
python -m pipx ensurepath

# Restart PowerShell or update PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install Ansible
pipx install --include-deps ansible

# Verify installation
ansible --version
```

### Step 2: Install Ansible Collections

```powershell
cd ansible
ansible-galaxy collection install -r requirements.yml
```

### Step 3: Get ACR Password

```powershell
az acr credential show --name taskflowacr67f05626 --resource-group taskflow-rg --query "passwords[0].value" -o tsv
```

Save this password - you'll need it in the next step.

### Step 4: Create Secrets File

```powershell
cd ansible
ansible-vault create secrets.yml
```

When prompted for a vault password, create one and remember it. Then paste this content:

```yaml
---
acr_password: "YOUR_ACR_PASSWORD_FROM_STEP_3"
db_password: "Mine@123"
```

Save and exit (Ctrl+X, Y, Enter if using nano).

**Important:** Create a file to store your vault password:
```powershell
echo "your_vault_password" > $env:USERPROFILE\.ansible_vault_pass
```

### Step 5: Test Connectivity

```powershell
ansible all -m ping
```

You should see green "SUCCESS" messages.

### Step 6: Deploy! 🎉

```powershell
# Option 1: Use the deployment script
.\deploy.ps1

# Option 2: Manual deployment
cd ansible
ansible-playbook site.yml --vault-password-file "$env:USERPROFILE\.ansible_vault_pass" -e "@secrets.yml"
```

### Step 7: Verify Deployment

Open your browser and visit: **http://74.225.145.155:5000**

## 📋 Common Commands

### Deploy only the application (skip bastion setup)
```powershell
cd ansible
ansible-playbook deploy.yml --vault-password-file "$env:USERPROFILE\.ansible_vault_pass" -e "@secrets.yml"
```

### Run health check
```powershell
cd ansible
ansible-playbook health-check.yml
```

### View application logs
```powershell
cd ansible
ansible app_servers -m shell -a "docker logs taskflow-app" -b
```

### Restart application
```powershell
cd ansible
ansible app_servers -m shell -a "docker restart taskflow-app" -b
```

### SSH to bastion host
```powershell
ssh -i $env:USERPROFILE\.ssh\taskflow_azure azureuser@52.140.96.216
```

### SSH to app VM (via bastion)
```powershell
ssh -J azureuser@52.140.96.216 azureuser@10.0.10.4 -i $env:USERPROFILE\.ssh\taskflow_azure
```

## 🔄 Continuous Deployment

Every push to `main` branch will automatically:
1. Build Docker image
2. Push to Azure Container Registry
3. Deploy to production using Ansible
4. Run health checks

See `.github/workflows/cd.yml` for details.

## 📦 What Gets Deployed?

- ✅ Docker installed on app VM
- ✅ Azure CLI installed
- ✅ Application container running on port 5000
- ✅ Database connection configured
- ✅ Automatic container restart on failure
- ✅ Log rotation configured

## 🔐 Security Best Practices

1. **Never commit secrets** - Use ansible-vault
2. **Rotate passwords regularly**
3. **Use SSH keys only** - No password authentication
4. **Keep vault password safe** - Store in password manager
5. **Review permissions** - Ensure SSH key is chmod 600

## 🐛 Troubleshooting

### Ansible not found after installation
```powershell
# Refresh PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Or restart PowerShell
```

### Cannot connect to bastion
```powershell
# Test SSH connection
ssh -i $env:USERPROFILE\.ssh\taskflow_azure azureuser@52.140.96.216

# Check if key has correct permissions
icacls $env:USERPROFILE\.ssh\taskflow_azure
```

### Docker pull fails
```powershell
# Verify ACR password is correct
az acr credential show --name taskflowacr67f05626 --resource-group taskflow-rg

# Update secrets.yml with correct password
ansible-vault edit ansible/secrets.yml
```

### Application not responding
```powershell
# Check container status
cd ansible
ansible app_servers -m shell -a "docker ps -a" -b

# View container logs
ansible app_servers -m shell -a "docker logs taskflow-app" -b

# Check if port 5000 is listening
ansible app_servers -m shell -a "netstat -tlnp | grep 5000" -b
```

## 📚 Next Steps

- Review `ansible/README.md` for detailed documentation
- Check `ansible/deploy.yml` to understand deployment process
- Customize variables in `ansible/inventory/hosts.yml`
- Set up monitoring and alerting
- Configure SSL/TLS certificates for production

## 🆘 Need Help?

- Check logs: `ansible app_servers -m shell -a "docker logs taskflow-app" -b`
- Run health check: `ansible-playbook health-check.yml`
- View Ansible docs: https://docs.ansible.com/
- Azure docs: https://learn.microsoft.com/azure/

---

**Application Details:**
- **Bastion IP:** 52.140.96.216
- **App VM IP:** 10.0.10.4 (private)
- **Public URL:** http://74.225.145.155:5000
- **Database:** taskflow-db-67f05626.postgres.database.azure.com
- **Container Registry:** taskflowacr67f05626.azurecr.io
