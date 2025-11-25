#!/bin/bash
# Daily Black Swan Tail Risk Monitor
# Runs systemic-risk-monitor agent and emails results
# Schedule: Daily at 9:00 AM UTC (before market open)

set -euo pipefail

# Configuration
SCRIPT_NAME="daily-black-swan-monitor"

# Detect environment (local vs remote)
if [[ -f "$HOME/.bashrc.claude" ]]; then
    # Remote/automated environment - read from emails.csv
    LOG_DIR="$HOME/logs"
    EMAIL_CSV="$HOME/claude-agents/emails.csv"
    MCP_CONFIG="$HOME/.claude/mcp.json"
    CLAUDE_CMD="claude"
    TIMEOUT_CMD="timeout"  # Linux has timeout command

    # Read email addresses from CSV (skip header row)
    if [[ -f "$EMAIL_CSV" ]]; then
        EMAIL_TO=$(tail -n +2 "$EMAIL_CSV" | tr '\n' ',' | sed 's/,$//')
        echo "Running in production mode (reading from emails.csv: $(wc -l < "$EMAIL_CSV" | xargs echo -n) addresses)"
    else
        # Fallback to default if CSV not found
        EMAIL_TO="suneetn@gmail.com,suneetn@quanthub.ai"
        echo "Warning: emails.csv not found, using default addresses"
    fi

    source "$HOME/.bashrc.claude"
    USE_SKIP_PERMISSIONS="--dangerously-skip-permissions"
else
    # Local development/testing environment
    LOG_DIR="$(pwd)/automation/test-logs"
    EMAIL_TO="suneetn@gmail.com"
    USE_SKIP_PERMISSIONS=""
    TIMEOUT_CMD=""  # macOS doesn't have timeout by default - skip it for local testing

    # Use full path to claude CLI for local testing
    CLAUDE_CMD="$HOME/.nvm/versions/node/v21.6.2/bin/claude"
    if [[ ! -f "$CLAUDE_CMD" ]]; then
        # Fallback to PATH if full path doesn't exist
        CLAUDE_CMD="claude"
    fi

    # Use project MCP config for local testing
    if [[ -f "$HOME/.cursor/mcp.json" ]]; then
        MCP_CONFIG="$HOME/.cursor/mcp.json"
    elif [[ -f "$HOME/.claude/mcp.json" ]]; then
        MCP_CONFIG="$HOME/.claude/mcp.json"
    else
        MCP_CONFIG=""  # Will use default Claude Code config
    fi

    echo "Running in local testing mode (test email only)"
fi

LOG_FILE="$LOG_DIR/${SCRIPT_NAME}-$(date +%Y%m%d).log"
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

# Helper function: Convert comma-separated emails to JSON array
emails_to_json() {
    local emails="$1"
    echo "$emails" | tr ',' '\n' | awk '{print "\"" $0 "\""}' | paste -sd ',' | sed 's/^/[/' | sed 's/$/]/'
}

log "Starting daily black swan tail risk monitoring..."

# Validate MCP configuration
if [[ -n "$MCP_CONFIG" ]] && [[ ! -f "$MCP_CONFIG" ]]; then
    error "MCP config not found at $MCP_CONFIG"
    exit 1
fi

# Build MCP config argument
if [[ -n "$MCP_CONFIG" ]]; then
    MCP_ARG="--mcp-config $MCP_CONFIG"
    log "Using MCP config: $MCP_CONFIG"
else
    MCP_ARG=""
    log "Using default Claude Code MCP configuration"
fi

# Step 1: Execute black swan analysis
log "Running systemic-risk-monitor agent..."
log "DEBUG: CLAUDE_CMD=$CLAUDE_CMD"
log "DEBUG: MCP_ARG=$MCP_ARG"

# Save analysis output directly to file for better reliability
ANALYSIS_FILE="/tmp/black-swan-analysis-$$.txt"

# Execute with or without timeout
if [[ -n "$TIMEOUT_CMD" ]]; then
    $TIMEOUT_CMD $TIMEOUT "$CLAUDE_CMD" --print \
        --max-turns 20 \
        $USE_SKIP_PERMISSIONS \
        $MCP_ARG \
        -- "Use the systemic-risk-monitor agent to conduct a comprehensive black swan tail risk analysis.

Execute real-time analysis using MCP tools:
1. get_vix_data(period='1year') - Get current VIX level and 1-year percentile
   CRITICAL: Use the EXACT percentile value returned by this tool for your calculation
