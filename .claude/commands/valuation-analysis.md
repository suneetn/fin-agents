---
syntax: /valuation-analysis <ticker> [peers]
description: Comprehensive multi-layered stock valuation analysis combining fundamental metrics, analyst targets, technical levels, and peer comparisons
---

I'll perform a comprehensive multi-layered valuation analysis for $1 combining fundamental metrics, analyst targets, technical levels, and peer comparisons.

Analysis workflow:

1. Fundamental Analysis - Financial health, valuation metrics, growth analysis
2. Market Consensus - Analyst price targets and recommendations  
3. Technical Valuation - Support/resistance levels and entry/exit points
4. Comparative Analysis - Peer comparison if peers provided ($2)

Let me start the analysis:

Use the Task tool to launch the fundamental-stock-analyzer agent:
- Perform comprehensive fundamental analysis on $1 including valuation metrics, financial health, and investment grade
- Get analyst consensus data using mcp__fmp-weather-global__get_analyst_consensus for $1
- Get price targets using mcp__fmp-weather-global__get_price_targets for $1
- Get technical indicators and support/resistance levels for $1
- If peers provided ($2), use comparative-stock-analyzer to compare $1 vs $2
- Synthesize all data into unified valuation recommendation with fair value estimate

## Analysis Framework

This command executes a 4-layer valuation analysis:

### 1. Fundamental Valuation (Intrinsic Value)
- **Financial Health**: ROE, ROA, debt ratios, cash position
- **Valuation Metrics**: P/E, P/B, P/S, EV/EBITDA ratios
- **Growth Analysis**: Revenue/earnings trends and sustainability
- **Investment Grade**: A-F risk assessment with classification
- **Earnings-Aware Caching**: Optimal data freshness based on earnings cycle

### 2. Market Consensus (Analyst Targets)
- **Price Targets**: Average, high, low analyst projections
- **Recommendation Distribution**: Buy/Hold/Sell rating breakdown
- **Earnings Estimates**: Forward EPS and revenue expectations
- **Revision Trends**: Recent estimate changes and momentum

### 3. Technical Valuation (Support/Resistance)
- **Key Levels**: Major support and resistance zones
- **Entry/Exit Points**: Optimal timing based on technical indicators
- **Momentum Analysis**: RSI, MACD for overbought/oversold conditions
- **Trend Analysis**: Moving averages and trend direction

### 4. Comparative Valuation (Peer Analysis)
- **Peer Comparison**: Valuation metrics vs sector/industry peers
- **Relative Value**: Premium/discount to comparable companies
- **Sector Analysis**: Industry-wide valuation trends
- **Investment Grade Distribution**: Risk assessment across peers

## Expected Output

### Executive Summary
- **Fair Value Estimate**: Consensus intrinsic value range
- **Current Valuation**: Overvalued/Undervalued/Fairly Valued
- **Investment Recommendation**: Buy/Hold/Sell with confidence level
- **Key Catalysts**: Upcoming events that could impact valuation

### Detailed Analysis
- **Fundamental Score**: A-F grade with financial health metrics
- **Technical Levels**: Key support/resistance with entry points
- **Analyst Consensus**: Price target range and recommendation summary
- **Peer Comparison**: Relative valuation vs industry standards

### Risk Assessment
- **Valuation Risks**: Key factors that could impact fair value
- **Technical Risks**: Support breakdown or resistance failure scenarios
- **Fundamental Risks**: Business model or financial health concerns
- **Market Risks**: Sector rotation or macro headwinds

## Implementation

```bash
# Step 1: Fundamental Analysis (Primary Valuation)
# Uses fundamental-stock-analyzer agent with earnings-aware caching
fundamental-stock-analyzer: "Perform comprehensive fundamental analysis on ${TICKER} including valuation metrics, financial health, and investment grade"

# Step 2: Analyst Consensus Data
mcp__fmp-weather-global__get_analyst_consensus: ticker=${TICKER}
mcp__fmp-weather-global__get_price_targets: ticker=${TICKER}
mcp__fmp-weather-global__get_earnings_estimates: ticker=${TICKER}

# Step 3: Technical Analysis
mcp__fmp-weather-global__get_support_resistance_levels: ticker=${TICKER}
mcp__fmp-weather-global__get_technical_indicators: ticker=${TICKER}, indicators=SMA,RSI,MACD

# Step 4: Comparative Analysis (if peers provided)
comparative-stock-analyzer: "Compare valuation metrics for ${TICKER} vs ${PEERS}, focusing on P/E, P/B, EV/EBITDA, and investment grades"

# Step 5: Synthesis and Recommendation
# Combine all data points into unified valuation recommendation
```

## Valuation Methodology

### Fair Value Calculation
1. **DCF Model**: Intrinsic value based on fundamentals
2. **Multiple Analysis**: P/E, P/B, EV/EBITDA vs historical/peer averages
3. **Analyst Consensus**: Weighted average of professional estimates
4. **Technical Confluence**: Support/resistance level validation

### Investment Decision Framework
- **Strong Buy**: >20% undervalued with strong fundamentals
- **Buy**: 10-20% undervalued with solid metrics
- **Hold**: ±10% fair value with mixed signals
- **Sell**: >10% overvalued with deteriorating fundamentals
- **Strong Sell**: >20% overvalued with multiple red flags

### Risk-Adjusted Scoring
- **Low Risk**: A/B grade stocks with strong balance sheets
- **Medium Risk**: C grade stocks with mixed fundamentals
- **High Risk**: D/F grade stocks or turnaround situations

## Success Metrics

### Analysis Completeness
- ✅ Fundamental health assessment completed
- ✅ Analyst consensus data retrieved
- ✅ Technical levels identified
- ✅ Peer comparison executed (if applicable)
- ✅ Fair value range established

### Decision Support
- Clear buy/hold/sell recommendation
- Specific entry/exit price levels
- Catalyst timeline and key dates
- Risk factors and mitigation strategies

## Notes

- **Data Freshness**: Uses earnings-aware caching for optimal data timing
- **Market Hours**: Technical analysis most relevant during trading hours
- **Earnings Impact**: Valuation may shift significantly around earnings dates
- **Sector Rotation**: Consider broader market trends and sector performance
- **Position Sizing**: Recommendations include suggested position sizing based on risk grade

## Related Commands

- `/fundamental-analysis` - Deep dive fundamental analysis only
- `/technical-analysis` - Technical analysis focus
- `/comparative-analysis` - Multi-stock comparison
- `/earnings-calendar` - Upcoming earnings that impact valuation
- `/volatility-analysis` - Options-based valuation insights