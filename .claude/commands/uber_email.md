---
description: "Generate comprehensive daily market intelligence email with trading ideas, quality assessment, and smart money analysis using the uber daily specification"
allowed-tools:
  - Task
  - mcp__fmp-weather-global__*
  - mcp__fmp-weather-global__send_email_mailgun
  - TodoWrite
argument-hint: "[email_address|csv_file_path]"
---

# Uber Daily Market Intelligence Email

Generate a comprehensive daily market intelligence email that delivers the best value trading and growth opportunities using our advanced agent ecosystem. Combines fundamental analysis, technical signals, volatility insights, and smart money flows into actionable investment recommendations.

## Usage Examples:
- `/uber_email` - Send to default CSV file (emails.csv)
- `/uber_email user@example.com` - Send to specific email
- `/uber_email /path/to/emails.csv` - Send to all emails in CSV file
- `/uber_email john@company.com` - Send to recipient

## Implementation

**IMPORTANT: Execute steps SEQUENTIALLY to capture and pass data between agents.**

### Step 1: Market Pulse Analysis
```
Use the Task tool with subagent_type: "market-pulse-analyzer"
Prompt: "Generate today's comprehensive market pulse analysis including:
- Market overview (SPY, VIX, sector performance)
- News catalyst analysis and scoring
- Volatility regime assessment
- Risk management guidance
Format output for email section 1 of 6."

**AFTER COMPLETION: Capture the agent's complete output and store as SECTION_1_MARKET_PULSE**
```

### Step 2: Quality Assessment Dashboard
```
Use the Task tool with subagent_type: "quality-assessor"
Prompt: "Evaluate investment quality and assign letter grades (A+ to F) for the 25-stock tiered watchlist:

**CORE 10 (Durable Quality - Deep Analysis):**
AAPL, MSFT, GOOGL, AMZN, NVDA, META, TSLA, BRK.B, JPM, JNJ

**ROTATING 10 (Current Theme: AI/Cloud Enterprise):**
CRM, ADBE, NFLX, PYPL, AMD, ORCL, V, UNH, HD, COST

**BIG MOVERS 5 (High Volatility Momentum):**
PLTR, SNOW, SQ, SMCI, COIN

Provide:
- A+ to F grades for all 25 watchlist stocks
- Quality score rankings (0-100) with tier designation
- Focus 60% analysis time on Core 10, 30% on Rotating 10, 10% on Big Movers 5
- Fair value estimates vs current prices
- Key strengths and concerns by tier
- Buy/Hold/Sell recommendations
Format output for email section 2 of 6."

**AFTER COMPLETION: Capture the agent's complete output and store as SECTION_2_QUALITY**
```

### Step 3: Smart Money Intelligence
```
Use the Task tool with subagent_type: "smart-money-interpreter"
Prompt: "Analyze institutional activity and insider trades for smart money signals across the 25-stock tiered watchlist:

**CORE 10 (Priority Analysis):**
AAPL, MSFT, GOOGL, AMZN, NVDA, META, TSLA, BRK.B, JPM, JNJ

**ROTATING 10 (AI/Cloud Theme):**
CRM, ADBE, NFLX, PYPL, AMD, ORCL, V, UNH, HD, COST

**BIG MOVERS 5 (Momentum Signals):**
PLTR, SNOW, SQ, SMCI, COIN

Focus on:
- Institutional buying/selling signals (prioritize Core 10)
- Insider trading patterns
- Analyst upgrade/downgrade activity
- 13F filing intelligence
- Smart money conviction levels by tier
- Allocate 60% analysis depth to Core 10, 30% to Rotating 10, 10% to Big Movers
Format output for email section 3 of 6."

**AFTER COMPLETION: Capture the agent's complete output and store as SECTION_3_SMART_MONEY**
```

### Step 4: Volatility Opportunities
```
Use the Task tool with subagent_type: "volatility-analyzer"
Prompt: "Analyze volatility opportunities across the 25-stock tiered watchlist:

**CORE 10 (Stable Vol Strategies):**
AAPL, MSFT, GOOGL, AMZN, NVDA, META, TSLA, BRK.B, JPM, JNJ

**ROTATING 10 (Sector Vol Plays):**
CRM, ADBE, NFLX, PYPL, AMD, ORCL, V, UNH, HD, COST

**BIG MOVERS 5 (High Vol Opportunities):**
PLTR, SNOW, SQ, SMCI, COIN

Provide:
- IV rank analysis with real market data for all tiers
- Volatility buy/sell signals prioritized by tier
- Options trading opportunities (emphasize Big Movers 5 for vol trading)
- VIX market regime adjustments
- Risk management for volatility positions by tier
- Position sizing recommendations: Core 10 (large), Rotating 10 (medium), Big Movers 5 (small)
Format output for email section 4 of 6."

**AFTER COMPLETION: Capture the agent's complete output and store as SECTION_4_VOLATILITY**
```

