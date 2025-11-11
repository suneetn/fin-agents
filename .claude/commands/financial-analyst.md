---
description: Master orchestrator for comprehensive stock analysis using specialist agents
argument-hint: SYMBOL
allowed-tools: ["Task", "mcp__fmp-weather-global__*"]
---

# Financial Analyst Orchestrator

Perform comprehensive financial analysis by orchestrating specialist agents for fundamental, volatility, and sentiment analysis, then synthesize results into unified investment recommendations.

## Usage
```bash
/financial-analyst AAPL
/financial-analyst NVDA
/financial-analyst $1
```

## Orchestration Strategy

This command coordinates four specialist agents to provide comprehensive investment research:

1. **Fundamental Analysis**: Launch `fundamental-stock-analyzer` agent
   - Investment grade (A+, B, C-)
   - Earnings timing and cache strategy
   - Financial health assessment

2. **Technical Analysis**: Launch `technical-stock-analyzer` agent
   - Chart patterns and trend analysis
   - Support/resistance levels
   - Technical indicators (RSI, MACD, Moving Averages)
   - Entry/exit points

3. **Volatility Analysis**: Launch `volatility-analyzer` agent
   - IV rank and volatility signals
   - Volatility-based trading recommendations
   - Real implied volatility data

4. **Sentiment Analysis**: Launch `stock-sentiment-analyzer` agent
   - AI sentiment score using Perplexity
   - News impact assessment
   - Market perception analysis

## Workflow

### Phase 1: Parallel Specialist Analysis
Launch all four specialist agents simultaneously using multiple Task calls:

```
Task 1: fundamental-stock-analyzer for $ARGUMENTS
Task 2: technical-stock-analyzer for $ARGUMENTS
Task 3: volatility-analyzer for $ARGUMENTS
Task 4: stock-sentiment-analyzer for $ARGUMENTS
```

### Phase 2: Market Context (Direct MCP Calls)
Gather current market data:
- Current stock price and volume
- Company profile and sector info
- Sector performance context

### Phase 3: Synthesis & Integration
Apply composite rating methodology:

**Rating Scale:**
- 🟢 **STRONG BUY**: All specialists positive with high conviction
- 🟢 **BUY**: Majority positive signals with manageable risks
- 🟡 **HOLD**: Mixed signals or awaiting better entry/catalyst
- 🔴 **SELL**: Majority negative signals or excessive risk
- 🔴 **STRONG SELL**: All specialists negative with significant downside

**Composite Logic:**
1. Base rating from fundamental grade (A+/A → BUY, A-/B+ → HOLD, etc.)
2. Technical adjustment (bullish trend + support holding → upgrade, bearish breakdown → downgrade)
3. Volatility adjustment (STRONG BUY volatility → upgrade rating)
4. Sentiment adjustment (positive >+0.3 → support upside)
5. Earnings proximity override (within 7 days → reduce position size)

**Convergent/Divergent Analysis:**
- Identify where all four analyses agree (high confidence signals)
- Identify where analyses conflict (risk areas requiring caution)
- Weight consensus signals more heavily in final rating

### Phase 4: Investment Decision & Storage
- Generate actionable investment thesis
- Calculate risk-adjusted position sizing
- Store complete synthesized analysis using `mcp__fmp-weather-global__store_unified_analysis`
  - Agent type: "comprehensive_synthesis"
  - Include all four specialist results + composite rating
  - Store convergent/divergent findings
  - Store position sizing and entry/exit recommendations

## Position Sizing Guidelines
- **STRONG BUY**: 5-8% allocation (reduced if high volatility)
- **BUY**: 3-5% allocation
- **HOLD**: 1-3% allocation or maintain current
- **SELL**: <1% allocation or exit

## Output Format
```
## $SYMBOL - Company Name
**Rating: [🟢/🟡/🔴] [RATING]**
**Price: $X.XX** | **Target: $X.XX** | **Upside: +X%**

### Investment Thesis
[2-3 sentence summary of key investment rationale]

### Specialist Analysis Summary
- **Fundamental**: [Grade] - [Key metrics, earnings date]
- **Technical**: [Trend] - [Support/resistance, indicators, pattern]
- **Volatility**: [Signal] - [IV rank, volatility regime]
- **Sentiment**: [Score] - [News impact, market perception]

### Convergent Analysis (High Confidence)
- [Where all 4 analyses agree - these are the strongest signals]
- [Example: "All analyses point to near-term weakness to $X support"]

### Divergent Analysis (Caution Areas)
- [Where analyses conflict - areas of uncertainty]
- [Example: "Fundamentals weak but sentiment improving"]

### Key Metrics
- P/E: X.X (Sector: X.X)
- ROE: X.X%
- Revenue Growth: X.X%
- Technical Trend: [Bullish/Bearish/Neutral]
- Support/Resistance: $X.XX / $X.XX
- IV Rank: X% ([SIGNAL])
- Sentiment Score: +X.X ([STRENGTH])

### Catalysts & Risks
**Positive:** [Key upside drivers from all analyses]
**Risks:** [Key downside risks from all analyses]

### Position Sizing & Entry Strategy
**Allocation:** X% of portfolio (based on composite risk level)
**Entry Zone:** $X.XX - $X.XX (from technical analysis)
**Stop Loss:** $X.XX
**Target:** $X.XX
**Risk/Reward:** 1:X.X

### ✅ Analysis Storage
Complete synthesis stored in unified analytics database for portfolio-level analysis.
```

## Risk Management
- Factor in earnings proximity (reduce size within 7 days)
- Consider volatility level for position sizing
- Weight sentiment strength in final recommendation
- Identify convergent signals (all agree) vs divergent signals (conflicts)
- Store all results for portfolio-level analysis

## CRITICAL: Analysis Storage Requirement

**ALWAYS** store the final synthesized analysis using:
```
mcp__fmp-weather-global__store_unified_analysis(
  symbol=SYMBOL,
  agent_type="comprehensive_synthesis",
  analysis_data={
    "composite_rating": "[STRONG BUY/BUY/HOLD/SELL/STRONG SELL]",
    "specialist_results": {
      "fundamental": {...},
      "technical": {...},
      "volatility": {...},
      "sentiment": {...}
    },
    "convergent_signals": [...],
    "divergent_signals": [...],
    "position_sizing": {...},
    "entry_exit_levels": {...},
    "risk_reward_ratio": X.X
  }
)
```

This enables:
- Portfolio-level comparative analysis
- Historical tracking of recommendations
- Performance attribution by analysis dimension
- Multi-stock screening and ranking