"""Check data drift and trigger retraining if needed."""
import json, sys
from pathlib import Path

METRICS_FILE = Path('metrics/latest.json')
THRESHOLD    = 0.05

metrics = json.loads(METRICS_FILE.read_text())
drift   = metrics.get('psi_score', 0)
if drift > THRESHOLD:
    print(f'Drift {drift:.3f} > {THRESHOLD} — triggering retrain')
    sys.exit(1)
print(f'Drift {drift:.3f} within threshold — skipping retrain')
