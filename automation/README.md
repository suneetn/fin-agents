# Cloud Automation with Claude

## Overview

Run Claude agents automatically on the cloud server (159.65.37.77) using cron jobs.

## Architecture

```
Local Development → GitHub → Cloud Server → Cron Automation
```

**Local:** Develop agents in `.claude/agents/`
**GitHub:** Version control and deployment source
**Cloud:** `/root/claude-agents/` with deployed agents
**Cron:** Scheduled execution using Claude Code

## Setup

### 1. Deploy Agents to Cloud
```bash
"Deploy latest agents to cloud server"
```

### 2. Copy Automation Scripts
```bash
scp automation/examples/*.sh root@159.65.37.77:/root/claude-agents/scripts/
ssh root@159.65.37.77 "chmod +x /root/claude-agents/scripts/*.sh"
```

### 3. Add Cron Jobs
```bash
ssh root@159.65.37.77 "crontab -e"
```

## Example Scripts

### Daily Market Intelligence (9 AM UTC)
```bash
0 9 * * * /root/claude-agents/scripts/daily-market-scan.sh >> /root/claude-agents/logs/daily-scan.log 2>&1
```

### Weekly Portfolio Review (Sunday 6 PM)
```bash
0 18 * * 0 /root/claude-agents/scripts/weekly-portfolio.sh >> /root/claude-agents/logs/weekly-portfolio.log 2>&1
```

### Volatility Screening (Every 4 hours)
```bash
0 */4 * * * /root/claude-agents/scripts/volatility-scan.sh >> /root/claude-agents/logs/volatility.log 2>&1
```

## Monitoring

### View Logs
```bash
ssh root@159.65.37.77 "tail -f /root/claude-agents/logs/daily-scan.log"
```

### Check Cron Status
```bash
ssh root@159.65.37.77 "crontab -l"
```

### Recent Executions
```bash
ssh root@159.65.37.77 "grep CRON /var/log/syslog | tail -20"
```

## Available Automation Templates

See `automation/examples/` for ready-to-use scripts:

- `daily-market-scan.sh` - Daily market intelligence report
- `weekly-portfolio.sh` - Weekly portfolio analysis
- `volatility-scan.sh` - IV rank monitoring
- `earnings-alerts.sh` - Upcoming earnings notifications
- `put-scanner.sh` - Daily put-selling opportunities

## Best Practices

1. **Test locally first** - Verify agents work before deploying
2. **Monitor logs** - Check execution logs regularly
3. **Set timeouts** - Use `timeout 600` to prevent hung jobs
4. **Email results** - Send reports to your email
5. **Error handling** - Scripts should handle failures gracefully
6. **Rate limits** - Respect API rate limits (FMP: 250/day)

## Troubleshooting

### Script not running
```bash
# Check cron syntax
ssh root@159.65.37.77 "crontab -l"

# Check permissions
ssh root@159.65.37.77 "ls -la /root/claude-agents/scripts/*.sh"

# Test manually
ssh root@159.65.37.77 "/root/claude-agents/scripts/daily-market-scan.sh"
```

### Authentication errors
```bash
# Verify token loaded
ssh root@159.65.37.77 "source ~/.bashrc.claude && env | grep CLAUDE"
```

### MCP tools not available
```bash
# Check MCP config
ssh root@159.65.37.77 "cat /root/.claude/mcp.json"

# Test MCP connection
ssh root@159.65.37.77 "
  source ~/.bashrc.claude &&
  claude --print --mcp-config /root/.claude/mcp.json -- 'Test MCP tools'
"
```
