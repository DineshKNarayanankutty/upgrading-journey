#!/bin/bash
# ============================================================
# 06 - Log Aggregator & Error Parser
# Scans log files for errors/warnings, generates a summary
# and optionally sends a Slack alert.
# Usage: ./06_log_parser.sh /var/log/app [--slack]
# ============================================================

set -euo pipefail

LOG_DIR="${1:?Usage: $0 <log_dir> [--slack]}"
SLACK_NOTIFY=false
[[ "${2:-}" == "--slack" ]] && SLACK_NOTIFY=true

SLACK_WEBHOOK="${SLACK_WEBHOOK_URL:-}"
REPORT_FILE="/tmp/log_report_$(date +%Y%m%d_%H%M%S).txt"
LOOKBACK_HOURS=1

log() { echo "[$(date '+%H:%M:%S')] $*"; }

declare -A ERROR_COUNT
declare -A WARN_COUNT
TOTAL_ERRORS=0
TOTAL_WARNS=0

[[ -d "$LOG_DIR" ]] || { log "ERROR: Directory '$LOG_DIR' not found."; exit 1; }

{
  echo "================================================"
  echo " LOG ANALYSIS REPORT — $(date '+%Y-%m-%d %H:%M:%S')"
  echo " Directory : $LOG_DIR"
  echo " Lookback  : Last ${LOOKBACK_HOURS}h"
  echo "================================================"
  echo ""

  while IFS= read -r -d '' logfile; do
    filename=$(basename "$logfile")

    # Count errors and warnings
    errors=$(grep -ciE '\b(ERROR|CRITICAL|FATAL|Exception|Traceback)\b' \
             "$logfile" 2>/dev/null || true)
    warns=$(grep -ciE '\b(WARN|WARNING)\b' "$logfile" 2>/dev/null || true)

    ERROR_COUNT["$filename"]=$errors
    WARN_COUNT["$filename"]=$warns
    TOTAL_ERRORS=$(( TOTAL_ERRORS + errors ))
    TOTAL_WARNS=$(( TOTAL_WARNS  + warns  ))

    echo "── $filename ──"
    printf "   Errors: %-6s Warnings: %s\n" "$errors" "$warns"

    # Print top 5 unique error lines
    if (( errors > 0 )); then
      echo "   Top errors:"
      grep -iE '\b(ERROR|CRITICAL|FATAL)\b' "$logfile" 2>/dev/null \
        | sort | uniq -c | sort -rn | head -5 \
        | sed 's/^/     /'
    fi
    echo ""
  done < <(find "$LOG_DIR" -maxdepth 2 -name "*.log" \
           -newer "/tmp/.lookback_anchor_${LOOKBACK_HOURS}h" \
           -print0 2>/dev/null)

  echo "================================================"
  echo " SUMMARY: $TOTAL_ERRORS errors | $TOTAL_WARNS warnings"
  echo "================================================"
} | tee "$REPORT_FILE"

log "Report saved to: $REPORT_FILE"

# Create lookback anchor for next run
touch -d "${LOOKBACK_HOURS} hours ago" \
  "/tmp/.lookback_anchor_${LOOKBACK_HOURS}h" 2>/dev/null || true

# Slack notification if errors found
if $SLACK_NOTIFY && (( TOTAL_ERRORS > 0 )); then
  if [[ -z "$SLACK_WEBHOOK" ]]; then
    log "WARN: SLACK_WEBHOOK_URL not set — skipping Slack alert."
  else
    PAYLOAD=$(cat <<EOF
{
  "text": ":rotating_light: *Log Alert on $(hostname)*",
  "attachments": [{
    "color": "danger",
    "text": "*${TOTAL_ERRORS} errors* and *${TOTAL_WARNS} warnings* found in \`${LOG_DIR}\` (last ${LOOKBACK_HOURS}h)\nSee attached report."
  }]
}
EOF
    )
    curl -s -X POST -H 'Content-type: application/json' \
      --data "$PAYLOAD" "$SLACK_WEBHOOK" &>/dev/null
    log "Slack alert sent."
  fi
fi
