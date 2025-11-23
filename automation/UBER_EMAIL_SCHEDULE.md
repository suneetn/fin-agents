# Automated Daily Market Intelligence Email - Uber Email Schedule

## Overview
Daily automated comprehensive market intelligence report with 6-agent sequential analysis and professional HTML email delivery to multiple recipients.

## Schedule

### Daily Uber Email
- **Script**: `/root/claude-agents/automation/examples/daily-uber-email.sh`
- **Frequency**: Daily at 8:00 AM UTC (before market open, 1 hour before black swan monitor)
- **User**: `claude-automation`
- **Email Recipients**: Read from `/root/claude-agents/emails.csv` (7 addresses)
- **Cron Expression**: `0 8 * * * /root/claude-agents/automation/examples/daily-uber-email.sh`
- **Estimated Runtime**: 60-75 minutes
- **Timeout**: 90 minutes (5400 seconds)

## What It Does

### 8-Step Sequential Execution

**Step 1: Market Pulse Analysis** (10-12 min)
- Market overview (SPY, VIX, sector performance)
- News catalyst analysis and scoring
- Volatility regime assessment
- Risk management guidance

**Step 2: Quality Assessment Dashboard** (12-15 min)
- A+ to F grades for all 25 watchlist stocks
- Quality score rankings (0-100) with tier designation
- Fair value estimates vs current prices
- Buy/Hold/Sell recommendations by tier

**Step 3: Smart Money Intelligence** (10-12 min)
- Institutional buying/selling signals
- Insider trading patterns
- Analyst upgrade/downgrade activity
- 13F filing intelligence
- Smart money conviction levels by tier

**Step 4: Volatility Opportunities** (8-10 min)
- IV rank analysis with real market data
- Volatility buy/sell signals by tier
- Options trading opportunities
- VIX market regime adjustments
- Risk management for volatility positions

**Step 5: Value & Growth Screening** (10-12 min)
- Cross-stock comparisons and sector analysis
- Value screening (low P/E, P/B, high dividend yield)
- Growth screening (revenue growth, earnings acceleration)
- Momentum screening for high volatility stocks
- Relative positioning and percentile rankings

**Step 6: Top 10 Trading Ideas Synthesis** (10-15 min)
- Synthesizes all 5 prior sections
- Scores ideas on 100-point scale:
  * Quality 30%
  * Technical 25%
  * Volatility 20%
  * Smart Money 15%
  * Risk/Reward 10%
- Precise entry/exit zones with stop-losses
- Position sizing and time horizons

**Step 7: Professional HTML Formatting** (10-15 min)
- Bloomberg Terminal-quality styling
- Navy blue headers with gold accents
- Monospace fonts for all numbers
- Mobile-responsive design
- Executive dashboard with 30-second overview
- Maximum 8 pages total length

**Step 8: Email Delivery** (1-2 min)
- Reads recipients from CSV file
- Sends via Mailgun MCP tool
- Professional subject line with date
- Tags for tracking and analytics

### 25-Stock Tiered Watchlist

**CORE 10 (Durable Quality - 60% Analysis Time):**
- AAPL, MSFT, GOOGL, AMZN, NVDA (Mag 5)
- META, TSLA (Large Tech)
- BRK.B, JPM, JNJ (Quality Value/Dividend)

**ROTATING 10 (Current Theme: AI/Cloud - 30% Analysis Time):**
- CRM, ADBE, NFLX, PYPL (Software/Platforms)
- AMD, ORCL (Enterprise Tech)
- V, UNH, HD, COST (Sector Leaders)

**BIG MOVERS 5 (High Volatility Momentum - 10% Analysis Time):**
- PLTR, SNOW, SQ (Growth/Turnaround)
- SMCI, COIN (Emerging/Crypto)

## Email Format

**Subject**: `QuantHub.ai Daily Intelligence - YYYY-MM-DD`

