"""
01_file_organizer.py
Organizes files in a directory into subfolders by file extension.
Usage: python 01_file_organizer.py --dir /path/to/folder [--dry-run]
"""

import os, shutil, argparse
from pathlib import Path
from collections import defaultdict

EXTENSION_MAP = {
    "Images":        [".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg", ".webp"],
    "Videos":        [".mp4", ".mkv", ".avi", ".mov", ".wmv", ".flv"],
    "Audio":         [".mp3", ".wav", ".aac", ".flac", ".ogg"],
    "Documents":     [".pdf", ".doc", ".docx", ".txt", ".md", ".rtf"],
    "Spreadsheets":  [".xls", ".xlsx", ".csv"],
    "Presentations": [".ppt", ".pptx"],
    "Archives":      [".zip", ".tar", ".gz", ".rar", ".7z"],
    "Code":          [".py", ".js", ".ts", ".html", ".css", ".sh", ".yaml", ".yml", ".json"],
    "Executables":   [".exe", ".dmg", ".deb", ".rpm"],
}

def get_category(ext):
    for cat, exts in EXTENSION_MAP.items():
        if ext.lower() in exts:
            return cat
    return "Misc"

def organize(target_dir, dry_run=False):
    target = Path(target_dir)
    if not target.exists():
        print(f"[ERROR] Not found: {target_dir}"); return
    moved = defaultdict(int)
    for item in target.iterdir():
        if item.is_dir(): continue
        cat = get_category(item.suffix)
        dest = target / cat / item.name
        if dry_run:
            print(f"[DRY-RUN] {item.name} → {cat}/")
        else:
            (target / cat).mkdir(exist_ok=True)
            if dest.exists(): print(f"[SKIP] {item.name}"); continue
            shutil.move(str(item), str(dest))
            print(f"[MOVED] {item.name} → {cat}/")
            moved[cat] += 1
    print("\n--- Summary ---")
    for c, n in sorted(moved.items()): print(f"  {c}: {n} file(s)")

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Organize files by extension.")
    p.add_argument("--dir", required=True, help="Target directory")
    p.add_argument("--dry-run", action="store_true")
    a = p.parse_args()
    organize(a.dir, a.dry_run)
