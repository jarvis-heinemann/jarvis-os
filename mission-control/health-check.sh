#!/bin/bash

# Jarvis Health Check - Run every heartbeat (10 min)
# Checks what needs attention and reports to Gabriel

echo "💓 Jarvis Health Check - $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================================="
echo ""

WORKSPACE="$HOME/.openclaw/workspace/mission-control"
DATA="$WORKSPACE/data"

# Check 1: Server Status
echo "🌐 Server Status:"
if curl -s http://localhost:8888/ > /dev/null 2>&1; then
    echo "  ✅ Mission Control dashboard running"
else
    echo "  ⚠️  Dashboard not running - start with: python3 -m http.server 8888"
fi
echo ""

# Check 2: CRM Status
echo "📊 CRM Status:"
CONTACTS=$(jq '.contacts | length' "$DATA/contacts.json" 2>/dev/null || echo "0")
COMPANIES=$(jq '.companies | length' "$DATA/companies.json" 2>/dev/null || echo "0")
OPPORTUNITIES=$(jq '.opportunities | length' "$DATA/opportunities.json" 2>/dev/null || echo "0")
PIPELINE=$(jq '.totalPipelineValue' "$DATA/opportunities.json" 2>/dev/null || echo "0")

echo "  📋 Contacts: $CONTACTS"
echo "  🏢 Companies: $COMPANIES"
echo "  💼 Opportunities: $OPPORTUNITIES"
echo "  💰 Pipeline Value: \$$PIPELINE"
echo ""

# Check 3: Tools Status
echo "🛠️  Tools Status:"
if [ -f "$HOME/.openclaw/credentials/smartlead.key" ]; then
    echo "  ✅ Smartlead: API key configured"
else
    echo "  ⬜ Smartlead: Not configured (sign up at smartlead.ai)"
fi

if [ -f "$HOME/.openclaw/credentials/hunter.key" ]; then
    echo "  ✅ Hunter.io: API key configured"
else
    echo "  ⬜ Hunter.io: Not configured (sign up at hunter.io)"
fi
echo ""

# Check 4: Landing Page Status
echo "🌐 Landing Page Status:"
if [ -f "$WORKSPACE/landing-pages/claimhaus.html" ]; then
    echo "  ✅ ClaimHaus: HTML ready to deploy"
    echo "  📋 Next: Deploy to Vercel or Netlify"
else
    echo "  ⬜ ClaimHaus: Landing page not found"
fi
echo ""

# Check 5: Email Sequence Status
echo "📧 Email Sequence Status:"
if [ "$CONTACTS" -gt 0 ]; then
    echo "  ✅ $CONTACTS contacts ready for outreach"
    echo "  📋 Next: Configure sequence in Smartlead"
else
    echo "  ⬜ No contacts uploaded yet"
fi
echo ""

# Check 6: Outstanding Actions
echo "🎯 Outstanding Actions:"
echo "  1. Sign up for Smartlead (\$80/mo) - https://smartlead.ai"
echo "  2. Sign up for Hunter.io (\$49/mo) - https://hunter.io"
echo "  3. Deploy ClaimHaus landing page - vercel.com"
echo "  4. Configure email sequence in Smartlead"
echo "  5. Launch campaign Monday 9 AM"
echo ""

# Check 7: Revenue Progress
echo "💰 Revenue Progress:"
echo "  Target (Week 1): 1 meeting booked"
echo "  Target (Week 2): 1 pilot closed (\$5K)"
echo "  Target (Month 1): 3 pilots (\$15K)"
echo "  Current: Setup phase - no revenue yet"
echo ""

# Check 8: Next Follow-ups
echo "📅 Next Follow-ups (from CRM):"
jq -r '.contacts[] | select(.nextFollowUp != null) | "  \(.nextFollowUp) - \(.company) (\(.firstName) \(.lastName))"' "$DATA/contacts.json" 2>/dev/null | sort | head -5
echo ""

# Summary
echo "💡 Summary:"
if [ "$CONTACTS" -eq 0 ]; then
    echo "  ⚠️  Priority: Upload contacts to CRM"
elif [ ! -f "$HOME/.openclaw/credentials/smartlead.key" ]; then
    echo "  ⚠️  Priority: Set up Smartlead email automation"
elif [ ! -f "$HOME/.openclaw/credentials/hunter.key" ]; then
    echo "  ⚠️  Priority: Set up Hunter.io for email finding"
else
    echo "  ✅ All tools configured - ready to launch!"
    echo "  📋 Next: Deploy landing page + launch email sequence"
fi
echo ""

echo "📚 Quick Links:"
echo "  Dashboard: http://localhost:8888"
echo "  Quick Start: cat $WORKSPACE/QUICK-START.md"
echo "  Action Plan: cat $WORKSPACE/ACTION-PLAN.md"
echo "  Launch Kit: cat $WORKSPACE/claimhaus-launch-kit.md"
echo ""
