---
description: "DEVELOPMENT VERSION: Generate comprehensive daily market intelligence report WITHOUT sending emails - outputs to HTML file for testing and iteration"
allowed-tools:
  - Task
  - mcp__fmp-weather-global__*
  - TodoWrite
  - Write
argument-hint: "[output_filename]"
---

# Uber Daily Market Intelligence - DEVELOPMENT VERSION

**⚠️ DEVELOPMENT VERSION - NO EMAILS SENT ⚠️**

Generate comprehensive daily market intelligence report for testing and iteration. Outputs to HTML file instead of sending emails. Perfect for development, testing new features, and validating analysis before promoting to production.

## Usage Examples:
- `/uber_email_dev` - Output to default file (uber_intelligence_dev_YYYY-MM-DD.html)
- `/uber_email_dev my_test_report.html` - Output to specific filename
- `/uber_email_dev analysis_v2.html` - Test iterations with custom names

## Implementation

### Step 0: Executive Dashboard (NEW)
```
Use the Task tool with subagent_type: "market-pulse-analyzer"
Prompt: "Generate a concise executive dashboard for today's market intelligence email. This should be a 2-3 sentence market summary that appears at the top of the email for quick scanning.

Include:
- Key market metrics: SPY level, VIX reading, dominant sector
- Today's market theme/narrative in one sentence
- Market sentiment gauge (Bullish/Neutral/Bearish) with confidence level
- Risk-on or Risk-off environment indicator

Format as HTML with clear visual hierarchy:
- Use a highlighted summary box with key metrics
- Color-coded sentiment indicator (green/yellow/red)
- Bold key numbers and percentages
- Keep to maximum 3-4 lines for quick scanning

Output should be formatted for the top of the email, before Section 1."
```

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
- A+ to F grades for all 25 watchlist stocks with reasoning
- Quality score rankings (0-100) with tier designation
- Focus 60% analysis time on Core 10, 30% on Rotating 10, 10% on Big Movers 5
- Fair value estimates vs current prices with upside percentage
- Key strengths and concerns by tier
- Buy/Hold/Sell recommendations
- Present data in structured format (can be markdown table or clear list format)
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
- For each idea provide: Symbol, Category, Entry range, Target, Stop loss, Position size, Time horizon, Risk/reward ratio
- Scoring methodology (100 points): Quality 30%, Technical 25%, Volatility 20%, Smart Money 15%, Risk/Reward 10%
- Include detailed rationale for each recommendation
- Rank by total score (highest first)
- Risk/reward ratios (minimum 1.5:1)

Use data from the previous 5 analysis sections to generate ranked trading recommendations.
Present in structured format (markdown table or clear numbered list).
Format output for email section 6 of 6."
```

### Step 7: Professional HTML Formatting
```
Use the Task tool with subagent_type: "output-formatter"
Prompt: "Format the comprehensive market intelligence analysis into a professional HTML email using the provided analysis sections and styling template.

**Input Data:**
- Executive Dashboard (from Step 0)
- Market Pulse Analysis (from Step 1)
- Quality Assessment Dashboard (from Step 2)
- Smart Money Intelligence (from Step 3)
- Volatility Opportunities (from Step 4)
- Value & Growth Screening (from Step 5)
- Top 10 Trading Ideas (from Step 6)

**HTML Template Requirements:**
Use the complete CSS styling template with professional QuantHub.ai branding including:
- Executive dashboard with market metrics styling (.executive-dashboard class)
- Professional table formatting for stock quality data with grade color coding
- Trading ideas in card-based grid layout (.trading-ideas-grid)
- Sentiment indicators with color coding (bullish/neutral/bearish)
- Mobile responsive design and print-friendly styling
- Development banner indicating no emails sent

**Specific Formatting Instructions:**
1. Convert quality assessment data into styled HTML table with grade color classes (grade-a-plus, grade-a, etc.)
2. Format trading ideas as cards in grid layout with risk/reward color coding
3. Style executive dashboard with market metrics boxes
4. Ensure all data is preserved while applying professional presentation
5. Add proper spacing, typography, and visual hierarchy
6. Include hover effects and modern styling elements

