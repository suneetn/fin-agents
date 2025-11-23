---
description: Deploy agents and commands to cloud server via GitHub
allowed-tools:
  - Bash
  - Read
---

# Deploy Agents to Cloud Server (GitHub)

Deploy the latest agents and commands to 159.65.37.77 via git push/pull.

## Prerequisites

Ensure GitHub remote is configured:
```bash
git remote -v
# Should show: origin  https://github.com/YOUR_USERNAME/fin-agent-with-claude.git
```

If not set up, see `.github-setup.md`

## Deployment Steps:

1. **Commit local changes:**
   ```bash
   git add .claude/ automation/ deploy/
   git commit -m "Update agents and automation scripts"
   ```

2. **Push to GitHub:**
   ```bash
   git push origin main
   ```

3. **Pull on remote server:**
   ```bash
   ssh root@159.65.37.77 "
     cd /root/claude-agents &&
     git pull origin main &&
     echo '✅ Agents deployed successfully' &&
     echo &&
     echo 'Latest commit:' &&
     git log -1 --oneline &&
     echo &&
     echo 'Deployed agents:' &&
     ls -1 .claude/agents/ | wc -l &&
     echo 'Deployed commands:' &&
     ls -1 .claude/commands/ | wc -l
   "
   ```

4. **Verify deployment:**
   ```bash
   ssh root@159.65.37.77 "
     su - claude-automation -c '
       source ~/.bashrc.claude &&
       claude --print \
         --mcp-config ~/.claude/mcp.json \
         --dangerously-skip-permissions \
         -- \"List the first 5 available agents\"
     '
   "
   ```

## Rollback (if needed)

```bash
# Rollback to previous commit
ssh root@159.65.37.77 "
  cd /root/claude-agents &&
  git reset --hard HEAD~1 &&
  git log -1 --oneline
"
```

## Quick Deploy

Just run: `/deploy-cloud`

This will:
1. Commit and push your changes
2. Pull updates on remote server
3. Verify deployment
