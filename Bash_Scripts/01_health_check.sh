#!/bin/bash
# ============================================================
# 01 - System Health Check
# Checks CPU, memory, disk, and running services
# ============================================================

set -euo pipefail

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; NC='\033[0m'

SERVICES=("docker" "nginx" "ssh")
CPU_THRESHOLD=85
MEM_THRESHOLD=85
DISK_THRESHOLD=85

log() { echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"; }

check_cpu() {
  local cpu_idle
  cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | tr -d '%id,')
  local cpu_usage=$(echo "100 - $cpu_idle" | bc 2>/dev/null || echo "N/A")
  if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l 2>/dev/null || echo 0) )); then
    echo -e "${RED}[WARN] CPU Usage: ${cpu_usage}%${NC}"
  else
    echo -e "${GREEN}[OK]   CPU Usage: ${cpu_usage}%${NC}"
  fi
}

check_memory() {
  local mem_total mem_used mem_pct
  mem_total=$(free -m | awk '/^Mem:/{print $2}')
  mem_used=$(free -m  | awk '/^Mem:/{print $3}')
  mem_pct=$(awk "BEGIN {printf \"%.1f\", ($mem_used/$mem_total)*100}")
  if (( $(echo "$mem_pct > $MEM_THRESHOLD" | bc -l) )); then
    echo -e "${RED}[WARN] Memory Usage: ${mem_pct}% (${mem_used}MB / ${mem_total}MB)${NC}"
  else
    echo -e "${GREEN}[OK]   Memory Usage: ${mem_pct}% (${mem_used}MB / ${mem_total}MB)${NC}"
  fi
}

check_disk() {
  while IFS= read -r line; do
    local pct mount
    pct=$(echo "$line" | awk '{print $5}' | tr -d '%')
    mount=$(echo "$line" | awk '{print $6}')
    if (( pct > DISK_THRESHOLD )); then
      echo -e "${RED}[WARN] Disk ${mount}: ${pct}% used${NC}"
    else
      echo -e "${GREEN}[OK]   Disk ${mount}: ${pct}% used${NC}"
    fi
  done < <(df -h | tail -n +2 | grep -v tmpfs)
}

check_services() {
  for svc in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$svc" 2>/dev/null; then
      echo -e "${GREEN}[OK]   Service '${svc}' is running${NC}"
    else
      echo -e "${RED}[WARN] Service '${svc}' is NOT running${NC}"
    fi
  done
}

log "======== SYSTEM HEALTH CHECK ========"
log "Host: $(hostname) | Uptime: $(uptime -p)"
echo ""
log "--- CPU ---";      check_cpu
log "--- Memory ---";   check_memory
log "--- Disk ---";     check_disk
log "--- Services ---"; check_services
log "====================================="
