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
