# Simple Ansible Deployment via Docker
# No encoding issues, no complex logic

Write-Host "`nTaskFlow Deployment`n" -ForegroundColor Cyan

# Check Docker
docker info 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker not running" -ForegroundColor Red
    exit 1
}

# Build image
Write-Host "Building Docker image..." -ForegroundColor Yellow
docker build -t taskflowacr67f05626.azurecr.io/taskflow:latest .

# Push to ACR
Write-Host "`nPushing to ACR..." -ForegroundColor Yellow
az acr login --name taskflowacr67f05626
docker push taskflowacr67f05626.azurecr.io/taskflow:latest

# Use ansible/runner image (has SSH)
$IMG = "quay.io/ansible/ansible-runner:latest"

Write-Host "`nPulling Ansible runner image..." -ForegroundColor Yellow
docker pull $IMG

Write-Host "`nInstalling collections..." -ForegroundColor Yellow
docker run --rm `
    -v "${PWD}\ansible:/runner" `
    -w /runner `
    $IMG `
    ansible-galaxy collection install -r requirements.yml --force

Write-Host "`nDeploying application..." -ForegroundColor Yellow  
Write-Host "(Enter vault password when prompted)`n" -ForegroundColor Gray

docker run --rm -it `
    -v "${PWD}\ansible:/runner" `
    -v "${env:USERPROFILE}\.ssh:/root/.ssh:ro" `
    -e RUNNER_PLAYBOOK=site.yml `
    -e ANSIBLE_HOST_KEY_CHECKING=False `
    $IMG `
    ansible-playbook site.yml -i inventory/hosts.yml -e '@secrets.yml'

Write-Host "`nDeployment complete!" -ForegroundColor Green
Write-Host "URL: http://74.225.145.155:5000`n" -ForegroundColor Cyan
