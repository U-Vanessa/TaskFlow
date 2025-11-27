# Ansible Docker Wrapper for Windows
# Usage: .\ansible-docker.ps1 <ansible-command> [args...]
# Example: .\ansible-docker.ps1 ansible --version
# Example: .\ansible-docker.ps1 ansible-playbook deploy.yml --ask-vault-pass -e @secrets.yml

param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$AnsibleArgs
)

# Configuration
$ANSIBLE_IMAGE = "cytopia/ansible:latest"
$PROJECT_DIR = $PSScriptRoot
$ANSIBLE_DIR = Join-Path $PROJECT_DIR "ansible"
$SSH_DIR = Join-Path $env:USERPROFILE ".ssh"

# Check if Docker is running
try {
    docker info 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Docker is not running. Please start Docker Desktop." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERROR: Docker is not installed or not in PATH." -ForegroundColor Red
    Write-Host "Download from: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Pull image if not exists
Write-Host "Checking for Ansible Docker image..." -ForegroundColor Cyan
$imageExists = docker images -q $ANSIBLE_IMAGE
if (-not $imageExists) {
    Write-Host "Pulling Ansible image (first time only)..." -ForegroundColor Yellow
    docker pull $ANSIBLE_IMAGE
}

# Join arguments into command
$command = $AnsibleArgs -join " "

Write-Host "Running: $command" -ForegroundColor Green
Write-Host ""

# Run Ansible in Docker container
docker run --rm -it `
    -v "${ANSIBLE_DIR}:/ansible" `
    -v "${SSH_DIR}:/root/.ssh:ro" `
    -w /ansible `
    --network host `
    $ANSIBLE_IMAGE `
    $AnsibleArgs

# Capture exit code
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    Write-Host ""
    Write-Host "Command completed successfully!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "Command failed with exit code: $exitCode" -ForegroundColor Red
}

exit $exitCode
