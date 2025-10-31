#!/bin/bash

# Manual deployment script for agents2automate.com
# Usage: ./scripts/deploy.sh

set -e

# Configuration
EC2_HOST="98.84.96.36"
EC2_USER="ubuntu"
SSH_KEY="$HOME/.ssh/agents2automate_deploy"
REMOTE_DIR="/var/www/agents2automate.com"

echo "🚀 Starting deployment to agents2automate.com..."

# Check if SSH key exists
if [ ! -f "$SSH_KEY" ]; then
    echo "❌ SSH key not found: $SSH_KEY"
    echo "Please run: ssh-keygen -t ed25519 -C 'github-actions-deploy' -f $SSH_KEY"
    exit 1
fi

# Create deployment package
echo "📦 Creating deployment package..."
tar -czf deploy.tar.gz index.html public/ 2>/dev/null || tar -czf deploy.tar.gz index.html

# Copy to EC2
echo "📤 Uploading to EC2..."
scp -i "$SSH_KEY" deploy.tar.gz ${EC2_USER}@${EC2_HOST}:/tmp/

# Deploy on server
echo "🔄 Deploying on server..."
ssh -i "$SSH_KEY" ${EC2_USER}@${EC2_HOST} << 'ENDSSH'
    set -e
    
    cd /tmp
    tar -xzf deploy.tar.gz
    
    # Backup current site
    sudo cp -r /var/www/agents2automate.com /var/www/agents2automate.com.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
    
    # Deploy new files
    sudo cp -r index.html /var/www/agents2automate.com/
    if [ -d "public" ]; then
        sudo cp -r public/* /var/www/agents2automate.com/ 2>/dev/null || true
    fi
    
    # Set permissions
    sudo chown -R www-data:www-data /var/www/agents2automate.com
    sudo chmod -R 755 /var/www/agents2automate.com
    
    # Reload Nginx
    sudo nginx -t
    sudo systemctl reload nginx
    
    # Cleanup
    rm -f /tmp/deploy.tar.gz
    rm -rf /tmp/index.html /tmp/public
ENDSSH

# Cleanup local
rm -f deploy.tar.gz

echo "✅ Deployment completed successfully!"
echo "🌐 Visit: https://agents2automate.com"
