#!/bin/bash
# Weekly Portfolio Analysis
# Cron: 0 18 * * 0 (Sunday 6 PM UTC)

set -euo pipefail

# Load Claude authentication
source ~/.bashrc.claude || {
  echo "ERROR: Failed to load Claude authentication" >&2
  exit 1
}

# Configuration
AGENT_DIR="/root/claude-agents/.claude"
MCP_CONFIG="/root/.claude/mcp.json"

# Execute weekly portfolio review
timeout 600 claude --print \
  --setting-sources "$AGENT_DIR" \
  --mcp-config "$MCP_CONFIG" \
  --dangerously-skip-permissions \
  -- "Generate comprehensive weekly portfolio analysis covering:
1. Performance review of all positions
2. Sector allocation analysis
3. Fundamental quality assessment
4. Risk metrics and volatility analysis
5. Actionable recommendations for the week ahead
Email results to portfolio report recipient" || {
  echo "ERROR: Weekly portfolio analysis failed" >&2
  exit 1
}

echo "✅ Weekly portfolio analysis completed successfully"
