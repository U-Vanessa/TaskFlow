# PowerShell deployment script for TaskFlow
# Usage: .\deploy.ps1 [-Environment production]

param(
    [string]$Environment = "production"
)

Write-Host "🚀 TaskFlow Deployment Script" -ForegroundColor Cyan
Write-Host "Environment: $Environment" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Cyan

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$AnsibleDir = Join-Path $ScriptDir "ansible"

# Check if ansible is installed
if (-not (Get-Command ansible -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Ansible is not installed. Please install it first:" -ForegroundColor Red
    Write-Host "   python -m pip install --user pipx" -ForegroundColor Yellow
    Write-Host "   python -m pipx ensurepath" -ForegroundColor Yellow
    Write-Host "   pipx install --include-deps ansible" -ForegroundColor Yellow
    exit 1
}

# Check if SSH key exists
$SSHKey = Join-Path $env:USERPROFILE ".ssh\taskflow_azure"
if (-not (Test-Path $SSHKey)) {
    Write-Host "❌ SSH key not found at $SSHKey" -ForegroundColor Red
    exit 1
}

# Change to ansible directory
Set-Location $AnsibleDir

# Check if secrets file exists
if (-not (Test-Path "secrets.yml")) {
    Write-Host "⚠️  Secrets file not found. Creating from template..." -ForegroundColor Yellow
    
    if (Test-Path "secrets.yml.example") {
        Write-Host "Please create ansible/secrets.yml with your actual secrets" -ForegroundColor Yellow
        Write-Host "Use: ansible-vault create secrets.yml" -ForegroundColor Yellow
        exit 1
    }
}

# Install required collections
Write-Host "📦 Installing Ansible collections..." -ForegroundColor Cyan
ansible-galaxy collection install -r requirements.yml --force

# Test connectivity
Write-Host "🔌 Testing connectivity..." -ForegroundColor Cyan
$VaultPassFile = Join-Path $env:USERPROFILE ".ansible_vault_pass"

if (Test-Path $VaultPassFile) {
    $pingResult = ansible all -m ping --vault-password-file $VaultPassFile 2>$null
} else {
    $pingResult = ansible all -m ping --ask-vault-pass
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Connectivity test passed" -ForegroundColor Green
} else {
    Write-Host "❌ Connectivity test failed" -ForegroundColor Red
    exit 1
}

# Get ACR credentials if Azure CLI is available
Write-Host "🔐 Checking Azure Container Registry credentials..." -ForegroundColor Cyan
if (Get-Command az -ErrorAction SilentlyContinue) {
    Write-Host "Getting ACR password from Azure..." -ForegroundColor Yellow
    $ACRPassword = az acr credential show --name taskflowacr67f05626 --resource-group taskflow-rg --query "passwords[0].value" -o tsv 2>$null
    if ($ACRPassword) {
        Write-Host "✅ ACR credentials retrieved" -ForegroundColor Green
    }
}

# Build and push Docker image
Write-Host "🐳 Building Docker image..." -ForegroundColor Cyan
Set-Location $ScriptDir
docker build -t taskflowacr67f05626.azurecr.io/taskflow:latest .

if (Get-Command az -ErrorAction SilentlyContinue) {
    Write-Host "📤 Pushing image to ACR..." -ForegroundColor Cyan
    az acr login --name taskflowacr67f05626
    docker push taskflowacr67f05626.azurecr.io/taskflow:latest
    Write-Host "✅ Image pushed successfully" -ForegroundColor Green
} else {
    Write-Host "⚠️  Azure CLI not found. Skipping image push." -ForegroundColor Yellow
}

# Deploy with Ansible
Write-Host "🚀 Deploying application..." -ForegroundColor Cyan
Set-Location $AnsibleDir

if (Test-Path $VaultPassFile) {
    ansible-playbook deploy.yml --vault-password-file $VaultPassFile -e "@secrets.yml" -v
} else {
    ansible-playbook deploy.yml --ask-vault-pass -e "@secrets.yml" -v
}

# Run health check
Write-Host "🏥 Running health check..." -ForegroundColor Cyan
if (Test-Path $VaultPassFile) {
    ansible-playbook health-check.yml --vault-password-file $VaultPassFile
} else {
    ansible-playbook health-check.yml --ask-vault-pass
}

Write-Host ""
Write-Host "✅ Deployment completed successfully!" -ForegroundColor Green
Write-Host "🌐 Application URL: http://74.225.145.155:5000" -ForegroundColor Cyan
Write-Host ""
