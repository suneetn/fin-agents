#!/bin/bash
# Daily Put-Selling Opportunity Scanner
# Cron: 0 15 * * 1-5 (3 PM UTC, weekdays only)

set -euo pipefail

# Load Claude authentication
source ~/.bashrc.claude || {
  echo "ERROR: Failed to load Claude authentication" >&2
  exit 1
}

# Configuration
AGENT_DIR="/root/claude-agents/.claude"
MCP_CONFIG="/root/.claude/mcp.json"
EMAIL="${1:-your-email@example.com}"

# Execute put-selling scanner
timeout 600 claude --print \
  --setting-sources "$AGENT_DIR" \
  --mcp-config "$MCP_CONFIG" \
  --dangerously-skip-permissions \
  -- "/csp-scanner" || {
  echo "ERROR: Put scanner failed" >&2
  exit 1
}

echo "✅ Put-selling scan completed successfully"
