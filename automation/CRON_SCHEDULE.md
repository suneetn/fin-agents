# Automated Daily Black Swan Monitoring - Cron Schedule

## Overview
Daily automated black swan tail risk monitoring with email alerts to suneetn@gmail.com and suneetn@quanthub.com.

## Schedule

### Daily Black Swan Monitor
- **Script**: `/root/claude-agents/automation/examples/daily-black-swan-monitor.sh`
- **Frequency**: Daily at 9:00 AM UTC (before market open)
- **User**: `claude-automation`
- **Email**: suneetn@gmail.com, suneetn@quanthub.com
- **Cron Expression**: `0 9 * * * /root/claude-agents/automation/examples/daily-black-swan-monitor.sh`

## What It Does

1. **Runs systemic-risk-monitor agent** with real-time MCP data
2. **Calculates black swan risk score (0-100)** with component breakdown:
   - VIX Analysis (0-30 points)
   - Sector Correlation (0-25 points)
   - Extreme Movers (0-25 points)
   - IV Rank Average (0-20 points)

3. **Sends HTML email** with:
   - Current risk level (NORMAL/ELEVATED/HIGH/CRISIS)
   - Specific actionable recommendations
   - Key metrics and trends
   - Historical context

4. **Logs execution** to `~/logs/daily-black-swan-monitor-YYYYMMDD.log`

## Risk Levels & Alerts

- **🟢 NORMAL (0-25)**: Standard allocation, informational only
- **🟡 ELEVATED (26-50)**: Caution warranted, reduce positions 25%
- **🔴 HIGH STRESS (51-75)**: Defensive positioning, cut positions 50%
- **🚨 CRISIS (76-100)**: Capital preservation mode, 50%+ cash

## Email Format

**Subject**: `Daily Black Swan Risk Monitor - YYYY-MM-DD - [Risk Level]`

**Content**:
- Professional HTML format
- Full analysis output with risk score
- Component breakdown
- Actionable recommendations
- Timestamp and server info

## Logs & Reports

**Log Files**: `~/logs/daily-black-swan-monitor-YYYYMMDD.log`
**Reports**: `~/logs/black-swan-report-YYYYMMDD-HHMMSS.txt`

## Installation

### 1. Deploy to Remote Server
```bash
# Push to GitHub
git add automation/
git commit -m "Add daily black swan monitoring automation"
git push origin main

# Pull on remote server
ssh root@159.65.37.77 "cd /root/claude-agents && git pull origin main"
```

### 2. Make Script Executable
```bash
ssh root@159.65.37.77 "chmod +x /root/claude-agents/automation/examples/daily-black-swan-monitor.sh"
```

### 3. Add to Crontab (as claude-automation user)
```bash
ssh root@159.65.37.77 "crontab -u claude-automation -l > /tmp/cron.tmp 2>/dev/null || true; \
echo '0 9 * * * /root/claude-agents/automation/examples/daily-black-swan-monitor.sh' >> /tmp/cron.tmp; \
crontab -u claude-automation /tmp/cron.tmp; \
rm /tmp/cron.tmp"
```

### 4. Verify Cron Job
```bash
ssh root@159.65.37.77 "crontab -u claude-automation -l"
```

## Testing

### Test Execution Manually
```bash
ssh root@159.65.37.77 "su - claude-automation -c '/root/claude-agents/automation/examples/daily-black-swan-monitor.sh'"
```

### Check Logs
```bash
ssh root@159.65.37.77 "tail -f /home/claude-automation/logs/daily-black-swan-monitor-*.log"
```

### Verify Email Delivery
Check suneetn@gmail.com and suneetn@quanthub.com inbox for test email.

## Monitoring

### Check Cron Execution
```bash
# View cron logs
ssh root@159.65.37.77 "journalctl -u cron -f"

# Check last execution
ssh root@159.65.37.77 "ls -ltr /home/claude-automation/logs/daily-black-swan-monitor-*.log | tail -1"
```

### Email Delivery Status
- Check Mailgun dashboard for delivery statistics
- Verify email receipt at both addresses
- Monitor bounce/failure notifications

## Troubleshooting

### Script Fails to Execute
```bash
# Check permissions
ssh root@159.65.37.77 "ls -la /root/claude-agents/automation/examples/daily-black-swan-monitor.sh"

# Check Claude auth
ssh root@159.65.37.77 "su - claude-automation -c 'cat ~/.bashrc.claude'"

# Check MCP config
ssh root@159.65.37.77 "su - claude-automation -c 'cat ~/.claude/mcp.json'"
```

### Email Not Received
```bash
# Check email output in logs
ssh root@159.65.37.77 "grep -A 20 'Sending email' /home/claude-automation/logs/daily-black-swan-monitor-*.log"

# Test Mailgun directly
ssh root@159.65.37.77 "su - claude-automation -c 'claude --print -- \"Use mcp__fmp-weather-global__send_email_mailgun to send test email to suneetn@gmail.com\"'"
```

### Analysis Timeout
- Default timeout: 600 seconds (10 minutes)
- Increase if needed in script: `TIMEOUT=900`
- Check MCP server health

## Maintenance

### Update Script
1. Edit local file: `automation/examples/daily-black-swan-monitor.sh`
2. Commit and push: `git add . && git commit -m "Update monitor" && git push`
3. Pull on remote: `ssh root@159.65.37.77 "cd /root/claude-agents && git pull"`

### Change Schedule
```bash
# Edit crontab for claude-automation user
ssh root@159.65.37.77 "crontab -u claude-automation -e"

# Common schedules:
# 0 9 * * *        - Daily at 9 AM UTC
# 0 9 * * 1-5      - Weekdays at 9 AM UTC
# 0 */4 * * *      - Every 4 hours
# 0 9,15 * * *     - 9 AM and 3 PM UTC daily
```

### Disable Monitoring
```bash
# Comment out cron job
ssh root@159.65.37.77 "crontab -u claude-automation -l | sed 's/^0 9 \* \* \* \/root\/claude-agents/#&/' | crontab -u claude-automation -"
```

## Security

- Script runs as `claude-automation` (non-root) user
- Uses `--dangerously-skip-permissions` for automation
- Email credentials stored in MCP server environment variables
- Logs contain full analysis but no API keys
- GitHub deployment ensures version control and rollback capability

## Cost Estimation

**Per Execution**:
- Claude API calls: ~3-5 calls per analysis
- Mailgun email: 1 email to 2 recipients
- Estimated cost: $0.10-0.20 per execution

**Monthly**:
- Daily execution: 30 days × $0.15 = ~$4.50/month
- Includes: Analysis + Email delivery

**Optimization**:
- Reduce to weekdays only: ~$3.15/month
- Add conditional logic to only email if risk > ELEVATED
