"""
06_website_monitor.py
Monitors a list of URLs for uptime and response time. Logs results and alerts on failure.
Usage: python 06_website_monitor.py --urls urls.txt --interval 60
"""

import time, argparse, datetime, urllib.request, urllib.error
from pathlib import Path

def check_url(url, timeout=10):
    start = time.time()
    try:
        with urllib.request.urlopen(url, timeout=timeout) as r:
            elapsed = (time.time() - start) * 1000
            return r.status, elapsed
    except urllib.error.HTTPError as e:
        return e.code, (time.time() - start) * 1000
    except Exception as e:
        return 0, (time.time() - start) * 1000

def monitor(urls, interval, log_file=None):
    log = open(log_file, "a") if log_file else None
    try:
        while True:
            now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            print(f"\n[{now}] Checking {len(urls)} URL(s)...")
            for url in urls:
                status, ms = check_url(url)
                icon = "✅" if 200 <= status < 400 else "❌"
                line = f"  {icon} {url:<50} status={status}  {ms:.0f}ms"
                print(line)
                if log: log.write(f"{now} | {url} | {status} | {ms:.0f}ms\n"); log.flush()
            if interval <= 0: break
            print(f"  Next check in {interval}s...")
            time.sleep(interval)
    except KeyboardInterrupt:
        print("\nMonitor stopped.")
    finally:
        if log: log.close()

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Monitor website uptime.")
    p.add_argument("--urls",     required=True, help="File with one URL per line, or comma-separated URLs")
    p.add_argument("--interval", type=int, default=60, help="Seconds between checks (0=once)")
    p.add_argument("--log",      default=None)
    a = p.parse_args()
    path = Path(a.urls)
    if path.exists():
        urls = [l.strip() for l in path.read_text().splitlines() if l.strip()]
    else:
        urls = [u.strip() for u in a.urls.split(",") if u.strip()]
    monitor(urls, a.interval, a.log)
