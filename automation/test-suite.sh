#!/bin/bash
# Comprehensive Test Suite for Daily Email Automations
# Tests both Black Swan Monitor and Uber Email cron jobs

set -euo pipefail

# Configuration
REMOTE_HOST="root@159.65.37.77"
REMOTE_USER="claude-automation"
TEST_RESULTS_DIR="$(pwd)/test-results"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging
log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $*"
}

success() {
    echo -e "${GREEN}✓${NC} $*"
}

error() {
    echo -e "${RED}✗${NC} $*"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $*"
}

# Create test results directory
mkdir -p "$TEST_RESULTS_DIR"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

run_test() {
    local test_name="$1"
    local test_command="$2"

    TESTS_RUN=$((TESTS_RUN + 1))
    log "Running: $test_name"

    if eval "$test_command" > "$TEST_RESULTS_DIR/${test_name// /_}.log" 2>&1; then
        success "$test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        error "$test_name"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

###############################################################################
# TEST SUITE 1: Infrastructure Tests
###############################################################################

test_remote_connectivity() {
    log "=== TEST SUITE 1: Infrastructure Tests ==="

    run_test "Remote SSH connection" \
        "ssh -o ConnectTimeout=5 $REMOTE_HOST 'echo success'"

    run_test "Claude automation user exists" \
        "ssh $REMOTE_HOST 'id $REMOTE_USER'"

    run_test "Claude CLI installed" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"which claude\"'"

    run_test "Claude authentication configured" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"test -f ~/.bashrc.claude\"'"

    run_test "MCP config exists" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"test -f ~/.claude/mcp.json\"'"
}

###############################################################################
# TEST SUITE 2: Script Installation Tests
###############################################################################

test_script_installation() {
    log "=== TEST SUITE 2: Script Installation Tests ==="

    run_test "Black swan script exists" \
        "ssh $REMOTE_HOST 'test -f /root/claude-agents/automation/examples/daily-black-swan-monitor.sh'"

    run_test "Black swan script is executable" \
        "ssh $REMOTE_HOST 'test -x /root/claude-agents/automation/examples/daily-black-swan-monitor.sh'"

    run_test "Uber email script exists" \
        "ssh $REMOTE_HOST 'test -f /root/claude-agents/automation/examples/daily-uber-email.sh'"

    run_test "Uber email script is executable" \
        "ssh $REMOTE_HOST 'test -x /root/claude-agents/automation/examples/daily-uber-email.sh'"

    run_test "Emails CSV exists" \
        "ssh $REMOTE_HOST 'test -f /root/claude-agents/emails.csv'"

    run_test "Emails CSV has valid content" \
        "ssh $REMOTE_HOST 'grep -q \"@\" /root/claude-agents/emails.csv'"
}

###############################################################################
# TEST SUITE 3: Cron Configuration Tests
###############################################################################

test_cron_configuration() {
    log "=== TEST SUITE 3: Cron Configuration Tests ==="

    run_test "Crontab exists for claude-automation" \
        "ssh $REMOTE_HOST 'crontab -u $REMOTE_USER -l > /dev/null 2>&1'"

    run_test "Black swan cron job configured" \
        "ssh $REMOTE_HOST 'crontab -u $REMOTE_USER -l | grep -q \"daily-black-swan-monitor.sh\"'"

    run_test "Uber email cron job configured" \
        "ssh $REMOTE_HOST 'crontab -u $REMOTE_USER -l | grep -q \"daily-uber-email.sh\"'"

    run_test "Cron jobs use Eastern Time" \
        "ssh $REMOTE_HOST 'crontab -u $REMOTE_USER -l | grep -q \"TZ=America/New_York\"'"

    run_test "Cron jobs run weekdays only" \
        "ssh $REMOTE_HOST 'crontab -u $REMOTE_USER -l | grep -q \"1-5\"'"
}

###############################################################################
# TEST SUITE 4: Agent Availability Tests
###############################################################################

test_agent_availability() {
    log "=== TEST SUITE 4: Agent Availability Tests ==="

    # Required agents for black swan
    run_test "systemic-risk-monitor agent exists" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"test -f ~/.claude/agents/black-swan-monitor.md || ls ~/.claude/agents/ | grep -i systemic\"'"

    # Required agents for uber email
    local agents=("market-pulse-analyzer" "quality-assessor" "smart-money-interpreter"
                  "volatility-analyzer" "comparative-stock-analyzer" "trading-idea-generator"
                  "output-formatter")

    for agent in "${agents[@]}"; do
        run_test "Agent $agent exists" \
            "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"test -f ~/.claude/agents/${agent}.md\"'"
    done
}

###############################################################################
# TEST SUITE 5: MCP Tools Tests
###############################################################################

test_mcp_tools() {
    log "=== TEST SUITE 5: MCP Tools Tests ==="

    run_test "MCP server config is valid JSON" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"python3 -m json.tool ~/.claude/mcp.json > /dev/null\"'"

    run_test "FMP API key configured" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"grep -q FMP_API_KEY ~/.claude/mcp.json\"'"

    run_test "Mailgun API key configured" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"grep -q MAILGUN_API_KEY ~/.claude/mcp.json\"'"

    run_test "MCP tools accessible via Claude CLI" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"timeout 30 claude --print --list-tools 2>&1 | grep -q mcp__fmp-weather-global\"'"
}

###############################################################################
# TEST SUITE 6: Quick Component Tests (Fast)
###############################################################################

test_quick_components() {
    log "=== TEST SUITE 6: Quick Component Tests (~2 min each) ==="

    warning "Testing single MCP tool call..."
    run_test "MCP tool: get_vix_data" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"timeout 60 claude --print --dangerously-skip-permissions -- \\\"Use mcp__fmp-weather-global__get_vix_data to get current VIX\\\" 2>&1 | grep -q VIX\"'"

    warning "Testing single agent execution (this takes ~2 minutes)..."
    if [ "${QUICK_MODE:-0}" -eq 0 ]; then
        run_test "Single agent: market-pulse-analyzer (quick test)" \
            "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"timeout 180 claude --print --max-turns 5 --dangerously-skip-permissions -- \\\"Use market-pulse-analyzer to provide a 2-sentence market overview\\\" 2>&1 | grep -iq \\\"market\\|vix\\|sector\\\"\"'"
    else
        warning "Skipping single agent test (quick mode enabled)"
    fi
}

###############################################################################
# TEST SUITE 7: Integration Tests (Slow)
###############################################################################

test_integration_black_swan() {
    log "=== TEST SUITE 7a: Black Swan Integration Test (~5 min) ==="

    if [ "${SKIP_INTEGRATION:-0}" -eq 1 ]; then
        warning "Skipping integration test (SKIP_INTEGRATION=1)"
        return 0
    fi

    local test_log="$TEST_RESULTS_DIR/black-swan-integration-$TIMESTAMP.log"

    log "Running full black swan monitor script..."
    warning "This will take ~5 minutes and send test email..."

    if ssh $REMOTE_HOST "su - $REMOTE_USER -c '/root/claude-agents/automation/examples/daily-black-swan-monitor.sh'" > "$test_log" 2>&1; then
        success "Black swan integration test completed"

        # Validate output
        if grep -q "Email sent successfully" "$test_log"; then
            success "Email delivery confirmed"
        else
            error "Email delivery not confirmed in logs"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi

        if grep -q "completed successfully" "$test_log"; then
            success "Script completed successfully"
        else
            error "Script did not complete successfully"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi

        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        error "Black swan integration test failed"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi

    TESTS_RUN=$((TESTS_RUN + 1))
}

test_integration_uber_email() {
    log "=== TEST SUITE 7b: Uber Email Integration Test (~75 min) ==="

    if [ "${SKIP_LONG_TESTS:-1}" -eq 1 ]; then
        warning "Skipping uber email integration test (SKIP_LONG_TESTS=1)"
        warning "To run: SKIP_LONG_TESTS=0 ./test-suite.sh"
        return 0
    fi

    local test_log="$TEST_RESULTS_DIR/uber-email-integration-$TIMESTAMP.log"

    log "Running full uber email script..."
    warning "This will take ~75 minutes and send test email to 9 recipients..."

    if ssh $REMOTE_HOST "su - $REMOTE_USER -c '/root/claude-agents/automation/examples/daily-uber-email.sh'" > "$test_log" 2>&1; then
        success "Uber email integration test completed"

        # Validate all 8 steps
        for step in {1..8}; do
            if grep -q "Step $step/" "$test_log"; then
                success "Step $step completed"
            else
                error "Step $step not found in logs"
                TESTS_FAILED=$((TESTS_FAILED + 1))
            fi
        done

        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        error "Uber email integration test failed"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi

    TESTS_RUN=$((TESTS_RUN + 1))
}

###############################################################################
# TEST SUITE 8: Log Validation Tests
###############################################################################

test_log_validation() {
    log "=== TEST SUITE 8: Log Validation Tests ==="

    run_test "Log directory exists" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"test -d ~/logs\"'"

    run_test "Recent black swan logs exist" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"ls ~/logs/black-swan-* 2>/dev/null | head -1\"'"

    # Check for errors in recent logs
    log "Checking recent logs for errors..."
    if ssh $REMOTE_HOST "su - $REMOTE_USER -c 'grep -i \"error\\|failed\\|timeout\" ~/logs/daily-black-swan-monitor-*.log 2>/dev/null | tail -5'"; then
        warning "Found errors in recent black swan logs"
    else
        success "No recent errors in black swan logs"
    fi
}

###############################################################################
# TEST SUITE 9: Email Delivery Tests
###############################################################################

test_email_delivery() {
    log "=== TEST SUITE 9: Email Delivery Tests ==="

    run_test "Email recipients CSV readable" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"cat /root/claude-agents/emails.csv | wc -l\"'"

    run_test "Multiple recipients configured" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"tail -n +2 /root/claude-agents/emails.csv | grep -c @\"'"

    warning "Sending test email via Mailgun MCP tool..."
    run_test "Mailgun test email" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"timeout 60 claude --print --dangerously-skip-permissions -- \\\"Use mcp__fmp-weather-global__send_email_mailgun to send test email to suneetn@gmail.com with subject '\''Test Suite Validation'\'' and content '\''Automation test successful'\''\\\"\"'"
}

###############################################################################
# TEST SUITE 10: Monitoring & Status Tests
###############################################################################

test_monitoring() {
    log "=== TEST SUITE 10: Monitoring & Status Tests ==="

    # Check if any jobs are currently running
    log "Checking for running automation jobs..."
    if ssh $REMOTE_HOST 'ps aux | grep -E "(daily-black-swan-monitor|daily-uber-email)" | grep -v grep'; then
        warning "Found running automation jobs"
    else
        success "No automation jobs currently running"
    fi

    # Check disk space
    run_test "Sufficient disk space available" \
        "ssh $REMOTE_HOST 'df -h /home/$REMOTE_USER | tail -1 | awk \"{print \\\$5}\" | sed \"s/%//\" | awk \"{exit \\\$1 < 80 ? 0 : 1}\"'"

    # Check log file sizes
    run_test "Log files not excessively large" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"find ~/logs -type f -size +100M\" | wc -l | awk \"{exit \\\$1 == 0 ? 0 : 1}\"'"
}

###############################################################################
# TEST SUITE 11: Cron Simulation Tests
###############################################################################

test_cron_simulation() {
    log "=== TEST SUITE 11: Cron Simulation Tests ==="

    # Test cron environment simulation
    warning "Testing scripts in cron-like environment..."

    run_test "Black swan script runs in minimal environment" \
        "ssh $REMOTE_HOST 'su - $REMOTE_USER -c \"env -i HOME=/home/$REMOTE_USER PATH=/usr/bin:/bin SHELL=/bin/bash bash -c '\''source ~/.bashrc.claude && which claude'\\''\"'"

    # Test timezone handling
    run_test "Timezone environment variable works" \
        "ssh $REMOTE_HOST 'TZ=America/New_York date +%Z | grep -q EST\\|EDT'"
}

###############################################################################
# Main Execution
###############################################################################

main() {
    log "======================================================================"
    log "Daily Email Automation Test Suite - Started at $(date)"
    log "======================================================================"
    log ""
    log "Test Results Directory: $TEST_RESULTS_DIR"
    log "Remote Host: $REMOTE_HOST"
    log "Remote User: $REMOTE_USER"
    log ""

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --quick)
                export QUICK_MODE=1
                warning "Quick mode enabled - skipping slow tests"
                ;;
            --skip-integration)
                export SKIP_INTEGRATION=1
                warning "Skipping integration tests"
                ;;
            --full)
                export SKIP_LONG_TESTS=0
                warning "Full test mode - including 75-minute uber email test"
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --quick              Skip slow component tests"
                echo "  --skip-integration   Skip 5-minute integration tests"
                echo "  --full               Run full suite including 75-minute test"
                echo "  --help               Show this help message"
                echo ""
                echo "Environment Variables:"
                echo "  SKIP_LONG_TESTS=0    Enable long tests (default: 1)"
                echo "  SKIP_INTEGRATION=1   Disable integration tests (default: 0)"
                echo "  QUICK_MODE=1         Enable quick mode (default: 0)"
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                exit 1
                ;;
        esac
        shift
    done

    # Run test suites
    test_remote_connectivity
    log ""

    test_script_installation
    log ""

    test_cron_configuration
    log ""

    test_agent_availability
    log ""

    test_mcp_tools
    log ""

    test_quick_components
    log ""

    test_integration_black_swan
    log ""

    test_integration_uber_email
    log ""

    test_log_validation
    log ""

    test_email_delivery
    log ""

    test_monitoring
    log ""

    test_cron_simulation
    log ""

    # Final summary
    log "======================================================================"
    log "Test Suite Complete - $(date)"
    log "======================================================================"
    log ""
    log "Tests Run:    $TESTS_RUN"
    success "Tests Passed: $TESTS_PASSED"
    error "Tests Failed: $TESTS_FAILED"
    log ""

    if [ $TESTS_FAILED -eq 0 ]; then
        success "All tests passed! ✓"
        exit 0
    else
        error "Some tests failed. Check logs in: $TEST_RESULTS_DIR"
        exit 1
    fi
}

# Run main function
main "$@"
