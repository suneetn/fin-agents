#!/bin/bash
# Daily Black Swan Tail Risk Monitor
# Runs systemic-risk-monitor agent and emails results
# Schedule: Daily at 9:00 AM UTC (before market open)

set -euo pipefail

# Configuration
SCRIPT_NAME="daily-black-swan-monitor"
LOG_DIR="$HOME/logs"
LOG_FILE="$LOG_DIR/${SCRIPT_NAME}-$(date +%Y%m%d).log"
EMAIL_TO="suneetn@gmail.com,suneetn@quanthub.com"
TIMEOUT=600  # 10 minutes

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Logging functions
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "$LOG_FILE" >&2
}

# Load Claude authentication
if [[ ! -f "$HOME/.bashrc.claude" ]]; then
    error "Claude authentication not found at $HOME/.bashrc.claude"
    exit 1
fi
source "$HOME/.bashrc.claude"

log "Starting daily black swan tail risk monitoring..."

# MCP configuration path
MCP_CONFIG="$HOME/.claude/mcp.json"
if [[ ! -f "$MCP_CONFIG" ]]; then
    error "MCP config not found at $MCP_CONFIG"
    exit 1
fi

# Execute black swan analysis
log "Running systemic-risk-monitor agent..."

ANALYSIS_OUTPUT=$(timeout $TIMEOUT claude --print \
    --max-turns 20 \
    --dangerously-skip-permissions \
    --mcp-config "$MCP_CONFIG" \
    -- "Use the systemic-risk-monitor agent to conduct a comprehensive black swan tail risk analysis.

Execute real-time analysis using MCP tools:
1. get_vix_data(period='1year') - Current VIX and percentile
2. get_sector_performance() - Sector correlation analysis
3. get_market_movers('gainers') and get_market_movers('losers') - Extreme mover counts
4. get_multiple_iv_ranks(['SPY','QQQ','IWM','DIA']) - Options market IV

Calculate the black swan risk score (0-100) with component breakdown:
- VIX Analysis (0-30 points): VIX percentile × 0.30
- Sector Correlation (0-25 points): % sectors same direction
- Extreme Movers (0-25 points): Count of >10% daily moves
- IV Rank (0-20 points): Average IV rank × 0.20

Provide:
- Current risk score with level (NORMAL/ELEVATED/HIGH/CRISIS)
- Specific actionable recommendations
- Key metrics (VIX, correlation %, extreme count)
- Historical context and comparison

Format the output clearly for email delivery." 2>&1)

CLAUDE_EXIT=$?

if [[ $CLAUDE_EXIT -ne 0 ]]; then
    error "Claude execution failed with exit code $CLAUDE_EXIT"
    log "Output: $ANALYSIS_OUTPUT"
    exit 1
fi

log "Analysis completed successfully"

# Extract key information for email subject
RISK_LEVEL=$(echo "$ANALYSIS_OUTPUT" | grep -i "risk.*level\|risk.*score" | head -1 || echo "Analysis Complete")

# Send email via Claude with Mailgun MCP tool
log "Sending email notification to $EMAIL_TO..."

EMAIL_RESULT=$(timeout 120 claude --print \
    --dangerously-skip-permissions \
    --mcp-config "$MCP_CONFIG" \
    -- "Send an email using the mcp__fmp-weather-global__send_email_mailgun tool.

Parameters:
- to_addresses: ['suneetn@gmail.com', 'suneetn@quanthub.com']
- subject: 'Daily Black Swan Risk Monitor - $(date +%Y-%m-%d) - ${RISK_LEVEL}'
- content: '''
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .header { background: #1a1a2e; color: white; padding: 20px; }
        .content { padding: 20px; }
        .metric { background: #f4f4f4; padding: 15px; margin: 10px 0; border-left: 4px solid #0066cc; }
        .alert { background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 15px 0; }
        .critical { background: #f8d7da; border-left: 4px solid #dc3545; }
        .normal { background: #d4edda; border-left: 4px solid #28a745; }
        .footer { font-size: 12px; color: #666; padding: 20px; border-top: 1px solid #ddd; }
    </style>
</head>
<body>
    <div class=\"header\">
        <h1>🚨 Daily Black Swan Tail Risk Monitor</h1>
        <p>Report Generated: $(date +'%Y-%m-%d %H:%M:%S UTC')</p>
    </div>

    <div class=\"content\">
        <h2>Systemic Risk Analysis</h2>
        <pre style=\"background: #f9f9f9; padding: 15px; border-radius: 5px; overflow-x: auto;\">
$ANALYSIS_OUTPUT
        </pre>
    </div>

    <div class=\"footer\">
        <p><strong>Automated Black Swan Monitor</strong></p>
        <p>This report is generated daily at 9:00 AM UTC by the systemic-risk-monitor agent.</p>
        <p>Server: claude-automation@159.65.37.77</p>
        <p>Repository: <a href=\"https://github.com/suneetn/fin-agents\">github.com/suneetn/fin-agents</a></p>
    </div>
</body>
</html>
'''
- is_html: true
- tags: ['black-swan-monitor', 'daily-report', 'systemic-risk']

Execute the email send now." 2>&1)

EMAIL_EXIT=$?

if [[ $EMAIL_EXIT -eq 0 ]]; then
    log "Email sent successfully to $EMAIL_TO"
else
    error "Email delivery failed with exit code $EMAIL_EXIT"
    log "Email output: $EMAIL_RESULT"
    exit 1
fi

# Save analysis to file for reference
REPORT_FILE="$LOG_DIR/black-swan-report-$(date +%Y%m%d-%H%M%S).txt"
echo "$ANALYSIS_OUTPUT" > "$REPORT_FILE"
log "Analysis saved to $REPORT_FILE"

log "Daily black swan monitoring completed successfully"
exit 0
