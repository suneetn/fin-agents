# Financial Analysis Agent with Claude

A comprehensive financial analysis system powered by Claude AI, featuring specialized agents for fundamental analysis, sentiment analysis, volatility analysis, and options strategy recommendations.

## Features

- **Multi-Agent System**: Specialized agents for different analysis types
- **Real-time Market Data**: Live data via Financial Modeling Prep API
- **Advanced Volatility Analysis**: Real implied volatility from MarketData.app
- **AI-Powered Sentiment**: Sentiment analysis using Perplexity AI
- **Options Analysis**: Strategy P&L visualization with Greeks
- **Intelligent Caching**: Earnings-aware caching system
- **Daily Reports**: Automated market intelligence emails

## Quick Start

### Prerequisites

- Python 3.8+
- Claude Code CLI
- API Keys (FMP, MarketData.app, FRED, Perplexity)

### Installation

```bash
# Install dependencies
pip install -r requirements.txt

# Set up environment variables (see .env.example)
cp .env.example .env
# Edit .env with your API keys

# Start the MCP server
cd ../agent-with-claude/fmp-mcp-server
python3 fastmcp_server.py
```

### Basic Usage

```bash
# Fundamental analysis
claude "Do a fundamental analysis on AAPL"

# Sentiment analysis
claude "What's the current sentiment on TSLA?"

# Volatility analysis
claude "What's the IV rank for AAPL, TSLA, NVDA?"

# Options scanner
claude "What options strategies should I consider for SPY?"
```

## Project Structure

```
fin-agent-with-claude/
├── .claude/                    # Claude agents and commands
│   ├── agents/                # Specialized agent definitions
│   └── commands/              # Slash commands
├── src/
│   ├── clients/               # Client implementations
│   ├── agents/                # Agent implementations
│   ├── reports/               # Report generators
│   └── analyzers/             # Analysis modules
├── tests/                     # Test files
├── scripts/                   # Shell scripts and automation
├── tools/                     # Utility tools
├── config/                    # Configuration files
│   ├── watchlist.yaml        # Stock watchlist
│   ├── email_config.yaml     # Email settings
│   └── alert_thresholds.yaml # Alert configurations
├── docs/                      # Documentation
│   ├── architecture/         # Architecture docs
│   ├── specifications/       # Spec documents
│   └── reports/             # Analysis reports
├── data/                      # Databases and cache
├── outputs/                   # Generated reports (gitignored)
└── backups/                   # Backup files

External:
../agent-with-claude/fmp-mcp-server/  # MCP server
```

## Available Agents

- **fundamental-stock-analyzer**: Deep fundamental analysis with earnings-aware caching
- **comparative-stock-analyzer**: Cross-stock comparisons and screening
- **stock-sentiment-analyzer**: AI-powered sentiment analysis
- **volatility-analyzer**: Advanced volatility analysis with real IV data
- **options-strategy-analyzer**: P&L visualization with Greeks
- **options-scanner**: Intelligent strategy recommendations

## Slash Commands

- `/financial-analyst SYMBOL` - Comprehensive stock analysis
- `/uber_email [email]` - Daily market intelligence email
- `/uber_email_dev [file]` - Development version (no email)
- `/oversold-quality` - Find oversold quality stocks
- `/put-scanner` - Cash-secured put opportunities
- `/value-screen` - Screen for undervalued stocks

See `docs/Claude Code Slash Commands.md` for complete reference.

## Configuration

### Watchlist
Edit `config/watchlist.yaml` to customize your stock watchlist.

### Email Settings
Configure email delivery in `config/email_config.yaml`.

### Alert Thresholds
Set alert thresholds in `config/alert_thresholds.yaml`.

## Development

### Running Tests

```bash
# Run all tests
pytest tests/

# Run specific test
pytest tests/test_fundamental_analysis.py
```

### Adding New Agents

1. Create agent definition in `.claude/agents/`
2. Implement agent logic in `src/agents/`
3. Add tests in `tests/`
4. Update documentation

### Code Style

- Follow PEP 8 guidelines
- Use type hints
- Add docstrings to functions
- Keep functions focused and single-purpose

## MCP Server

The project uses a FastMCP server for financial data access.

### Starting the Server

```bash
cd ../agent-with-claude/fmp-mcp-server
python3 fastmcp_server.py
```

### Check Server Status

```bash
ps aux | grep "fastmcp_server.py" | grep -v grep
```

### Available Tools

See `CLAUDE.md` for complete list of MCP tools.

## Environment Variables

Required in `.env`:

- `FMP_API_KEY` - Financial Modeling Prep API key
- `MARKETDATA_API_KEY` - MarketData.app API key (for real IV)
- `FRED_API_KEY` - Federal Reserve Economic Data API key
- `PERPLEXITY_API_KEY` - Perplexity API key (for sentiment)
- `OPENWEATHER_API_KEY` - OpenWeatherMap API key
- `MAILGUN_API_KEY` - Mailgun API key (for emails)

## Daily Reports

### Running Daily Reports

```bash
# Generate and email report
./scripts/run-daily-email-report.sh

# Development mode (no email)
claude /uber_email_dev report.html
```

### Scheduling with Cron

```bash
# Set up cron job
./scripts/setup-cron.sh

# View schedule
cat config/crontab-schedule.txt
```

## Documentation

- `CLAUDE.md` - Project instructions and available tools
- `docs/DEV-WORKFLOW.md` - Development workflow
- `docs/Claude Code Slash Commands.md` - Command reference
- `docs/STANDARD_FUNDAMENTAL_SCHEMA.md` - Data schema
- `docs/architecture/` - Architecture documentation
- `docs/specifications/` - Feature specifications

## Troubleshooting

### MCP Server Not Running

```bash
cd ../agent-with-claude/fmp-mcp-server
python3 fastmcp_server.py
```

### API Rate Limits

The system includes rate limiting and caching to minimize API calls. Check logs in `logs/` for details.

### Database Issues

Database files are in `data/`. To reset:

```bash
rm data/*.db
# Databases will be recreated on next run
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Add tests
4. Update documentation
5. Submit pull request

## License

[Add your license here]

## Support

For issues and questions:
- Check documentation in `docs/`
- Review `CLAUDE.md` for tool reference
- File an issue on GitHub

## Acknowledgments

- Claude AI by Anthropic
- Financial Modeling Prep API
- MarketData.app API
- Perplexity AI
