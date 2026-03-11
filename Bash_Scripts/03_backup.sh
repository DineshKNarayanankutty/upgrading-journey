#!/bin/bash
# ============================================================
# 03 - Automated Backup with Retention Policy
# Backs up a directory, compresses it, and removes old backups
# Usage: ./03_backup.sh /path/to/source /path/to/backup_dest
# ============================================================

set -euo pipefail

SOURCE_DIR="${1:?Usage: $0 <source_dir> <backup_dir>}"
BACKUP_DIR="${2:?Usage: $0 <source_dir> <backup_dir>}"
RETAIN_DAYS="${3:-7}"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
HOSTNAME=$(hostname -s)
ARCHIVE_NAME="${HOSTNAME}_$(basename "$SOURCE_DIR")_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

# Validate source
[[ -d "$SOURCE_DIR" ]] || { log "ERROR: Source '$SOURCE_DIR' not found."; exit 1; }

# Create backup destination
mkdir -p "$BACKUP_DIR"

log "Starting backup: $SOURCE_DIR -> $ARCHIVE_PATH"

# Create compressed archive, excluding common junk
tar --exclude='*.pyc'          \
    --exclude='__pycache__'    \
    --exclude='.git'           \
    --exclude='node_modules'   \
    --exclude='*.log'          \
    -czf "$ARCHIVE_PATH"       \
    -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

ARCHIVE_SIZE=$(du -sh "$ARCHIVE_PATH" | cut -f1)
CHECKSUM=$(sha256sum "$ARCHIVE_PATH" | cut -d' ' -f1)

log "Backup complete: $ARCHIVE_PATH ($ARCHIVE_SIZE)"
log "SHA256: $CHECKSUM"

# Write manifest
MANIFEST="${BACKUP_DIR}/backup_manifest.log"
echo "${TIMESTAMP} | ${ARCHIVE_NAME} | ${ARCHIVE_SIZE} | ${CHECKSUM}" >> "$MANIFEST"

# Retention policy: remove archives older than RETAIN_DAYS
log "Applying retention policy: keeping last ${RETAIN_DAYS} days..."
DELETED=$(find "$BACKUP_DIR" -maxdepth 1 -name "*.tar.gz" \
          -mtime "+${RETAIN_DAYS}" -print -delete | wc -l)
log "Removed ${DELETED} old archive(s)."

log "Backup directory contents:"
ls -lh "$BACKUP_DIR"/*.tar.gz 2>/dev/null || log "No archives found."