**Content** (Professional HTML):
1. Executive Dashboard (30-second overview)
2. Section 1: Market Pulse
3. Section 2: Quality Dashboard
4. Section 3: Smart Money Intelligence
5. Section 4: Volatility Opportunities
6. Section 5: Value & Growth Screening
7. Section 6: Top 10 Trading Ideas

**Recipients** (from emails.csv):
- suneetn@gmail.com
- suneetn@quanthub.ai
- suneetn@icloud.com
- sangeeeta_nandwani@yahoo.com
- AminderRpatel@gmail.com
- prashant.nedungadi@gmail.com
- rohitbhag@gmail.com

## Logs & Reports

**Log Files**: `~/logs/daily-uber-email-YYYYMMDD.log`

**Report Directories**: `~/logs/uber-email-YYYYMMDD-HHMMSS/`
- `section1-market-pulse.txt`
- `section2-quality.txt`
- `section3-smart-money.txt`
- `section4-volatility.txt`
- `section5-screening.txt`
- `section6-trading-ideas.txt`
- `final-email.html`

## Installation

### 1. Deploy to Remote Server
```bash
# Push to GitHub
git add automation/
git commit -m "Add daily uber email automation"
git push origin main

# Pull on remote server
ssh root@159.65.37.77 "cd /root/claude-agents && git pull origin main"
```

### 2. Deploy emails.csv to Remote Server
```bash
# Copy emails.csv to remote server
scp /Users/suneetn/fin-agent-with-claude/emails.csv root@159.65.37.77:/root/claude-agents/emails.csv

# Or copy config/emails.csv if using symlink
scp /Users/suneetn/fin-agent-with-claude/config/emails.csv root@159.65.37.77:/root/claude-agents/emails.csv
```

### 3. Make Script Executable
```bash
ssh root@159.65.37.77 "chmod +x /root/claude-agents/automation/examples/daily-uber-email.sh"
```

### 4. Add to Crontab (as claude-automation user)
```bash
ssh root@159.65.37.77 "crontab -u claude-automation -l > /tmp/cron.tmp 2>/dev/null || true; \
echo '0 8 * * * /root/claude-agents/automation/examples/daily-uber-email.sh' >> /tmp/cron.tmp; \
crontab -u claude-automation /tmp/cron.tmp; \
rm /tmp/cron.tmp"
```

### 5. Verify Cron Job
```bash
ssh root@159.65.37.77 "crontab -u claude-automation -l"
```

Expected output:
```
0 8 * * * /root/claude-agents/automation/examples/daily-uber-email.sh
0 9 * * * /root/claude-agents/automation/examples/daily-black-swan-monitor.sh
```

## Testing

### Test Execution Manually (Full Run - 60-75 minutes)
```bash
ssh root@159.65.37.77 "su - claude-automation -c '/root/claude-agents/automation/examples/daily-uber-email.sh'"
```

### Test with Single Agent (Quick Test - ~10 minutes)
```bash
# Test just Step 1 (Market Pulse)
ssh root@159.65.37.77 "su - claude-automation -c 'source ~/.bashrc.claude && claude --print --max-turns 20 --dangerously-skip-permissions -- \"Use the market-pulse-analyzer agent to generate today'\''s comprehensive market pulse analysis\"'"
```

### Check Logs (Real-time)
```bash
ssh root@159.65.37.77 "tail -f /home/claude-automation/logs/daily-uber-email-*.log"
```

### Verify Email Delivery
Check all 7 email inboxes for delivery confirmation.

## Monitoring

### Check Cron Execution
```bash
# View cron logs
ssh root@159.65.37.77 "journalctl -u cron -f"

# Check last execution
ssh root@159.65.37.77 "ls -ltr /home/claude-automation/logs/daily-uber-email-*.log | tail -1"
```

