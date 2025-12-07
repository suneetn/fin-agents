#!/bin/bash
# Daily Uber Email - Comprehensive Market Intelligence Report
# Runs 6 sequential agents and emails professional HTML report
# Schedule: Daily at 8:00 AM UTC (1 hour before market open)
# Estimated runtime: 60-75 minutes

set -euo pipefail

# Configuration
SCRIPT_NAME="daily-uber-email"
LOG_DIR="$HOME/logs"
LOG_FILE="$LOG_DIR/${SCRIPT_NAME}-$(date +%Y%m%d).log"
EMAIL_CSV="${1:-/root/claude-agents/emails.csv}"  # Default CSV file location on remote
TIMEOUT=5400  # 90 minutes (generous buffer for 60-75 min runtime)

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

log "Starting daily uber email generation..."

# MCP configuration path
MCP_CONFIG="$HOME/.claude/mcp.json"
if [[ ! -f "$MCP_CONFIG" ]]; then
    error "MCP config not found at $MCP_CONFIG"
    exit 1
fi

# Define 25-stock tiered watchlist
CORE_10="AAPL, MSFT, GOOGL, AMZN, NVDA, META, TSLA, BRK.B, JPM, JNJ"
ROTATING_10="CRM, ADBE, NFLX, PYPL, AMD, ORCL, V, UNH, HD, COST"
BIG_MOVERS_5="PLTR, SNOW, SQ, SMCI, COIN"

# Step 1: Market Pulse Analysis (10-12 minutes)
log "Step 1/7: Running market-pulse-analyzer agent..."

