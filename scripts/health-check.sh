#!/bin/bash

# Health check script for agents2automate.com

set -e

echo "🏥 Running health checks..."

# Check main site
echo "Checking https://agents2automate.com..."
MAIN_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://agents2automate.com)
if [ "$MAIN_STATUS" = "200" ]; then
    echo "✅ Main site: OK (HTTP $MAIN_STATUS)"
else
    echo "❌ Main site: FAILED (HTTP $MAIN_STATUS)"
fi

# Check WWW redirect
echo "Checking https://www.agents2automate.com..."
WWW_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://www.agents2automate.com)
if [ "$WWW_STATUS" = "200" ] || [ "$WWW_STATUS" = "301" ]; then
    echo "✅ WWW redirect: OK (HTTP $WWW_STATUS)"
else
    echo "❌ WWW redirect: FAILED (HTTP $WWW_STATUS)"
fi

# Check n8n
echo "Checking https://n8n.agents2automate.com..."
N8N_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://n8n.agents2automate.com)
if [ "$N8N_STATUS" = "200" ]; then
    echo "✅ n8n platform: OK (HTTP $N8N_STATUS)"
else
    echo "⚠️ n8n platform: WARNING (HTTP $N8N_STATUS)"
fi

# Check Nginx
echo "Checking Nginx status..."
if systemctl is-active --quiet nginx; then
    echo "✅ Nginx: Running"
else
    echo "❌ Nginx: Not running"
fi

# Check Docker (n8n)
echo "Checking Docker containers..."
if docker ps | grep -q n8n; then
    echo "✅ n8n container: Running"
else
    echo "❌ n8n container: Not running"
fi

# Check SSL certificates
echo "Checking SSL certificates..."
CERT_DAYS=$(sudo certbot certificates 2>/dev/null | grep "Expiry Date" | head -1 | grep -oP '\d+(?= days)' || echo "0")
if [ "$CERT_DAYS" -gt 30 ]; then
    echo "✅ SSL certificates: Valid ($CERT_DAYS days remaining)"
elif [ "$CERT_DAYS" -gt 0 ]; then
    echo "⚠️ SSL certificates: Expiring soon ($CERT_DAYS days remaining)"
else
    echo "❌ SSL certificates: Check required"
fi

# Check disk space
echo "Checking disk space..."
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 80 ]; then
    echo "✅ Disk space: OK (${DISK_USAGE}% used)"
else
    echo "⚠️ Disk space: Warning (${DISK_USAGE}% used)"
fi

echo "🏥 Health check completed!"
