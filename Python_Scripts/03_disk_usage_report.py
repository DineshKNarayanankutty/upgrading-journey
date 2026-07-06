"""
03_disk_usage_report.py
Scans a directory and reports disk usage per subfolder, sorted by size.
Outputs a summary table and optionally saves a CSV report.
Usage: python 03_disk_usage_report.py --dir /var/log --csv report.csv
"""

import os, csv, argparse
from pathlib import Path

def get_dir_size(path):
    total = 0
    with os.scandir(path) as it:
        for entry in it:
            try:
                if entry.is_file(follow_symlinks=False):
                    total += entry.stat().st_size
                elif entry.is_dir(follow_symlinks=False):
                    total += get_dir_size(entry.path)
            except PermissionError:
                pass
    return total

def human(size):
    for unit in ["B","KB","MB","GB","TB"]:
        if size < 1024: return f"{size:.2f} {unit}"
        size /= 1024
    return f"{size:.2f} PB"

def report(directory, csv_out=None):
    target = Path(directory)
    if not target.exists():
        print(f"[ERROR] Not found: {directory}"); return
    entries = []
    for item in target.iterdir():
        size = get_dir_size(item) if item.is_dir() else item.stat().st_size
        entries.append((item.name, "DIR" if item.is_dir() else "FILE", size))
    entries.sort(key=lambda x: x[2], reverse=True)
    print(f"\nDisk Usage Report: {directory}")
    print(f"{'Name':<40} {'Type':<6} {'Size':>12}")
    print("-" * 60)
    for name, typ, size in entries:
        print(f"{name:<40} {typ:<6} {human(size):>12}")
    total = sum(s for _, _, s in entries)
    print("-" * 60)
    print(f"{'TOTAL':<46} {human(total):>12}\n")
    if csv_out:
        with open(csv_out, "w", newline="") as f:
            w = csv.writer(f)
            w.writerow(["Name", "Type", "Size (bytes)", "Size (human)"])
            for name, typ, size in entries:
                w.writerow([name, typ, size, human(size)])
        print(f"[SAVED] CSV report: {csv_out}")

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Disk usage report for a directory.")
    p.add_argument("--dir", required=True)
    p.add_argument("--csv", default=None, help="Optional CSV output path")
    a = p.parse_args()
    report(a.dir, a.csv)
