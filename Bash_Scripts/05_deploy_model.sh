#!/bin/bash
# ============================================================
# 05 - ML Model Deployment Pipeline
# Builds a Docker image for an ML model, runs smoke tests,
# pushes to registry, and triggers a rolling Kubernetes update.
# Usage: ./05_deploy_model.sh <model_name> <version> <registry>
# ============================================================

set -euo pipefail

MODEL_NAME="${1:?Usage: $0 <model_name> <version> <registry>}"
VERSION="${2:?Usage: $0 <model_name> <version> <registry>}"
REGISTRY="${3:?Usage: $0 <model_name> <version> <registry>}"
NAMESPACE="${4:-ml-serving}"
DOCKERFILE="${DOCKERFILE:-Dockerfile}"
K8S_DEPLOY="${MODEL_NAME}-deployment"

IMAGE="${REGISTRY}/${MODEL_NAME}:${VERSION}"
IMAGE_LATEST="${REGISTRY}/${MODEL_NAME}:latest"

log()     { echo -e "\033[1;36m[$(date '+%H:%M:%S')] $*\033[0m"; }
success() { echo -e "\033[0;32m[SUCCESS] $*\033[0m"; }
fail()    { echo -e "\033[0;31m[FAIL] $*\033[0m"; exit 1; }

log "Deploying model: $MODEL_NAME v$VERSION"
log "Image: $IMAGE"

# ── Step 1: Build ─────────────────────────────────────────
log "[1/5] Building Docker image..."
docker build \
  --build-arg MODEL_VERSION="$VERSION" \
  --label "model.name=$MODEL_NAME" \
  --label "model.version=$VERSION" \
  --label "build.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  -t "$IMAGE" -t "$IMAGE_LATEST" -f "$DOCKERFILE" .
success "Image built: $IMAGE"

# ── Step 2: Run smoke test ────────────────────────────────
log "[2/5] Running model smoke test..."
CONTAINER_ID=$(docker run -d -p 18080:8080 --rm "$IMAGE")
sleep 5

HTTP_CODE=$(curl -sf -o /dev/null -w "%{http_code}" \
  http://localhost:18080/health 2>/dev/null || echo "000")

docker stop "$CONTAINER_ID" &>/dev/null || true

if [[ "$HTTP_CODE" == "200" ]]; then
  success "Smoke test passed (HTTP $HTTP_CODE)"
else
  fail "Smoke test failed (HTTP $HTTP_CODE). Aborting deployment."
fi

# ── Step 3: Security scan ─────────────────────────────────
log "[3/5] Running vulnerability scan..."
if command -v trivy &>/dev/null; then
  trivy image --exit-code 1 --severity HIGH,CRITICAL "$IMAGE" || {
    fail "Critical CVEs found. Aborting."
  }
  success "No critical vulnerabilities found."
else
  echo "[SKIP] trivy not installed — skipping CVE scan."
fi

# ── Step 4: Push ──────────────────────────────────────────
log "[4/5] Pushing image to registry..."
docker push "$IMAGE"
docker push "$IMAGE_LATEST"
success "Pushed: $IMAGE"

# ── Step 5: K8s rolling update ────────────────────────────
log "[5/5] Triggering Kubernetes rolling update..."
if command -v kubectl &>/dev/null; then
  kubectl set image deployment/"$K8S_DEPLOY" \
    "${MODEL_NAME}=${IMAGE}" -n "$NAMESPACE"
  kubectl rollout status deployment/"$K8S_DEPLOY" \
    -n "$NAMESPACE" --timeout=180s
  success "Rollout complete for $K8S_DEPLOY in namespace $NAMESPACE"
else
  echo "[SKIP] kubectl not available — skipping K8s update."
fi

success "Model $MODEL_NAME v$VERSION deployed successfully!"
