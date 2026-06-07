#!/usr/bin/env python3
"""HyperBoost Performance Analyzer"""
import subprocess
import time

def measure_fps(package: str, duration: int = 5):
    print(f"Measuring FPS for {package}...")
    subprocess.run(['adb', 'shell', f'dumpsys gfxinfo {package}'], capture_output=True)
    time.sleep(duration)
    result = subprocess.run(['adb', 'shell', f'dumpsys gfxinfo {package}'], capture_output=True, text=True)
    print(result.stdout)

if __name__ == "__main__":
    print("Performance Analyzer - Run while game is open")