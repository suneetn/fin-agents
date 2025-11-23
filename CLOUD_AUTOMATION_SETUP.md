# Cloud Automation Setup - Complete Guide

**Date:** 2025-11-22
**Status:** ✅ Fully Operational

---

## 🎉 What's Been Accomplished

You now have a complete **agent development → deployment → automation** pipeline:

```
Local Development → Deploy to Cloud → Automated Execution
      (Mac)              (159.65.37.77)      (Cron Jobs)
```

---

## 📁 Directory Structure

### **Local (Development)**
```
fin-agent-with-claude/
├── .claude/
│   ├── agents/          # 24 agents including:
│   │   ├── fundamental-stock-analyzer.md
│   │   ├── volatility-analyzer.md
│   │   ├── cloud-sre.md
│   │   └── ... 21 more
│   ├── commands/        # 21 slash commands including:
│   │   ├── uber_email.md
│   │   ├── deploy-cloud.md
│   │   └── ... 19 more
│   └── settings.local.json
├── deploy/
│   └── deploy-to-cloud.md
└── automation/
    ├── README.md
    └── examples/
        ├── daily-market-scan.sh
        ├── weekly-portfolio.sh
        ├── volatility-scan.sh
        ├── put-scanner.sh
        └── earnings-alerts.sh
```

### **Remote (Production)**
```
/root/claude-agents/
├── .claude/
│   ├── agents/          # Deployed from local
│   ├── commands/        # Deployed from local
│   └── settings.local.json
├── scripts/
│   ├── daily-market-scan.sh
│   ├── weekly-portfolio.sh
│   ├── volatility-scan.sh
│   ├── put-scanner.sh
│   └── earnings-alerts.sh
└── logs/
    ├── daily-scan.log
    ├── volatility.log
    └── ... more logs

/root/.claude/
├── agents -> /root/claude-agents/.claude/agents (symlink)
├── commands -> /root/claude-agents/.claude/commands (symlink)
└── mcp.json

/home/claude-automation/
├── .claude/
│   ├── agents -> /root/claude-agents/.claude/agents (symlink)
│   ├── commands -> /root/claude-agents/.claude/commands (symlink)
│   └── mcp.json
└── .bashrc.claude
```

---

## 👤 User Configuration

### **claude-automation User**
- **Purpose:** Non-root user for running Claude Code automation
- **Home:** `/home/claude-automation`
- **Authentication:** Claude Code OAuth token configured
- **MCP Access:** Full access to all MCP tools
- **Agent Access:** Symlinked to `/root/claude-agents/.claude/`
- **Permissions:** Execute access to automation scripts

**Why non-root?**
- Claude Code blocks `--dangerously-skip-permissions` for root (security)
- Cron jobs should run as non-root users
- Better security isolation

---

## 🚀 Deployment Workflow

### **Method 1: Using Slash Command** (Recommended)

```bash
# From local machine
/deploy-cloud
```

This will:
1. Package `.claude/` directory
2. Copy to remote server
3. Extract and verify
4. Report deployment status

### **Method 2: Manual Deployment**

```bash
# 1. Package agents
tar -czf claude-deploy.tar.gz .claude/

# 2. Copy to server
scp claude-deploy.tar.gz root@159.65.37.77:/root/claude-agents/

# 3. Extract on server
ssh root@159.65.37.77 "
  cd /root/claude-agents &&
  tar -xzf claude-deploy.tar.gz &&
  rm claude-deploy.tar.gz
"

# 4. Clean up local
rm claude-deploy.tar.gz
```

### **Deploy Automation Scripts**

```bash
# Copy updated scripts
scp automation/examples/*.sh root@159.65.37.77:/root/claude-agents/scripts/

# Fix permissions
ssh root@159.65.37.77 "
  chmod 755 /root/claude-agents/scripts/*.sh &&
  chown claude-automation:claude-automation /root/claude-agents/scripts/*.sh
"
```