### Step 5: Value & Growth Screening
```
Use the Task tool with subagent_type: "comparative-stock-analyzer"
Prompt: "Screen for value and growth opportunities across the 25-stock tiered watchlist:

**CORE 10 (Quality Foundation):**
AAPL, MSFT, GOOGL, AMZN, NVDA, META, TSLA, BRK.B, JPM, JNJ

**ROTATING 10 (AI/Cloud Sector Focus):**
CRM, ADBE, NFLX, PYPL, AMD, ORCL, V, UNH, HD, COST

**BIG MOVERS 5 (Speculative Opportunities):**
PLTR, SNOW, SQ, SMCI, COIN

Provide:
- Cross-stock comparisons and sector analysis by tier
- Value screening (low P/E, P/B, high dividend yield) - emphasize Core 10
- Growth screening (revenue growth, earnings acceleration) - focus on Rotating 10
- Momentum screening for Big Movers 5 (price action, volume, volatility)
- Relative positioning and percentile rankings within each tier
- Sector leadership identification across all tiers
Format output for email section 5 of 6."

**AFTER COMPLETION: Capture the agent's complete output and store as SECTION_5_SCREENING**
```

### Step 6: Top 10 Trading Ideas Synthesis
```
Use the Task tool with subagent_type: "trading-idea-generator"

**CRITICAL: Pass the accumulated analysis data from Steps 1-5 to this agent.**

Prompt: "Synthesize the following analysis into the top 10 trading ideas:

===== MARKET PULSE ANALYSIS =====
{SECTION_1_MARKET_PULSE}

===== QUALITY ASSESSMENT =====
{SECTION_2_QUALITY}

===== SMART MONEY INTELLIGENCE =====
{SECTION_3_SMART_MONEY}

===== VOLATILITY ANALYSIS =====
{SECTION_4_VOLATILITY}

===== SCREENING RESULTS =====
{SECTION_5_SCREENING}

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
Format output for email section 6 of 6."

**AFTER COMPLETION: Capture the agent's complete output and store as SECTION_6_TRADING_IDEAS**
```

### Step 7: Format Professional HTML Email
```
Use the Task tool with subagent_type: "output-formatter"

**CRITICAL: Pass all 6 accumulated sections to this agent.**

Prompt: "Transform the following 6 analysis sections into a professional, institutional-grade HTML email for QuantHub.ai Daily Intelligence.

===== SECTION 1: MARKET PULSE =====
{SECTION_1_MARKET_PULSE}

===== SECTION 2: QUALITY DASHBOARD =====
{SECTION_2_QUALITY}

===== SECTION 3: SMART MONEY INTELLIGENCE =====
{SECTION_3_SMART_MONEY}

===== SECTION 4: VOLATILITY OPPORTUNITIES =====
{SECTION_4_VOLATILITY}

===== SECTION 5: VALUE & GROWTH SCREENING =====
{SECTION_5_SCREENING}

===== SECTION 6: TOP 10 TRADING IDEAS =====
{SECTION_6_TRADING_IDEAS}

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

Output the complete HTML email content ready for sending via Mailgun."

**AFTER COMPLETION: Capture the HTML output and store as FINAL_HTML_EMAIL**
```

### Step 8: Determine Email Recipients and Send
```
First, determine the email recipients:

1. If no argument provided ($1 is empty):
   - Use default CSV file: /Users/suneetn/fin-agent-with-claude/emails.csv
   - Read all email addresses from the CSV file

2. If argument contains "@" symbol:
   - Treat as single email address
   - Send to that address only

3. If argument ends with ".csv" or is a file path:
   - Read emails from the specified CSV file
   - Send to all addresses in that file

4. If argument is a valid file path (check if file exists):
   - Read emails from that CSV file
   - Send to all addresses

Then use mcp__fmp-weather-global__send_email_mailgun with:
- to_addresses: [List of email addresses determined above]
- subject: "QuantHub.ai Daily Intelligence - [Current Date]"
- content: {FINAL_HTML_EMAIL} (the HTML output captured from Step 7)
- is_html: true
- tags: ["daily-intelligence", "uber-email"]

For CSV files, assume first column contains email addresses (skip header row if present).
```

## Email Content Sections

The email should include the following sections in order:

