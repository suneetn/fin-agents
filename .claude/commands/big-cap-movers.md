---
syntax: /big-cap-movers [type] [email] [min_market_cap_billions]
description: Find top 10 big cap movers (>$100B market cap) with recent news and email formatted results
argument-hint: "type? (all|gainers|losers|actives) email? (recipient@example.com) min_cap_billions? (100)"
model: haiku
allowed-tools:
  - mcp__fmp-weather-global__get_market_movers
  - mcp__fmp-weather-global__get_company_profile
  - mcp__fmp-weather-global__get_stock_news
  - mcp__fmp-weather-global__analyze_stock_sentiment
  - mcp__zapier__gmail_send_email
---

# Big Cap Market Movers Analysis

I'll analyze the biggest market cap movers and email you a comprehensive formatted report with recent news and sentiment analysis.

## Configuration

- **Mover Type**: ${1:-all} (all|gainers|losers|actives)
- **Market Cap Filter**: ≥ $${3:-100} billion
- **Email Recipient**: ${2:-suneetn@quanthub.ai}
- **News Articles**: 5 most recent per stock
- **Results**: Top 10 stocks per category (deduplicated)

## Analysis Workflow

### Step 1: Collect Market Movers Data

**If type is "all" (default)**:
- Call `mcp__fmp-weather-global__get_market_movers` with `change_type='gainers'`
- Call `mcp__fmp-weather-global__get_market_movers` with `change_type='losers'`
- Call `mcp__fmp-weather-global__get_market_movers` with `change_type='actives'`

**If type is specific (gainers/losers/actives)**:
- Call `mcp__fmp-weather-global__get_market_movers` with `change_type='${1}'`

### Step 2: Filter for Big Caps

For each mover:
1. Call `mcp__fmp-weather-global__get_company_profile` to get market cap
2. Filter for market cap ≥ $${3:-100} billion
3. Take top 10 from each category (gainers, losers, actives)
4. **Deduplicate**: If a stock appears in multiple categories, merge into single entry with combined tags
   - Example: "AAPL" in both gainers and most active → Tag as "Gainer + Most Active"
   - Use categories: 🟢 Gainer, 🔴 Loser, 📊 Most Active

### Step 3: Enrich with News & Sentiment

For each unique stock symbol (after deduplication):
1. Call `mcp__fmp-weather-global__get_stock_news` with `tickers=SYMBOL` and `limit=5`
2. Call `mcp__fmp-weather-global__analyze_stock_sentiment` to get sentiment score (0-100)

**Error Handling**:
- If news API fails: Continue without news articles, note "News unavailable"
- If sentiment API fails: Continue without sentiment score, note "Sentiment unavailable"
- If < 10 stocks qualify in a category: Include all available stocks
- If no stocks qualify: Send email notification explaining no big-cap movers found

### Step 4: Format HTML Email

Create professional HTML email with:

**Email Structure**:
- **Subject**: "Big Cap Market Movers - ${1:-All Categories} (${3:-100}B+) - [DATE]"
- **Header Section**:
  - Total stocks analyzed
  - Market cap threshold
  - Timestamp

**For each stock (deduplicated)**:
- Company name and symbol
- **Category tags**: 🟢 Gainer / 🔴 Loser / 📊 Most Active (combined if multiple)
- Market cap (formatted: $XXX.XXB)
- Price change: $X.XX (+/- X.XX%)
- **Sentiment Score**: Color-coded
  - 🟢 Green: > 70 (Bullish)
  - 🟡 Yellow: 30-70 (Neutral)
  - 🔴 Red: < 30 (Bearish)
- **Recent News** (5 articles):
  - Clickable headline links (use both `title` and `url` fields)
  - Publication date
  - Source

**Email Sections** (if type = "all"):
1. **Summary Table**: All stocks with key metrics
2. **Top Gainers Section** (🟢): Detailed view
3. **Top Losers Section** (🔴): Detailed view
4. **Most Active Section** (📊): Detailed view
5. **Footer**: Disclaimer and timestamp

### Step 5: Send Email

Call `mcp__zapier__gmail_send_email`:
- **to**: ${2:-suneetn@quanthub.ai}
- **subject**: "Big Cap Market Movers - ${1:-All Categories} (${3:-100}B+) - [DATE]"
- **body**: HTML formatted content
- **body_type**: "html"

**Fallback**: If email sending fails, output formatted results to terminal

## Usage Examples

```bash
# Default: All movers, default email, $100B threshold (CRON USES THIS)
/big-cap-movers

# Only gainers to default email
/big-cap-movers gainers

# Only losers to custom email
/big-cap-movers losers user@example.com

# Most active stocks with $200B threshold to custom email
/big-cap-movers actives user@example.com 200

# All movers with custom email and $150B threshold
/big-cap-movers all user@example.com 150
```

## Required Dependencies

**MCP Server**: FMP MCP server must be running
- Location: `/Users/suneetn/agent-with-claude/fmp-mcp-server/`
- Start: `cd ../agent-with-claude/fmp-mcp-server && python3 fastmcp_server.py`

**API Keys** (configured in MCP server):
- `FMP_API_KEY`: Financial Modeling Prep (market data, profiles, news)
- `PERPLEXITY_API_KEY`: Perplexity AI (sentiment analysis)
- `ZAPIER_API_KEY`: Zapier (Gmail integration)

**Cron Schedule** (from `config/crontab-schedule.txt`):
- 9:30 AM PST (Monday-Friday): Market open analysis
- 4:00 PM PST (Monday-Friday): Market close analysis

## Expected Output

**Email Preview**:
```
Subject: Big Cap Market Movers - All Categories ($100B+) - Nov 2, 2025

═══════════════════════════════════════════════════════
📊 BIG CAP MARKET MOVERS ANALYSIS
═══════════════════════════════════════════════════════

Market Cap Threshold: ≥ $100 billion
Analysis Date: November 2, 2025, 9:30 AM PST
Total Stocks Analyzed: 24 (deduplicated)

─────────────────────────────────────────────────────────
🟢 TOP GAINERS ($100B+)
─────────────────────────────────────────────────────────

1. NVDA - NVIDIA Corporation
   Categories: 🟢 Gainer + 📊 Most Active
   Market Cap: $1,234.5B
   Price: $456.78 (+$23.45, +5.41%)
   Sentiment: 🟢 82/100 (Bullish)

   Recent News:
   • [NVIDIA Announces AI Chip Breakthrough](https://...)
   • [Data Centers Drive Q4 Revenue Beat](https://...)
   ...

[Additional stocks follow same format]
```

## Validation

The command validates inputs before execution:
- **type**: Must be one of: all, gainers, losers, actives
- **email**: Must be valid email format (validated by Zapier)
- **min_market_cap_billions**: Must be positive number

Invalid inputs will show error message and usage examples.

---

Let me start the analysis with your configuration:
- Type: **${1:-all}**
- Email: **${2:-suneetn@quanthub.ai}**
- Min Market Cap: **$${3:-100}B**
