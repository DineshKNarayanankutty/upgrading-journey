"""
08_env_backup.py
Backs up specified directories/files into a timestamped zip archive.
Supports retention policy (keep last N backups).
Usage: python 08_env_backup.py --sources /etc /home/user/.config --dest /backups --keep 7
"""

import os, zipfile, argparse, datetime, re
from pathlib import Path

def create_backup(sources, dest_dir, keep=None):
    dest = Path(dest_dir)
    dest.mkdir(parents=True, exist_ok=True)
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    archive = dest / f"backup_{ts}.zip"
    total = 0
    with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED) as zf:
        for src in sources:
            src_path = Path(src)
            if not src_path.exists():
                print(f"[SKIP] Not found: {src}"); continue
            if src_path.is_file():
                zf.write(src_path, src_path.name); total += 1
            else:
                for root, _, files in os.walk(src_path):
                    for f in files:
                        fp = Path(root) / f
                        arcname = fp.relative_to(src_path.parent)
                        zf.write(fp, arcname); total += 1
    size = archive.stat().st_size / 1024 / 1024
    print(f"[BACKUP] {archive}  ({total} files, {size:.2f} MB)")
    if keep:
        all_backups = sorted(dest.glob("backup_*.zip"))
        old = all_backups[:-keep]
        for b in old:
            b.unlink(); print(f"[PURGED] {b.name}")

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Backup files/dirs to a timestamped zip.")
    p.add_argument("--sources", nargs="+", required=True, help="Files/dirs to back up")
    p.add_argument("--dest",    required=True, help="Destination directory for archives")
    p.add_argument("--keep",    type=int, default=None, help="Retain only last N backups")
    a = p.parse_args()
    create_backup(a.sources, a.dest, a.keep)
