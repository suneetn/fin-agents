# Daily Email Automation Test Suite

Comprehensive testing framework for Black Swan Monitor and Uber Email cron job automations.

## Overview

The test suite validates all aspects of the remote automation infrastructure:
- Infrastructure (SSH, users, Claude CLI)
- Script installation and permissions
- Cron job configuration
- Agent availability
- MCP tools and API access
- Email delivery
- Integration tests
- Log validation
- Monitoring and health checks

## Quick Start

### Basic Tests (Fast - ~2 minutes)
```bash
cd automation
./test-suite.sh --quick
```

### Full Tests (Includes 5-min integration test)
```bash
./test-suite.sh
```

### Complete Suite (Includes 75-min uber email test)
```bash
./test-suite.sh --full
```

## Test Suites

### Suite 1: Infrastructure Tests
- SSH connectivity to remote server
- Claude automation user exists
- Claude CLI installed
- Authentication configured
- MCP config exists

**Runtime**: ~10 seconds

### Suite 2: Script Installation Tests
- Black swan script exists and executable
- Uber email script exists and executable
- Emails CSV exists with valid content

**Runtime**: ~5 seconds

### Suite 3: Cron Configuration Tests
- Crontab exists for claude-automation user
- Both cron jobs configured correctly
- Eastern Time (TZ=America/New_York) configured
- Weekdays-only schedule (1-5) configured

**Runtime**: ~5 seconds

### Suite 4: Agent Availability Tests
- systemic-risk-monitor agent exists
- market-pulse-analyzer exists
- quality-assessor exists
- smart-money-interpreter exists
- volatility-analyzer exists
- comparative-stock-analyzer exists
- trading-idea-generator exists
- output-formatter exists

**Runtime**: ~15 seconds

### Suite 5: MCP Tools Tests
- MCP config is valid JSON
- FMP API key configured
- Mailgun API key configured
- MCP tools accessible via Claude CLI

**Runtime**: ~30 seconds

### Suite 6: Quick Component Tests
- Single MCP tool call (get_vix_data)
- Single agent execution (market-pulse-analyzer quick test)

**Runtime**: ~2 minutes (can be skipped with --quick)

### Suite 7a: Black Swan Integration Test
- Full black swan script execution
- Email delivery confirmation
- Script completion validation

**Runtime**: ~5 minutes (can be skipped with --skip-integration)

### Suite 7b: Uber Email Integration Test
- Full 8-step uber email execution
- All 6 agents complete successfully
- Professional HTML formatting
- Email to 9 recipients

**Runtime**: ~75 minutes (only runs with --full flag)

### Suite 8: Log Validation Tests
- Log directory exists
- Recent logs present
- Error checking in logs

**Runtime**: ~10 seconds

### Suite 9: Email Delivery Tests
- Email CSV readable
- Multiple recipients configured
- Mailgun test email send

**Runtime**: ~30 seconds

### Suite 10: Monitoring & Status Tests
- Check for running jobs
- Disk space validation
- Log file size checks

**Runtime**: ~10 seconds

### Suite 11: Cron Simulation Tests
- Scripts run in minimal cron-like environment
- Timezone handling validation

**Runtime**: ~15 seconds

## Command Line Options

### --quick
Skip slow component tests (single agent execution).
```bash
./test-suite.sh --quick
```

### --skip-integration
Skip the 5-minute black swan integration test.
```bash
./test-suite.sh --skip-integration
```

### --full
Run complete suite including 75-minute uber email test.
```bash
./test-suite.sh --full
```

### --help
Display usage information.
```bash
./test-suite.sh --help
```

## Environment Variables

### SKIP_LONG_TESTS
Control whether to run the 75-minute uber email test.
```bash
SKIP_LONG_TESTS=0 ./test-suite.sh  # Enable long test
SKIP_LONG_TESTS=1 ./test-suite.sh  # Disable (default)
```

### SKIP_INTEGRATION
Control whether to run the 5-minute black swan integration test.
```bash
SKIP_INTEGRATION=1 ./test-suite.sh  # Disable
SKIP_INTEGRATION=0 ./test-suite.sh  # Enable (default)
```

### QUICK_MODE
Skip slow component tests.
```bash
QUICK_MODE=1 ./test-suite.sh
```

## Test Output

### Console Output
Colorized test results with:
- 🔵 Info messages (blue)
- ✓ Success messages (green)
- ✗ Failure messages (red)
- ⚠ Warning messages (yellow)

### Test Results Directory
All test logs saved to: `test-results/`

Files created:
```
test-results/
├── Remote_SSH_connection.log
├── Claude_CLI_installed.log
├── black-swan-integration-20251123-154530.log
├── uber-email-integration-20251123-170045.log
└── ... (one file per test)
```

## Usage Examples