Output the complete HTML document ready for file writing."
```

### Step 8: Generate HTML Report File (NO EMAIL SENDING)
```
DEVELOPMENT MODE: Generate HTML file instead of sending emails

1. Determine output filename:
   - If no argument provided ($1 is empty): Use "uber_intelligence_dev_YYYY-MM-DD.html"
   - If argument provided: Use that filename (add .html if not present)

2. Take the formatted HTML output from Step 7 (output-formatter agent)

3. Use Write tool to save the HTML file:
   - file_path: /Users/suneetn/fin-agent-with-claude/[filename]
   - content: [Complete styled HTML document from output-formatter]

4. Display success message with:
   - File location and size
   - Analysis summary
   - Instructions for viewing (open in browser)
   - Note that NO EMAILS were sent (dev mode)

HTML Structure:
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>QuantHub.ai Daily Intelligence - DEV MODE</title>
    <style>
        /* QuantHub.ai Professional Email Styling */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #ffffff;
            color: #333333;
            line-height: 1.6;
        }

        /* Development Banner */
        .dev-banner {
            background: linear-gradient(135deg, #ff6b35, #f7931e);
            color: white;
            padding: 15px;
            text-align: center;
            font-weight: bold;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        /* Header Styling */
        h1 {
            color: #2c3e50;
            border-bottom: 3px solid #3498db;
            padding-bottom: 15px;
            font-size: 2.2em;
            margin-bottom: 30px;
            text-align: center;
        }

        h2 {
            color: #34495e;
            border-left: 4px solid #3498db;
            padding-left: 15px;
            padding-bottom: 8px;
            font-size: 1.4em;
            margin-top: 40px;
            margin-bottom: 20px;
            background: linear-gradient(90deg, #f8f9fa 0%, #ffffff 100%);
            padding: 15px;
            border-radius: 0 8px 8px 0;
        }

        /* Executive Dashboard Styling */
        .executive-dashboard {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-left: 6px solid #007bff;
            padding: 25px;
            margin: 30px 0;
            border-radius: 0 12px 12px 0;
            box-shadow: 0 4px 12px rgba(0,123,255,0.1);
        }

        .executive-dashboard h2 {
            margin-top: 0;
            color: #007bff;
            border: none;
            background: none;
            padding: 0;
            font-size: 1.6em;
        }

        /* Market Metrics Styling */
        .market-metrics {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            margin: 20px 0;
            padding: 15px;
            background: #ffffff;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }

        .metric-item {
            text-align: center;
            padding: 10px;
            margin: 5px;
            background: #f8f9fa;
            border-radius: 6px;
            min-width: 120px;
        }

        .metric-value {
            font-size: 1.3em;
            font-weight: bold;
            color: #2c3e50;
        }

        .metric-label {
            font-size: 0.9em;
            color: #6c757d;
            margin-top: 5px;
        }

        /* Sentiment Indicators */
        .sentiment-bullish { color: #28a745; font-weight: bold; }
        .sentiment-neutral { color: #ffc107; font-weight: bold; }
        .sentiment-bearish { color: #dc3545; font-weight: bold; }

        /* Tables */
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
            background: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        th {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        td {
            border-bottom: 1px solid #dee2e6;
            padding: 12px;
            text-align: left;
            transition: background-color 0.2s ease;
        }

        tr:hover td {
            background-color: #f8f9fa;
        }

        /* Grade Color Coding */
        .grade-a-plus { background-color: #d4edda; color: #155724; font-weight: bold; }
        .grade-a { background-color: #d1ecf1; color: #0c5460; font-weight: bold; }
        .grade-b { background-color: #fff3cd; color: #856404; font-weight: bold; }
        .grade-c { background-color: #f8d7da; color: #721c24; font-weight: bold; }
        .grade-d { background-color: #f5c6cb; color: #721c24; font-weight: bold; }
        .grade-f { background-color: #f8d7da; color: #721c24; font-weight: bold; }

        /* Risk/Reward Color Coding */
        .risk-low { color: #28a745; font-weight: bold; }
        .risk-medium { color: #ffc107; font-weight: bold; }
        .risk-high { color: #dc3545; font-weight: bold; }

        /* Trading Ideas Grid */
        .trading-ideas-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }

        .trading-idea-card {
            background: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .trading-idea-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.15);
        }

        /* Footer */
        .footer {
            text-align: center;
            color: #6c757d;
            margin-top: 50px;
            padding: 30px 0;
            border-top: 2px solid #e9ecef;
            font-style: italic;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            body { padding: 10px; }
            h1 { font-size: 1.8em; }
            h2 { font-size: 1.2em; }
            .market-metrics { flex-direction: column; }
            .trading-ideas-grid { grid-template-columns: 1fr; }
            table { font-size: 0.9em; }
            th, td { padding: 8px; }
        }

        /* Print Styles */
        @media print {
            .dev-banner { display: none; }
            body { max-width: none; margin: 0; padding: 0; }
            .trading-idea-card { break-inside: avoid; }
        }
    </style>
</head>
<body>
    <div class="dev-banner">🚧 DEVELOPMENT MODE - NO EMAILS SENT 🚧</div>
    [All 6 sections content here]
    <hr>
    <p style="text-align: center; color: #666; margin-top: 30px;">
        <em>Generated by QuantHub.ai Development System | $(date) | File: [filename]</em>
    </p>
</body>
</html>
```
```

## Email Structure Template

```html
<h1>🌅 QuantHub.ai Daily Market Intelligence - [DATE]</h1>

<div class="executive-dashboard">
<h2>📈 EXECUTIVE DASHBOARD</h2>
[Executive dashboard output from Step 0]
</div>

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

<div class="footer">
<p><em>Generated by QuantHub.ai Financial Agent Ecosystem | Next Update: Tomorrow</em></p>
</div>
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

**Analysis Flow**: Market Context → Quality Foundation → Smart Money → Volatility → Screening → Trading Ideas

## Success Confirmation

Upon successful completion:
```
✅ Section 1: Market Pulse Analysis Generated
✅ Section 2: Quality Dashboard Generated
✅ Section 3: Smart Money Intelligence Generated
✅ Section 4: Volatility Opportunities Generated
✅ Section 5: Value & Growth Screening Generated
✅ Section 6: Top 10 Trading Ideas Generated
📄 HTML Report Saved: /Users/suneetn/fin-agent-with-claude/[filename]
🚧 DEVELOPMENT MODE: NO EMAILS SENT
📊 File Size: [X] KB
🎯 Total Analysis Time: ~60 minutes
📊 Stocks Analyzed: 25 watchlist names (10 Core + 10 Rotating + 5 Big Movers)
💡 Trading Ideas: Maximum 10 ranked opportunities
🌐 View Report: open [filepath] (opens in default browser)
```

## Requirements

- All 6 specialized agents available: market-pulse-analyzer, quality-assessor, smart-money-interpreter, volatility-analyzer, comparative-stock-analyzer, trading-idea-generator
- FMP MCP Server running with all financial data tools
- Mailgun email service configured in MCP server
- All required API keys: FMP_API_KEY, MARKETDATA_API_KEY, FRED_API_KEY, PERPLEXITY_API_KEY, MAILGUN_API_KEY

## Agent Execution Strategy

**Parallel Processing Phase 1 (15-20 minutes)**:
- market-pulse-analyzer (market context)
- quality-assessor (quality foundation)
- smart-money-interpreter (institutional signals)
- volatility-analyzer (options opportunities)

**Sequential Phase 2 (10 minutes)**:
- comparative-stock-analyzer (screening with quality context)

**Synthesis Phase 3 (10 minutes)**:
- trading-idea-generator (synthesize all analysis)

**Total Target Time**: 60 minutes maximum
**Success Metric**: >60% trading idea win rate with <2% max loss per idea