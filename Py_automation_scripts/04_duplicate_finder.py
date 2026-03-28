"""
04_duplicate_finder.py
Finds duplicate files in a directory tree using MD5 hashing.
Usage: python 04_duplicate_finder.py --dir /path/to/scan [--delete]
"""

import os, hashlib, argparse
from pathlib import Path
from collections import defaultdict

def md5(path, chunk=8192):
    h = hashlib.md5()
    with open(path, "rb") as f:
        while chunk_data := f.read(chunk):
            h.update(chunk_data)
    return h.hexdigest()

def find_duplicates(directory, delete=False):
    hashes = defaultdict(list)
    target = Path(directory)
    print(f"Scanning: {directory} ...")
    for root, _, files in os.walk(target):
        for fname in files:
            fpath = Path(root) / fname
            try:
                h = md5(fpath)
                hashes[h].append(fpath)
            except (PermissionError, OSError):
                pass
    dupes = {h: paths for h, paths in hashes.items() if len(paths) > 1}
    if not dupes:
        print("No duplicates found."); return
    total_wasted = 0
    for h, paths in dupes.items():
        size = paths[0].stat().st_size
        wasted = size * (len(paths) - 1)
        total_wasted += wasted
        print(f"\n[DUPLICATE] MD5: {h}")
        for i, p in enumerate(paths):
            tag = "  KEEP  " if i == 0 else "  DUPE  "
            print(f"  [{tag}] {p}")
        if delete:
            for p in paths[1:]:
                p.unlink()
                print(f"  [DELETED] {p}")
    print(f"\nTotal wasted space: {total_wasted / 1024 / 1024:.2f} MB")

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Find (and optionally delete) duplicate files.")
    p.add_argument("--dir",    required=True)
    p.add_argument("--delete", action="store_true", help="Delete duplicates (keeps first occurrence)")
    a = p.parse_args()
    find_duplicates(a.dir, a.delete)
