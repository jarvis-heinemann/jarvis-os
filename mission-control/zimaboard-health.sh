#!/bin/bash
# Zimaboard Health Check Script
# Checks the status of all services on the Zimaboard

ZIMA_IP="192.168.4.65"

echo "🔍 Zimaboard Health Check"
echo "========================="
echo ""

# Check ZimaOS
echo "📡 ZimaOS (Port 80):"
if curl -s --connect-timeout 3 "http://$ZIMA_IP/" | grep -q "ZimaOS"; then
    echo "   ✅ Online"
else
    echo "   ❌ Offline"
fi

# Check Portainer
echo "🐳 Portainer (Port 9000):"
RESPONSE=$(curl -s --connect-timeout 3 "http://$ZIMA_IP:9000/api/status" 2>/dev/null)
if [ -n "$RESPONSE" ]; then
    VERSION=$(echo "$RESPONSE" | grep -o '"Version":"[^"]*"' | cut -d'"' -f4)
    echo "   ✅ Online (v$VERSION)"
else
    echo "   ❌ Offline"
fi

# Check N8N (if deployed)
echo "⚡ N8N (Port 5678):"
if curl -s --connect-timeout 3 "http://$ZIMA_IP:5678/healthz" > /dev/null 2>&1; then
    echo "   ✅ Online"
else
    echo "   ⚪ Not deployed"
fi

echo ""
echo "📋 Access URLs:"
echo "   ZimaOS:     http://$ZIMA_IP/"
echo "   Portainer:  http://$ZIMA_IP:9000/"
echo "   N8N:        http://$ZIMA_IP:5678/ (if deployed)"
