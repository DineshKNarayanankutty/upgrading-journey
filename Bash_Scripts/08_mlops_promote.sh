#!/bin/bash
# ============================================================
# 08 - ML Experiment Tracker & Model Registry Sync
# Reads MLflow runs, compares metrics, promotes the best model
# to a registry, and archives old model artifacts.
# Usage: ./08_mlops_promote.sh <experiment_name> <metric> [threshold]
# ============================================================

set -euo pipefail

EXPERIMENT="${1:?Usage: $0 <experiment_name> <metric> [min_threshold]}"
METRIC="${2:?Usage: $0 <experiment_name> <metric> [min_threshold]}"
THRESHOLD="${3:-0.0}"
TRACKING_URI="${MLFLOW_TRACKING_URI:-http://localhost:5000}"
MODEL_STAGE="Production"
ARCHIVE_STAGE="Archived"

log()     { echo "[$(date '+%H:%M:%S')] $*"; }
success() { echo -e "\033[0;32m[OK]\033[0m $*"; }
warn()    { echo -e "\033[1;33m[WARN]\033[0m $*"; }
fail()    { echo -e "\033[0;31m[FAIL]\033[0m $*"; exit 1; }

command -v python3 &>/dev/null || fail "python3 required."
python3 -c "import mlflow" 2>/dev/null || fail "mlflow Python package not installed."

log "MLflow Tracking URI: $TRACKING_URI"
log "Experiment: $EXPERIMENT | Metric: $METRIC | Min Threshold: $THRESHOLD"

# ── Fetch best run ────────────────────────────────────────
log "Querying best run..."
RESULT=$(python3 - <<PYEOF
import mlflow, json, sys

mlflow.set_tracking_uri("$TRACKING_URI")
client = mlflow.tracking.MlflowClient()

try:
    exp = client.get_experiment_by_name("$EXPERIMENT")
    if not exp:
        print(json.dumps({"error": "experiment_not_found"}))
        sys.exit(0)

    runs = client.search_runs(
        experiment_ids=[exp.experiment_id],
        filter_string="status = 'FINISHED'",
        order_by=["metrics.$METRIC DESC"],
        max_results=1
    )
    if not runs:
        print(json.dumps({"error": "no_runs"}))
        sys.exit(0)

    best = runs[0]
    print(json.dumps({
        "run_id":     best.info.run_id,
        "metric_val": best.data.metrics.get("$METRIC", 0),
        "params":     best.data.params,
        "artifact_uri": best.info.artifact_uri
    }))
except Exception as e:
    print(json.dumps({"error": str(e)}))
PYEOF
)

ERROR=$(echo "$RESULT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('error',''))")
if [[ -n "$ERROR" ]]; then
  fail "MLflow query failed: $ERROR"
fi

RUN_ID=$(echo "$RESULT"     | python3 -c "import json,sys; print(json.load(sys.stdin)['run_id'])")
METRIC_VAL=$(echo "$RESULT" | python3 -c "import json,sys; print(json.load(sys.stdin)['metric_val'])")

log "Best run: $RUN_ID | ${METRIC}=${METRIC_VAL}"

# ── Check threshold ───────────────────────────────────────
PASSES=$(python3 -c "print(1 if float('$METRIC_VAL') >= float('$THRESHOLD') else 0)")
if [[ "$PASSES" != "1" ]]; then
  fail "Best ${METRIC}=${METRIC_VAL} is below threshold ${THRESHOLD}. Not promoting."
fi
success "Metric threshold met (${METRIC_VAL} >= ${THRESHOLD})"

# ── Promote to registry ───────────────────────────────────
log "Promoting model to stage: $MODEL_STAGE..."
python3 - <<PYEOF
import mlflow
mlflow.set_tracking_uri("$TRACKING_URI")
client = mlflow.tracking.MlflowClient()

# Register model
model_uri = f"runs:/$RUN_ID/$EXPERIMENT"
try:
    reg = mlflow.register_model(model_uri, "$EXPERIMENT")
    version = reg.version
    print(f"Registered version: {version}")

    # Transition previous Production -> Archived
    for mv in client.search_model_versions(f"name='$EXPERIMENT'"):
        if mv.current_stage == "$MODEL_STAGE" and mv.version != version:
            client.transition_model_version_stage(
                name="$EXPERIMENT", version=mv.version, stage="$ARCHIVE_STAGE"
            )
            print(f"Archived previous version: {mv.version}")

    # Promote new version
    client.transition_model_version_stage(
        name="$EXPERIMENT", version=version, stage="$MODEL_STAGE"
    )
    print(f"Promoted v{version} to $MODEL_STAGE")
except Exception as e:
    print(f"ERROR: {e}")
    exit(1)
PYEOF

success "Model '$EXPERIMENT' promoted to $MODEL_STAGE from run $RUN_ID"
log "Done."
