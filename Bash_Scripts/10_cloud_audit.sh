#!/bin/bash
# ============================================================
# 10 - Cloud Resource Audit & Cost Reporter (AWS)
# Inventories running EC2, RDS, and EKS resources, flags
# idle/unused resources, and outputs a cost summary.
# Usage: ./10_cloud_audit.sh [--region us-east-1] [--output csv]
# ============================================================

set -euo pipefail

REGION="us-east-1"
OUTPUT_FORMAT="table"   # table | csv

while [[ $# -gt 0 ]]; do
  case "$1" in
    --region) REGION="$2";        shift 2 ;;
    --output) OUTPUT_FORMAT="$2"; shift 2 ;;
    *)        echo "Unknown arg: $1"; exit 1 ;;
  esac
done

REPORT_FILE="/tmp/cloud_audit_$(date +%Y%m%d_%H%M%S).${OUTPUT_FORMAT}"
CPU_IDLE_THRESHOLD=5   # Flag instances with <5% average CPU in last 24h

log()  { echo "[$(date '+%H:%M:%S')] $*"; }
sep()  { printf '%0.s─' {1..60}; echo; }

command -v aws    &>/dev/null || { log "ERROR: aws CLI not found"; exit 1; }
command -v jq     &>/dev/null || { log "ERROR: jq not found"; exit 1; }

aws sts get-caller-identity --region "$REGION" &>/dev/null \
  || { log "ERROR: AWS credentials not configured"; exit 1; }

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
log "AWS Account: $ACCOUNT_ID | Region: $REGION"

# ── EC2 Instances ─────────────────────────────────────────
log "Fetching EC2 instances..."
EC2_JSON=$(aws ec2 describe-instances \
  --region "$REGION" \
  --query 'Reservations[*].Instances[*].{
    ID:InstanceId,
    Type:InstanceType,
    State:State.Name,
    Name:Tags[?Key==`Name`]|[0].Value,
    LaunchTime:LaunchTime,
    PublicIP:PublicIpAddress,
    AZ:Placement.AvailabilityZone
  }' \
  --output json | jq 'flatten')

EC2_COUNT=$(echo "$EC2_JSON" | jq length)
RUNNING=$(echo "$EC2_JSON" | jq '[.[] | select(.State=="running")] | length')
STOPPED=$(echo "$EC2_JSON" | jq '[.[] | select(.State=="stopped")] | length')

log "EC2: $EC2_COUNT total | $RUNNING running | $STOPPED stopped"

# ── Flag idle EC2 (low CPU) ───────────────────────────────
log "Checking for idle instances (avg CPU < ${CPU_IDLE_THRESHOLD}% last 24h)..."
START=$(date -u -d '24 hours ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null \
     || date -u -v-24H        '+%Y-%m-%dT%H:%M:%SZ')
END=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
IDLE_INSTANCES=()

while IFS= read -r instance_id; do
  AVG_CPU=$(aws cloudwatch get-metric-statistics \
    --region "$REGION" \
    --namespace AWS/EC2 \
    --metric-name CPUUtilization \
    --dimensions Name=InstanceId,Value="$instance_id" \
    --start-time "$START" --end-time "$END" \
    --period 86400 --statistics Average \
    --query 'Datapoints[0].Average' --output text 2>/dev/null || echo "N/A")

  if [[ "$AVG_CPU" != "N/A" && "$AVG_CPU" != "None" ]]; then
    IS_IDLE=$(python3 -c "print(1 if float('$AVG_CPU') < $CPU_IDLE_THRESHOLD else 0)")
    [[ "$IS_IDLE" == "1" ]] && IDLE_INSTANCES+=("$instance_id (CPU: ${AVG_CPU}%)")
  fi
done < <(echo "$EC2_JSON" | jq -r '.[] | select(.State=="running") | .ID')

# ── RDS Instances ─────────────────────────────────────────
log "Fetching RDS instances..."
RDS_JSON=$(aws rds describe-db-instances \
  --region "$REGION" \
  --query 'DBInstances[*].{
    ID:DBInstanceIdentifier,
    Class:DBInstanceClass,
    Engine:Engine,
    Status:DBInstanceStatus,
    Storage:AllocatedStorage,
    MultiAZ:MultiAZ
  }' --output json 2>/dev/null || echo "[]")

RDS_COUNT=$(echo "$RDS_JSON" | jq length)
log "RDS: $RDS_COUNT instances found"

# ── EKS Clusters ─────────────────────────────────────────
log "Fetching EKS clusters..."
EKS_CLUSTERS=$(aws eks list-clusters --region "$REGION" \
  --query 'clusters' --output json 2>/dev/null || echo "[]")
EKS_COUNT=$(echo "$EKS_CLUSTERS" | jq length)
log "EKS: $EKS_COUNT clusters"

# ── S3 Buckets (count only) ───────────────────────────────
S3_COUNT=$(aws s3api list-buckets --query 'length(Buckets)' --output text 2>/dev/null || echo "N/A")

# ── Generate Report ───────────────────────────────────────
{
  echo "========================================================"
  echo "  CLOUD RESOURCE AUDIT — $(date '+%Y-%m-%d %H:%M:%S')"
  echo "  Account: $ACCOUNT_ID | Region: $REGION"
  echo "========================================================"
  echo ""
  echo "EC2 INSTANCES ($EC2_COUNT total)"
  sep
  echo "$EC2_JSON" | jq -r '.[] | [.ID, .Name//"(no name)", .Type, .State, .AZ] | @tsv' \
    | column -t -s $'\t'
  echo ""

  if (( ${#IDLE_INSTANCES[@]} > 0 )); then
    echo "⚠  IDLE INSTANCES (avg CPU < ${CPU_IDLE_THRESHOLD}% last 24h):"
    for i in "${IDLE_INSTANCES[@]}"; do echo "   • $i"; done
    echo ""
  fi

  echo "STOPPED EC2 (candidates for termination/snapshot):"
  echo "$EC2_JSON" | jq -r '.[] | select(.State=="stopped") | "   • "+.ID+" "+(.Name//"(no name)")' || echo "   None"
  echo ""

  echo "RDS INSTANCES ($RDS_COUNT)"
  sep
  echo "$RDS_JSON" | jq -r '.[] | [.ID, .Class, .Engine, .Status, (.Storage|tostring)+"GB", (.MultiAZ|tostring)] | @tsv' \
    | column -t -s $'\t' || echo "  None"
  echo ""

  echo "EKS CLUSTERS ($EKS_COUNT)"
  sep
  echo "$EKS_CLUSTERS" | jq -r '.[]' | sed 's/^/  • /' || echo "  None"
  echo ""

  echo "S3 BUCKETS: $S3_COUNT"
  echo ""
  echo "========================================================"
  echo "  RECOMMENDATIONS"
  echo "========================================================"
  (( ${#IDLE_INSTANCES[@]} > 0 )) && \
    echo "  • Consider stopping/rightsizing ${#IDLE_INSTANCES[@]} idle EC2 instance(s)"
  STOPPED_N=$(echo "$EC2_JSON" | jq '[.[] | select(.State=="stopped")] | length')
  (( STOPPED_N > 0 )) && \
    echo "  • Review $STOPPED_N stopped EC2 instance(s) for potential termination"
  echo "  • Run AWS Cost Explorer for a full cost breakdown"
  echo "========================================================"
} | tee "$REPORT_FILE"

log "Report saved: $REPORT_FILE"
