#!/bin/bash
# ============================================================
# 04 - Kubernetes Pod Inspector
# Shows pod statuses, restarts, resource usage, and recent logs
# Usage: ./04_k8s_inspector.sh [namespace] [app_label_filter]
# ============================================================

set -euo pipefail

NAMESPACE="${1:-default}"
FILTER="${2:-}"
LOG_LINES=50
RESTART_THRESHOLD=5

log() { echo -e "\n\033[1;34m==> $*\033[0m"; }
warn() { echo -e "\033[1;33m[WARN] $*\033[0m"; }
ok()   { echo -e "\033[0;32m[OK]   $*\033[0m"; }

command -v kubectl &>/dev/null || { echo "kubectl not found"; exit 1; }

log "Cluster Info"
kubectl cluster-info --request-timeout=5s 2>/dev/null | head -3

log "Namespace: $NAMESPACE — Pod Overview"
kubectl get pods -n "$NAMESPACE" ${FILTER:+-l "app=$FILTER"} \
  -o wide --sort-by='.status.phase' 2>/dev/null

log "Checking for Unhealthy Pods"
UNHEALTHY=$(kubectl get pods -n "$NAMESPACE" \
  --field-selector='status.phase!=Running,status.phase!=Succeeded' \
  -o jsonpath='{.items[*].metadata.name}' 2>/dev/null)

if [[ -z "$UNHEALTHY" ]]; then
  ok "All pods are Running or Succeeded."
else
  warn "Unhealthy pods detected: $UNHEALTHY"
  for pod in $UNHEALTHY; do
    echo "--- Events for $pod ---"
    kubectl describe pod "$pod" -n "$NAMESPACE" 2>/dev/null \
      | grep -A5 "Events:" | tail -10
  done
fi

log "Pods with High Restart Counts (> $RESTART_THRESHOLD)"
kubectl get pods -n "$NAMESPACE" \
  -o jsonpath='{range .items[*]}{.metadata.name}{" "}{range .status.containerStatuses[*]}{.restartCount}{"\n"}{end}{end}' \
  2>/dev/null | awk -v t="$RESTART_THRESHOLD" '$2 > t {print "[WARN] "$1" restarts="$2}'

log "Resource Usage (top pods)"
kubectl top pods -n "$NAMESPACE" ${FILTER:+-l "app=$FILTER"} \
  --sort-by=memory 2>/dev/null | head -15 || warn "metrics-server not available."

if [[ -n "$FILTER" ]]; then
  log "Recent Logs — app=$FILTER (last $LOG_LINES lines)"
  kubectl logs -n "$NAMESPACE" -l "app=$FILTER" \
    --tail="$LOG_LINES" --prefix=true --max-log-requests=5 2>/dev/null
fi

log "PersistentVolumeClaims"
kubectl get pvc -n "$NAMESPACE" 2>/dev/null

log "Done."
