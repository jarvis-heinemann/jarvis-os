#!/bin/bash

# GTM Automation Setup Script
# Purpose: Initialize all GTM tools and configurations
# Run once to set up the entire infrastructure

set -e

echo "🚀 GTM Automation Setup"
echo "======================="
echo ""

# Configuration
DOMAIN="claimhaus.com"
EMAIL="gabriel@claimhaus.com"
WORKSPACE="$HOME/.openclaw/workspace/mission-control"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Step 1: Check prerequisites
echo -e "${BLUE}Step 1: Checking prerequisites...${NC}"

if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js first."
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "❌ Git not found. Please install Git first."
    exit 1
fi

echo "✅ Prerequisites check passed"
echo ""

# Step 2: Create directory structure
echo -e "${BLUE}Step 2: Creating directory structure...${NC}"

mkdir -p "$WORKSPACE/data"
mkdir -p "$WORKSPACE/logs"
mkdir -p "$WORKSPACE/backups"
mkdir -p "$WORKSPACE/templates"

echo "✅ Directory structure created"
echo ""

# Step 3: Initialize CRM data files
echo -e "${BLUE}Step 3: Initializing CRM data...${NC}"

cat > "$WORKSPACE/data/contacts.json" <<EOF
{
  "contacts": [],
  "lastUpdated": "$(date -Iseconds)"
}
EOF

cat > "$WORKSPACE/data/companies.json" <<EOF
{
  "companies": [],
  "lastUpdated": "$(date -Iseconds)"
}
EOF

cat > "$WORKSPACE/data/opportunities.json" <<EOF
{
  "opportunities": [],
  "lastUpdated": "$(date -Iseconds)"
}
EOF

cat > "$WORKSPACE/data/interactions.json" <<EOF
{
  "interactions": [],
  "lastUpdated": "$(date -Iseconds)"
}
EOF

echo "✅ CRM data files initialized"
echo ""

# Step 4: Create configuration file
echo -e "${BLUE}Step 4: Creating configuration...${NC}"

cat > "$WORKSPACE/data/config.json" <<EOF
{
  "shells": {
    "ClaimHaus": {
      "vertical": "distressed-debt",
      "targetBuyers": ["Debt Buyers", "Portfolio Managers", "Collections Directors"],
      "email": "gabriel@claimhaus.com",
      "domain": "claimhaus.com",
      "active": true
    },
    "Ignis": {
      "vertical": "robotics-fire-rescue",
      "targetBuyers": ["Fire Chiefs", "Emergency Managers", "Safety Directors"],
      "email": "gabriel@ignisrobotics.com",
      "domain": "ignisrobotics.com",
      "active": false
    },
    "Saybrook": {
      "vertical": "procurement-savings",
      "targetBuyers": ["CFOs", "Finance Directors", "Procurement Officers"],
      "email": "gabriel@saybrooksolutions.com",
      "domain": "saybrooksolutions.com",
      "active": false
    },
    "HeinemannCapital": {
      "vertical": "real-estate-fund",
      "targetBuyers": ["Family Offices", "Allocators", "RIAs"],
      "email": "gabriel@heinemanncapital.com",
      "domain": "heinemanncapital.com",
      "active": false
    },
    "GraphNative": {
      "vertical": "ai-governance",
      "targetBuyers": ["CTOs", "VP Engineering", "Platform Architects"],
      "email": "gabriel@graphnative.ai",
      "domain": "graphnative.ai",
      "active": false
    }
  },
  "emailProviders": {
    "smartlead": {
      "status": "not-connected",
      "cost": 80,
      "priority": 1
    },
    "hunter": {
      "status": "not-connected",
      "cost": 49,
      "priority": 1
    }
  },
  "dataProviders": {
    "serper": {
      "status": "not-connected",
      "cost": 100
    },
    "apollo": {
      "status": "not-connected",
      "cost": 99
    },
    "piloterr": {
      "status": "not-connected",
      "cost": 49
    }
  },
  "settings": {
    "maxEmailsPerDay": 50,
    "followupDelay": 3,
    "trackOpens": true,
    "trackClicks": true,
    "autoFollowup": true
  }
}
EOF

echo "✅ Configuration created"
echo ""

# Step 5: Create backup script
echo -e "${BLUE}Step 5: Creating backup script...${NC}"

cat > "$WORKSPACE/backup.sh" <<'BACKUP_EOF'
#!/bin/bash

BACKUP_DIR="$HOME/.openclaw/workspace/mission-control/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$DATE.tar.gz"

tar -czf "$BACKUP_FILE" \
  -C "$HOME/.openclaw/workspace/mission-control" \
  data/

echo "✅ Backup created: $BACKUP_FILE"

# Keep only last 30 backups
ls -t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +31 | xargs -r rm

echo "✅ Old backups cleaned (keeping last 30)"
BACKUP_EOF

chmod +x "$WORKSPACE/backup.sh"

echo "✅ Backup script created"
echo ""

# Step 6: Create email sync script
echo -e "${BLUE}Step 6: Creating email sync placeholder...${NC}"

cat > "$WORKSPACE/sync-emails.sh" <<'SYNC_EOF'
#!/bin/bash

