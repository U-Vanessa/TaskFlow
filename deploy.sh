#!/bin/bash
# Deploy script for TaskFlow application
# Usage: ./deploy.sh [environment]

set -e

ENVIRONMENT=${1:-production}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$SCRIPT_DIR/ansible"

echo "🚀 TaskFlow Deployment Script"
echo "Environment: $ENVIRONMENT"
echo "================================"

# Check if ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "❌ Ansible is not installed. Please install it first:"
    echo "   pipx install --include-deps ansible"
    exit 1
fi

# Check if SSH key exists
if [ ! -f ~/.ssh/taskflow_azure ]; then
    echo "❌ SSH key not found at ~/.ssh/taskflow_azure"
    exit 1
fi

# Change to ansible directory
cd "$ANSIBLE_DIR"

# Check if secrets file exists
if [ ! -f secrets.yml ]; then
    echo "⚠️  Secrets file not found. Creating from template..."
    
    if [ -f secrets.yml.example ]; then
        echo "Please create ansible/secrets.yml with your actual secrets"
        echo "Use: ansible-vault create secrets.yml"
        exit 1
    fi
fi

# Install required collections
echo "📦 Installing Ansible collections..."
ansible-galaxy collection install -r requirements.yml --force

# Test connectivity
echo "🔌 Testing connectivity..."
if ansible all -m ping --vault-password-file ~/.ansible_vault_pass 2>/dev/null || \
   ansible all -m ping --ask-vault-pass; then
    echo "✅ Connectivity test passed"
else
    echo "❌ Connectivity test failed"
    exit 1
fi

# Get ACR credentials if not in vault
echo "🔐 Checking Azure Container Registry credentials..."
if command -v az &> /dev/null; then
    echo "Getting ACR password from Azure..."
    ACR_PASSWORD=$(az acr credential show --name taskflowacr67f05626 --resource-group taskflow-rg --query "passwords[0].value" -o tsv 2>/dev/null || echo "")
    if [ -n "$ACR_PASSWORD" ]; then
        echo "✅ ACR credentials retrieved"
    fi
fi

# Build and push Docker image
echo "🐳 Building Docker image..."
cd "$SCRIPT_DIR"
docker build -t taskflowacr67f05626.azurecr.io/taskflow:latest .

if command -v az &> /dev/null; then
    echo "📤 Pushing image to ACR..."
    az acr login --name taskflowacr67f05626
    docker push taskflowacr67f05626.azurecr.io/taskflow:latest
    echo "✅ Image pushed successfully"
else
    echo "⚠️  Azure CLI not found. Skipping image push."
fi

# Deploy with Ansible
echo "🚀 Deploying application..."
cd "$ANSIBLE_DIR"

if [ -f ~/.ansible_vault_pass ]; then
    ansible-playbook deploy.yml \
        --vault-password-file ~/.ansible_vault_pass \
        -e @secrets.yml \
        -v
else
    ansible-playbook deploy.yml \
        --ask-vault-pass \
        -e @secrets.yml \
        -v
fi

# Run health check
echo "🏥 Running health check..."
if [ -f ~/.ansible_vault_pass ]; then
    ansible-playbook health-check.yml --vault-password-file ~/.ansible_vault_pass
else
    ansible-playbook health-check.yml --ask-vault-pass
fi

echo ""
echo "✅ Deployment completed successfully!"
echo "🌐 Application URL: http://74.225.145.155:5000"
echo ""
