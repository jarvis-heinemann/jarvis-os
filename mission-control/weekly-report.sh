#!/bin/bash

# Weekly Report Generator
# Run every Monday morning

echo "📊 Weekly GTM Report - Week of $(date +%Y-%m-%d)"
echo "================================================"
echo ""

WORKSPACE="$HOME/.openclaw/workspace/mission-control"
DATA="$WORKSPACE/data"

# Load data
CONTACTS=$(jq '.contacts | length' "$DATA/contacts.json" 2>/dev/null || echo "0")
COMPANIES=$(jq '.companies | length' "$DATA/companies.json" 2>/dev/null || echo "0")
OPPORTUNITIES=$(jq '.opportunities | length' "$DATA/opportunities.json" 2>/dev/null || echo "0")
PIPELINE=$(jq '.totalPipelineValue' "$DATA/opportunities.json" 2>/dev/null || echo "0")
WEIGHTED_PIPELINE=$(jq '.weightedPipelineValue' "$DATA/opportunities.json" 2>/dev/null || echo "0")

# Email stats (from interactions.json)
EMAILS_SENT=$(jq '.stats.totalEmailsSent' "$DATA/interactions.json" 2>/dev/null || echo "0")
EMAILS_OPENED=$(jq '.stats.totalOpens' "$DATA/interactions.json" 2>/dev/null || echo "0")
EMAILS_REPLIED=$(jq '.stats.totalReplies' "$DATA/interactions.json" 2>/dev/null || echo "0")
MEETINGS=$(jq '.stats.totalMeetings' "$DATA/interactions.json" 2>/dev/null || echo "0")
PILOTS=$(jq '.stats.totalPilots' "$DATA/interactions.json" 2>/dev/null || echo "0")

# Calculate rates
if [ "$EMAILS_SENT" -gt 0 ]; then
    OPEN_RATE=$(echo "scale=1; $EMAILS_OPENED * 100 / $EMAILS_SENT" | bc)
    REPLY_RATE=$(echo "scale=1; $EMAILS_REPLIED * 100 / $EMAILS_SENT" | bc)
else
    OPEN_RATE="0"
    REPLY_RATE="0"
fi

# Section 1: Outreach Metrics
echo "📧 Outreach Metrics"
echo "-------------------"
echo "Emails Sent: $EMAILS_SENT"
echo "Open Rate: ${OPEN_RATE}% (target: 30%)"
echo "Reply Rate: ${REPLY_RATE}% (target: 10%)"
echo "Meetings Booked: $MEETINGS"
echo ""

# Section 2: Pipeline Health
echo "💼 Pipeline Health"
echo "------------------"
echo "Total Opportunities: $OPPORTUNITIES"
echo "Total Pipeline Value: \$$PIPELINE"
echo "Weighted Pipeline: \$$WEIGHTED_PIPELINE"
echo ""

# Pipeline by stage
echo "By Stage:"
jq -r '.pipeline | to_entries[] | "  \(.key): \(.value | length)"' "$DATA/opportunities.json" 2>/dev/null
echo ""

# Section 3: Revenue Progress
echo "💰 Revenue Progress"
echo "-------------------"
echo "Pilots Closed: $PILOTS"
echo "Pilot Revenue: \$$(($PILOTS * 5000))"
echo "MRR: \$$(($PILOTS * 2500))"
echo ""

# Section 4: This Week's Targets
echo "🎯 This Week's Targets"
echo "----------------------"
echo "Outreach:"
echo "  - Send 10 new emails"
echo "  - Book 3 meetings"
echo "  - Reply to all responses within 2 hours"
echo ""
echo "Pipeline:"
echo "  - Move 2 opportunities to 'interest' stage"
echo "  - Close 1 pilot (\$5K)"
echo ""
echo "Infrastructure:"
echo "  - [ ] Set up Smartlead (if not done)"
echo "  - [ ] Set up Hunter.io (if not done)"
echo "  - [ ] Deploy landing page (if not done)"
echo "  - [ ] Launch email sequence (if not done)"
echo ""

# Section 5: Top Priorities
echo "🔥 Top 3 Priorities This Week"
echo "-----------------------------"
if [ "$PILOTS" -eq 0 ]; then
    echo "1. Close first pilot customer (\$5K)"
else
    echo "1. Close pilot #$((PILOTS + 1)) (\$5K)"
fi

if [ "$MEETINGS" -lt 3 ]; then
    echo "2. Book $((3 - MEETINGS)) more meetings"
else
    echo "2. Run demos for booked meetings"
fi

if [ ! -f "$HOME/.openclaw/credentials/smartlead.key" ]; then
    echo "3. Set up Smartlead email automation"
else
    echo "3. Scale outreach to 50 accounts"
fi
echo ""

# Section 6: Blockers
echo "⚠️  Blockers"
echo "------------"
if [ ! -f "$HOME/.openclaw/credentials/smartlead.key" ]; then
    echo "  - Smartlead not configured (blocks email automation)"
fi
if [ ! -f "$HOME/.openclaw/credentials/hunter.key" ]; then
    echo "  - Hunter.io not configured (blocks contact enrichment)"
fi
if [ "$EMAILS_SENT" -eq 0 ]; then
    echo "  - No emails sent yet (need to launch campaign)"
fi
echo ""

# Section 7: Quick Wins
echo "✅ Quick Wins (Complete Today)"
echo "------------------------------"
echo "  - Review email templates in outbound-templates.md"
echo "  - Personalize subject lines for top 3 accounts"
echo "  - Prepare demo deck for meetings"
echo "  - Research top 10 accounts (find pain points)"
echo ""

# Save report
REPORT_FILE="$WORKSPACE/logs/weekly-report-$(date +%Y-%m-%d).txt"
mkdir -p "$WORKSPACE/logs"
{
    echo "Weekly GTM Report - $(date +%Y-%m-%d)"
    echo ""
    echo "Outreach:"
    echo "  Emails: $EMAILS_SENT"
    echo "  Opens: ${OPEN_RATE}%"
    echo "  Replies: ${REPLY_RATE}%"
    echo "  Meetings: $MEETINGS"
    echo ""
    echo "Pipeline:"
    echo "  Total: \$$PIPELINE"
    echo "  Weighted: \$$WEIGHTED_PIPELINE"
    echo ""
    echo "Revenue:"
    echo "  Pilots: $PILOTS"
    echo "  Revenue: \$$(($PILOTS * 5000))"
} > "$REPORT_FILE"

echo "📄 Report saved to: $REPORT_FILE"
echo ""
