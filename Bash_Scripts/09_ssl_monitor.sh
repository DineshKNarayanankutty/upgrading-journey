#!/bin/bash
# ============================================================
# 09 - SSL Certificate Expiry Monitor
# Checks SSL cert expiry for a list of domains, alerts if
# certs expire within WARNING_DAYS or CRITICAL_DAYS.
# Usage: ./09_ssl_monitor.sh [domains_file]
# ============================================================

set -euo pipefail

DOMAINS_FILE="${1:-}"
WARNING_DAYS=30
CRITICAL_DAYS=7
TIMEOUT=10

# Inline domains if no file provided
DEFAULT_DOMAINS=(
  "google.com"
  "github.com"
  "example.com"
)

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

check_cert() {
  local domain="$1"
  local port="${2:-443}"

  # Fetch certificate expiry date
  local expiry_str
  expiry_str=$(echo | timeout "$TIMEOUT" openssl s_client \
    -connect "${domain}:${port}" -servername "$domain" 2>/dev/null \
    | openssl x509 -noout -enddate 2>/dev/null \
    | cut -d= -f2)

  if [[ -z "$expiry_str" ]]; then
    echo -e "  ${RED}[ERROR]${NC}  $domain — Could not retrieve certificate"
    return
  fi

  local expiry_epoch now_epoch days_left
  expiry_epoch=$(date -d "$expiry_str" +%s 2>/dev/null \
              || date -j -f "%b %d %T %Y %Z" "$expiry_str" +%s 2>/dev/null)
  now_epoch=$(date +%s)
  days_left=$(( (expiry_epoch - now_epoch) / 86400 ))

  local expiry_fmt
  expiry_fmt=$(date -d "@$expiry_epoch" '+%Y-%m-%d' 2>/dev/null \
            || date -r "$expiry_epoch" '+%Y-%m-%d' 2>/dev/null)

  if (( days_left <= 0 )); then
    echo -e "  ${RED}[EXPIRED] ${NC} $domain — EXPIRED on $expiry_fmt"
  elif (( days_left <= CRITICAL_DAYS )); then
    echo -e "  ${RED}[CRITICAL]${NC} $domain — ${days_left}d left (expires $expiry_fmt)"
  elif (( days_left <= WARNING_DAYS )); then
    echo -e "  ${YELLOW}[WARNING] ${NC} $domain — ${days_left}d left (expires $expiry_fmt)"
  else
    echo -e "  ${GREEN}[OK]      ${NC} $domain — ${days_left}d left (expires $expiry_fmt)"
  fi
}

log "===== SSL Certificate Monitor ====="
log "Critical: <${CRITICAL_DAYS}d | Warning: <${WARNING_DAYS}d"
echo ""

# Build domain list
if [[ -n "$DOMAINS_FILE" && -f "$DOMAINS_FILE" ]]; then
  mapfile -t DOMAINS < <(grep -v '^\s*#' "$DOMAINS_FILE" | grep -v '^\s*$')
  log "Loaded ${#DOMAINS[@]} domains from $DOMAINS_FILE"
else
  DOMAINS=("${DEFAULT_DOMAINS[@]}")
  log "Using ${#DOMAINS[@]} default domains"
fi

echo ""
EXPIRED=0; CRITICAL=0; WARNING=0; HEALTHY=0

for entry in "${DOMAINS[@]}"; do
  domain=$(echo "$entry" | cut -d: -f1)
  port=$(echo "$entry" | cut -d: -f2)
  port=${port:-443}

  result=$(check_cert "$domain" "$port")
  echo "$result"

  echo "$result" | grep -q "EXPIRED"  && (( EXPIRED++  )) || true
  echo "$result" | grep -q "CRITICAL" && (( CRITICAL++ )) || true
  echo "$result" | grep -q "WARNING"  && (( WARNING++  )) || true
  echo "$result" | grep -q "\[OK\]"   && (( HEALTHY++  )) || true
done

echo ""
log "===== Summary ====="
echo -e "  ${GREEN}OK:${NC}       $HEALTHY"
echo -e "  ${YELLOW}Warning:${NC}  $WARNING"
echo -e "  ${RED}Critical:${NC} $CRITICAL"
echo -e "  ${RED}Expired:${NC}  $EXPIRED"

(( EXPIRED + CRITICAL > 0 )) && exit 2
(( WARNING > 0 ))            && exit 1
exit 0
