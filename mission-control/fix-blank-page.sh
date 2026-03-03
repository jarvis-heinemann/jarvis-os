#!/bin/bash

# Mission Control - Fix Blank Page
# Restores working version

echo "🔧 Fixing blank page issue..."
echo ""

cd ~/.openclaw/workspace/mission-control

# Check if broken version exists
if [ -f "index-broken.html" ]; then
    echo "✅ Found broken version (backed up as index-broken.html)"
fi

# Restore working v2 version
if [ -f "index-v2-backup.html" ]; then
    echo "✅ Restoring working version..."
    cp index-v2-backup.html index.html
    echo "✅ Fixed! Opening dashboard..."
    open index.html
else
    echo "❌ No backup found. Please redownload from original files."
fi

echo ""
echo "📊 Mission Control v2 restored (working version)"
echo "🔄 To add Convex later, use index-convex-fixed.html"
