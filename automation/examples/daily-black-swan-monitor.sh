#!/bin/bash
# Daily Black Swan Tail Risk Monitor
# Runs systemic-risk-monitor agent and emails results
# Schedule: Daily at 9:00 AM UTC (before market open)

set -euo pipefail

# Configuration
SCRIPT_NAME="daily-black-swan-monitor"
LOG_DIR="$HOME/logs"
LOG_FILE="$LOG_DIR/${SCRIPT_NAME}-$(date +%Y%m%d).log"
EMAIL_TO="suneetn@gmail.com,suneetn@quanthub.ai"
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

# Step 1: Execute black swan analysis
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

Provide structured output with:
- Current risk score with level (NORMAL/ELEVATED/HIGH/CRISIS)
- Component breakdown with actual values
- Specific actionable recommendations
- Key metrics (VIX, correlation %, extreme count)
- Historical context and comparison

Output the analysis in JSON format for professional formatting." 2>&1)

CLAUDE_EXIT=$?

if [[ $CLAUDE_EXIT -ne 0 ]]; then
    error "Claude execution failed with exit code $CLAUDE_EXIT"
    log "Output: $ANALYSIS_OUTPUT"
    exit 1
fi

log "Analysis completed successfully"

# Step 2: Format the analysis using output-formatter agent
log "Formatting analysis for professional email delivery..."

# Create temp file for formatted HTML
HTML_TEMP_FILE="/tmp/black-swan-email-$$.html"

timeout 300 claude --print \
    --max-turns 15 \
    --dangerously-skip-permissions \
    --mcp-config "$MCP_CONFIG" \
    -- "Use the output-formatter agent to transform this black swan risk analysis into a Bloomberg Terminal-quality HTML email.

Analysis Data:
$ANALYSIS_OUTPUT

Requirements:
- Professional institutional design (navy blue headers with gold accents)
- Monospace fonts for all numbers and metrics
- Risk level badges with appropriate colors (green/yellow/red/black)
- Component breakdown table with scores
- Clear actionable recommendations section
- NO purple gradients, minimal emojis (section headers only)
- Include timestamp: $(date +'%Y-%m-%d %H:%M:%S UTC')
- Title: 'Daily Black Swan Tail Risk Monitor'
- Source attribution: 'Automated via systemic-risk-monitor agent'

CRITICAL: Use the Write tool to save the complete HTML (no explanations, ONLY the HTML code) to this file:
$HTML_TEMP_FILE

Output ONLY the HTML code - do not include any explanations or descriptions.
Use strict anti-AI-detection rules - this must look like a \$10K/year professional research platform." 2>&1

FORMAT_EXIT=$?

# Check if HTML file was created
if [[ -f "$HTML_TEMP_FILE" ]]; then
    FORMATTED_HTML=$(cat "$HTML_TEMP_FILE")
    rm -f "$HTML_TEMP_FILE"
    log "Formatting completed - HTML file generated"
elif [[ -f "/home/claude-automation/black_swan_risk_report.html" ]]; then
    # Fallback to check the default location
    FORMATTED_HTML=$(cat "/home/claude-automation/black_swan_risk_report.html")
    log "Formatting completed - using default HTML location"
else
    error "Formatting produced no HTML file"
    # Fall back to simple HTML
    FORMATTED_HTML="<html><body><h1>Black Swan Risk Analysis</h1><pre>$ANALYSIS_OUTPUT</pre></body></html>"
    log "Using fallback HTML formatting"
fi

# Extract key information for email subject
RISK_LEVEL=$(echo "$ANALYSIS_OUTPUT" | grep -i "risk.*level\|risk.*score" | head -1 || echo "Analysis Complete")

# Step 3: Send email via Mailgun MCP tool
log "Sending email notification to $EMAIL_TO..."

EMAIL_RESULT=$(timeout 120 claude --print \
    --dangerously-skip-permissions \
    --mcp-config "$MCP_CONFIG" \
    -- "Send an email using the mcp__fmp-weather-global__send_email_mailgun tool.

Parameters:
- to_addresses: ['suneetn@gmail.com', 'suneetn@quanthub.ai']
- subject: 'Daily Black Swan Risk Monitor - $(date +%Y-%m-%d) - ${RISK_LEVEL}'
- content: '''$FORMATTED_HTML'''
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

# Save formatted HTML for reference
HTML_FILE="$LOG_DIR/black-swan-email-$(date +%Y%m%d-%H%M%S).html"
echo "$FORMATTED_HTML" > "$HTML_FILE"
log "Formatted email saved to $HTML_FILE"

log "Daily black swan monitoring completed successfully"
exit 0
