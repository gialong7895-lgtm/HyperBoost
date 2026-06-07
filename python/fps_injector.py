#!/usr/bin/env python3
"""HyperBoost FPS Injector"""
import subprocess
import sys

def inject_fps(package: str, fps: int = 120):
    commands = [
        f"settings put global {package}_max_fps {fps}",
        f"settings put system {package}_frame_rate {fps}",
        f"dumpsys deviceidle whitelist +{package}"
    ]
    for cmd in commands:
        subprocess.run(['adb', 'shell', cmd], capture_output=True)
    print(f"[✓] {package} set to {fps} FPS")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        inject_fps(sys.argv[1], int(sys.argv[2]) if len(sys.argv) > 2 else 120)
    else:
        print("Usage: python fps_injector.py <package> [fps]")