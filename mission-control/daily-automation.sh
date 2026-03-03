#!/bin/bash

# Daily Automation - Run every morning at 8 AM
# Checks system status, updates metrics, generates reports

echo "🤖 Daily Automation - $(date '+%Y-%m-%d %H:%M:%S')"
echo "================================================="
echo ""

WORKSPACE="$HOME/.openclaw/workspace/mission-control"
DATA="$WORKSPACE/data"
LOGS="$WORKSPACE/logs"

# Create logs directory if needed
mkdir -p "$LOGS"

# 1. Health Check
echo "1️⃣ Running health check..."
"$WORKSPACE/health-check.sh" > "$LOGS/health-$(date +%Y-%m-%d).log" 2>&1
echo "✅ Health check saved"
echo ""

# 2. Backup Data
echo "2️⃣ Backing up data..."
"$WORKSPACE/backup.sh" 2>&1 | tail -2
echo ""

# 3. Update Stats
echo "3️⃣ Calculating daily metrics..."

CONTACTS=$(jq '.contacts | length' "$DATA/contacts.json" 2>/dev/null || echo "0")
COMPANIES=$(jq '.companies | length' "$DATA/companies.json" 2>/dev/null || echo "0")
OPPORTUNITIES=$(jq '.opportunities | length' "$DATA/opportunities.json" 2>/dev/null || echo "0")
PIPELINE=$(jq '.totalPipelineValue' "$DATA/opportunities.json" 2>/dev/null || echo "0")

EMAILS_SENT=$(jq '.stats.totalEmailsSent' "$DATA/interactions.json" 2>/dev/null || echo "0")
MEETINGS=$(jq '.stats.totalMeetings' "$DATA/interactions.json" 2>/dev/null || echo "0")
PILOTS=$(jq '.stats.totalPilots' "$DATA/interactions.json" 2>/dev/null || echo "0")

echo "📊 Today's Metrics:"
echo "  Contacts: $CONTACTS"
echo "  Companies: $COMPANIES"
echo "  Opportunities: $OPPORTUNITIES"
echo "  Pipeline: \$$PIPELINE"
echo "  Emails Sent: $EMAILS_SENT"
echo "  Meetings: $MEETINGS"
echo "  Pilots Closed: $PILOTS"
echo ""

# 4. Check Follow-ups Due
echo "4️⃣ Checking follow-ups due today..."
TODAY=$(date +%Y-%m-%d)
jq -r --arg today "$TODAY" '.contacts[] | select(.nextFollowUp == $today) | "  ⚠️  \(.company) - \(.firstName) \(.lastName) (\(.email))"' "$DATA/contacts.json" 2>/dev/null
echo ""

# 5. Check for Overdue Follow-ups
echo "5️⃣ Checking overdue follow-ups..."
jq -r --arg today "$TODAY" '.contacts[] | select(.nextFollowUp < $today) | "  🔴 OVERDUE: \(.company) - \(.nextFollowUp)"' "$DATA/contacts.json" 2>/dev/null
echo ""

# 6. Generate Daily Report
REPORT_FILE="$LOGS/daily-$(date +%Y-%m-%d).txt"
{
  echo "Daily Report - $(date +%Y-%m-%d)"
  echo "================================"
  echo ""
  echo "Metrics:"
  echo "  Contacts: $CONTACTS"
  echo "  Companies: $COMPANIES"
  echo "  Opportunities: $OPPORTUNITIES"
  echo "  Pipeline: \$$PIPELINE"
  echo ""
  echo "Activity:"
  echo "  Emails Sent: $EMAILS_SENT"
  echo "  Meetings: $MEETINGS"
  echo "  Pilots: $PILOTS"
  echo ""
  echo "Next Actions:"
  echo "  1. Set up Smartlead (if not done)"
  echo "  2. Set up Hunter.io (if not done)"
  echo "  3. Deploy landing page (if not done)"
  echo "  4. Launch email sequence (if not done)"
  echo "  5. Follow up with overdue contacts"
} > "$REPORT_FILE"

echo "✅ Daily report saved to: $REPORT_FILE"
echo ""

# 7. Check Tool Status
echo "6️⃣ Checking tool status..."

if [ -f "$HOME/.openclaw/credentials/smartlead.key" ]; then
    echo "  ✅ Smartlead: Connected"
else
    echo "  ⬜ Smartlead: Not connected (https://smartlead.ai)"
fi

if [ -f "$HOME/.openclaw/credentials/hunter.key" ]; then
    echo "  ✅ Hunter.io: Connected"
else
    echo "  ⬜ Hunter.io: Not connected (https://hunter.io)"
fi

echo ""

# 8. Revenue Progress
echo "7️⃣ Revenue Progress:"
TARGET_WEEK1=1
TARGET_WEEK2=5000
TARGET_MONTH1=15000

CURRENT_REVENUE=$((PILOTS * 5000))

if [ "$CURRENT_REVENUE" -eq 0 ]; then
    echo "  Status: Setup phase"
    echo "  Next milestone: First pilot (\$5K)"
else
    PERCENT=$((CURRENT_REVENUE * 100 / TARGET_MONTH1))
    echo "  Current: \$$CURRENT_REVENUE"
    echo "  Month target: \$$TARGET_MONTH1"
    echo "  Progress: ${PERCENT}%"
fi
echo ""

# 9. Recommendations
echo "8️⃣ Recommendations for Today:"

if [ ! -f "$HOME/.openclaw/credentials/smartlead.key" ]; then
    echo "  🔴 Priority: Set up Smartlead email automation"
elif [ ! -f "$HOME/.openclaw/credentials/hunter.key" ]; then
    echo "  🔴 Priority: Set up Hunter.io email finder"
elif [ "$EMAILS_SENT" -eq 0 ]; then
    echo "  🟡 Priority: Launch email sequence to 10 contacts"
elif [ "$MEETINGS" -eq 0 ]; then
    echo "  🟡 Priority: Book first meeting from outreach"
else
    echo "  🟢 Priority: Run demos and close pilots"
fi

echo ""

# 10. Save to master log
echo "Daily automation complete at $(date '+%H:%M:%S')" >> "$LOGS/automation.log"

echo "✅ Daily automation complete!"
echo ""
