#!/bin/bash
# Daily Market Intelligence Scan
# Run as: claude-automation user
# Cron: 0 9 * * * /root/claude-agents/scripts/daily-market-scan.sh >> /root/claude-agents/logs/daily-scan.log 2>&1

set -euo pipefail

# Load Claude authentication
source ~/.bashrc.claude || {
  echo "ERROR: Failed to load Claude authentication" >&2
  exit 1
}

# Configuration
MCP_CONFIG="$HOME/.claude/mcp.json"
EMAIL="${1:-your-email@example.com}"  # Override with argument or set default

# Execute daily market intelligence report
timeout 600 claude --print \
  --mcp-config "$MCP_CONFIG" \
  --dangerously-skip-permissions \
  -- "/uber_email $EMAIL" || {
  echo "ERROR: Daily market scan failed" >&2
  exit 1
}

echo "✅ Daily market scan completed successfully at $(date)"
