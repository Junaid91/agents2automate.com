#!/bin/bash

# Backup script for agents2automate.com
# Run this on EC2 server

set -e

BACKUP_DIR="$HOME/backups"
SITE_DIR="/var/www/agents2automate.com"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/agents2automate_$TIMESTAMP.tar.gz"

echo "🔄 Starting backup..."

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create backup
echo "📦 Creating backup: $BACKUP_FILE"
sudo tar -czf "$BACKUP_FILE" -C /var/www agents2automate.com

# Set permissions
sudo chown $USER:$USER "$BACKUP_FILE"

# Get file size
SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
echo "✅ Backup completed: $SIZE"

# Keep only last 7 backups
echo "🧹 Cleaning old backups (keeping last 7)..."
cd "$BACKUP_DIR"
ls -t agents2automate_*.tar.gz | tail -n +8 | xargs -r rm

echo "📊 Current backups:"
ls -lh agents2automate_*.tar.gz 2>/dev/null || echo "No backups found"

echo "✅ Backup process completed!"
