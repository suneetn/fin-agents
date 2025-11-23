#!/bin/bash
# Volatility Screening for Options Opportunities
# Run as: claude-automation user
# Cron: 0 */4 * * * /root/claude-agents/scripts/volatility-scan.sh >> /root/claude-agents/logs/volatility.log 2>&1

set -euo pipefail

# Load Claude authentication
source ~/.bashrc.claude || {
  echo "ERROR: Failed to load Claude authentication" >&2
  exit 1
}

# Configuration
MCP_CONFIG="$HOME/.claude/mcp.json"

# Get watchlist symbols
WATCHLIST="AAPL,MSFT,GOOGL,AMZN,NVDA,TSLA,META,AMD,NFLX,CRM"

# Execute volatility scan
timeout 300 claude --print \
  --mcp-config "$MCP_CONFIG" \
  --dangerously-skip-permissions \
  -- "Use volatility-analyzer agent to scan these symbols for options opportunities: $WATCHLIST

Analyze:
1. Current IV rank for each symbol
2. IV vs HV comparison
3. Volatility regime classification
4. Trading signals (BUY/SELL volatility)

Format results as a concise summary table." || {
  echo "ERROR: Volatility scan failed" >&2
  exit 1
}

echo "✅ Volatility scan completed successfully at $(date)"
