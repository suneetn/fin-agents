---
description: "Generate market pulse analysis report and email it using Zapier"
allowed-tools:
  - Task
  - mcp__fmp-weather-global__*
  - mcp__zapier__gmail_send_email
argument-hint: "[email_address]"
---

# Market Pulse Email Report

Generate a comprehensive market pulse analysis and email the formatted report using the Zapier Gmail integration.

## Usage Examples:
- `/market-pulse-email` - Send to default email
- `/market-pulse-email user@example.com` - Send to specific email
- `/market-pulse-email john@company.com` - Send to recipient

## Implementation

### Step 1: Generate Market Analysis
```
Use the Task tool with subagent_type: "market-pulse-analyzer"
Prompt: "Generate today's market pulse analysis for email report"
```

### Step 2: Send Email Report
```
Use mcp__zapier__gmail_send_email with:
- to: [email from $1 argument or default]
- subject: "QuantHub.ai Market Pulse Analysis - [Current Date]"
- body: [analysis results from Step 1]
- body_type: "html"
- instructions: "Send market pulse analysis report"
```

## Configuration

**Default Email**: Use `suneetn@quanthub.ai` if no email argument provided

**Subject Format**: `"QuantHub.ai Market Pulse Analysis - YYYY-MM-DD"`

**Content**: The market-pulse-analyzer agent automatically generates professional HTML-formatted reports with all necessary sections

## Success Confirmation

Upon successful completion:
```
✅ Market Analysis Generated
✅ Email Sent to: [email_address]
📧 Subject: Market Pulse Analysis - [date]
```

## Requirements

- market-pulse-analyzer agent available
- Zapier Gmail integration configured
- Gmail account connected to Zapier