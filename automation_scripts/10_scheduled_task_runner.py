"""
10_scheduled_task_runner.py
A lightweight task scheduler that runs shell commands or Python functions on a cron-like schedule.
Define your tasks in the TASKS list below and run this script as a daemon.
Usage: python 10_scheduled_task_runner.py
"""

import time, subprocess, datetime, logging, threading
from dataclasses import dataclass, field
from typing import Callable, Optional

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[logging.StreamHandler(), logging.FileHandler("task_runner.log")]
)
log = logging.getLogger(__name__)

@dataclass
class Task:
    name:        str
    interval_s:  int                            # run every N seconds
    command:     Optional[str]    = None        # shell command
    func:        Optional[Callable] = None      # or Python callable
    args:        list             = field(default_factory=list)
    last_run:    Optional[float]  = None
    run_count:   int              = 0

    def is_due(self):
        if self.last_run is None: return True
        return (time.time() - self.last_run) >= self.interval_s

    def run(self):
        self.last_run = time.time()
        self.run_count += 1
        try:
            if self.command:
                result = subprocess.run(self.command, shell=True, capture_output=True, text=True, timeout=60)
                if result.returncode == 0:
                    log.info(f"[{self.name}] ✅ exit=0  stdout={result.stdout.strip()[:120]}")
                else:
                    log.error(f"[{self.name}] ❌ exit={result.returncode}  stderr={result.stderr.strip()[:120]}")
            elif self.func:
                out = self.func(*self.args)
                log.info(f"[{self.name}] ✅ result={out}")
        except Exception as e:
            log.error(f"[{self.name}] 💥 {e}")

# ─── Define your tasks here ─────────────────────────────────────────────────

def heartbeat():
    return f"alive at {datetime.datetime.now().strftime('%H:%M:%S')}"

def check_disk():
    import shutil
    total, used, free = shutil.disk_usage("/")
    pct = used / total * 100
    if pct > 85:
        log.warning(f"Disk usage HIGH: {pct:.1f}%")
    return f"disk {pct:.1f}% used"

TASKS = [
    Task(name="Heartbeat",   interval_s=30,   func=heartbeat),
    Task(name="Disk Check",  interval_s=120,  func=check_disk),
    Task(name="Date/Time",   interval_s=60,   command="date"),
    # Add more tasks below:
    # Task(name="My Backup", interval_s=3600, command="python 08_env_backup.py --sources /data --dest /backups --keep 7"),
]

# ────────────────────────────────────────────────────────────────────────────

def scheduler_loop(tasks, poll_interval=5):
    log.info(f"Scheduler started with {len(tasks)} task(s). Press Ctrl+C to stop.")
    try:
        while True:
            for task in tasks:
                if task.is_due():
                    t = threading.Thread(target=task.run, daemon=True)
                    t.start()
            time.sleep(poll_interval)
    except KeyboardInterrupt:
        log.info("Scheduler stopped.")
        for task in tasks:
            log.info(f"  {task.name}: ran {task.run_count} time(s)")

if __name__ == "__main__":
    scheduler_loop(TASKS)
