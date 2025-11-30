# TaskFlow Docker-based Deployment Script for Windows
# This script uses Ansible in Docker (no local Ansible installation needed)
# Usage: .\deploy-docker.ps1

param(
    [string]$Environment = "production"
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "🚀 TaskFlow Docker Deployment" -ForegroundColor Cyan
Write-Host "Environment: $Environment" -ForegroundColor Yellow
Write-Host "================================`n" -ForegroundColor Cyan

$PROJECT_DIR = $PSScriptRoot
$ANSIBLE_DIR = Join-Path $PROJECT_DIR "ansible"
$TERRAFORM_DIR = Join-Path $PROJECT_DIR "terraform"

# Check Docker
Write-Host "🐳 Checking Docker..." -ForegroundColor Cyan
try {
    docker info 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker not running"
    }
    Write-Host "✅ Docker is running`n" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    Write-Host "   Download from: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Get infrastructure details
Write-Host "📋 Getting infrastructure details..." -ForegroundColor Cyan
Push-Location $TERRAFORM_DIR
try {
    $bastionIP = terraform output -raw bastion_public_ip 2>$null
    $appIP = terraform output -raw app_vm_public_ip 2>$null
    $acrName = terraform output -raw acr_name 2>$null
    
    if ($bastionIP -and $appIP) {
        Write-Host "   Bastion:  $bastionIP" -ForegroundColor Gray
        Write-Host "   App VM:   $appIP" -ForegroundColor Gray
        Write-Host "   ACR:      $acrName`n" -ForegroundColor Gray
    }
} catch {
    Write-Host "⚠️  Could not get Terraform outputs`n" -ForegroundColor Yellow
} finally {
    Pop-Location
}

# Check SSH key
$sshKey = Join-Path $env:USERPROFILE ".ssh\taskflow_azure"
if (-not (Test-Path $sshKey)) {
    Write-Host "❌ SSH key not found: $sshKey" -ForegroundColor Red
    exit 1
}
Write-Host "✅ SSH key found`n" -ForegroundColor Green

# Check secrets file
$secretsFile = Join-Path $ANSIBLE_DIR "secrets.yml"
if (-not (Test-Path $secretsFile)) {
    Write-Host "❌ Secrets file not found: $secretsFile" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please create it with:" -ForegroundColor Yellow
    Write-Host "  cd ansible" -ForegroundColor Gray
    Write-Host "  ansible-vault create secrets.yml" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Or use the example:" -ForegroundColor Yellow
    Write-Host "  Copy-Item ansible\secrets.yml.example ansible\secrets.yml" -ForegroundColor Gray
    Write-Host "  # Edit and add your passwords" -ForegroundColor Gray
    exit 1
}

# Build Docker image
Write-Host "🐳 Building Docker image..." -ForegroundColor Cyan
docker build -t taskflowacr67f05626.azurecr.io/taskflow:latest $PROJECT_DIR
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker build failed" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Docker image built`n" -ForegroundColor Green

# Push to ACR
if (Get-Command az -ErrorAction SilentlyContinue) {
    Write-Host "📤 Pushing to Azure Container Registry..." -ForegroundColor Cyan
    az acr login --name taskflowacr67f05626 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        docker push taskflowacr67f05626.azurecr.io/taskflow:latest
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Image pushed to ACR`n" -ForegroundColor Green
        }
    } else {
        Write-Host "⚠️  ACR login failed. Skipping push.`n" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  Azure CLI not found. Skipping image push.`n" -ForegroundColor Yellow
}

# Deploy with Ansible in Docker
Write-Host "🚀 Deploying with Ansible (Docker)..." -ForegroundColor Cyan
Write-Host ""

$ANSIBLE_IMAGE = "cytopia/ansible:latest"

# Pull image if needed
Write-Host "📥 Checking Ansible image..." -ForegroundColor Cyan
$imageExists = docker images -q $ANSIBLE_IMAGE
if (-not $imageExists) {
    docker pull $ANSIBLE_IMAGE
}

# Install Ansible collections
Write-Host "📦 Installing Ansible collections..." -ForegroundColor Cyan
docker run --rm `
    -v "${ANSIBLE_DIR}:/ansible" `
    -w /ansible `
    $ANSIBLE_IMAGE `
    ansible-galaxy collection install -r requirements.yml --force

Write-Host ""
Write-Host "🎯 Running deployment playbook..." -ForegroundColor Cyan
Write-Host "   (You'll be prompted for vault password)" -ForegroundColor Gray
Write-Host ""

# Run deployment
docker run --rm -it `
    -v "${ANSIBLE_DIR}:/ansible" `
    -v "${env:USERPROFILE}\.ssh:/root/.ssh:ro" `
    -w /ansible `
    --network host `
    $ANSIBLE_IMAGE `
    ansible-playbook site.yml --ask-vault-pass -e @secrets.yml -v

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Deployment failed" -ForegroundColor Red
    exit 1
}

# Health check
Write-Host ""
Write-Host "🏥 Running health check..." -ForegroundColor Cyan
docker run --rm -it `
    -v "${ANSIBLE_DIR}:/ansible" `
    -v "${env:USERPROFILE}\.ssh:/root/.ssh:ro" `
    -w /ansible `
    --network host `
    $ANSIBLE_IMAGE `
    ansible-playbook health-check.yml

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "✅ Deployment completed!" -ForegroundColor Green
Write-Host ""
if ($appIP) {
    Write-Host "🌐 Application URL: http://${appIP}:5000" -ForegroundColor Cyan
}
Write-Host "🔐 Bastion SSH:     ssh -i ~/.ssh/taskflow_azure azureuser@$bastionIP" -ForegroundColor Cyan
Write-Host ""