SECTION_1_MARKET_PULSE=$(timeout 900 claude --print \
    --max-turns 20 \
    --dangerously-skip-permissions \
    --mcp-config "$MCP_CONFIG" \
    -- "Use the market-pulse-analyzer agent to generate today's comprehensive market pulse analysis including:
- Market overview (SPY, VIX, sector performance)
- News catalyst analysis and scoring
- Volatility regime assessment
- Risk management guidance

Format output for email section 1 of 6." 2>&1)

STEP1_EXIT=$?
if [[ $STEP1_EXIT -ne 0 ]]; then
    error "Market pulse analysis failed with exit code $STEP1_EXIT"
    log "Output: $SECTION_1_MARKET_PULSE"
    exit 1
fi

log "Step 1/7: Market Pulse completed successfully"

# Step 2: Quality Assessment Dashboard (12-15 minutes)
log "Step 2/7: Running quality-assessor agent..."

SECTION_2_QUALITY=$(timeout 1200 claude --print \
    --max-turns 25 \
    --dangerously-skip-permissions \
    --mcp-config "$MCP_CONFIG" \
    -- "Use the quality-assessor agent to evaluate investment quality and assign letter grades (A+ to F) for the 25-stock tiered watchlist:

**CORE 10 (Durable Quality - Deep Analysis):**
$CORE_10

**ROTATING 10 (Current Theme: AI/Cloud Enterprise):**
$ROTATING_10

**BIG MOVERS 5 (High Volatility Momentum):**
$BIG_MOVERS_5

Provide:
- A+ to F grades for all 25 watchlist stocks
- Quality score rankings (0-100) with tier designation
- Focus 60% analysis time on Core 10, 30% on Rotating 10, 10% on Big Movers 5
- Fair value estimates vs current prices
- Key strengths and concerns by tier
- Buy/Hold/Sell recommendations

Format output for email section 2 of 6." 2>&1)

STEP2_EXIT=$?
if [[ $STEP2_EXIT -ne 0 ]]; then
    error "Quality assessment failed with exit code $STEP2_EXIT"
    log "Output: $SECTION_2_QUALITY"
    exit 1
fi

log "Step 2/7: Quality Assessment completed successfully"

# Step 3: Smart Money Intelligence (10-12 minutes)
log "Step 3/7: Running smart-money-interpreter agent..."

SECTION_3_SMART_MONEY=$(timeout 900 claude --print \
    --max-turns 20 \
    --dangerously-skip-permissions \
    --mcp-config "$MCP_CONFIG" \
    -- "Use the smart-money-interpreter agent to analyze institutional activity and insider trades for smart money signals across the 25-stock tiered watchlist:

**CORE 10 (Priority Analysis):**
$CORE_10

**ROTATING 10 (AI/Cloud Theme):**
$ROTATING_10

**BIG MOVERS 5 (Momentum Signals):**
$BIG_MOVERS_5

Focus on:
- Institutional buying/selling signals (prioritize Core 10)
- Insider trading patterns
- Analyst upgrade/downgrade activity
- 13F filing intelligence
- Smart money conviction levels by tier
- Allocate 60% analysis depth to Core 10, 30% to Rotating 10, 10% to Big Movers

Format output for email section 3 of 6." 2>&1)

STEP3_EXIT=$?
if [[ $STEP3_EXIT -ne 0 ]]; then
    error "Smart money analysis failed with exit code $STEP3_EXIT"
    log "Output: $SECTION_3_SMART_MONEY"
    exit 1
fi

log "Step 3/7: Smart Money Intelligence completed successfully"

# Step 4: Volatility Opportunities (8-10 minutes)
log "Step 4/7: Running volatility-analyzer agent..."

SECTION_4_VOLATILITY=$(timeout 900 claude --print \
    --max-turns 20 \
    --dangerously-skip-permissions \
    --mcp-config "$MCP_CONFIG" \
    -- "Use the volatility-analyzer agent to analyze volatility opportunities across the 25-stock tiered watchlist:

**CORE 10 (Stable Vol Strategies):**
$CORE_10

**ROTATING 10 (Sector Vol Plays):**
$ROTATING_10

**BIG MOVERS 5 (High Vol Opportunities):**
$BIG_MOVERS_5

Provide:
- IV rank analysis with real market data for all tiers
- Volatility buy/sell signals prioritized by tier
- Options trading opportunities (emphasize Big Movers 5 for vol trading)
- VIX market regime adjustments
- Risk management for volatility positions by tier
- Position sizing recommendations: Core 10 (large), Rotating 10 (medium), Big Movers 5 (small)

Format output for email section 4 of 6." 2>&1)

STEP4_EXIT=$?
if [[ $STEP4_EXIT -ne 0 ]]; then
    error "Volatility analysis failed with exit code $STEP4_EXIT"
    log "Output: $SECTION_4_VOLATILITY"
    exit 1
fi

log "Step 4/7: Volatility Opportunities completed successfully"

# Step 5: Value & Growth Screening (10-12 minutes)
log "Step 5/7: Running comparative-stock-analyzer agent..."

SECTION_5_SCREENING=$(timeout 900 claude --print \
    --max-turns 20 \
    --dangerously-skip-permissions \
    --mcp-config "$MCP_CONFIG" \
    -- "Use the comparative-stock-analyzer agent to screen for value and growth opportunities across the 25-stock tiered watchlist:

**CORE 10 (Quality Foundation):**
$CORE_10

**ROTATING 10 (AI/Cloud Sector Focus):**
$ROTATING_10

**BIG MOVERS 5 (Speculative Opportunities):**
$BIG_MOVERS_5

Provide:
- Cross-stock comparisons and sector analysis by tier
- Value screening (low P/E, P/B, high dividend yield) - emphasize Core 10
- Growth screening (revenue growth, earnings acceleration) - focus on Rotating 10
- Momentum screening for Big Movers 5 (price action, volume, volatility)
- Relative positioning and percentile rankings within each tier
- Sector leadership identification across all tiers

Format output for email section 5 of 6." 2>&1)

STEP5_EXIT=$?
if [[ $STEP5_EXIT -ne 0 ]]; then
    error "Screening analysis failed with exit code $STEP5_EXIT"
    log "Output: $SECTION_5_SCREENING"
    exit 1
fi

log "Step 5/7: Value & Growth Screening completed successfully"

# Step 6: Top 10 Trading Ideas Synthesis (10-15 minutes)
log "Step 6/7: Running trading-idea-generator agent..."

SECTION_6_TRADING_IDEAS=$(timeout 1200 claude --print \
    --max-turns 25 \
    --dangerously-skip-permissions \
    --mcp-config "$MCP_CONFIG" \
    -- "Use the trading-idea-generator agent to synthesize the following analysis into the top 10 trading ideas:

===== MARKET PULSE ANALYSIS =====
$SECTION_1_MARKET_PULSE

===== QUALITY ASSESSMENT =====
$SECTION_2_QUALITY

===== SMART MONEY INTELLIGENCE =====
$SECTION_3_SMART_MONEY

===== VOLATILITY ANALYSIS =====
$SECTION_4_VOLATILITY

===== SCREENING RESULTS =====
$SECTION_5_SCREENING

===== SYNTHESIS REQUIREMENTS =====
Based on the above data, generate maximum 10 high-conviction trading ideas with:

- Scoring methodology (100 points):
  * Quality 30% (from quality assessment data)
  * Technical 25% (from market pulse and screening data)
  * Volatility 20% (from volatility analysis data)
  * Smart Money 15% (from smart money intelligence data)
  * Risk/Reward 10% (calculated from entry/exit levels)

- Categories: Quality at discount, growth at reasonable price, momentum plays, put selling setups
- Precise entry/exit zones with stop-losses
- Position sizing and time horizons
- Risk/reward ratios (minimum 1.5:1)

Rank all ideas by composite score and select top 10.
Format output for email section 6 of 6." 2>&1)

STEP6_EXIT=$?
if [[ $STEP6_EXIT -ne 0 ]]; then
    error "Trading ideas synthesis failed with exit code $STEP6_EXIT"
    log "Output: $SECTION_6_TRADING_IDEAS"
    exit 1
fi

log "Step 6/7: Top 10 Trading Ideas completed successfully"

# Step 7: Format Professional HTML Email (10-15 minutes)
log "Step 7/7: Formatting professional HTML email using output-formatter agent..."

# Create temp file for formatted HTML
HTML_TEMP_FILE="/tmp/uber-email-$$.html"

timeout 1200 claude --print \
    --max-turns 25 \
    --dangerously-skip-permissions \
    --mcp-config "$MCP_CONFIG" \
    -- "Use the output-formatter agent to transform the following 6 analysis sections into a professional, institutional-grade HTML email for QuantHub.ai Daily Intelligence.

===== SECTION 1: MARKET PULSE =====
$SECTION_1_MARKET_PULSE

===== SECTION 2: QUALITY DASHBOARD =====
$SECTION_2_QUALITY

===== SECTION 3: SMART MONEY INTELLIGENCE =====
$SECTION_3_SMART_MONEY

===== SECTION 4: VOLATILITY OPPORTUNITIES =====
$SECTION_4_VOLATILITY

===== SECTION 5: VALUE & GROWTH SCREENING =====
$SECTION_5_SCREENING

===== SECTION 6: TOP 10 TRADING IDEAS =====
$SECTION_6_TRADING_IDEAS

===== FORMATTING REQUIREMENTS =====
Content Structure:
- Executive Dashboard with 30-second overview at the top
- All 6 sections formatted for professional presentation
- Maximum 8 pages total length
- Mobile-responsive design
- Bloomberg Terminal-quality styling (no purple gradients, minimal emojis)
- Navy blue headers with gold accents
- Monospace fonts for numbers
- Professional institutional language
- Include timestamp: $(date +'%Y-%m-%d %H:%M:%S UTC')
- Title: 'QuantHub.ai Daily Intelligence'
- Source attribution: 'Automated multi-agent analysis system'

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
elif [[ -f "/home/claude-automation/uber_email_report.html" ]]; then
    # Fallback to check the default location
    FORMATTED_HTML=$(cat "/home/claude-automation/uber_email_report.html")
    log "Formatting completed - using default HTML location"
else
    error "Formatting produced no HTML file"
    # Fall back to simple HTML with all sections
    FORMATTED_HTML="<html><body><h1>QuantHub.ai Daily Intelligence</h1>
<h2>Section 1: Market Pulse</h2><pre>$SECTION_1_MARKET_PULSE</pre>
<h2>Section 2: Quality Dashboard</h2><pre>$SECTION_2_QUALITY</pre>
<h2>Section 3: Smart Money</h2><pre>$SECTION_3_SMART_MONEY</pre>
<h2>Section 4: Volatility</h2><pre>$SECTION_4_VOLATILITY</pre>
<h2>Section 5: Screening</h2><pre>$SECTION_5_SCREENING</pre>
<h2>Section 6: Trading Ideas</h2><pre>$SECTION_6_TRADING_IDEAS</pre>
</body></html>"
    log "Using fallback HTML formatting"
fi

log "Step 7/7: Professional HTML email formatted successfully"

# Step 8: Send emails in batches
log "Step 8/8: Sending emails in batches..."

# Read email addresses from CSV file
if [[ ! -f "$EMAIL_CSV" ]]; then
    error "Email CSV file not found at $EMAIL_CSV"
    exit 1
fi

# Save HTML to temporary file for batch sender
HTML_TEMP_FILE="/tmp/uber-email-$(date +%Y%m%d-%H%M%S).html"
echo "$FORMATTED_HTML" > "$HTML_TEMP_FILE"

# Use batch sender script
BATCH_SENDER="$HOME/scripts/send-email-batch.sh"
SUBJECT="QuantHub.ai Daily Intelligence - $(date +%Y-%m-%d)"

if [[ ! -f "$BATCH_SENDER" ]]; then
    error "Batch sender script not found at $BATCH_SENDER"
    error "Please deploy send-email-batch.sh to $HOME/scripts/"
    exit 1
fi

# Send emails in batches of 3
export MCP_CONFIG  # Pass MCP config to batch sender
export LOG_PREFIX="[UBER_EMAIL]"

"$BATCH_SENDER" "$EMAIL_CSV" "$SUBJECT" "$HTML_TEMP_FILE" 3

EMAIL_EXIT=$?

# Cleanup temp file
rm -f "$HTML_TEMP_FILE"

if [[ $EMAIL_EXIT -eq 0 ]]; then
    log "Emails sent successfully in batches"
else
    error "Batch email delivery failed with exit code $EMAIL_EXIT"
    exit 1
fi

# Save all sections to files for reference
REPORT_DIR="$LOG_DIR/uber-email-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$REPORT_DIR"

echo "$SECTION_1_MARKET_PULSE" > "$REPORT_DIR/section1-market-pulse.txt"
echo "$SECTION_2_QUALITY" > "$REPORT_DIR/section2-quality.txt"
echo "$SECTION_3_SMART_MONEY" > "$REPORT_DIR/section3-smart-money.txt"
echo "$SECTION_4_VOLATILITY" > "$REPORT_DIR/section4-volatility.txt"
echo "$SECTION_5_SCREENING" > "$REPORT_DIR/section5-screening.txt"
echo "$SECTION_6_TRADING_IDEAS" > "$REPORT_DIR/section6-trading-ideas.txt"
echo "$FORMATTED_HTML" > "$REPORT_DIR/final-email.html"

log "All sections saved to $REPORT_DIR"
log "Daily uber email completed successfully"

exit 0
