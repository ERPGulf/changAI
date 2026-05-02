import subprocess
import sys

def install_system_deps():
    subprocess.run([
        "sudo", "apt", "install", "-y",
        "libffi-dev", "build-essential"
    ], check=True)