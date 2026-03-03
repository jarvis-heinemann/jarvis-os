#!/bin/bash

# Mission Control Launcher
# Opens the Command Center dashboard

cd ~/.openclaw/workspace/mission-control

echo "⚡ Opening Mission Control..."
echo ""
echo "   Flagship: $(cat data.json | grep -o '"flagship":"[^"]*"' | cut -d'"' -f4 || echo 'Not selected')"
echo "   Ideas: $(cat data.json | grep -o '"ideas":\[' -c || echo '0')"
echo "   Projects: $(cat data.json | grep -o '"projects":\[' -c || echo '0')"
echo ""

# Try to open in default browser
if command -v open &> /dev/null; then
    open index.html
elif command -v xdg-open &> /dev/null; then
    xdg-open index.html
else
    echo "Open manually: file://$(pwd)/index.html"
fi

echo "✅ Mission Control launched"
echo ""
echo "Remember:"
echo "  • One flagship. One seed. One task."
echo "  • Build the MVU, not the galaxy."
echo "  • Stay at altitude. Delegate the rest."
