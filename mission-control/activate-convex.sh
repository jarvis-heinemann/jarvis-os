#!/bin/bash

# Mission Control v3 - Convex Activation
# Switches to Convex-enabled dashboard

echo "🚀 Activating Mission Control v3 with Convex..."
echo ""

cd ~/.openclaw/workspace/mission-control

# Backup old index
if [ -f "index.html" ]; then
    echo "📦 Backing up old index.html..."
    cp index.html index-v2-backup.html
fi

# Activate Convex version
if [ -f "index-convex.html" ]; then
    echo "✅ Activating Convex-enabled dashboard..."
    cp index-convex.html index.html
fi

echo ""
echo "✅ Mission Control v3 activated!"
echo ""
echo "📊 Dashboard: index.html"
echo "☁️  Convex: https://aromatic-basilisk-680.convex.cloud"
echo "📁 Backup: index-v2-backup.html"
echo ""
echo "🔄 Next steps:"
echo "  1. Open: open index.html"
echo "  2. Check sync status (green dot = connected)"
echo "  3. Add your first idea"
echo "  4. Select your flagship"
echo ""
echo "See CONVEX-DEPLOYED.md for details"
