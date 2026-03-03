#!/bin/bash
# Zimaboard N8N Deployment Script
# Deploys N8N workflow automation to the Zimaboard 16G server

ZIMA_IP="192.168.4.65"
ZIMA_USER="Spinnaker"
ZIMA_PASS="307783"

echo "🚀 Deploying N8N to Zimaboard ($ZIMA_IP)..."

# Check if Zimaboard is reachable
if ! curl -s --connect-timeout 5 "http://$ZIMA_IP/" > /dev/null; then
    echo "❌ Cannot reach Zimaboard at $ZIMA_IP"
    exit 1
fi

echo "✅ Zimaboard is online"

# N8N Docker deployment command for Portainer
# Run this in Portainer's console or via SSH:
cat << 'EOF'

📋 MANUAL STEPS (Portainer UI):

1. Open: http://192.168.4.65:9000/
2. Login: Spinnaker / 307783
3. Go to: Containers → Add Container
4. Configure:
   - Name: n8n
   - Image: n8nio/n8n:latest
   - Port mapping: 5678:5678
   - Volumes: /home/node/.n8n → Map to local folder
   - Environment:
     N8N_BASIC_AUTH_ACTIVE=true
     N8N_BASIC_AUTH_USER=admin
     N8N_BASIC_AUTH_PASSWORD=Zima307783!
     WEBHOOK_URL=http://192.168.4.65:5678/
     GENERIC_TIMEZONE=America/New_York

5. Deploy container

🌐 After deployment:
   - N8N UI: http://192.168.4.65:5678/
   - Login: admin / Zima307783!

EOF

echo ""
echo "📌 Quick Docker CLI command (if SSH available):"
echo "docker run -d --name n8n -p 5678:5678 -v ~/.n8n:/home/node/.n8n -e N8N_BASIC_AUTH_ACTIVE=true -e N8N_BASIC_AUTH_USER=admin -e N8N_BASIC_AUTH_PASSWORD=Zima307783! -e WEBHOOK_URL=http://192.168.4.65:5678/ n8nio/n8n:latest"