### Monitor Active Execution
```bash
# Check if script is running
ssh root@159.65.37.77 "ps aux | grep daily-uber-email | grep -v grep"

# View progress in log
ssh root@159.65.37.77 "tail -f /home/claude-automation/logs/daily-uber-email-$(date +%Y%m%d).log"
```

### Email Delivery Status
- Check Mailgun dashboard for delivery statistics
- Verify email receipt at all 7 addresses
- Monitor bounce/failure notifications
- Check spam folders if not received

### Performance Metrics
```bash
# Check execution time
ssh root@159.65.37.77 "grep 'Starting\\|completed successfully' /home/claude-automation/logs/daily-uber-email-*.log | tail -8"

# Check which step is currently running
ssh root@159.65.37.77 "grep 'Step [0-9]/[0-9]' /home/claude-automation/logs/daily-uber-email-$(date +%Y%m%d).log | tail -1"
```

## Troubleshooting

### Script Fails to Execute
```bash
# Check permissions
ssh root@159.65.37.77 "ls -la /root/claude-agents/automation/examples/daily-uber-email.sh"

# Check Claude auth
ssh root@159.65.37.77 "su - claude-automation -c 'cat ~/.bashrc.claude'"

# Check MCP config
ssh root@159.65.37.77 "su - claude-automation -c 'cat ~/.claude/mcp.json'"

# Verify emails.csv exists
ssh root@159.65.37.77 "ls -la /root/claude-agents/emails.csv"
```

### Specific Step Fails
```bash
# Check logs for step failure
ssh root@159.65.37.77 "grep -A 10 'ERROR' /home/claude-automation/logs/daily-uber-email-*.log"

# View output from failed step
ssh root@159.65.37.77 "grep -B 5 -A 20 'failed with exit code' /home/claude-automation/logs/daily-uber-email-*.log"
```

### Email Not Received
```bash
# Check email output in logs
ssh root@159.65.37.77 "grep -A 20 'Sending email' /home/claude-automation/logs/daily-uber-email-*.log"

# Verify CSV file format
ssh root@159.65.37.77 "cat /root/claude-agents/emails.csv"

# Test Mailgun directly
ssh root@159.65.37.77 "su - claude-automation -c 'claude --print -- \"Use mcp__fmp-weather-global__send_email_mailgun to send test email to suneetn@gmail.com\"'"
```

### Timeout Issues
```bash
# Check current timeout setting (default: 5400 seconds = 90 minutes)
ssh root@159.65.37.77 "grep 'TIMEOUT=' /root/claude-agents/automation/examples/daily-uber-email.sh"

# Increase timeout if needed (edit script)
ssh root@159.65.37.77 "sed -i 's/TIMEOUT=5400/TIMEOUT=7200/' /root/claude-agents/automation/examples/daily-uber-email.sh"
```

### Agent Not Found
```bash
# Check available agents
ssh root@159.65.37.77 "su - claude-automation -c 'ls -la ~/.claude/agents/'"

# Verify agent symlinks
ssh root@159.65.37.77 "su - claude-automation -c 'readlink ~/.claude/agents'"
```

## Maintenance

### Update Script
1. Edit local file: `automation/examples/daily-uber-email.sh`
2. Commit and push: `git add . && git commit -m "Update uber email automation" && git push`
3. Pull on remote: `ssh root@159.65.37.77 "cd /root/claude-agents && git pull"`

### Update Email Recipients
```bash
# Edit local emails.csv
vim /Users/suneetn/fin-agent-with-claude/emails.csv

# Deploy to remote
scp /Users/suneetn/fin-agent-with-claude/emails.csv root@159.65.37.77:/root/claude-agents/emails.csv
```

### Change Schedule
```bash
# Edit crontab for claude-automation user
ssh root@159.65.37.77 "crontab -u claude-automation -e"

# Common schedules:
# 0 8 * * *        - Daily at 8 AM UTC
# 0 8 * * 1-5      - Weekdays at 8 AM UTC
# 0 6,12 * * *     - 6 AM and 12 PM UTC daily
# 0 8 * * 1,3,5    - Mon/Wed/Fri at 8 AM UTC
```

