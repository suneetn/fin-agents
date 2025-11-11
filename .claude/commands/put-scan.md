---
allowed-tools: Task, mcp__fmp-weather-global__*, mcp__zapier__gmail_send_email, mcp__zapier__gmail_create_draft
description: Comprehensive put-selling scanner with technical analysis and email reporting
argument-hint: "[--watchlist SYMBOLS] [--min-premium AMOUNT] [--max-delta NUMBER] [--email ADDRESS] [--draft-only]"
---

# Weekly Put Selling Scanner & Report

**Generate a comprehensive put-selling opportunities report with technical analysis and email delivery.**

## Parameters:
- `--watchlist`: Comma-separated stock symbols (default: large cap stocks)
- `--min-premium`: Minimum premium threshold in dollars (default: 0.50)
- `--max-delta`: Maximum delta for put options (default: 45)
- `--email`: Email address to send report (optional)
- `--draft-only`: Create email draft instead of sending

## Default Watchlist:
AAPL, MSFT, GOOGL, TSLA, NVDA, META, JPM, UNH, V, HD, AMZN, BRK.B, JNJ, PG, WMT, MA, XOM, CVX, ABBV, LLY

## Execution Steps:

### 1. Parse Arguments and Setup
```
# Check for help or no arguments - show usage
if [[ "$1" == "--help" || "$1" == "-h" || $# -eq 0 ]]; then
    echo "📊 Put-Selling Scanner & Report Generator"
    echo ""
    echo "USAGE:"
    echo "  /put-scan [OPTIONS]"
    echo ""
    echo "OPTIONS:"
    echo "  --watchlist=SYMBOLS     Comma-separated stock symbols"
    echo "                         (default: AAPL,MSFT,GOOGL,TSLA,NVDA,META,JPM,UNH,V,HD,AMZN,BRK.B,JNJ,PG,WMT,MA,XOM,CVX,ABBV,LLY)"
    echo "  --min-premium=AMOUNT    Minimum premium threshold in dollars (default: 0.50)"
    echo "  --max-delta=NUMBER      Maximum delta for put options (default: 45)"
    echo "  --email=ADDRESS         Email address to send report (optional)"
    echo "  --draft-only            Create email draft instead of sending"
    echo "  --help, -h              Show this help message"
    echo ""
    echo "EXAMPLES:"
    echo "  /put-scan                                    # Basic scan with defaults"
    echo "  /put-scan --watchlist=AAPL,MSFT,GOOGL       # Custom watchlist"
    echo "  /put-scan --min-premium=2.00 --max-delta=30 # High premium only"
    echo "  /put-scan --email=trader@example.com         # Email results"
    echo "  /put-scan --draft-only --email=me@email.com  # Create draft"
    echo ""
    return 0
fi

WATCHLIST="${1:-AAPL,MSFT,GOOGL,TSLA,NVDA,META,JPM,UNH,V,HD,AMZN,BRK.B,JNJ,PG,WMT,MA,XOM,CVX,ABBV,LLY}"
MIN_PREMIUM="${2:-0.50}"
MAX_DELTA="${3:-45}"
EMAIL_ADDRESS="${4}"
DRAFT_ONLY="${5}"

# Parse named arguments
for arg in "$@"; do
    case $arg in
        --watchlist=*)
            WATCHLIST="${arg#*=}"
            shift
            ;;
        --min-premium=*)
            MIN_PREMIUM="${arg#*=}"
            shift
            ;;
        --max-delta=*)
            MAX_DELTA="${arg#*=}"
            shift
            ;;
        --email=*)
            EMAIL_ADDRESS="${arg#*=}"
            shift
            ;;
        --draft-only)
            DRAFT_ONLY="true"
            shift
            ;;
        --help|-h)
            # Help already shown above
            return 0
            ;;
    esac
done
```

### 2. Market Overview Analysis
Use the **volatility-analyzer** agent to:
- Get current VIX level and market fear gauge
- Analyze overall market volatility environment
- Check sector performance for context

### 3. Technical Screening
Use the **technical-stock-analyzer** agent to:
- Screen watchlist for ideal put-selling setups:
  - Stocks in uptrends with pullbacks to support
  - Range-bound stocks near support levels
  - RSI 30-60 (not oversold, room to fall)
  - Strong support levels identified
  - Good volume and liquidity

### 4. Options Analysis
Use the **options-scanner** agent to:
- Get options chains for qualified stocks
- Find optimal strike prices (30-45 delta range)
- Calculate expected premiums and returns
- Assess implied volatility levels
- Check liquidity (bid-ask spreads)

### 5. Risk Assessment
For each candidate:
- Distance to support levels
- Probability of profit based on technical levels
- Risk-reward ratio analysis
- Position sizing recommendations

### 6. Report Generation
Create comprehensive markdown report with:

#### Market Overview Section
- Current VIX and market sentiment
- Sector rotation insights
- Overall volatility environment assessment

#### Top Put-Selling Opportunities (5-10 stocks)
For each opportunity:
- **Stock**: Symbol and current price
- **Technical Setup**: Support levels, RSI, trend analysis
- **Recommended Strike**: Price and delta
- **Premium**: Expected premium and annualized return
- **Risk Level**: Distance to support, probability assessment
- **Position Size**: Recommended allocation
- **Entry Timing**: Best days to enter

#### Risk Management Guidelines
- Maximum position sizes
- Exit strategies (profit taking, rolling)
- Market condition warnings

#### Weekly Calendar
- Key earnings dates to avoid
- Economic events that could impact volatility
- Optimal entry/exit timing

### 7. Email Integration
If email address provided:
- Format report as professional HTML email
- Include executive summary at top
- Add disclaimer about risk
- Send via Gmail or create draft if --draft-only specified

### 8. Output Summary
Display:
- Number of opportunities found
- Market conditions assessment
- Email delivery status
- Next recommended scan date

## Example Usage:

```bash
# Basic scan with default watchlist
/put-scan

# Custom watchlist with email
/put-scan --watchlist=AAPL,MSFT,GOOGL --email=trader@example.com

# High premium opportunities only
/put-scan --min-premium=2.00 --max-delta=30 --email=investor@example.com

# Create draft for review
/put-scan --watchlist=TSLA,NVDA,AMD --draft-only --email=review@example.com
```

## Risk Disclaimer:
This analysis is for educational purposes only. Options trading involves substantial risk and is not suitable for all investors. Past performance does not guarantee future results. Always conduct your own research and consider consulting with a qualified financial advisor.

---

**Note**: This command integrates multiple specialized agents and MCP tools to provide comprehensive analysis. Ensure MCP server is running and all required API keys are configured.