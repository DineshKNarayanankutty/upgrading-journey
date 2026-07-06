import subprocess

servers = ["10.0.1.10", "10.0.1.11", "10.0.1.12"]

for server in servers:
    result = subprocess.run(["ping", "-c", "1", server], capture_output=True)

    if result.returncode == 0:
        print(f"{server} is UP")
    else:
        print(f"{server} is DOWN")