2. get_sector_performance() - Sector correlation analysis
3. get_market_movers('gainers') and get_market_movers('losers') - For extreme mover counts
   CRITICAL: For TRUE SYSTEMIC RISK, count ONLY large-cap stocks:
   - Stock price >= \$10 (exclude penny stocks)
   - Market cap >= \$10 BILLION (large caps only - this is MANDATORY)
   - EXCLUDE all leveraged ETFs (names containing "2X", "2x", "ETF", "Daily")
   - EXCLUDE small/mid caps - they do NOT represent systemic market stress
   - Only count S&P 500 / Russell 1000 sized companies
   Example: INSP at \$3.5B market cap does NOT count (too small)
4. get_multiple_iv_ranks(['SPY','QQQ','IWM','DIA']) - Options market IV

Calculate the black swan risk score (0-100) with component breakdown:
- VIX Analysis (0-30 points): Use the actual 1-year percentile × 0.30
  Example: If VIX is at 86.4th percentile, this contributes 25.92 points
- Sector Correlation (0-25 points): % sectors moving in same direction
- Extreme Movers (0-25 points): Count of LARGE CAP stocks (market cap ≥\$10B) with >10% daily moves
  Scale: 0 stocks = 0 points, 1-2 stocks = 5 points, 3-5 stocks = 10 points, 6-10 stocks = 15 points, >10 stocks = 25 points
  IMPORTANT: If no large caps have >10% moves, score is 0 points (not 25)
- IV Rank (0-20 points): Average IV rank of major indices × 0.20

Provide structured output with:
- Current risk score with level (NORMAL <35 / ELEVATED 35-60 / HIGH 60-80 / CRISIS >80)
- Component breakdown with actual values and calculations shown
- List of LARGE CAP extreme movers (market cap ≥\$10B) with symbols, prices, and market caps
  * If ZERO large caps, explicitly state: "0 large cap stocks with >10% moves"
  * Show total count of small/mid cap movers that were EXCLUDED for context
- Specific actionable recommendations
- Key metrics (VIX level, VIX percentile, correlation %, large cap extreme count)
- Historical context and comparison

Output the analysis in JSON format for professional formatting." > "$ANALYSIS_FILE" 2>&1
else
    "$CLAUDE_CMD" --print \
        --max-turns 20 \
        $USE_SKIP_PERMISSIONS \
        $MCP_ARG \
        -- "Use the systemic-risk-monitor agent to conduct a comprehensive black swan tail risk analysis.

Execute real-time analysis using MCP tools:
1. get_vix_data(period='1year') - Get current VIX level and 1-year percentile
   CRITICAL: Use the EXACT percentile value returned by this tool for your calculation
