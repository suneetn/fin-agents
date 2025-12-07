#!/bin/bash
# Deploy batch email sending infrastructure to remote server
# Usage: ./deploy-batch-email.sh [SERVER_IP]

set -euo pipefail

SERVER="${1:-159.65.37.77}"
SERVER_USER="root"
REMOTE_HOME="/home/claude-automation"
REMOTE_SCRIPTS="$REMOTE_HOME/scripts"
REMOTE_AUTOMATION="$REMOTE_HOME/claude-agents/automation/examples"

echo "========================================="
echo "Deploying Batch Email Infrastructure"
echo "========================================="
echo "Target Server: $SERVER_USER@$SERVER"
echo "Remote Path: $REMOTE_HOME"
echo ""

# Test connectivity
echo "[1/5] Testing server connectivity..."
if ! ssh -o ConnectTimeout=5 "$SERVER_USER@$SERVER" "echo 'Connected'" 2>/dev/null; then
    echo "ERROR: Cannot connect to $SERVER"
    echo "Please check:"
    echo "  - Server is online"
    echo "  - SSH keys are configured"
    echo "  - Firewall allows SSH"
    exit 1
fi
echo "✅ Server is accessible"
echo ""

# Create directories
echo "[2/5] Creating remote directories..."
ssh "$SERVER_USER@$SERVER" "mkdir -p $REMOTE_SCRIPTS"
echo "✅ Directories created"
echo ""

# Deploy batch sender script
echo "[3/5] Deploying send-email-batch.sh..."
scp automation/scripts/send-email-batch.sh "$SERVER_USER@$SERVER:$REMOTE_SCRIPTS/"
ssh "$SERVER_USER@$SERVER" "chmod +x $REMOTE_SCRIPTS/send-email-batch.sh"
echo "✅ Batch sender deployed"
echo ""

# Backup and deploy updated automation scripts
echo "[4/5] Updating automation scripts..."

# Backup originals
ssh "$SERVER_USER@$SERVER" "
    if [ -f '$REMOTE_AUTOMATION/daily-uber-email.sh' ]; then
        cp '$REMOTE_AUTOMATION/daily-uber-email.sh' '$REMOTE_AUTOMATION/daily-uber-email.sh.backup-$(date +%Y%m%d-%H%M%S)'
        echo '  ✅ Backed up daily-uber-email.sh'
    fi
    if [ -f '$REMOTE_AUTOMATION/daily-black-swan-monitor.sh' ]; then
        cp '$REMOTE_AUTOMATION/daily-black-swan-monitor.sh' '$REMOTE_AUTOMATION/daily-black-swan-monitor.sh.backup-$(date +%Y%m%d-%H%M%S)'
        echo '  ✅ Backed up daily-black-swan-monitor.sh'
    fi
"

# Deploy updated scripts
scp automation/examples/daily-uber-email.sh "$SERVER_USER@$SERVER:$REMOTE_AUTOMATION/"
scp automation/examples/daily-black-swan-monitor.sh "$SERVER_USER@$SERVER:$REMOTE_AUTOMATION/"

ssh "$SERVER_USER@$SERVER" "
    chmod +x '$REMOTE_AUTOMATION/daily-uber-email.sh'
    chmod +x '$REMOTE_AUTOMATION/daily-black-swan-monitor.sh'
"
echo "✅ Automation scripts updated"
echo ""

# Verify deployment
echo "[5/5] Verifying deployment..."

VERIFY=$(ssh "$SERVER_USER@$SERVER" "
    echo -n 'Batch sender: '
    if [ -x '$REMOTE_SCRIPTS/send-email-batch.sh' ]; then
        echo 'OK'
    else
        echo 'MISSING'
    fi

    echo -n 'Uber email script: '
    if [ -f '$REMOTE_AUTOMATION/daily-uber-email.sh' ]; then
        echo 'OK'
    else
        echo 'MISSING'
    fi

    echo -n 'Black swan script: '
    if [ -f '$REMOTE_AUTOMATION/daily-black-swan-monitor.sh' ]; then
        echo 'OK'
    else
        echo 'MISSING'
    fi

    echo -n 'emails.csv: '
    if [ -f '$REMOTE_HOME/../root/claude-agents/emails.csv' ]; then
        wc -l < '$REMOTE_HOME/../root/claude-agents/emails.csv' | xargs echo 'lines'
    else
        echo 'MISSING'
    fi
")

echo "$VERIFY"
echo ""

# Check for errors
if echo "$VERIFY" | grep -q "MISSING"; then
    echo "⚠️  WARNING: Some files are missing!"
    echo "Please check the deployment manually."
    exit 1
fi

echo "========================================="
echo "✅ Deployment completed successfully!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Test batch sender with test email:"
echo "   ssh $SERVER_USER@$SERVER '$REMOTE_SCRIPTS/send-email-batch.sh /root/claude-agents/emails.csv \"Test Subject\" /tmp/test.html 3'"
echo ""
echo "2. Monitor logs when cron runs:"
echo "   ssh $SERVER_USER@$SERVER 'tail -f /root/logs/daily-uber-email-*.log'"
echo ""
echo "3. Check cron schedule:"
echo "   ssh $SERVER_USER@$SERVER 'crontab -l | grep -E \"uber-email|black-swan\"'"
echo ""
echo "Rollback instructions are in EMAIL_BATCH_DEPLOYMENT.md"
echo ""

exit 0
