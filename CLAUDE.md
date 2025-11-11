# Financial Agent with Claude

## Available Agents
- **fundamental-stock-analyzer**: Located in `.claude/agents/fundamental-stock-analyzer.md` - **🚀 Revolutionary earnings-aware fundamental analysis with intelligent caching** 🆕
- **comparative-stock-analyzer**: Located in `.claude/agents/comparative-stock-analyzer.md` - **📊 Cross-stock comparisons, screening, and portfolio intelligence** 🚀 NEW
- **stock-sentiment-analyzer**: Located in `.claude/agents/stock-sentiment-analyzer.md` - AI-powered sentiment analysis using Perplexity
- **volatility-analyzer**: Located in `.claude/agents/volatility-analyzer.md` - **Advanced volatility analysis with real IV data** 🆕
- **options-strategy-analyzer**: Located in `.claude/agents/options-strategy-analyzer.md` - **P&L visualization with Greeks and real options data** 🆕
- **options-scanner**: Located in `.claude/agents/options-scanner.md` - **Intelligent options strategy recommendations** 🆕

## 🌐 Web Chat Interface (NEW!) 🚀

Access all agents through a user-friendly web interface powered by Gradio and Claude Code SDK!

### Quick Start
```bash
# Launch the web interface
./scripts/launch-web-chat.sh

# Access at http://localhost:7860
```

### Features
- **🎯 Smart Agent Routing**: Auto-selects the best agent for your query
- **💬 Conversational**: Full conversation history and context management
- **⚡ Fast**: Prompt caching for improved performance
- **🔧 Transparent**: See which MCP tools are being used
- **📊 All Agents**: Access to all 17+ specialized agents

### Documentation
See [docs/WEB_CHAT_INTERFACE.md](docs/WEB_CHAT_INTERFACE.md) for complete documentation including:
- Installation and setup
- Usage examples
- Architecture overview
- Troubleshooting guide

## MCP Server
The project uses the FMP MCP server at `/Users/suneetn/agent-with-claude/fmp-mcp-server/`

### Start MCP Server
```bash
cd ../agent-with-claude/fmp-mcp-server
python3 fastmcp_server.py
```

### Check Server Status
```bash
ps aux | grep "fastmcp_server.py" | grep -v grep
```

## Available MCP Tools

### Financial Data Tools
- `mcp__fmp-weather-global__get_stock_price` - Current/historical stock prices
- `mcp__fmp-weather-global__get_company_profile` - Company profiles and info  
- `mcp__fmp-weather-global__get_financial_statements` - Income statements, balance sheets, cash flow
- `mcp__fmp-weather-global__get_key_metrics` - Financial metrics and ratios
- `mcp__fmp-weather-global__get_financial_ratios` - Comprehensive financial ratios
- `mcp__fmp-weather-global__get_technical_indicators` - SMA, RSI, MACD, EMA
- `mcp__fmp-weather-global__get_support_resistance_levels` - Technical analysis levels
- `mcp__fmp-weather-global__get_market_movers` - Gainers, losers, most active
- `mcp__fmp-weather-global__get_sector_performance` - Sector performance data

### Earnings Calendar Tools 🆕
- `mcp__fmp-weather-global__get_earnings_calendar` - **Earnings calendar for date ranges or symbols**
- `mcp__fmp-weather-global__get_historical_earnings` - Historical earnings dates for symbols
- `mcp__fmp-weather-global__get_next_earnings_date` - **Next upcoming earnings date with cache invalidation info**
- `mcp__fmp-weather-global__get_last_earnings_date` - Most recent earnings date
- `mcp__fmp-weather-global__get_earnings_cache_info` - **🎯 Intelligent cache strategy based on earnings timing**

