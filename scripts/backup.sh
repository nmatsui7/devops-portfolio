#!/usr/bin/env bash
set -euo pipefail

BACKUP_BUCKET="${BACKUP_BUCKET:-s3://example-portfolio-backups}"
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USER:-portfolio}"
DB_NAME="${DB_NAME:-portfolio}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="/tmp/portfolio_${TIMESTAMP}.sql.gz"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

cleanup() {
    rm -f "$BACKUP_FILE"
}
trap cleanup EXIT

log "Starting database backup"

if [[ -z "${DB_PASSWORD:-}" ]]; then
    echo "ERROR: DB_PASSWORD is not set" >&2
    exit 1
fi

export PGPASSWORD="$DB_PASSWORD"

pg_dump \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    -U "$DB_USER" \
    -d "$DB_NAME" \
    --no-owner \
    --no-acl \
    --format=custom \
    | gzip > "$BACKUP_FILE"

log "Backup completed: $(du -h "$BACKUP_FILE" | cut -f1)"

aws s3 cp "$BACKUP_FILE" "${BACKUP_BUCKET}/daily/${TIMESTAMP}.sql.gz" \
    --storage-class STANDARD_IA

aws s3 cp "$BACKUP_FILE" "${BACKUP_BUCKET}/latest.sql.gz"

log "Backup uploaded to ${BACKUP_BUCKET}"

if [[ "$(date +%u)" -eq 7 ]]; then
    WEEKLY_FILE="${BACKUP_BUCKET}/weekly/$(date +%Y)/week_$(date +%V).sql.gz"
    aws s3 cp "$BACKUP_FILE" "$WEEKLY_FILE" --storage-class GLACIER
    log "Weekly backup stored in Glacier"
fi

log "Backup completed successfully"
