---
syntax: /csp-scanner [symbols]
description: Scan for cash-secured put opportunities with IV rank analysis and trade recommendations
---

I'll scan for optimal cash-secured put opportunities, analyzing IV rank and providing specific trade setups.

## Analysis Workflow:

1. **Get Market Data & IV Analysis**
   - If symbols provided: analyze those specific stocks
   - If no symbols: use mcp__fmp-weather-global__get_market_movers to get top 20 losers + always include Mag 7 (AAPL, MSFT, GOOGL, AMZN, NVDA, TSLA, META)
   - Get current stock prices using mcp__fmp-weather-global__get_stock_price
   - Get company profiles using mcp__fmp-weather-global__get_company_profile
   - Get IV and HV comparison using mcp__fmp-weather-global__compare_iv_hv (use_real_iv=true)
   - Calculate IV rank using mcp__fmp-weather-global__get_iv_rank (use_real_iv=true)

2. **Filter Candidates** (must meet ALL criteria):
   - IV Rank > 30% (elevated volatility for premium)
   - Market cap > $100B (mega-cap quality filter) - NOTE: Mag 7 stocks always included regardless of filters
   - Stock price > $20 (avoid penny stocks)
   - Recent weakness or consolidation (prefer stocks down from highs for better entry points)

3. **Technical Analysis**
   - Get support/resistance levels using mcp__fmp-weather-global__get_support_resistance_levels(symbol)
   - Calculate technical indicators using mcp__fmp-weather-global__get_technical_indicators(symbol, indicators=["RSI", "SMA"], sma_periods=[50])
   - Identify key support levels for strike selection below nearest support

4. **Trade Setup Recommendations**
   - Target Delta: 20-30 (0.20-0.30)
   - DTE: 30-45 days
   - Strike Selection: Below nearest support level
   - Calculate premium estimates based on IV
   - Position sizing: Based on $100K portfolio (adjustable)

5. **Risk/Reward Analysis**
   - Calculate Return on Capital (ROC)
   - Annualized return potential
   - Break-even price
   - Probability of profit
   - Max loss scenario

6. **Output Format**:
```
🎯 CASH-SECURED PUT OPPORTUNITIES
═══════════════════════════════

Stock: [SYMBOL]
Current Price: $[PRICE]
IV Rank: [IV_RANK]% 📊 [HIGH/MODERATE/LOW]
Current IV: [CURRENT_IV]% | Historical IV: [HV]%
IV Premium: [IV_PREMIUM]% (IV vs HV difference)
Support Level: $[SUPPORT]

📝 TRADE SETUP:
Strike: $[STRIKE] (20-30 delta)
Expiration: [DATE] ([DTE] days)
Premium: $[EST_PREMIUM]
Cash Required: $[CASH_NEEDED]

💰 RETURNS:
ROC: [ROC]% ([DTE] days)
Annualized: [ANNUAL]%
Break-even: $[BREAKEVEN]
Probability of Profit: [POP]%

📊 TECHNICALS:
RSI: [RSI] [OVERSOLD/NEUTRAL/OVERBOUGHT]
50-SMA: $[SMA50]
Position vs Support: [X]% above
```

Let me scan for opportunities:

Use the Task tool to launch the options-scanner agent with these instructions:
- Get symbols list: either parse $ARGUMENTS for comma-separated symbols OR use mcp__fmp-weather-global__get_market_movers(change_type="losers") to get top 20 losers + ALWAYS include Mag 7 stocks (AAPL, MSFT, GOOGL, AMZN, NVDA, TSLA, META)
- For each symbol:
  - Use mcp__fmp-weather-global__get_company_profile to get market cap and basic info
  - Use mcp__fmp-weather-global__get_stock_price to get current price
  - Use mcp__fmp-weather-global__compare_iv_hv(symbol, use_real_iv=true) to get IV vs HV comparison
  - Use mcp__fmp-weather-global__get_iv_rank(symbol, use_real_iv=true) to calculate IV rank
  - Use mcp__fmp-weather-global__get_technical_indicators(symbol, indicators=["RSI", "SMA"], sma_periods=[50]) for RSI and 50-SMA
  - Use mcp__fmp-weather-global__get_support_resistance_levels(symbol) for technical levels
- Filter candidates meeting ALL criteria:
  - IV Rank > 30%
  - Market cap > $100B (NOTE: Mag 7 stocks always included regardless of this filter)
  - Stock price > $20
  - Recent weakness or consolidation patterns (prefer stocks offering better entry points)
- For qualified candidates:
  - Display Current IV%, Historical IV%, and IV Rank% (from compare_iv_hv and get_iv_rank results)
  - Calculate IV Premium (Current IV - Historical IV)
  - Calculate optimal strike price (below nearest support, targeting 20-30 delta)
  - Estimate DTE at 30-45 days
  - Calculate estimated premium based on IV and time value
  - Compute ROC and annualized returns
  - Format output with emojis and clear sections showing all volatility metrics
- Prioritize by IV Rank (highest first)
- Limit to top 5 candidates
- Include risk warnings about earnings dates if within DTE window
- IMPORTANT: Always display Current IV%, Historical IV%, IV Rank%, and IV Premium for every stock analyzed