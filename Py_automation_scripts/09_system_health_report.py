"""
09_system_health_report.py
Generates a system health snapshot: CPU, memory, disk, top processes, and network stats.
Usage: python 09_system_health_report.py [--save report.txt]
"""

import os, platform, datetime, argparse, subprocess, shutil

def run(cmd):
    try:
        return subprocess.check_output(cmd, shell=True, text=True, stderr=subprocess.DEVNULL).strip()
    except: return "N/A"

def bytes_to_human(n):
    for u in ["B","KB","MB","GB","TB"]:
        if n < 1024: return f"{n:.1f} {u}"
        n /= 1024
    return f"{n:.1f} PB"

def report(save_path=None):
    lines = []
    def p(s=""): lines.append(s); print(s)

    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    p(f"{'='*60}")
    p(f"  SYSTEM HEALTH REPORT — {now}")
    p(f"{'='*60}")
    p(f"\n  OS      : {platform.system()} {platform.release()} ({platform.machine()})")
    p(f"  Host    : {platform.node()}")
    p(f"  Python  : {platform.python_version()}")

    # CPU
    p("\n--- CPU ---")
    if platform.system() == "Linux":
        loadavg = os.getloadavg()
        p(f"  Load avg (1/5/15m): {loadavg[0]:.2f} / {loadavg[1]:.2f} / {loadavg[2]:.2f}")
        p(f"  CPU cores: {os.cpu_count()}")
        p(f"  Uptime: {run('uptime -p')}")
    else:
        p(f"  CPU cores: {os.cpu_count()}")

    # Memory
    p("\n--- Memory ---")
    if platform.system() == "Linux":
        mem = run("free -b")
        for line in mem.splitlines():
            parts = line.split()
            if parts[0] == "Mem:":
                total, used, free = int(parts[1]), int(parts[2]), int(parts[3])
                pct = used / total * 100
                p(f"  Total: {bytes_to_human(total)}  Used: {bytes_to_human(used)} ({pct:.1f}%)  Free: {bytes_to_human(free)}")

    # Disk
    p("\n--- Disk ---")
    total, used, free = shutil.disk_usage("/")
    p(f"  / — Total: {bytes_to_human(total)}  Used: {bytes_to_human(used)} ({used/total*100:.1f}%)  Free: {bytes_to_human(free)}")
    if platform.system() == "Linux":
        df = run("df -h --output=target,size,used,avail,pcent -x tmpfs -x devtmpfs")
        for line in df.splitlines()[1:6]:
            p(f"  {line}")

    # Top processes
    p("\n--- Top 5 Processes (by CPU) ---")
    if platform.system() == "Linux":
        ps = run("ps aux --sort=-%cpu | head -6")
        for line in ps.splitlines()[1:]: p(f"  {line[:100]}")

    # Network
    p("\n--- Network Interfaces ---")
    if platform.system() == "Linux":
        ip = run("ip -br addr")
        for line in ip.splitlines(): p(f"  {line}")

    p(f"\n{'='*60}\n")

    if save_path:
        with open(save_path, "w") as f:
            f.write("\n".join(lines))
        print(f"[SAVED] {save_path}")

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="System health snapshot.")
    p.add_argument("--save", default=None, help="Save report to file")
    a = p.parse_args()
    report(a.save)
