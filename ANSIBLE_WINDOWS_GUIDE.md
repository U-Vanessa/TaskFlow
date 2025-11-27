# Ansible on Windows - Alternative Approach

## ⚠️ Issue: Ansible Native Windows Support

Ansible has limited native Windows support due to its Unix/Linux dependencies. You have **3 options**:

## ✅ **Option 1: Use WSL2 (Recommended)**

### Install WSL2:
```powershell
# Run as Administrator
wsl --install
# Restart your computer
```

### After restart, install Ansible in WSL:
```bash
# Inside WSL Ubuntu terminal
sudo apt update
sudo apt install ansible -y
ansible --version
```

### Navigate to your project in WSL:
```bash
cd /mnt/d/ALU/TaskFlow
cd ansible
```

### Use Ansible normally:
```bash
ansible --version
ansible-playbook deploy.yml --ask-vault-pass -e @secrets.yml
```

---

## ✅ **Option 2: Use Docker (No WSL needed)**

Run Ansible in a Docker container:

```powershell
# Pull Ansible Docker image
docker pull cytopia/ansible:latest

# Run Ansible commands through Docker
docker run --rm -it `
  -v ${PWD}:/ansible `
  -v ${env:USERPROFILE}\.ssh:/root/.ssh:ro `
  cytopia/ansible:latest `
  ansible --version

# Deploy with Docker:
cd D:\ALU\TaskFlow\ansible
docker run --rm -it `
  -v ${PWD}:/ansible `
  -v ${env:USERPROFILE}\.ssh:/root/.ssh:ro `
  -w /ansible `
  cytopia/ansible:latest `
  ansible-playbook deploy.yml --ask-vault-pass -e @secrets.yml
```

Create a helper script `ansible-docker.ps1`:
```powershell
# ansible-docker.ps1
$ansibleCmd = $args -join " "
docker run --rm -it `
  -v ${PWD}:/ansible `
  -v ${env:USERPROFILE}\.ssh:/root/.ssh:ro `
  -w /ansible `
  cytopia/ansible:latest `
  $ansibleCmd
```

Usage:
```powershell
.\ansible-docker.ps1 ansible --version
.\ansible-docker.ps1 ansible-playbook deploy.yml --ask-vault-pass -e @secrets.yml
```

---

## ✅ **Option 3: GitHub Actions Only (No Local Ansible)**

Skip local Ansible entirely and use GitHub Actions for deployment:

1. **Set up GitHub Secrets** (see `GITHUB_SECRETS_SETUP.md`)
2. **Push to `main` branch** - CD pipeline runs automatically
3. **Monitor deployment** in GitHub Actions tab

### Manual trigger from GitHub:
1. Go to **Actions** tab
2. Select **CD Pipeline** workflow
3. Click **Run workflow**
4. Select branch and click **Run**

This way, you don't need Ansible on your local machine!

---

## 🎯 **Recommended Path**

For development and testing: **Use WSL2** (Option 1)
- Full Linux environment
- Native Ansible support
- Best compatibility

For quick deployments: **Use GitHub Actions** (Option 3)
- No local setup needed
- Automated deployments
- Works immediately

For intermediate: **Use Docker** (Option 2)
- Works on Windows natively
- Consistent environment
- No full WSL needed

---

## 🚀 **Quick Start with WSL2**

```powershell
# 1. Install WSL2 (run as admin)
wsl --install

# 2. Restart computer

# 3. Open Ubuntu from Start Menu

# 4. Inside Ubuntu:
sudo apt update
sudo apt install ansible python3-pip sshpass -y

# 5. Navigate to project
cd /mnt/d/ALU/TaskFlow/ansible

# 6. Install collections
ansible-galaxy collection install -r requirements.yml

# 7. Test connectivity
ansible all -m ping --ask-vault-pass

# 8. Deploy!
ansible-playbook site.yml --ask-vault-pass -e @secrets.yml
```

---

## ❌ **Why Native Windows Ansible Doesn't Work**

- Ansible uses Unix-specific system calls (`os.get_blocking`)
- Windows doesn't support POSIX file descriptors the same way
- Microsoft recommends using WSL for Ansible on Windows

---

**Choose your option and let me know which path you'd like to take!** 🚀
