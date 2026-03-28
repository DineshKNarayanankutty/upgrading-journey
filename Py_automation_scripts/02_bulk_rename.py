"""
02_bulk_rename.py
Bulk rename files with prefix, suffix, numbering, or regex replace.
Usage: python 02_bulk_rename.py --dir ./photos --prefix "vacation_" --number
"""

import os, re, argparse
from pathlib import Path

def bulk_rename(directory, prefix="", suffix="", number=False, regex=None, replace_with="", dry_run=False):
    target = Path(directory)
    if not target.exists():
        print(f"[ERROR] Directory not found: {directory}"); return
    files = sorted([f for f in target.iterdir() if f.is_file()])
    if not files:
        print("No files found."); return
    pad = len(str(len(files)))
    for i, f in enumerate(files, 1):
        stem = f.stem
        ext  = f.suffix
        if regex:
            stem = re.sub(regex, replace_with, stem)
        new_name = f"{prefix}{(str(i).zfill(pad) + '_') if number else ''}{stem}{suffix}{ext}"
        new_path = target / new_name
        if dry_run:
            print(f"[DRY-RUN] {f.name} → {new_name}")
        else:
            f.rename(new_path)
            print(f"[RENAMED] {f.name} → {new_name}")

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Bulk rename files.")
    p.add_argument("--dir",          required=True)
    p.add_argument("--prefix",       default="")
    p.add_argument("--suffix",       default="")
    p.add_argument("--number",       action="store_true", help="Add sequential numbers")
    p.add_argument("--regex",        default=None, help="Regex pattern to match in filename stem")
    p.add_argument("--replace-with", default="",   help="Replacement string for regex match")
    p.add_argument("--dry-run",      action="store_true")
    a = p.parse_args()
    bulk_rename(a.dir, a.prefix, a.suffix, a.number, a.regex, a.replace_with, a.dry_run)
