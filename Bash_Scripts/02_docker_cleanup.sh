#!/bin/bash
# ============================================================
# 02 - Docker Cleanup
# Removes stopped containers, dangling images, unused volumes
# and networks. Frees disk space safely.
# ============================================================

set -euo pipefail

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

log()  { echo -e "[$(date '+%H:%M:%S')] $*"; }
run()  { if $DRY_RUN; then echo "[DRY-RUN] $*"; else eval "$*"; fi; }

log "Docker Disk Usage (BEFORE):"
docker system df

log "Removing stopped containers..."
CONTAINERS=$(docker ps -aq --filter "status=exited" --filter "status=dead")
if [[ -n "$CONTAINERS" ]]; then
  run "docker rm $CONTAINERS"
  log "Removed containers: $(echo "$CONTAINERS" | wc -l)"
else
  log "No stopped containers found."
fi

log "Removing dangling images..."
IMAGES=$(docker images -qf "dangling=true")
if [[ -n "$IMAGES" ]]; then
  run "docker rmi $IMAGES"
else
  log "No dangling images found."
fi

log "Removing unused volumes..."
run "docker volume prune -f"

log "Removing unused networks..."
run "docker network prune -f"

log "Removing build cache older than 24h..."
run "docker builder prune --filter 'until=24h' -f"

log ""
log "Docker Disk Usage (AFTER):"
docker system df

log "Cleanup complete!"
