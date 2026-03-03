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
