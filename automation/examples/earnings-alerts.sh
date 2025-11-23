#!/bin/bash
# Upcoming Earnings Alerts
# Cron: 0 8 * * 1 (Monday 8 AM UTC - weekly)

set -euo pipefail

# Load Claude authentication
source ~/.bashrc.claude || {
  echo "ERROR: Failed to load Claude authentication" >&2
  exit 1
}

# Configuration
AGENT_DIR="/root/claude-agents/.claude"
MCP_CONFIG="/root/.claude/mcp.json"

# Get earnings calendar for next 7 days
timeout 300 claude --print \
  --setting-sources "$AGENT_DIR" \
  --mcp-config "$MCP_CONFIG" \
  --dangerously-skip-permissions \
  -- "Get upcoming earnings for the next 7 days using get_earnings_calendar.

For each earnings date:
1. List the companies reporting
2. Show current stock price
3. Indicate pre-market or after-market timing
4. Highlight any portfolio positions

Format as a clean weekly calendar view." || {
  echo "ERROR: Earnings alerts failed" >&2
  exit 1
}

echo "✅ Earnings alerts completed successfully"
