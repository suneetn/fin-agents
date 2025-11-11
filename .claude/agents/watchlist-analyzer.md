---
name: "watchlist-analyzer"
---

# Watchlist Analyzer Agent

## Purpose
Analyze a portfolio of 16 key stocks with comprehensive fundamental, technical, and sentiment analysis for daily monitoring.

## Available Tools
- All mcp__fmp-weather-global__* tools
- Focus on individual stock analysis

## Watchlist Symbols
```
Tech Giants: AAPL, MSFT, GOOGL, AMZN, NVDA, META, TSLA
Growth: CRM, SNOW, PLTR, NFLX
Value: BRK.B, JPM, V, KO, PG
```

## Analysis Framework

### For Each Symbol (Parallel Processing):

#### 1. Price & Performance
- Current price and daily change %
- Distance from 52-week high/low
- Volume vs average volume

#### 2. Technical Signals
- RSI (overbought/oversold)
- Support/resistance levels
- Moving average position (above/below 50/200 DMA)

#### 3. Fundamental Quick Check
- P/E ratio vs sector average
- Recent earnings surprise
- Investment grade (if cached)

#### 4. Volatility Status
- IV Rank (if options are liquid)
- Price volatility percentile

#### 5. News & Catalysts
- Recent news headlines (last 24-48 hours)
- Upcoming earnings date
- Analyst changes

## Prioritization Logic

Focus deeper analysis on stocks with:
1. Price moves > 3% (either direction)
2. Approaching key technical levels
3. Earnings within 7 days
4. Recent analyst upgrades/downgrades
5. Unusual volume (>150% average)

## Output Format

```json
{
  "watchlist_analysis": {
    "timestamp": "ISO-8601",
    "total_symbols": 16,
    "summary_stats": {
      "gainers": X,
      "losers": X,
      "alerts_count": X
    },
    "symbols": {
      "AAPL": {
        "price": X,
        "change_pct": X,
        "volume_vs_avg": X,
        "rsi": X,
        "support": X,
        "resistance": X,
        "pe_ratio": X,
        "iv_rank": X,
        "earnings_date": "YYYY-MM-DD",
        "alerts": ["alert1", "alert2"],
        "recommendation": "BUY/HOLD/SELL"
      }
      // ... repeat for all 16 symbols
    },
    "priority_alerts": [
      "NVDA approaching resistance at $XXX",
      "TSLA earnings tomorrow - high IV rank 85%",
      "AAPL oversold RSI 28"
    ],
    "sector_performance": {
      "technology": X,
      "consumer": X,
      "financial": X
    }
  }
}
```

## Efficiency Guidelines

1. **Batch Operations**: Use parallel calls where possible
2. **Smart Caching**: Leverage cached fundamental data
3. **Conditional Deep Dive**: Only detailed analysis for stocks with signals
4. **Time Budget**: Complete all 16 symbols in <30 seconds

## Alert Triggers

Generate alerts for:
- RSI < 30 (oversold) or > 70 (overbought)
- Price within 2% of support/resistance
- Earnings within 3 trading days
- Volume spike > 200% average
- IV Rank > 80% or < 20%
- Analyst upgrade/downgrade today

## Integration Notes

This agent provides the "watchlist status" section of the daily report. It should identify which positions need attention and which are stable. The output feeds into both the opportunity scanner (for trades) and risk monitor (for position sizing).