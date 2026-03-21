import os, random, subprocess, time
from datetime import date, datetime, timezone
from pathlib import Path

TODAY = date.today().isoformat()
NOW   = datetime.now(timezone.utc)

# ── Content bank ──────────────────────────────────────────────────────────────
TOPICS = {
    "kubectl": [
        ("kubectl-node-debug.sh",
         "#!/bin/bash\n# Debug a node via ephemeral container\nkubectl debug node/$1 -it --image=busybox\n"),
        ("kubectl-top-pods.sh",
         "#!/bin/bash\n# Top pods sorted by CPU\nkubectl top pods -A --sort-by=cpu | head -20\n"),
        ("kubectl-drain.sh",
         "#!/bin/bash\n# Safely drain a node before maintenance\nkubectl drain $1 --ignore-daemonsets --delete-emptydir-data\n"),
    ],
    "terraform": [
        ("tf-fmt-validate.sh",
         "#!/bin/bash\n# Format and validate before plan\nterraform fmt -recursive && terraform validate\n"),
        ("tf-state-mv.sh",
         "#!/bin/bash\n# Move resource to a new address\nterraform state mv $1 $2\n"),
        ("tf-workspace.sh",
         "#!/bin/bash\n# Switch or create workspace\nterraform workspace select $1 2>/dev/null || terraform workspace new $1\n"),
    ],
    "docker": [
        ("docker-prune.sh",
         "#!/bin/bash\n# Prune unused images, containers, volumes\ndocker system prune -af --volumes\n"),
        ("docker-inspect-ip.sh",
         "#!/bin/bash\n# Get container IP\ndocker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1\n"),
        ("multi-stage.Dockerfile",
         "FROM python:3.11-slim AS builder\nWORKDIR /app\nCOPY requirements.txt .\nRUN pip install --user -r requirements.txt\n\nFROM python:3.11-slim\nWORKDIR /app\nCOPY --from=builder /root/.local /root/.local\nCOPY . .\nCMD [\"python\", \"app.py\"]\n"),
    ],
    "prometheus": [
        ("alert-high-cpu.yaml",
         "groups:\n- name: node\n  rules:\n  - alert: HighCPU\n    expr: 100 - (avg by(instance)(rate(node_cpu_seconds_total{mode='idle'}[5m])) * 100) > 85\n    for: 5m\n    labels:\n      severity: warning\n    annotations:\n      summary: \"CPU > 85% on {{ $labels.instance }}\"\n"),
        ("scrape-config.yaml",
         "scrape_configs:\n  - job_name: 'kubernetes-pods'\n    kubernetes_sd_configs:\n      - role: pod\n    relabel_configs:\n      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]\n        action: keep\n        regex: true\n"),
    ],
    "github-actions": [
        ("trivy-scan.yml",
         "name: Trivy Scan\non: [push]\njobs:\n  scan:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v4\n      - uses: aquasecurity/trivy-action@master\n        with:\n          image-ref: '${{ env.IMAGE }}'\n          format: 'table'\n          exit-code: '1'\n          severity: 'CRITICAL,HIGH'\n"),
    ],
    "mlops": [
        ("model-retrain-check.py",
         "\"\"\"Check data drift and trigger retraining if needed.\"\"\"\nimport json, sys\nfrom pathlib import Path\n\nMETRICS_FILE = Path('metrics/latest.json')\nTHRESHOLD    = 0.05\n\nmetrics = json.loads(METRICS_FILE.read_text())\ndrift   = metrics.get('psi_score', 0)\nif drift > THRESHOLD:\n    print(f'Drift {drift:.3f} > {THRESHOLD} — triggering retrain')\n    sys.exit(1)\nprint(f'Drift {drift:.3f} within threshold — skipping retrain')\n"),
        ("feature-store-push.py",
         "\"\"\"Push features to an online store (Redis example).\"\"\"\nimport redis, pandas as pd\n\nr  = redis.Redis(host='localhost', port=6379)\ndf = pd.read_parquet('features/latest.parquet')\n\nfor _, row in df.iterrows():\n    key = f\"user:{row['user_id']}\"\n    r.hset(key, mapping=row.to_dict())\nprint(f'Pushed {len(df)} feature rows')\n"),
    ],
    "azure": [
        ("az-aks-upgrade.sh",
         "#!/bin/bash\n# Upgrade AKS cluster to latest patch\nAKS_NAME=$1; RG=$2\nLATEST=$(az aks get-upgrades -n $AKS_NAME -g $RG --query 'controlPlaneProfile.upgrades[-1].kubernetesVersion' -o tsv)\naz aks upgrade -n $AKS_NAME -g $RG --kubernetes-version $LATEST --yes\n"),
        ("adls-gen2-upload.py",
         "\"\"\"Upload a local file to ADLS Gen2.\"\"\"\nfrom azure.storage.filedatalake import DataLakeServiceClient\nimport os\n\nclient = DataLakeServiceClient.from_connection_string(os.environ['ADLS_CONN'])\nfs = client.get_file_system_client('raw')\nfile_client = fs.get_file_client('data/upload.parquet')\nwith open('local.parquet','rb') as f:\n    file_client.upload_data(f.read(), overwrite=True)\nprint('Upload complete')\n"),
    ],
    "helm": [
        ("helm-diff-deploy.sh",
         "#!/bin/bash\n# Show diff before upgrading a release\nhelm plugin install https://github.com/databus23/helm-diff 2>/dev/null || true\nhelm diff upgrade $1 $2 --values values.yaml\n"),
    ],
    "aws": [
        ("ecr-login.sh",
         "#!/bin/bash\n# Login to ECR and push image\nACCOUNT=$(aws sts get-caller-identity --query Account --output text)\nREGION=${AWS_DEFAULT_REGION:-us-east-1}\naws ecr get-login-password | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.$REGION.amazonaws.com\n"),
        ("s3-sync-backup.sh",
         "#!/bin/bash\n# Sync local dir to S3 with versioning\naws s3 sync ./data s3://$1/backup/$(date +%Y/%m/%d)/ --storage-class STANDARD_IA\n"),
    ],
}