### Comparative Fundamental Analysis Tools 🚀 NEW
- `mcp__fmp-weather-global__compare_stocks` - **Compare multiple stocks across fundamental metrics** 
- `mcp__fmp-weather-global__screen_stocks_fundamental` - **Screen stocks using fundamental criteria**
- `mcp__fmp-weather-global__get_sector_fundamental_analysis` - **Sector-based fundamental comparisons**
- `mcp__fmp-weather-global__get_investment_grade_distribution` - **Investment grade distribution analysis**
- `mcp__fmp-weather-global__store_fundamental_analysis` - **Store analysis results for comparison**

### Unified Analytics Tools 🎯 NEW
- `mcp__fmp-weather-global__store_unified_analysis` - **Store structured analysis results in unified database**
- `mcp__fmp-weather-global__store_fundamental_analysis` - **🚀 Enhanced fundamental storage with earnings-aware features** 🆕
- `mcp__fmp-weather-global__migrate_fundamental_database` - **Migrate legacy fundamental_analyses.db to unified schema** 🆕
- `mcp__fmp-weather-global__get_multi_dimensional_comparison` - **Multi-dimensional stock comparisons**
- `mcp__fmp-weather-global__advanced_stock_screening` - **Advanced screening across all dimensions**

### Volatility Analysis Tools 🆕
- `mcp__fmp-weather-global__get_realized_volatility` - Calculate historical volatility from price data
- `mcp__fmp-weather-global__get_vix_data` - VIX fear index data from FRED API
- `mcp__fmp-weather-global__compare_iv_hv` - **Real implied volatility vs historical volatility**
- `mcp__fmp-weather-global__get_volatility_cone` - Multi-period volatility analysis
- `mcp__fmp-weather-global__get_iv_rank` - **IV percentile rankings with real market data**
- `mcp__fmp-weather-global__get_multiple_iv_ranks` - **Batch IV analysis with trading signals**

### Options Analysis Tools 🆕
- `mcp__fmp-weather-global__get_options_chain_data` - **Full options chain with real Greeks**
- `mcp__fmp-weather-global__get_option_contract` - Specific option contract data
- `mcp__fmp-weather-global__find_options_by_delta` - Find options by delta target
- `mcp__fmp-weather-global__calculate_black_scholes_price` - Theoretical pricing with Greeks
- `mcp__fmp-weather-global__analyze_options_strategy` - **Multi-leg strategy P&L analysis**
- `mcp__fmp-weather-global__create_strategy_visualization` - **Interactive HTML P&L charts**

### News & Sentiment Tools
- `mcp__fmp-weather-global__get_stock_news` - Stock-specific news
- `mcp__fmp-weather-global__get_press_releases` - Company press releases
- `mcp__fmp-weather-global__analyze_stock_sentiment` - AI sentiment analysis (uses Perplexity)
- `mcp__fmp-weather-global__compare_sentiment` - Compare sentiment across stocks
- `mcp__fmp-weather-global__store_sentiment_analysis` - **Store sentiment with intelligent caching** 🆕
- `mcp__fmp-weather-global__get_cached_sentiment` - **Retrieve cached sentiment analysis** 🆕

### Portfolio Tools
- `mcp__fmp-weather-global__calculate_portfolio_value` - Portfolio calculations

### Additional Tools
- Weather data tools
- Event search tools

## Environment Variables
Required environment variables (set in MCP server):
- **FMP_API_KEY**: Financial Modeling Prep API key (required for financial data)
- **MARKETDATA_API_KEY**: MarketData.app API key (required for **real implied volatility**) 🆕
- **FRED_API_KEY**: Federal Reserve Economic Data API key (required for VIX data) 🆕
- **PERPLEXITY_API_KEY**: Perplexity API key (required for sentiment analysis)
- **OPENWEATHER_API_KEY**: OpenWeatherMap API key (for weather data)
- **EVENTBRITE_API_KEY**: Eventbrite API key (optional, for events)

## Common Tasks

### Stock Analysis
```bash
# Use the financial-analyst agent for broad market and technical analysis
# Example: "Analyze AAPL stock comprehensively"
```

