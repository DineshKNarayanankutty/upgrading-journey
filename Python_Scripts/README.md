# 🐍 Python Day-to-Day Automation Scripts

A collection of 10 production-ready Python scripts for common automation tasks.
No third-party dependencies required — all scripts use the Python standard library.

---

## Scripts Overview

| # | Script | What it does |
|---|--------|-------------|
| 01 | `01_file_organizer.py`      | Sorts files into subfolders by extension (Images, Docs, Code, etc.) |
| 02 | `02_bulk_rename.py`         | Bulk rename with prefix, suffix, sequential numbering, or regex |
| 03 | `03_disk_usage_report.py`   | Disk usage breakdown by subfolder, with optional CSV export |
| 04 | `04_duplicate_finder.py`    | Finds (and optionally deletes) duplicate files via MD5 hashing |
| 05 | `05_csv_cleaner.py`         | Cleans CSVs: strips whitespace, normalizes headers, deduplicates |
| 06 | `06_website_monitor.py`     | Monitors URLs for uptime & response time, logs results |
| 07 | `07_log_analyzer.py`        | Parses log files: level counts, top errors, hourly trends |
| 08 | `08_env_backup.py`          | Zips files/dirs with timestamp, auto-prunes old backups |
| 09 | `09_system_health_report.py`| CPU, memory, disk, top processes, network snapshot |
| 10 | `10_scheduled_task_runner.py`| Lightweight scheduler to run tasks on a repeating interval |

---

## Quick Usage

```bash
# Organize your Downloads folder
python 01_file_organizer.py --dir ~/Downloads --dry-run

# Bulk rename photos with prefix and sequential numbers
python 02_bulk_rename.py --dir ./photos --prefix "trip_" --number

# Disk usage report with CSV
python 03_disk_usage_report.py --dir /var/log --csv report.csv

# Find duplicates
python 04_duplicate_finder.py --dir ~/Documents

# Clean a messy CSV
python 05_csv_cleaner.py --input dirty.csv --output clean.csv

# Monitor websites every 60s
python 06_website_monitor.py --urls "https://google.com,https://github.com" --interval 60

# Analyze a log file
python 07_log_analyzer.py --log app.log --tail 500

# Backup with 7-backup retention
python 08_env_backup.py --sources /etc ~/.config --dest ~/backups --keep 7

# System health snapshot
python 09_system_health_report.py --save health.txt

# Run the task scheduler (edit TASKS list inside first)
python 10_scheduled_task_runner.py
```

## Requirements
- Python 3.8+
- No pip installs needed (stdlib only)
