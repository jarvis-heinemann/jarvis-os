#!/bin/bash
# Complete Zimaboard Affiliate Engine Deployment
# Run this once SSH access is enabled

set -e

ZIMA_IP="192.168.4.65"
ZIMA_USER="Spinnaker"
ZIMA_PASS="307783"

echo "🚀 Complete Affiliate Engine Deployment"
echo "========================================"
echo ""

# Check if we're running locally on the Zimaboard or remotely
if hostname | grep -qi "zima\|casa"; then
    echo "✅ Running on Zimaboard"
    DEPLOY_DIR="/home/Spinnaker/affiliate-engine"
else
    echo "📡 Deploying remotely to $ZIMA_IP"
    DEPLOY_DIR="/home/Spinnaker/affiliate-engine"
fi

# Create deployment directory
mkdir -p "$DEPLOY_DIR"
cd "$DEPLOY_DIR"

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  n8n:
    image: n8nio/n8n:latest
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=Zima307783!
      - WEBHOOK_URL=http://192.168.4.65:5678/
      - GENERIC_TIMEZONE=America/New_York
      - TZ=America/New_York
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=affiliate
      - DB_POSTGRESDB_USER=postgres
      - DB_POSTGRESDB_PASSWORD=affiliate307783
      - QUEUE_BULL_REDIS_HOST=redis
    volumes:
      - n8n_data:/home/node/.n8n
      - ./workflows:/home/node/.n8n/workflows
    depends_on:
      - redis
      - postgres

  redis:
    image: redis:alpine
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  postgres:
    image: postgres:15-alpine
    restart: unless-stopped
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_PASSWORD=affiliate307783
      - POSTGRES_DB=affiliate
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./schema.sql:/docker-entrypoint-initdb.d/schema.sql

  minio:
    image: minio/minio
    restart: unless-stopped
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

# Copy schema and workflows
mkdir -p workflows
cp /Users/jarvisheinemann/.openclaw/workspace/mission-control/n8n-workflows/schema.sql ./schema.sql
cp /Users/jarvisheinemann/.openclaw/workspace/mission-control/n8n-workflows/*.json ./workflows/

# Deploy stack
echo ""
echo "🚀 Deploying containers..."
docker-compose up -d

# Wait for services to start
echo ""
echo "⏳ Waiting for services to initialize..."
sleep 30

# Check health
echo ""
echo "🔍 Checking service health..."
curl -s http://localhost:5678/healthz > /dev/null && echo "✅ N8N is running" || echo "⚠️  N8N starting..."
curl -s http://localhost:9010/minio/health/live > /dev/null && echo "✅ Minio is running" || echo "⚠️  Minio starting..."

# Create Minio bucket
echo ""
echo "📦 Creating Minio bucket..."
docker exec $(docker ps -q -f name=minio) mc alias set local http://localhost:9000 admin Zima307783! 2>/dev/null || true
docker exec $(docker ps -q -f name=minio) mc mb local/affiliate-ads 2>/dev/null || true

echo ""
echo "✅ Deployment Complete!"
echo ""
echo "🌐 Access URLs:"
echo "   N8N:      http://192.168.4.65:5678/"
echo "   Minio:    http://192.168.4.65:9011/"
echo "   Postgres: localhost:5432 (user: postgres, pass: affiliate307783)"
echo "   Redis:    localhost:6379"
echo ""
echo "📋 Next Steps:"
echo "   1. Open N8N: http://192.168.4.65:5678/"
echo "   2. Login: admin / Zima307783!"
echo "   3. Import workflows from ./workflows/"
echo "   4. Add credentials (OpenArt, Facebook, Minio, Postgres)"
echo "   5. Activate workflows"