def git(cmd: str) -> None:
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"[git error] {result.stderr.strip()}")

def make_commit(category: str, filename: str, content: str, idx: int) -> str:
    folder = Path(f"content/{category}")
    folder.mkdir(parents=True, exist_ok=True)
    filepath = folder / filename
    filepath.write_text(content)
    git(f'git add content/{category}/{filename}')
    msg = f"chore({category}): add {filename} [{TODAY} #{idx}]"
    git(f'git commit -m "{msg}"')
    return f"- `{category}/{filename}` — {msg}"

def build_report(entries: list[str]) -> None:
    report_dir = Path("daily-reports")
    report_dir.mkdir(exist_ok=True)
    report_path = report_dir / f"{TODAY}.md"
    lines = [
        f"# Daily DevOps/MLOps Update — {TODAY}\n",
        f"**Generated at**: {NOW.strftime('%H:%M UTC')}  \n",
        f"**Commits today**: {len(entries)}\n\n",
        "## Files added\n\n",
        *[e + "\n" for e in entries],
        "\n---\n",
        f"*Auto-generated by daily commit engine — {NOW.isoformat()}*\n",
    ]
    report_path.write_text("".join(lines))
    # Update index
    index = Path("daily-reports/README.md")
    existing = index.read_text() if index.exists() else "# Daily Reports\n\n"
    link = f"- [{TODAY}](./{TODAY}.md)\n"
    if link not in existing:
        index.write_text(existing + link)

def main():
    n_commits = random.randint(5, 20)
    print(f"[engine] targeting {n_commits} commits for {TODAY}")

    # Flatten all topics into (category, filename, content) tuples
    all_items = [(cat, fn, body) for cat, items in TOPICS.items() for fn, body in items]
    chosen    = random.sample(all_items, min(n_commits, len(all_items)))

    entries = []
    for idx, (cat, fn, body) in enumerate(chosen, 1):
        entry = make_commit(cat, fn, body, idx)
        entries.append(entry)
        print(f"  [{idx}/{n_commits}] committed {cat}/{fn}")
        if idx < len(chosen):
            sleep_sec = random.randint(10, 20)  
            print(f"  sleeping {sleep_sec}s...")
            time.sleep(sleep_sec)

    # Build and commit the daily report
    build_report(entries)
    git(f'git add daily-reports/')
    git(f'git commit -m "report: daily summary {TODAY}"')
    print(f"[engine] done — {len(entries)} commits + 1 report commit")

if __name__ == "__main__":
    main()