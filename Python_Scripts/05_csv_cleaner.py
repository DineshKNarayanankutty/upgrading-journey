"""
05_csv_cleaner.py
Cleans a CSV file: removes blank rows, strips whitespace, deduplicates, standardizes column names.
Usage: python 05_csv_cleaner.py --input dirty.csv --output clean.csv
"""

import csv, argparse, re
from pathlib import Path

def clean_header(name):
    name = name.strip().lower()
    name = re.sub(r"[^\w]+", "_", name)
    return name.strip("_")

def clean_csv(input_path, output_path, dedup=True):
    rows = []
    with open(input_path, newline="", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        if not reader.fieldnames:
            print("[ERROR] No headers found."); return
        clean_fields = [clean_header(h) for h in reader.fieldnames]
        for row in reader:
            cleaned = {clean_fields[i]: v.strip() for i, v in enumerate(row.values())}
            if all(v == "" for v in cleaned.values()):
                continue  # skip blank rows
            rows.append(cleaned)
    before = len(rows)
    if dedup:
        seen = set()
        unique = []
        for r in rows:
            key = tuple(r.values())
            if key not in seen:
                seen.add(key); unique.append(r)
        rows = unique
    with open(output_path, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=clean_fields)
        w.writeheader(); w.writerows(rows)
    print(f"[DONE] {before} rows → {len(rows)} rows (after dedup)")
    print(f"[SAVED] {output_path}")

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Clean and normalize a CSV file.")
    p.add_argument("--input",  required=True)
    p.add_argument("--output", required=True)
    p.add_argument("--no-dedup", action="store_true")
    a = p.parse_args()
    clean_csv(a.input, a.output, not a.no_dedup)