2. get_sector_performance() - Sector correlation analysis
3. get_market_movers('gainers') and get_market_movers('losers') - For extreme mover counts
   CRITICAL: For TRUE SYSTEMIC RISK, count ONLY large-cap stocks:
   - Stock price >= \$10 (exclude penny stocks)
   - Market cap >= \$10 BILLION (large caps only - this is MANDATORY)
   - EXCLUDE all leveraged ETFs (names containing \"2X\", \"2x\", \"ETF\", \"Daily\")
   - EXCLUDE small/mid caps - they do NOT represent systemic market stress
   - Only count S&P 500 / Russell 1000 sized companies
   Example: INSP at \$3.5B market cap does NOT count (too small)
4. get_multiple_iv_ranks(['SPY','QQQ','IWM','DIA']) - Options market IV

Calculate the black swan risk score (0-100) with component breakdown:
- VIX Analysis (0-30 points): Use the actual 1-year percentile × 0.30
  Example: If VIX is at 86.4th percentile, this contributes 25.92 points
- Sector Correlation (0-25 points): % sectors moving in same direction
- Extreme Movers (0-25 points): Count of LARGE CAP stocks (market cap ≥\$10B) with >10% daily moves
  Scale: 0 stocks = 0 points, 1-2 stocks = 5 points, 3-5 stocks = 10 points, 6-10 stocks = 15 points, >10 stocks = 25 points
  IMPORTANT: If no large caps have >10% moves, score is 0 points (not 25)
- IV Rank (0-20 points): Average IV rank of major indices × 0.20

Provide structured output with:
- Current risk score with level (NORMAL <35 / ELEVATED 35-60 / HIGH 60-80 / CRISIS >80)
- Component breakdown with actual values and calculations shown
- List of LARGE CAP extreme movers (market cap ≥\$10B) with symbols, prices, and market caps
  * If ZERO large caps, explicitly state: \"0 large cap stocks with >10% moves\"
  * Show total count of small/mid cap movers that were EXCLUDED for context
- Specific actionable recommendations
- Key metrics (VIX level, VIX percentile, correlation %, large cap extreme count)
- Historical context and comparison

Output the analysis in JSON format for professional formatting." > "$ANALYSIS_FILE" 2>&1
fi

CLAUDE_EXIT=$?

if [[ $CLAUDE_EXIT -ne 0 ]]; then
    error "Claude execution failed with exit code $CLAUDE_EXIT"
    if [[ -f "$ANALYSIS_FILE" ]]; then
        log "Partial output: $(head -20 "$ANALYSIS_FILE")"
    fi
    exit 1
fi

# Verify output was captured
if [[ ! -s "$ANALYSIS_FILE" ]]; then
    error "Analysis file is empty - no output captured"
    exit 1
fi

log "Analysis completed successfully ($(wc -l < "$ANALYSIS_FILE") lines captured)"

# Step 2: Format the analysis using output-formatter agent
log "Formatting analysis for professional email delivery..."

# Create temp file for formatted HTML
HTML_TEMP_FILE="/tmp/black-swan-email-$$.html"

# Build command with or without timeout
if [[ -n "$TIMEOUT_CMD" ]]; then
    CMD_PREFIX="$TIMEOUT_CMD 300"
else
    CMD_PREFIX=""
fi

$CMD_PREFIX "$CLAUDE_CMD" --print \
    --max-turns 15 \
    $USE_SKIP_PERMISSIONS \
    $MCP_ARG \
    -- "Use the output-formatter agent to transform this black swan risk analysis into a Bloomberg Terminal-quality HTML email.

Analysis Data:
$(cat "$ANALYSIS_FILE")

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
    FORMATTED_HTML="<html><body><h1>Black Swan Risk Analysis</h1><pre>$(cat "$ANALYSIS_FILE")</pre></body></html>"
    log "Using fallback HTML formatting"
fi

# Extract key information for email subject
RISK_LEVEL=$(grep -i "risk.*level\|risk.*score" "$ANALYSIS_FILE" | head -1 || echo "Analysis Complete")

# Step 3: Send email via Mailgun MCP tool
log "Sending email notification (BCC) to $EMAIL_TO..."

# Convert comma-separated emails to JSON array
EMAIL_JSON=$(emails_to_json "$EMAIL_TO")

# Build command with or without timeout
if [[ -n "$TIMEOUT_CMD" ]]; then
    CMD_PREFIX="$TIMEOUT_CMD 120"
else
    CMD_PREFIX=""
fi

EMAIL_RESULT=$($CMD_PREFIX "$CLAUDE_CMD" --print \
    $USE_SKIP_PERMISSIONS \
    $MCP_ARG \
    -- "Send an email using the mcp__fmp-weather-global__send_email_mailgun tool.

Parameters:
- to_addresses: ['suneetn@gmail.com']  # Primary recipient (visible)
- bcc_addresses: $EMAIL_JSON  # Distribution list (hidden for privacy)
- subject: 'Daily Black Swan Risk Monitor - $(date +%Y-%m-%d) - ${RISK_LEVEL}'
- content: '''$FORMATTED_HTML'''
- is_html: true
- tags: ['black-swan-monitor', 'daily-report', 'systemic-risk']

Execute the email send now." 2>&1)

EMAIL_EXIT=$?

if [[ $EMAIL_EXIT -eq 0 ]]; then
    log "Email sent successfully to $EMAIL_TO"
    log "Mailgun API Response: $EMAIL_RESULT"
else
    error "Email delivery failed with exit code $EMAIL_EXIT"
    log "Email output: $EMAIL_RESULT"
    exit 1
fi

# Save analysis to file for reference
REPORT_FILE="$LOG_DIR/black-swan-report-$(date +%Y%m%d-%H%M%S).txt"
cp "$ANALYSIS_FILE" "$REPORT_FILE"
log "Analysis saved to $REPORT_FILE"

# Save formatted HTML for reference
HTML_FILE="$LOG_DIR/black-swan-email-$(date +%Y%m%d-%H%M%S).html"
echo "$FORMATTED_HTML" > "$HTML_FILE"
log "Formatted email saved to $HTML_FILE"

# Cleanup temp files
rm -f "$ANALYSIS_FILE"

log "Daily black swan monitoring completed successfully"
exit 0
