#!/usr/bin/env python3
"""HyperBoost Device Info Scanner"""
import subprocess
import json

def get_prop(prop: str) -> str:
    try:
        return subprocess.check_output(['adb', 'shell', 'getprop', prop]).decode().strip()
    except:
        return "Unknown"

def main():
    info = {
        "model": get_prop("ro.product.model"),
        "brand": get_prop("ro.product.brand"),
        "android": get_prop("ro.build.version.release"),
        "sdk": get_prop("ro.build.version.sdk"),
        "chipset": get_prop("ro.board.platform"),
        "density": get_prop("ro.sf.lcd_density"),
    }
    print(json.dumps(info, indent=2))

if __name__ == "__main__":
    main()