1. **Market Pulse** - Market overview and current conditions
2. **Quality Dashboard** - Investment quality rankings and grades
3. **Smart Money Signals** - Institutional activity and insider intelligence
4. **Volatility Opportunities** - IV analysis and options strategies
5. **Value & Growth Opportunities** - Screening results and comparisons
6. **Top 10 Trading Ideas** - High-conviction ranked recommendations

The output-formatter agent will handle professional presentation and styling.

## Configuration

**Default CSV File**: `/Users/suneetn/fin-agent-with-claude/emails.csv` (contains: suneetn@gmail.com, suneetn@quanthub.ai, suneetn@icloud.com)

**Email Resolution Logic**:
- No argument: Read from default CSV file
- Contains "@": Single email address
- Ends with ".csv": Read from specified CSV file
- Valid file path: Read from that CSV file

**Subject Format**: `"QuantHub.ai Daily Intelligence - YYYY-MM-DD"`

**Target Watchlist (25 Stocks - Tiered Structure)**:

**CORE 10 (Durable Quality - Always Analyzed):**
- AAPL, MSFT, GOOGL, AMZN, NVDA (Mag 5)
- META, TSLA (Large Tech)
- BRK.B, JPM, JNJ (Quality Value/Dividend)

**ROTATING 10 (Current Theme: AI/Cloud Enterprise):**
- CRM, ADBE, NFLX, PYPL (Software/Platforms)
- AMD, ORCL (Enterprise Tech)
- V, UNH, HD, COST (Sector Leaders)

**BIG MOVERS 5 (High Volatility Momentum):**
- PLTR, SNOW, SQ (Growth/Turnaround)
- SMCI, COIN (Emerging/Crypto)

**Analysis Flow**: Market Context → Quality Foundation → Smart Money → Volatility → Screening → Trading Ideas → Professional Formatting → Email Delivery

## Success Confirmation

Upon successful completion:
```
✅ Section 1: Market Pulse Analysis Generated
✅ Section 2: Quality Dashboard Generated
✅ Section 3: Smart Money Intelligence Generated
✅ Section 4: Volatility Opportunities Generated
✅ Section 5: Value & Growth Screening Generated
✅ Section 6: Top 10 Trading Ideas Generated
✅ Section 7: Professional HTML Email Formatted (institutional-grade, mobile-optimized)
✅ Section 8: Email Sent to: [email_address]
📧 Subject: QuantHub.ai Daily Intelligence - [date]
🎯 Total Analysis Time: ~70 minutes
📊 Stocks Analyzed: 25 watchlist names (10 Core + 10 Rotating + 5 Big Movers)
💡 Trading Ideas: Maximum 10 ranked opportunities
📱 Email Format: Mobile-optimized HTML with executive dashboard
```

## Requirements

- All 7 specialized agents available: market-pulse-analyzer, quality-assessor, smart-money-interpreter, volatility-analyzer, comparative-stock-analyzer, trading-idea-generator, output-formatter
- FMP MCP Server running with all financial data tools
- Mailgun email service configured in MCP server
- All required API keys: FMP_API_KEY, MARKETDATA_API_KEY, FRED_API_KEY, PERPLEXITY_API_KEY, MAILGUN_API_KEY

## Agent Execution Strategy (Sequential Data-Passing Architecture)

**CRITICAL: Execute all steps SEQUENTIALLY to capture and pass data between agents.**

**Phase 1: Data Collection (40-45 minutes)**:
1. market-pulse-analyzer → Capture output as SECTION_1_MARKET_PULSE
2. quality-assessor → Capture output as SECTION_2_QUALITY
3. smart-money-interpreter → Capture output as SECTION_3_SMART_MONEY
4. volatility-analyzer → Capture output as SECTION_4_VOLATILITY
5. comparative-stock-analyzer → Capture output as SECTION_5_SCREENING

**Phase 2: Synthesis (10-15 minutes)**:
6. trading-idea-generator → Pass SECTIONS 1-5 as input → Capture output as SECTION_6_TRADING_IDEAS

**Phase 3: Formatting (10-15 minutes)**:
7. output-formatter → Pass SECTIONS 1-6 as input → Capture output as FINAL_HTML_EMAIL

**Phase 4: Delivery (1-2 minutes)**:
8. Email sending → Use FINAL_HTML_EMAIL content

**Total Target Time**: 60-75 minutes
**Success Metrics**: >60% trading idea win rate, <8 pages total length, >4.5/5 user satisfaction

**Why Sequential?**
- Each downstream agent needs complete data from upstream agents
- trading-idea-generator requires quality grades, smart money signals, volatility data, and screening results to calculate composite scores
- output-formatter requires all 6 sections to generate the complete HTML email
- This architecture ensures true synthesis rather than independent re-analysis