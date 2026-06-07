#!/bin/bash
# =====================================================================
# HYPERBOOST DEVICE INFO SCANNER
# Detailed device information
# =====================================================================

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     DEVICE INFORMATION SCANNER            ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"

if command -v adb &>/dev/null && adb devices 2>/dev/null | grep -q "device$"; then
    echo -e "\n${GREEN}[*] Connected Device Info:${NC}"
    echo -e " Model: $(adb shell getprop ro.product.model 2>/dev/null)"
    echo -e " Brand: $(adb shell getprop ro.product.brand 2>/dev/null)"
    echo -e " Android: $(adb shell getprop ro.build.version.release 2>/dev/null)"
    echo -e " SDK: $(adb shell getprop ro.build.version.sdk 2>/dev/null)"
    echo -e " Chipset: $(adb shell getprop ro.board.platform 2>/dev/null)"
    echo -e " CPU: $(adb shell cat /proc/cpuinfo 2>/dev/null | grep 'Hardware' | head -1)"
    echo -e " RAM: $(adb shell cat /proc/meminfo 2>/dev/null | grep 'MemTotal' | head -1)"
    echo -e " GPU: $(adb shell getprop ro.hardware.vulkan 2>/dev/null)"
    echo -e " Density: $(adb shell getprop ro.sf.lcd_density 2>/dev/null)"
    echo -e " Resolution: $(adb shell wm size 2>/dev/null)"
    echo -e " Refresh Rate: $(adb shell dumpsys display 2>/dev/null | grep refreshRate | head -1)"
else
    echo -e "${YELLOW}[!] No ADB device connected${NC}"
    
    if [ -f /system/build.prop ]; then
        echo -e "\n${GREEN}[*] Local Device Info:${NC}"
        grep "ro.product.model" /system/build.prop 2>/dev/null
        grep "ro.build.version.release" /system/build.prop 2>/dev/null
    fi
fi