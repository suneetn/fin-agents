#!/bin/bash
# Email Batch Sender - Send emails in batches of 3 to work around Mailgun limits
# Usage: send-email-batch.sh EMAIL_CSV SUBJECT HTML_FILE [BATCH_SIZE]

set -euo pipefail

# Configuration
EMAIL_CSV="${1:?Email CSV file required}"
SUBJECT="${2:?Email subject required}"
HTML_FILE="${3:?HTML file required}"
BATCH_SIZE="${4:-3}"  # Default: 3 recipients per batch
MCP_CONFIG="${MCP_CONFIG:-$HOME/.claude/mcp.json}"
LOG_PREFIX="${LOG_PREFIX:-[EMAIL_BATCH]}"

# Logging function
log() {
    echo "$LOG_PREFIX $(date +'%Y-%m-%d %H:%M:%S') $*"
}

error() {
    echo "$LOG_PREFIX $(date +'%Y-%m-%d %H:%M:%S') ERROR: $*" >&2
}

# Validate inputs
if [[ ! -f "$EMAIL_CSV" ]]; then
    error "Email CSV file not found: $EMAIL_CSV"
    exit 1
fi

if [[ ! -f "$HTML_FILE" ]]; then
    error "HTML file not found: $HTML_FILE"
    exit 1
fi

if [[ ! -f "$MCP_CONFIG" ]]; then
    error "MCP config not found: $MCP_CONFIG"
    exit 1
fi

# Load Claude authentication
if [[ -f "$HOME/.bashrc.claude" ]]; then
    source "$HOME/.bashrc.claude"
fi

# Read HTML content (escape single quotes for JSON)
HTML_CONTENT=$(cat "$HTML_FILE" | sed "s/'/'\\\\''/g")

# Read email addresses from CSV (skip header, get first column, trim whitespace)
mapfile -t ALL_EMAILS < <(tail -n +2 "$EMAIL_CSV" | cut -d',' -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep -v '^$')

TOTAL_EMAILS=${#ALL_EMAILS[@]}
log "Total recipients: $TOTAL_EMAILS"
log "Batch size: $BATCH_SIZE"

# Calculate number of batches
NUM_BATCHES=$(( (TOTAL_EMAILS + BATCH_SIZE - 1) / BATCH_SIZE ))
log "Sending in $NUM_BATCHES batches..."

# Send emails in batches
BATCH_NUM=1
SUCCESS_COUNT=0
FAIL_COUNT=0

for ((i=0; i<TOTAL_EMAILS; i+=BATCH_SIZE)); do
    # Extract batch of emails
    BATCH_EMAILS=("${ALL_EMAILS[@]:i:BATCH_SIZE}")
    BATCH_COUNT=${#BATCH_EMAILS[@]}

    log "Batch $BATCH_NUM/$NUM_BATCHES: Sending to $BATCH_COUNT recipients..."

    # Convert batch to JSON array format
    BATCH_JSON="["
    FIRST=true
    for email in "${BATCH_EMAILS[@]}"; do
        if [[ "$FIRST" = true ]]; then
            BATCH_JSON="${BATCH_JSON}'${email}'"
            FIRST=false
        else
            BATCH_JSON="${BATCH_JSON}, '${email}'"
        fi
    done
    BATCH_JSON="${BATCH_JSON}]"

    log "Recipients: ${BATCH_EMAILS[*]}"

    # Send email to this batch
    EMAIL_RESULT=$(timeout 120 claude --print \
        --dangerously-skip-permissions \
        --mcp-config "$MCP_CONFIG" \
        -- "Send an email using the mcp__fmp-weather-global__send_email_mailgun tool.

Parameters:
- to_addresses: $BATCH_JSON
- subject: '$SUBJECT'
- content: '''$HTML_CONTENT'''
- is_html: true
- tags: ['batch-send', 'batch-$BATCH_NUM']

Execute the email send now." 2>&1)

    EMAIL_EXIT=$?

    if [[ $EMAIL_EXIT -eq 0 ]]; then
        log "✅ Batch $BATCH_NUM sent successfully"
        SUCCESS_COUNT=$((SUCCESS_COUNT + BATCH_COUNT))

        # Log Mailgun response
        if echo "$EMAIL_RESULT" | grep -q "message_id"; then
            MESSAGE_ID=$(echo "$EMAIL_RESULT" | grep -o '"message_id":"[^"]*"' | cut -d'"' -f4)
            log "Message ID: $MESSAGE_ID"
        fi
    else
        error "❌ Batch $BATCH_NUM failed with exit code $EMAIL_EXIT"
        error "Output: $EMAIL_RESULT"
        FAIL_COUNT=$((FAIL_COUNT + BATCH_COUNT))
    fi

    # Add delay between batches (respect rate limits)
    if [[ $BATCH_NUM -lt $NUM_BATCHES ]]; then
        log "Waiting 5 seconds before next batch..."
        sleep 5
    fi

    BATCH_NUM=$((BATCH_NUM + 1))
done

# Summary
log "========================================="
log "Email batch sending completed"
log "Total batches: $NUM_BATCHES"
log "Successful: $SUCCESS_COUNT recipients"
log "Failed: $FAIL_COUNT recipients"
log "========================================="

if [[ $FAIL_COUNT -gt 0 ]]; then
    error "Some emails failed to send"
    exit 1
fi

exit 0
