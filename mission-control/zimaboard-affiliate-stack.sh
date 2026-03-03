#!/bin/bash
# Zimaboard Affiliate Stack Deployment
# Deploys the complete affiliate marketing automation stack

ZIMA_IP="192.168.4.65"

echo "💰 Deploying Affiliate Marketing Stack to Zimaboard"
echo "===================================================="
echo ""

cat << 'EOF'

📦 RECOMMENDED STACK:

1. N8N (Workflow Automation)
   - Port: 5678
   - Image: n8nio/n8n:latest
   - Purpose: Connect OpenArt.AI → Facebook Ads API → CRM

2. Redis (Queue/Cache)
   - Port: 6379
   - Image: redis:alpine
   - Purpose: Job queue for bulk image generation

3. PostgreSQL (Database)
   - Port: 5432
   - Image: postgres:15-alpine
   - Purpose: Store campaigns, creatives, analytics

4. Minio (Object Storage)
   - Ports: 9000, 9001
   - Image: minio/minio
   - Purpose: Store generated ad images locally

📋 DOCKER COMPOSE (save as docker-compose.yml):

version: '3.8'
services:
  n8n:
    image: n8nio/n8n:latest
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=Zima307783!
      - WEBHOOK_URL=http://192.168.4.65:5678/
      - GENERIC_TIMEZONE=America/New_York
    volumes:
      - n8n_data:/home/node/.n8n
    depends_on:
      - redis
      - postgres

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  postgres:
    image: postgres:15-alpine
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_PASSWORD=affiliate307783
      - POSTGRES_DB=affiliate
    volumes:
      - postgres_data:/var/lib/postgresql/data

  minio:
    image: minio/minio
    ports:
      - "9010:9000"
      - "9011:9001"
    environment:
      - MINIO_ROOT_USER=admin
      - MINIO_ROOT_PASSWORD=Zima307783!
    volumes:
      - minio_data:/data
    command: server /data --console-address ":9001"

volumes:
  n8n_data:
  redis_data:
  postgres_data:
  minio_data:

EOF

echo ""
echo "🚀 DEPLOYMENT STEPS:"
echo ""
echo "1. SSH into Zimaboard (or use Portainer console)"
echo "2. Create stack directory:"
echo "   mkdir -p ~/affiliate && cd ~/affiliate"
echo ""
echo "3. Save the docker-compose.yml above"
echo ""
echo "4. Deploy:"
echo "   docker-compose up -d"
echo ""
echo "5. Verify:"
echo "   ./zimaboard-health.sh"
echo ""
echo "🌐 After deployment:"
echo "   N8N:      http://192.168.4.65:5678/"
echo "   Minio:    http://192.168.4.65:9011/"
echo "   Postgres: localhost:5432"
echo "   Redis:    localhost:6379"
