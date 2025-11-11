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

### Step 1: Market Pulse Analysis
```
Use the Task tool with subagent_type: "market-pulse-analyzer"
Prompt: "Generate today's comprehensive market pulse analysis including:
- Market overview (SPY, VIX, sector performance)
- News catalyst analysis and scoring
- Volatility regime assessment
- Risk management guidance
Format output for email section 1 of 6."
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
```

### Step 6: Top 10 Trading Ideas Synthesis
```
Use the Task tool with subagent_type: "trading-idea-generator"
Prompt: "Synthesize the analysis from market pulse, quality assessment, smart money intelligence, volatility analysis, and comparative screening into the top 10 trading ideas.

Requirements:
- Maximum 10 high-conviction ideas with precise entry/exit levels
- Categories: Quality at discount, growth at reasonable price, momentum plays, put selling setups
- Entry/exit zones with stop-losses
- Position sizing and time horizons
- Risk/reward ratios (minimum 1.5:1)
- Scoring methodology (100 points): Quality 30%, Technical 25%, Volatility 20%, Smart Money 15%, Risk/Reward 10%

Use data from the previous 5 analysis sections to generate ranked trading recommendations.
Format output for email section 6 of 6."
```

### Step 7: Format Professional HTML Email
```
Use the Task tool with subagent_type: "output-formatter"
Prompt: "Transform the 6 analysis sections into a professional, mobile-optimized HTML email for QuantHub.ai Daily Intelligence.

Input Data:
- Section 1: Market Pulse Analysis (from market-pulse-analyzer)
- Section 2: Quality Dashboard (from quality-assessor)
- Section 3: Smart Money Intelligence (from smart-money-interpreter)
- Section 4: Volatility Opportunities (from volatility-analyzer)
- Section 5: Value & Growth Screening (from comparative-stock-analyzer)
- Section 6: Top 10 Trading Ideas (from trading-idea-generator)

Formatting Requirements:
- Create Executive Dashboard with 30-second overview at the top
- Mobile-first responsive HTML design
- Color-coded signals: 🔥 Strong Buy, 🟢 Buy, 🟡 Hold, 🔴 Sell
- Progress bars for scores and conviction levels
- Expandable/collapsible sections for detailed analysis
- QuantHub branding with professional gradient header
- Maximum 8 pages total length
- Touch-friendly design for mobile devices
- Ensure compatibility with Gmail, Outlook, Apple Mail

Content Prioritization (Tier 0-3 structure):
- **Tier 0**: Executive Dashboard (30 seconds) - market pulse, top 3 opportunities, risk level
- **Tier 1**: Top Trading Ideas (2 minutes) - all 10 ideas with entry/exit
- **Tier 2**: Quality Rankings (1 minute) - letter grades and key metrics
- **Tier 3**: Detailed Analysis (optional) - full sections in expandable format

Output the complete HTML email content ready for sending via Mailgun."
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
- subject: "🌅 QuantHub.ai Uber Daily Intelligence - [Current Date]"
- content: [Professional HTML email from output-formatter agent (Step 7)]
- is_html: true
- tags: ["daily-intelligence", "uber-email"]

For CSV files, assume first column contains email addresses (skip header row if present).
```

## Email Structure Template

```html
<h1>🌅 QuantHub.ai Daily Market Intelligence - [DATE]</h1>

<h2>📊 SECTION 1: MARKET PULSE</h2>
[Market pulse analyzer output]

<h2>💎 SECTION 2: QUALITY DASHBOARD</h2>
[Quality assessor output]

<h2>🧠 SECTION 3: SMART MONEY SIGNALS</h2>
[Smart money interpreter output]

<h2>⚡ SECTION 4: VOLATILITY OPPORTUNITIES</h2>
[Volatility analyzer output]

<h2>🔍 SECTION 5: VALUE & GROWTH OPPORTUNITIES</h2>
[Comparative stock analyzer output]

<h2>🎯 SECTION 6: TOP 10 TRADING IDEAS</h2>
[Trading idea generator output]

<hr>
<p><em>Generated by QuantHub.ai Financial Agent Ecosystem | Next Update: Tomorrow</em></p>
```

## Configuration

**Default CSV File**: `/Users/suneetn/fin-agent-with-claude/emails.csv` (contains: suneetn@gmail.com, suneetn@quanthub.ai, suneetn@icloud.com)

**Email Resolution Logic**:
- No argument: Read from default CSV file
- Contains "@": Single email address
- Ends with ".csv": Read from specified CSV file
- Valid file path: Read from that CSV file

**Subject Format**: `"🌅 QuantHub.ai Uber Daily Intelligence - YYYY-MM-DD"`

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
✅ Section 7: Professional HTML Email Formatted (mobile-optimized)
✅ Section 8: Email Sent to: [email_address]
📧 Subject: Uber Daily Intelligence - [date]
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

## Agent Execution Strategy (Phase 1 Enhanced)

**Phase 0: Executive Dashboard (5 minutes)**:
- market-pulse-analyzer (30-second overview creation)

**Parallel Processing Phase 1 (15-20 minutes)**:
- market-pulse-analyzer (detailed market context)
- quality-assessor (quality foundation)
- smart-money-interpreter (institutional signals)
- volatility-analyzer (options opportunities)

**Sequential Phase 2 (10 minutes)**:
- comparative-stock-analyzer (screening with quality context)

**Synthesis Phase 3 (10 minutes)**:
- trading-idea-generator (synthesize all analysis)

**Formatting Phase 4 (10 minutes)**:
- output-formatter (mobile-optimized HTML with UX enhancements)

**Total Target Time**: 70 minutes maximum
**Success Metrics**: >60% trading idea win rate, <8 pages total length, >4.5/5 user satisfaction