### Fundamental Analysis 🆕
```bash  
# Use fundamental-stock-analyzer agent for deep fundamental analysis with earnings-aware caching
# Example: "Do a fundamental analysis on NVDA"
# Example: "Compare the fundamentals of AAPL vs MSFT"  
# Example: "What's the investment grade for TSLA?"
```

### Comparative Stock Analysis 🚀 NEW
```bash
# Use comparative-stock-analyzer agent for cross-stock screening and comparison
# Example: "Compare ROE and P/E ratios for AAPL, MSFT, GOOGL"
# Example: "Find all A-rated tech stocks with ROE > 20%"
# Example: "Show sector performance for Technology stocks"
# Example: "Screen for quality dividend stocks in my watchlist"
# Example: "Which healthcare stocks are cheapest on fundamentals?"
```

### Sentiment Analysis  
```bash
# Use stock-sentiment-analyzer agent for sentiment analysis
# Example: "What's the current sentiment on TSLA?"
```

### Volatility Analysis 🆕
```bash
# Use volatility-analyzer agent for advanced volatility analysis
# Example: "What's the current IV rank for AAPL, TSLA, NVDA?"
# Example: "Compare implied vs historical volatility for TSLA"
# Example: "Screen the market for volatility opportunities"
```

### Options Strategy Analysis 🆕
```bash
# Use options-strategy-analyzer agent for P&L visualization
# Example: "Analyze a bull call spread on AAPL"
# Example: "Show me the P&L for a long straddle on TSLA earnings"
# Example: "Build an iron condor strategy for NVDA"
# Example: "What's the breakeven for buying AAPL $150 calls?"
```

### Options Strategy Scanner 🆕
```bash
# Use options-scanner agent for intelligent strategy recommendations
# Example: "What options strategies should I consider for AAPL, TSLA, NVDA?"
# Example: "Screen the market for volatility opportunities"
# Example: "Find the best options play for SPY"
# Example: "Show me premium selling opportunities in tech stocks"
```

### Direct MCP Tool Usage
```bash
# Can also call MCP tools directly for specific data
# Example: Get stock price, financial ratios, sentiment, IV rank, etc.
```

## Testing
```bash
cd ../agent-with-claude/fmp-mcp-server
python -m pytest tests/
```

## Project Structure
```
fin-agent-with-claude/
├── .claude/
│   ├── agents/
│   │   ├── financial-analyst.md
│   │   ├── stock-sentiment-analyzer.md
│   │   └── volatility-analyzer.md 🆕
│   └── settings.local.json
└── CLAUDE.md

../agent-with-claude/fmp-mcp-server/
├── tools/
│   ├── sentiment.py (Perplexity-based sentiment analysis)
│   ├── perplexity_search.py
│   ├── volatility.py (Core volatility calculations) 🆕
│   ├── volatility_db.py (SQLite historical volatility database) 🆕
│   ├── marketdata_iv.py (Real implied volatility from MarketData.app) 🆕
│   ├── hv_iv_rank.py (IV Rank calculator with real data) 🆕
│   └── marketdata_optimized.py (Rate-limited API optimization) 🆕
├── fastmcp_server.py (Main MCP server)
├── server.py (Legacy server)
├── volatility_data.db (SQLite database for historical volatility) 🆕
└── tests/
```

## Key Features
1. **Real-time Data**: Access to live market data and pricing
2. **Professional Volatility Analysis**: **Real implied volatility** from options markets 🆕
3. **AI-Powered Analysis**: Sentiment analysis using Perplexity AI
4. **Comprehensive Metrics**: Financial statements, ratios, technical indicators
5. **Advanced Risk Assessment**: IV Rank, VIX analysis, volatility term structure 🆕
6. **News Integration**: Stock news, press releases, market updates
7. **Portfolio Management**: Portfolio calculations and volatility screening 🆕
8. **Multi-Agent System**: Specialized agents for different analysis types

