#!/usr/bin/env python3
"""HyperBoost ADB Shell Wrapper"""
import subprocess
import sys

def adb_command(cmd: str) -> str:
    """Execute ADB command and return output"""
    try:
        result = subprocess.run(['adb', 'shell', cmd], capture_output=True, text=True)
        return result.stdout.strip()
    except FileNotFoundError:
        print("ADB not found! Install Android Platform Tools.")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        print(adb_command(' '.join(sys.argv[1:])))
    else:
        print("Usage: python adb_shell_wrapper.py <command>")