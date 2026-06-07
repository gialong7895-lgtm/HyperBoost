#!/usr/bin/env python3
"""HyperBoost Vulkan Layer Manager"""
import subprocess

def enable_vulkan(package: str):
    commands = [
        f"settings put global {package}_vulkan 1",
        f"setprop persist.graphics.vulkan 1",
        f"setprop debug.hwui.renderer vulkan"
    ]
    for cmd in commands:
        subprocess.run(['adb', 'shell', cmd], capture_output=True)
    print(f"[✓] Vulkan enabled for {package}")

if __name__ == "__main__":
    enable_vulkan("com.miHoYo.GenshinImpact")