## New Volatility Capabilities 🆕
- **Real Implied Volatility**: Live IV from MarketData.app options chains
- **IV Rank Calculator**: Historical volatility percentiles with trading signals
- **Volatility Screening**: Batch analysis across multiple symbols
- **Rate-Limited Optimization**: Efficient API usage with intelligent caching
- **SQLite Integration**: Historical volatility database for percentile calculations
- **Professional Trading Signals**: 🟢 BUY / 🔴 SELL / 🟡 CONSIDER volatility recommendations

## Claude Code Slash Commands

### Reference Documentation
See `Claude Code Slash Commands.md` for complete slash command reference including:
- Command structure and locations (`.claude/commands/` for project, `~/.claude/commands/` for personal)
- Frontmatter options (`allowed-tools`, `argument-hint`, `description`, `model`)
- Argument handling (`$ARGUMENTS` vs positional `$1`, `$2`, etc.)
- Pre-execution commands with `!` prefix
- File references with `@` prefix

### Command Creation Examples
```bash
# Project-specific commands (shared with team)
.claude/commands/analyze-stock.md
.claude/commands/volatility/screen.md

# Personal commands (user-specific)
~/.claude/commands/quick-analysis.md
```

## Claude Code SDK Development

### Documentation References
- **Claude Code SDK Docs**: https://docs.anthropic.com/en/docs/claude-code
- **MCP Protocol**: https://modelcontextprotocol.io/
- **Agent Development**: https://docs.anthropic.com/en/docs/claude-code/agents
- **Tool Integration**: https://docs.anthropic.com/en/docs/claude-code/tools

### SDK Integration
For building with Claude Code SDK:
```python
# Example SDK usage for financial analysis
from claude_code import Claude

# Initialize with your financial agents
claude = Claude(agents_dir=".claude/agents")

# Use financial analysis capabilities
result = await claude.analyze_stock("AAPL")
sentiment = await claude.analyze_sentiment("TSLA")
```

### Development Setup
```bash
# Install Claude Code SDK
pip install claude-code-sdk

# Set up development environment
export CLAUDE_CODE_API_KEY="your-api-key"
```

## Slash Commands
- **`/financial-analyst SYMBOL`**: Master orchestrator for comprehensive stock analysis that coordinates all specialist agents and synthesizes results into unified investment recommendations 🆕
- **`/uber_email [email_address|csv_file_path]`**: Generate comprehensive daily market intelligence email using 25-stock tiered watchlist (10 Core + 10 Rotating + 5 Big Movers) 🆕
- **`/uber_email_dev [filename.html]`**: 🛠️ **DEVELOPMENT VERSION** - Generate market intelligence report to HTML file WITHOUT sending emails for safe testing and iteration 🆕

## Notes
- The **`/financial-analyst`** slash command orchestrates all specialist agents for comprehensive analysis
- The **stock-sentiment-analyzer** focuses specifically on sentiment using Perplexity
- The **volatility-analyzer** provides professional-grade volatility analysis with real IV data 🆕
- All agents can be used together for complete market analysis
- MCP server must be running for agents to access financial data
- SDK development requires Claude Code API access

## Volatility Analysis Examples 🆕
```bash
# Current market volatility status
"What's the current volatility environment?"
# Result: Average IV Rank 10.0% - STRONG BUY VOLATILITY signal

# Individual stock IV analysis  
"What's AAPL's IV rank?"
# Result: IV Rank 25.9%, Real IV 23.59%, Signal: CONSIDER BUYING

# Multi-symbol volatility screening
"Screen AAPL, TSLA, NVDA for volatility opportunities"
# Result: All showing low IV ranks, strong volatility buying signals

# VIX and market fear analysis
"What's the current market fear level?"
# Result: VIX 14.43 (10th percentile) - Low fear, market confidence
```