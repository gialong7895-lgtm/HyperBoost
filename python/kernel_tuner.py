#!/usr/bin/env python3
"""HyperBoost Kernel Tuner"""
import subprocess
import sys

def set_governor(governor: str = "performance"):
    for cpu in range(8):
        path = f"/sys/devices/system/cpu/cpu{cpu}/cpufreq/scaling_governor"
        subprocess.run(['adb', 'shell', f'echo {governor} > {path}'], capture_output=True)
    print(f"[✓] CPU Governor set to {governor}")

if __name__ == "__main__":
    gov = sys.argv[1] if len(sys.argv) > 1 else "performance"
    set_governor(gov)