"""
07_log_analyzer.py
Analyzes log files: counts ERROR/WARN/INFO, extracts top error messages, shows hourly trends.
Usage: python 07_log_analyzer.py --log app.log [--tail 100]
"""

import re, argparse, collections
from pathlib import Path
from datetime import datetime

LOG_PATTERN = re.compile(
    r"(?P<timestamp>\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}).*?"
    r"(?P<level>ERROR|WARN(?:ING)?|INFO|DEBUG|CRITICAL)",
    re.IGNORECASE
)

def analyze(log_path, tail=None):
    path = Path(log_path)
    if not path.exists():
        print(f"[ERROR] File not found: {log_path}"); return
    lines = path.read_text(errors="replace").splitlines()
    if tail: lines = lines[-tail:]
    level_counts = collections.Counter()
    hourly       = collections.Counter()
    error_msgs   = collections.Counter()
    for line in lines:
        m = LOG_PATTERN.search(line)
        if m:
            lvl = m.group("level").upper()
            lvl = "WARN" if lvl == "WARNING" else lvl
            level_counts[lvl] += 1
            try:
                hour = datetime.strptime(m.group("timestamp")[:13], "%Y-%m-%d %H")
                hourly[hour.strftime("%Y-%m-%d %H:00")] += 1
            except: pass
            if lvl in ("ERROR", "CRITICAL"):
                msg = line[m.end():].strip()[:80]
                error_msgs[msg] += 1
    print(f"\n=== Log Analysis: {log_path} ({len(lines)} lines) ===")
    print("\n--- Level Counts ---")
    for lvl in ["CRITICAL", "ERROR", "WARN", "INFO", "DEBUG"]:
        if level_counts[lvl]: print(f"  {lvl:<10} {level_counts[lvl]}")
    print("\n--- Top 10 Errors ---")
    for msg, cnt in error_msgs.most_common(10):
        print(f"  [{cnt:>4}x] {msg}")
    print("\n--- Hourly Activity (top 10 hours) ---")
    for hour, cnt in sorted(hourly.items(), key=lambda x: -x[1])[:10]:
        bar = "█" * min(cnt // 5, 40)
        print(f"  {hour}  {cnt:>5}  {bar}")

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Analyze log files.")
    p.add_argument("--log",  required=True)
    p.add_argument("--tail", type=int, default=None, help="Only analyze last N lines")
    a = p.parse_args()
    analyze(a.log, a.tail)
