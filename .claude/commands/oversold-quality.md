---
description: Find oversold high-quality stocks with strong fundamentals for put-selling opportunities
argument-hint: [email] (optional)
allowed-tools:
  - Task
  - mcp__zapier__gmail_send_email
---

# Oversold Quality Stocks Scanner

Screen for high-quality stocks that have experienced recent sell-offs but maintain strong fundamentals, creating attractive put-selling opportunities with margin return calculations.

**WATCHLIST**: AAPL, MSFT, GOOGL, TSLA, NVDA, META, JPM, UNH, V, HD, AMZN, BRK.B, JNJ, PG, WMT, MA, XOM, CVX, ABBV, LLY

## Step 1: Fundamental Quality Screen
Using fundamental-stock-analyzer agent to identify:
- Strong ROE (>15%), reasonable P/E ratios
- Solid balance sheets (low debt/equity)
- Consistent earnings growth
- Investment grade ratings (A- or better)
- Dividend aristocrat candidates

## Step 2: Technical Oversold Analysis
Using technical-stock-analyzer agent to find:
- RSI below 35 (oversold conditions)
- Recent 10-20% decline from highs
- Strong support levels holding
- Volume confirmation on selling
- Bullish divergences forming

## Step 3: Margin Return Calculations
Calculate comprehensive return metrics:
- **Cash Return**: Premium / Strike Price
- **Margin Return**: Premium / (30% margin requirement)
- **Annualized Margin Return**: Monthly margin return × 12
- **Risk-Adjusted Margin Return**: Margin return / volatility
- **Return on Buying Power**: Premium / actual capital used

## Step 4: Volatility Assessment
Using volatility-analyzer agent for:
- Current IV vs Historical IV comparison
- IV rank percentiles for premium quality
- Post-selloff volatility expansion
- Mean reversion opportunities

## Step 5: Generate Report
Professional HTML report including:
- Executive summary of market conditions
- Top 5-8 oversold quality opportunities
- Detailed margin return analysis
- Risk assessment and position sizing
- Entry timing recommendations
- Quality scores and investment grades

## Step 6: Email Delivery
If email provided: $1
- Professional formatting with charts
- Risk disclaimers and margin warnings
- Actionable recommendations
- Quality fundamental breakdown

**Executing oversold quality stock analysis with margin returns...**

ARGUMENTS: $1