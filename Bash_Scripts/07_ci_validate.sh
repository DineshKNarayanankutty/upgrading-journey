#!/bin/bash
# ============================================================
# 07 - Pre-Deployment Validation (CI/CD Gate)
# Runs code quality checks, unit tests, Docker lint, and
# environment variable validation before any deployment.
# Usage: ./07_ci_validate.sh [--strict]
# ============================================================

set -euo pipefail

STRICT=false
[[ "${1:-}" == "--strict" ]] && STRICT=true

PASS=0; FAIL=0; SKIP=0
REQUIRED_ENV_VARS=("DATABASE_URL" "APP_SECRET_KEY" "REDIS_URL")
PYTHON_MIN_COVERAGE=80

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
BLUE='\033[1;34m'; NC='\033[0m'

check() {
  local name="$1"; local cmd="$2"; local required="${3:-true}"
  echo -ne "${BLUE}[CHECK]${NC} $name ... "
  if eval "$cmd" &>/dev/null; then
    echo -e "${GREEN}PASS${NC}"; (( PASS++ ))
  else
    if [[ "$required" == "true" ]] || $STRICT; then
      echo -e "${RED}FAIL${NC}"; (( FAIL++ ))
    else
      echo -e "${YELLOW}SKIP (non-critical)${NC}"; (( SKIP++ ))
    fi
  fi
}

skip() { echo -e "${BLUE}[CHECK]${NC} $1 ... ${YELLOW}SKIP (tool not found)${NC}"; (( SKIP++ )); }

echo -e "\n${BLUE}======== CI/CD PRE-DEPLOYMENT VALIDATION ========${NC}\n"

# ── Environment Variables ─────────────────────────────────
echo -e "${BLUE}--- Environment Variables ---${NC}"
for var in "${REQUIRED_ENV_VARS[@]}"; do
  check "Env var: $var" "[[ -n \"\${${var}:-}\" ]]"
done

# ── Docker ────────────────────────────────────────────────
echo -e "\n${BLUE}--- Docker ---${NC}"
if command -v docker &>/dev/null; then
  check "Docker daemon running"    "docker info"
  check "Dockerfile exists"        "[[ -f Dockerfile ]]"
  if command -v hadolint &>/dev/null; then
    check "Dockerfile lint (hadolint)" "hadolint Dockerfile"
  else skip "Dockerfile lint (hadolint not installed)"; fi
  check "docker-compose config"    "docker-compose config -q" false
else skip "Docker (not installed)"; fi

# ── Python / Tests ────────────────────────────────────────
echo -e "\n${BLUE}--- Python & Tests ---${NC}"
if command -v python3 &>/dev/null; then
  check "Python syntax check"      "python3 -m py_compile \$(find . -name '*.py' ! -path './.git/*' | head -50 | tr '\n' ' ')"
  if command -v flake8 &>/dev/null; then
    check "Flake8 lint"            "flake8 . --max-line-length=120 --exclude=.git,venv,__pycache__"
  else skip "Flake8 (not installed)"; fi
  if command -v pytest &>/dev/null; then
    check "Unit tests"             "pytest tests/ -q --tb=no -x" true
    if command -v coverage &>/dev/null; then
      COV=$(coverage report --fail-under=$PYTHON_MIN_COVERAGE 2>&1 | tail -1)
      check "Test coverage ≥ ${PYTHON_MIN_COVERAGE}%" \
        "coverage run -m pytest tests/ -q --tb=no && coverage report --fail-under=${PYTHON_MIN_COVERAGE}"
    fi
  else skip "pytest (not installed)"; fi
else skip "Python3 (not installed)"; fi

# ── Infrastructure / IaC ─────────────────────────────────
echo -e "\n${BLUE}--- Infrastructure ---${NC}"
if command -v terraform &>/dev/null; then
  check "Terraform fmt check"      "terraform fmt -check -recursive" false
  check "Terraform validate"       "terraform validate" false
else skip "Terraform (not installed)"; fi
if command -v kubectl &>/dev/null; then
  check "kubectl YAML manifests"   "find k8s/ -name '*.yaml' -exec kubectl apply --dry-run=client -f {} \;" false
else skip "kubectl (not installed)"; fi

# ── Git ───────────────────────────────────────────────────
echo -e "\n${BLUE}--- Git ---${NC}"
check "No uncommitted changes"     "[[ -z \"\$(git status --porcelain 2>/dev/null)\" ]]" false
check "On main or release branch"  "[[ \"\$(git branch --show-current 2>/dev/null)\" =~ ^(main|master|release) ]]" false

# ── Result ────────────────────────────────────────────────
echo -e "\n${BLUE}================================================${NC}"
echo -e " Results: ${GREEN}${PASS} passed${NC}  ${RED}${FAIL} failed${NC}  ${YELLOW}${SKIP} skipped${NC}"
echo -e "${BLUE}================================================${NC}\n"

if (( FAIL > 0 )); then
  echo -e "${RED}GATE FAILED — Fix errors before deploying.${NC}\n"
  exit 1
else
  echo -e "${GREEN}GATE PASSED — Safe to deploy!${NC}\n"
  exit 0
fi