echo "📧 Email Sync"
echo "============="
echo ""
echo "This script will sync email engagement data from Smartlead"
echo ""
echo "Prerequisites:"
echo "  1. Sign up for Smartlead (https://smartlead.ai)"
echo "  2. Get API key from Settings → API"
echo "  3. Add API key to ~/.openclaw/credentials/smartlead.key"
echo ""
echo "Current status: Not configured"
echo ""
echo "To configure:"
echo "  mkdir -p ~/.openclaw/credentials"
echo "  echo 'YOUR_API_KEY' > ~/.openclaw/credentials/smartlead.key"
echo "  ./sync-emails.sh"
SYNC_EOF

chmod +x "$WORKSPACE/sync-emails.sh"

echo "✅ Email sync script created (placeholder)"
echo ""

# Step 7: Create TAM builder script
echo -e "${BLUE}Step 7: Creating TAM builder...${NC}"

cat > "$WORKSPACE/build-tam.js" <<'TAM_EOF'
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const DATA_DIR = path.join(process.env.HOME, '.openclaw/workspace/mission-control/data');

console.log('🎯 TAM Builder');
console.log('==============\n');

// Load TAM lists from GTM Launchpad
const gtmLaunchpad = require(path.join(DATA_DIR, '..', 'gtm-launchpad.js'));

console.log('Available TAM Lists:');
Object.keys(gtmLaunchpad.GTMLaunchpad.tamLists).forEach(shell => {
  console.log(`  - ${shell}`);
});

console.log('\nUsage:');
console.log('  1. Add contacts to data/contacts.json');
console.log('  2. Run node build-tam.js [shell-name]');
console.log('  3. View enriched TAM in Mission Control\n');

// TODO: Implement actual TAM building logic
// - Load priority accounts
// - Enrich with Hunter.io
// - Score based on ICP fit
// - Save to contacts.json
TAM_EOF

chmod +x "$WORKSPACE/build-tam.js"

echo "✅ TAM builder script created"
echo ""

# Step 8: Create daily report script
echo -e "${BLUE}Step 8: Creating daily report...${NC}"

cat > "$WORKSPACE/daily-report.sh" <<'REPORT_EOF'
#!/bin/bash

echo "📊 Daily GTM Report - $(date +%Y-%m-%d)"
echo "========================================"
echo ""

DATA_DIR="$HOME/.openclaw/workspace/mission-control/data"

# Count contacts
CONTACTS=$(jq '.contacts | length' "$DATA_DIR/contacts.json" 2>/dev/null || echo "0")
echo "📋 Total Contacts: $CONTACTS"

# Count companies
COMPANIES=$(jq '.companies | length' "$DATA_DIR/companies.json" 2>/dev/null || echo "0")
echo "🏢 Total Companies: $COMPANIES"

# Count opportunities
OPPORTUNITIES=$(jq '.opportunities | length' "$DATA_DIR/opportunities.json" 2>/dev/null || echo "0")
echo "💼 Total Opportunities: $OPPORTUNITIES"

# Pipeline value
PIPELINE=$(jq '[.opportunities[].value] | add // 0' "$DATA_DIR/opportunities.json" 2>/dev/null || echo "0")
echo "💰 Pipeline Value: \$$PIPELINE"

echo ""
echo "Next Actions:"
echo "  - [ ] Follow up with [prospect]"
echo "  - [ ] Send case study to [prospect]"
echo "  - [ ] Schedule demo with [prospect]"
echo ""
echo "To update: Edit data/*.json files"
REPORT_EOF

chmod +x "$WORKSPACE/daily-report.sh"

echo "✅ Daily report script created"
echo ""

# Step 9: Install dependencies (if package.json exists)
if [ -f "$WORKSPACE/package.json" ]; then
    echo -e "${BLUE}Step 9: Installing dependencies...${NC}"
    cd "$WORKSPACE"
    npm install
    echo "✅ Dependencies installed"
    echo ""
fi

# Step 10: Summary
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo ""
echo "What's next:"
echo ""
echo "1. 📧 Set up Smartlead ($80/mo)"
echo "   → https://smartlead.ai"
echo "   → Connect gabriel@claimhaus.com"
echo ""
echo "2. 🔍 Set up Hunter.io ($49/mo)"
echo "   → https://hunter.io"
echo "   → Install Chrome extension"
echo ""
echo "3. 📋 Upload target accounts"
echo "   → Open Mission Control dashboard"
echo "   → Go to Shell Factory → GTM Engine"
echo "   → Add 10 ClaimHaus priority accounts"
echo ""
echo "4. 🚀 Launch email sequence"
echo "   → Configure templates in Smartlead"
echo "   → Upload contacts"
echo "   → Schedule for Monday 9 AM"
echo ""
echo "5. 🌐 Deploy landing page"
echo "   → Buy claimhaus.com (if not owned)"
echo "   → Deploy landing-pages/claimhaus.html to Vercel/Netlify"
echo ""
echo "Tools created:"
echo "  - backup.sh - Backup data files"
echo "  - sync-emails.sh - Sync email engagement (needs config)"
echo "  - build-tam.js - Build TAM lists"
echo "  - daily-report.sh - Daily metrics summary"
echo ""
echo "Data files:"
echo "  - data/contacts.json"
echo "  - data/companies.json"
echo "  - data/opportunities.json"
echo "  - data/interactions.json"
echo "  - data/config.json"
echo ""
echo "📚 Documentation:"
echo "  - ACTION-PLAN.md"
echo "  - claimhaus-launch-kit.md"
echo "  - outbound-templates.md"
echo "  - claimhaus-pitch-deck.md"
echo "  - case-study-template.md"
echo ""
echo "Dashboard: http://localhost:8888"
echo ""