---

## ⚙️ Setting Up Cron Jobs

### **Add to crontab as claude-automation user:**

```bash
# SSH as root, then switch to claude-automation
ssh root@159.65.37.77
su - claude-automation
crontab -e
```

### **Example Cron Entries:**

```cron
# Daily Market Intelligence (9 AM UTC)
0 9 * * * /root/claude-agents/scripts/daily-market-scan.sh >> /root/claude-agents/logs/daily-scan.log 2>&1

# Volatility Screening (Every 4 hours)
0 */4 * * * /root/claude-agents/scripts/volatility-scan.sh >> /root/claude-agents/logs/volatility.log 2>&1

# Weekly Portfolio Review (Sunday 6 PM)
0 18 * * 0 /root/claude-agents/scripts/weekly-portfolio.sh >> /root/claude-agents/logs/weekly-portfolio.log 2>&1

# Put-Selling Scanner (3 PM UTC, weekdays only)
0 15 * * 1-5 /root/claude-agents/scripts/put-scanner.sh >> /root/claude-agents/logs/put-scanner.log 2>&1

# Earnings Alerts (Monday 8 AM)
0 8 * * 1 /root/claude-agents/scripts/earnings-alerts.sh >> /root/claude-agents/logs/earnings.log 2>&1
```

---

## 🧪 Testing

### **Test Agent Availability:**

```bash
ssh root@159.65.37.77 "
  su - claude-automation -c '
    source ~/.bashrc.claude &&
    claude --print \
      --mcp-config ~/.claude/mcp.json \
      --dangerously-skip-permissions \
      -- \"List all available agents\"
  '
"
```

### **Test MCP Tools:**

```bash
ssh root@159.65.37.77 "
  su - claude-automation -c '
    source ~/.bashrc.claude &&
    claude --print \
      --mcp-config ~/.claude/mcp.json \
      --dangerously-skip-permissions \
      -- \"Get AAPL stock price using get_stock_price\"
  '
"
```

### **Test Automation Script:**

```bash
ssh root@159.65.37.77 "
  su - claude-automation -c '/root/claude-agents/scripts/volatility-scan.sh'
"
```

**Expected:** Comprehensive volatility analysis table with trading signals

---

## 📊 Monitoring

### **View Cron Logs:**

```bash
# Real-time monitoring
ssh root@159.65.37.77 "tail -f /root/claude-agents/logs/volatility.log"

# Recent executions
ssh root@159.65.37.77 "tail -100 /root/claude-agents/logs/daily-scan.log"

# All logs
ssh root@159.65.37.77 "ls -lh /root/claude-agents/logs/"
```

### **Check Cron Status:**

```bash
# View scheduled jobs
ssh root@159.65.37.77 "su - claude-automation -c 'crontab -l'"

# Recent cron executions
ssh root@159.65.37.77 "grep CRON /var/log/syslog | tail -20"
```

### **System Monitoring:**

```bash
# Check if scripts are running
ssh root@159.65.37.77 "ps aux | grep claude"

# Check resource usage
ssh root@159.65.37.77 "top -b -n 1 | head -20"
```

---

## 🔄 Development Workflow

### **Day-to-Day Development:**

1. **Develop locally:**
   - Edit agents in `.claude/agents/`
   - Edit commands in `.claude/commands/`
   - Test locally first

2. **Deploy to cloud:**
   ```bash
   /deploy-cloud
   ```

3. **Test on cloud:**
   ```bash
   ssh root@159.65.37.77 "
     su - claude-automation -c '/root/claude-agents/scripts/test-script.sh'
   "
   ```

4. **Monitor automation:**
   ```bash
   ssh root@159.65.37.77 "tail -f /root/claude-agents/logs/script-name.log"
   ```

### **Rollback if Needed:**

```bash
# Restore from backup (manual)
ssh root@159.65.37.77 "
  cd /root/claude-agents &&
  mv .claude .claude.backup &&
  tar -xzf previous-deploy-backup.tar.gz
"
```

