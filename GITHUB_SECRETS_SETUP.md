# GitHub Actions Secrets Configuration

To enable automated CI/CD deployment, you need to configure the following secrets in your GitHub repository.

## 📍 Where to Add Secrets

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** for each secret below

## 🔐 Required Secrets

### 1. AZURE_CREDENTIALS
**Description:** Service Principal credentials for Azure authentication

**How to get it:**
```powershell
# Create a service principal
az ad sp create-for-rbac --name "taskflow-github-actions" \
  --role contributor \
  --scopes /subscriptions/079f14e5-201e-43cb-8ac0-3da23d698a06/resourceGroups/taskflow-rg \
  --sdk-auth
```

Copy the entire JSON output as the secret value.

**Format:**
```json
{
  "clientId": "xxx",
  "clientSecret": "xxx",
  "subscriptionId": "079f14e5-201e-43cb-8ac0-3da23d698a06",
  "tenantId": "xxx",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

---

### 2. SSH_PRIVATE_KEY
**Description:** Private SSH key for connecting to Azure VMs

**How to get it:**
```powershell
# Display your private key
Get-Content $env:USERPROFILE\.ssh\taskflow_azure
```

Copy the **entire content** including the BEGIN and END lines:
```
-----BEGIN OPENSSH PRIVATE KEY-----
...entire key content...
-----END OPENSSH PRIVATE KEY-----
```

---

### 3. ACR_PASSWORD
**Description:** Azure Container Registry password

**How to get it:**
```powershell
az acr credential show --name taskflowacr67f05626 --resource-group taskflow-rg --query "passwords[0].value" -o tsv
```

Copy the password string.

---

### 4. DB_PASSWORD
**Description:** PostgreSQL database password

**Value:** `Mine@123` (or your custom password from terraform.tfvars)

---

### 5. BASTION_HOST
**Description:** IP address of bastion host

**Value:** `52.140.96.216`

---

### 6. ANSIBLE_VAULT_PASSWORD
**Description:** Password to encrypt/decrypt Ansible vault files

**Value:** Create a strong password (e.g., generate with `openssl rand -base64 32`)

Save this password somewhere safe - you'll need it for local deployments too.

---

## ✅ Verification Checklist

After adding all secrets, verify:

- [ ] AZURE_CREDENTIALS - Valid JSON format
- [ ] SSH_PRIVATE_KEY - Includes BEGIN/END lines
- [ ] ACR_PASSWORD - Copied without extra spaces/newlines
- [ ] DB_PASSWORD - Matches your database password
- [ ] BASTION_HOST - Correct IP address
- [ ] ANSIBLE_VAULT_PASSWORD - Strong password created

## 🧪 Test Your Configuration

1. Make a small change to your code
2. Push to a feature branch
3. Check the **Actions** tab to see CI pipeline run
4. Merge to `main` branch
5. Watch the CD pipeline deploy your application

## 🔒 Security Best Practices

1. **Rotate secrets regularly** (every 90 days)
2. **Use separate credentials** for dev/staging/prod
3. **Limit service principal permissions** to only what's needed
4. **Enable secret scanning** in GitHub repository settings
5. **Review access logs** for unusual activity

## 🔄 Rotating Secrets

### Rotate Azure Service Principal
```powershell
# Create new credentials
az ad sp credential reset --name "taskflow-github-actions"

# Update AZURE_CREDENTIALS secret in GitHub
```

### Rotate ACR Password
```powershell
# Regenerate password
az acr credential renew --name taskflowacr67f05626 --password-name password

# Get new password
az acr credential show --name taskflowacr67f05626 --query "passwords[0].value" -o tsv

# Update ACR_PASSWORD secret in GitHub
```

### Rotate SSH Key
```powershell
# Generate new key
ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\taskflow_azure_new" -N ""

# Update VMs with new public key (use Terraform or Azure Portal)
# Update SSH_PRIVATE_KEY secret in GitHub
# Rename new key to replace old one
```

## 📊 Monitoring Deployments

After setup, monitor your deployments:

- **GitHub Actions** tab - View pipeline runs
- **Azure Portal** - Check resource health
- **Application logs** - Monitor container logs
- **Metrics** - Track performance

---

**Questions?** Check the main README.md or open an issue.