### Pre-Deployment Validation
Test everything before setting up cron jobs:
```bash
./test-suite.sh
```

### Daily Health Check
Quick validation that everything is still working:
```bash
./test-suite.sh --quick --skip-integration
```

### Full End-to-End Validation
Complete validation including actual email sends (run on weekends):
```bash
./test-suite.sh --full
```

### Troubleshooting Mode
Run specific suites by commenting out others in the script, or check logs:
```bash
./test-suite.sh 2>&1 | tee test-run.log
cat test-results/*.log | grep -i error
```

## Interpreting Results

### All Tests Passed
```
======================================================================
Test Suite Complete - Sat Nov 23 15:45:30 EST 2025
======================================================================

Tests Run:    42
✓ Tests Passed: 42
✗ Tests Failed: 0

✓ All tests passed! ✓
```

Exit code: 0

### Some Tests Failed
```
======================================================================
Test Suite Complete - Sat Nov 23 15:45:30 EST 2025
======================================================================

Tests Run:    42
✓ Tests Passed: 38
✗ Tests Failed: 4

✗ Some tests failed. Check logs in: test-results/
```

Exit code: 1

Check individual test logs in `test-results/` directory.

## Continuous Integration

### GitHub Actions Example
```yaml
name: Daily Automation Tests

on:
  schedule:
    - cron: '0 12 * * 6'  # Saturdays at noon
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup SSH key
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
      - name: Run test suite
        run: |
          cd automation
          ./test-suite.sh --quick
```

### Cron Job for Weekly Validation
```bash
# Add to local crontab
# Run test suite every Saturday at 10 AM
0 10 * * 6 cd /path/to/fin-agent-with-claude/automation && ./test-suite.sh --quick > ~/test-results-$(date +\%Y\%m\%d).log 2>&1
```

## Maintenance

### Update Test Suite
```bash
# Edit test suite
vim automation/test-suite.sh

# Test locally first
./automation/test-suite.sh --quick

# Commit and deploy
git add automation/test-suite.sh
git commit -m "Update test suite"
git push
```

### Add New Test
Add to appropriate test suite function:
```bash
run_test "New test name" \
    "ssh $REMOTE_HOST 'command to run'"
```

### Disable Specific Tests
Comment out test runs in main() function:
```bash
# test_integration_uber_email  # Temporarily disabled
```

## Troubleshooting

### SSH Connection Fails
```bash
# Test SSH manually
ssh root@159.65.37.77 'echo success'

# Check SSH key permissions
ls -la ~/.ssh/
```

### Agent Not Found
```bash
# List available agents
ssh root@159.65.37.77 "su - claude-automation -c 'ls ~/.claude/agents/'"

# Check agent symlinks
ssh root@159.65.37.77 "su - claude-automation -c 'readlink ~/.claude/agents'"
```

### MCP Tools Not Working
```bash
# Test MCP server directly
ssh root@159.65.37.77 "su - claude-automation -c 'claude --print --list-tools'"

# Check MCP config
ssh root@159.65.37.77 "su - claude-automation -c 'cat ~/.claude/mcp.json'"
```

### Email Not Sending
```bash
# Test Mailgun directly
ssh root@159.65.37.77 "su - claude-automation -c 'claude --print -- \"Send test email via Mailgun\"'"

# Check Mailgun API key
ssh root@159.65.37.77 "su - claude-automation -c 'grep MAILGUN ~/.claude/mcp.json'"
```

## Test Coverage

| Component | Coverage | Tests |
|-----------|----------|-------|
| Infrastructure | 100% | 5 tests |
| Scripts | 100% | 6 tests |
| Cron Config | 100% | 5 tests |
| Agents | 100% | 8 tests |
| MCP Tools | 100% | 4 tests |
| Components | 80% | 2 tests |
| Integration | 100% | 2 tests |
| Logs | 100% | 3 tests |
| Email | 100% | 3 tests |
| Monitoring | 100% | 3 tests |
| Simulation | 100% | 2 tests |

**Total: 43 automated tests**

## Performance

### Quick Mode
- Runtime: ~1 minute
- Tests: Infrastructure + Config + Agents + MCP
- Good for: Daily health checks

### Standard Mode
- Runtime: ~6 minutes
- Tests: Everything except uber email integration
- Good for: Pre-deployment validation

### Full Mode
- Runtime: ~80 minutes
- Tests: Complete end-to-end including uber email
- Good for: Weekly validation, regression testing

## Security

- No credentials stored in test suite
- SSH key required for remote access
- All tests run as claude-automation user (non-root)
- Logs sanitized of sensitive data

## Support

For issues or questions:
1. Check test logs in `test-results/`
2. Review individual test output files
3. Run specific tests manually for debugging
4. Check remote server logs: `/home/claude-automation/logs/`
