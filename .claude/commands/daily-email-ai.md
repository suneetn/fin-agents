---
description: Generate daily market intelligence email using AI orchestration (no Python)
argument-hint: "[email_address]"
allowed-tools: ["Task", "mcp__fmp-weather-global__*", "mcp__zapier__*", "Write", "Read"]
---

# AI-Orchestrated Daily Email Report

Generate comprehensive daily market intelligence using **pure AI orchestration** - no Python code, just intelligent agent coordination.

## Usage
```bash
/daily-email-ai                    # Generate report only
/daily-email-ai user@example.com   # Generate and email report
```

## Architecture: Pure AI Orchestration

This command demonstrates **AI-native orchestration** where Claude coordinates multiple specialist agents in parallel, synthesizes their outputs, and generates a professional report - all through reasoning, not code.

## Phase 1: Parallel Data Collection

Launch three specialized agents simultaneously to gather market intelligence:

### Agent 1: market-pulse-analyzer
**Agent Type**: `market-pulse-analyzer`
**Purpose**: Professional market condition analysis with validated data quality
**Task**: Execute comprehensive market pulse analysis using the market-pulse-analyzer agent's built-in framework

### Agent 2: fundamental-stock-analyzer
**Agent Type**: `fundamental-stock-analyzer`
**Purpose**: Deep dive into portfolio holdings
**Task**: Analyze these 16 symbols with fundamentals, technicals, and sentiment:
- Tech Giants: AAPL, MSFT, GOOGL, AMZN, NVDA, META, TSLA
- Growth: CRM, SNOW, PLTR, NFLX
- Value: BRK.B, JPM, V, KO, PG

### Agent 3: trading-idea-generator
**Agent Type**: `trading-idea-generator`
**Purpose**: Identify high-conviction trading opportunities
**Task**: Find 5-7 best trades combining:
- Fundamental strength (investment grade A- or better)
- Technical setup (support/resistance levels)
- Volatility opportunity (IV rank analysis)
- Catalyst timing (earnings, news events)

## Phase 2: Smart Money & Risk Analysis

### Agent 4: smart-money-interpreter
**Agent Type**: `smart-money-interpreter`
**Purpose**: Identify institutional positioning
**Task**: Analyze insider trades, 13F changes, unusual options activity

### Agent 5: quality-assessor
**Agent Type**: `quality-assessor`
**Purpose**: Portfolio risk assessment
**Task**: Calculate concentration risk, correlation analysis, volatility exposure

## Phase 3: AI Synthesis & Report Generation

Claude will:
1. **Synthesize** all agent outputs into cohesive narrative
2. **Prioritize** opportunities by conviction and risk/reward
3. **Generate** professional HTML email with mobile-responsive design
4. **Format** both HTML and plain text versions
5. **Store** analysis results for performance tracking

## Output Format

### Email Structure:
```
📊 Daily Market Intelligence - [Date]

🔥 MARKET PULSE
- VIX: [Level] ([Percentile]) - [Risk Assessment]
- Sentiment: [Bullish/Neutral/Bearish]
- Top Movers: [Winners & Losers]

📋 WATCHLIST STATUS (16 Symbols)
- Alerts: [Price targets, stops, earnings]
- Notable Changes: [Upgrades, downgrades, news]

🎯 TODAY'S OPPORTUNITIES (5-7 Trades)
1. [SYMBOL] - [BUY/SELL] - Conviction: [XX%]
   Entry: $[X] | Target: $[X] | Stop: $[X]
   Reasoning: [Technical + Fundamental + Catalyst]

⚠️ RISK ASSESSMENT
- Black Swan Risk: [Level]
- Portfolio Concentration: [Analysis]
- Recommended Adjustments: [Actions]

📈 PERFORMANCE UPDATE
- Yesterday's Calls: [Results]
- Week-to-Date: [Win Rate & Returns]
```

## Key Advantages of AI Orchestration

1. **Adaptive Intelligence**: Adjusts analysis based on market conditions
2. **Parallel Processing**: All agents work simultaneously
3. **Contextual Synthesis**: AI understands relationships between data points
4. **Natural Prioritization**: AI ranks opportunities by multiple factors
5. **Dynamic Formatting**: Adjusts report based on content importance

## Implementation Strategy

The command will:
1. Launch 5 parallel agent tasks using Task() tool with specified agent types
2. **Fallback Strategy**: If `market-pulse-analyzer` is unavailable, use `systemic-risk-monitor`
3. Wait for all agents to complete
4. Synthesize results using Claude's reasoning
5. Generate HTML/text reports using Write() tool
6. Send email using mcp__zapier__gmail_send_email if requested
7. Store results using mcp__fmp-weather-global__store_unified_analysis

## Agent Delegation Philosophy

Rather than micromanaging agent tasks, delegate to their specialized expertise:
- Let `market-pulse-analyzer` execute its professional framework
- Let `fundamental-stock-analyzer` use its earnings-aware caching
- Let `trading-idea-generator` apply its conviction scoring methodology
- Let `smart-money-interpreter` analyze institutional flows
- Let `quality-assessor` assess portfolio risk concentrations

## Performance Comparison

This AI-orchestrated approach will be compared against the Python version for:
- Speed (parallel vs sequential processing)
- Quality (adaptive vs rigid analysis)
- Completeness (AI can pursue interesting leads)
- Consistency (deterministic vs probabilistic)

## Email Delivery

If email address provided:
```
Subject: 📊 Daily Market Intelligence - [Date]
From: Market Intelligence System
To: [provided email]
Content-Type: text/html (with plain text alternative)
```

The email will be sent via Zapier Gmail integration with professional formatting.

## Success Metrics

- All 5 agents complete successfully
- 16 watchlist symbols analyzed
- 5-7 opportunities identified
- Risk assessment completed
- Email delivered (if requested)
- Analysis stored in database

This pure AI orchestration demonstrates Claude's ability to coordinate complex workflows without traditional programming.