---

## 📝 Available Automation Scripts

### **1. daily-market-scan.sh**
- **Frequency:** Daily at 9 AM UTC
- **Purpose:** Full market intelligence email
- **Agent:** Uses `/uber_email` command
- **Output:** Email report + log file

### **2. volatility-scan.sh**
- **Frequency:** Every 4 hours
- **Purpose:** Options volatility opportunities
- **Agent:** `volatility-analyzer`
- **Output:** IV rank analysis with trading signals

### **3. weekly-portfolio.sh**
- **Frequency:** Sunday 6 PM UTC
- **Purpose:** Comprehensive portfolio review
- **Agent:** Multiple agents (fundamental, technical, volatility)
- **Output:** Email report

### **4. put-scanner.sh**
- **Frequency:** Weekdays at 3 PM UTC
- **Purpose:** Cash-secured put opportunities
- **Agent:** Uses `/csp-scanner` command
- **Output:** Put-selling recommendations

### **5. earnings-alerts.sh**
- **Frequency:** Monday 8 AM UTC
- **Purpose:** Weekly earnings calendar
- **MCP Tool:** `get_earnings_calendar`
- **Output:** 7-day earnings preview

---

## 🛡️ Security

### **Best Practices:**

✅ **DO:**
- Run automation as `claude-automation` user (non-root)
- Use `--dangerously-skip-permissions` only for automation
- Monitor logs regularly
- Set timeouts on all scripts (e.g., `timeout 600`)
- Keep `.env` file secure with API keys
- Use symlinks instead of duplicating files

❌ **DON'T:**
- Run Claude Code as root with auto-permissions
- Expose logs with sensitive data
- Skip error handling in scripts
- Run automation without monitoring
- Hardcode API keys in scripts

### **Permissions:**

```bash
/root/claude-agents/              # 755 (readable by claude-automation)
/root/claude-agents/scripts/      # 755 (executable by claude-automation)
/root/claude-agents/scripts/*.sh  # 755 (executable)
/root/claude-agents/logs/         # 755 (writable by claude-automation)
```

---

## 🎯 Quick Reference

### **Deploy Agents:**
```bash
/deploy-cloud
```

### **Test on Cloud:**
```bash
ssh root@159.65.37.77 "su - claude-automation -c '/root/claude-agents/scripts/volatility-scan.sh'"
```

### **View Logs:**
```bash
ssh root@159.65.37.77 "tail -f /root/claude-agents/logs/volatility.log"
```

### **Update Cron:**
```bash
ssh root@159.65.37.77 "su - claude-automation" then "crontab -e"
```

---

## ✅ Verification Checklist

- [x] Local `.claude/` directory organized
- [x] Remote `/root/claude-agents/` created
- [x] `claude-automation` user configured
- [x] Agents deployed and symlinked
- [x] Automation scripts deployed
- [x] MCP tools accessible
- [x] Test script executed successfully
- [x] Documentation complete

---

## 🎉 Success!

**Status:** 🟢 **FULLY OPERATIONAL**

You can now:
- ✅ Develop agents locally
- ✅ Deploy with one command
- ✅ Automate via cron
- ✅ Monitor execution logs
- ✅ Run financial analysis 24/7

**Tested:** Volatility scanner executed successfully with full analysis output!

---

## 📞 Support

**For deployment issues:**
- Check `deploy/deploy-to-cloud.md`
- Verify symlinks: `ls -la /root/.claude/`
- Test manually before automation

**For automation issues:**
- Check logs: `/root/claude-agents/logs/`
- Verify permissions: `ls -la /root/claude-agents/scripts/`
- Test script manually first
- Check cron syntax: `crontab -l`

**For agent issues:**
- Use `cloud-sre` agent for troubleshooting
- Check MCP server status
- Verify API keys in `/opt/fin-mcp/.env`
