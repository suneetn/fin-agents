# Cloud Agent Deployment Guide

## Quick Deploy

**Using cloud-sre agent:**
```
"Deploy latest agents to cloud server"
```

## Manual Deployment

### Step 1: SSH to Server
```bash
ssh root@159.65.37.77
```

### Step 2: Pull Latest Changes
```bash
cd /root/claude-agents
git pull origin main
```

### Step 3: Verify Deployment
```bash
# List deployed agents
ls -la .claude/agents/

# List deployed commands
ls -la .claude/commands/

# Test agent loading
source ~/.bashrc.claude
claude --print \
  --setting-sources /root/claude-agents/.claude \
  -- "List available agents"
```

## Automated Deployment

Create a slash command: `.claude/commands/deploy-cloud.md`

```markdown
---
description: Deploy agents to cloud server
---

Use cloud-sre agent to:
1. SSH to root@159.65.37.77
2. Navigate to /root/claude-agents
3. Run git pull origin main
4. Verify agents and commands loaded
5. Report deployment status
```

## Rollback

```bash
ssh root@159.65.37.77 "cd /root/claude-agents && git reset --hard HEAD~1"
```

## Deployment Checklist

- [ ] Test agents locally first
- [ ] Commit and push to GitHub
- [ ] Deploy to cloud server
- [ ] Verify agent loading
- [ ] Test automation scripts
- [ ] Monitor logs for issues