### Disable Monitoring
```bash
# Comment out cron job
ssh root@159.65.37.77 "crontab -u claude-automation -l | sed 's/^0 8 \* \* \* \/root\/claude-agents\/automation\/examples\/daily-uber-email/#&/' | crontab -u claude-automation -"
```

### Update Watchlist
Edit the script to modify CORE_10, ROTATING_10, or BIG_MOVERS_5 variables:
```bash
ssh root@159.65.37.77 "vim /root/claude-agents/automation/examples/daily-uber-email.sh"

# Or edit locally and deploy via git
vim automation/examples/daily-uber-email.sh
git add . && git commit -m "Update watchlist" && git push
ssh root@159.65.37.77 "cd /root/claude-agents && git pull"
```

## Security

- Script runs as `claude-automation` (non-root) user
- Uses `--dangerously-skip-permissions` for automation
- Email credentials stored in MCP server environment variables
- Logs contain full analysis but no API keys
- GitHub deployment ensures version control and rollback capability
- All sections saved to files for audit trail

## Cost Estimation

**Per Execution**:
- Claude API calls: ~35-45 calls total (6 agents + formatting + email)
- Agent execution time: 60-75 minutes
- Mailgun email: 1 email to 7 recipients
- Estimated cost: $3.50-5.00 per execution

**Monthly**:
- Daily execution: 30 days × $4.25 = ~$127.50/month
- Includes: 6-agent analysis + formatting + email delivery

**Optimization**:
- Reduce to weekdays only: ~$89.25/month (21 days)
- Reduce Big Movers 5 to focus on Core 10: Save 10-15% runtime
- Cache quality assessments for 24 hours: Save ~15-20% API calls

## Performance Benchmarks

**Target Execution Times**:
- Step 1 (Market Pulse): 10-12 min
- Step 2 (Quality): 12-15 min
- Step 3 (Smart Money): 10-12 min
- Step 4 (Volatility): 8-10 min
- Step 5 (Screening): 10-12 min
- Step 6 (Trading Ideas): 10-15 min
- Step 7 (Formatting): 10-15 min
- Step 8 (Email): 1-2 min
- **Total**: 60-75 minutes

**Monitoring Alerts**:
- Warn if any step exceeds 20 minutes
- Alert if total execution exceeds 90 minutes
- Alert if any step fails
- Alert if email delivery fails

## Success Confirmation

Upon successful completion:
```
✅ Step 1/7: Market Pulse Analysis Generated
✅ Step 2/7: Quality Assessment Dashboard Generated
✅ Step 3/7: Smart Money Intelligence Generated
✅ Step 4/7: Volatility Opportunities Generated
✅ Step 5/7: Value & Growth Screening Generated
✅ Step 6/7: Top 10 Trading Ideas Generated
✅ Step 7/7: Professional HTML Email Formatted
✅ Step 8/8: Email Sent to: [7 recipients]
📧 Subject: QuantHub.ai Daily Intelligence - [date]
🎯 Total Analysis Time: ~70 minutes
💾 All sections saved to: ~/logs/uber-email-[timestamp]/
```

## Comparison with Black Swan Monitor

| Feature | Uber Email | Black Swan Monitor |
|---------|------------|-------------------|
| Schedule | 8:00 AM UTC | 9:00 AM UTC |
| Runtime | 60-75 min | 8-12 min |
| Agents | 6 sequential + formatter | 1 + formatter |
| Email Recipients | 7 (from CSV) | 2 (hardcoded) |
| Cost/Execution | $3.50-5.00 | $0.10-0.20 |
| Report Length | 8 pages | 2-3 pages |
| Analysis Depth | Comprehensive | Focused on risk |
| Watchlist Size | 25 stocks (3 tiers) | Market indices |

Both use the same email delivery and formatting infrastructure for consistency.
