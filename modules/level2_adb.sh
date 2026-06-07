#!/bin/bash
# =====================================================================
# HYPERBOOST LEVEL 2 - ADB SHELL OPTIMIZATION
# Requires ADB connection
# =====================================================================

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   HYPERBOOST LEVEL 2 - ADB MODE           ║${NC}"
echo -e "${BLUE}║   Requires ADB | No Root Needed           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"

# Check ADB
if ! command -v adb &>/dev/null; then
    echo -e "${RED}[✗] ADB not found!${NC}"
    exit 1
fi

if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo -e "${RED}[✗] No ADB device connected!${NC}"
    exit 1
fi

echo -e "\n${YELLOW}[*] Applying Level 2 optimizations...${NC}"

# Disable animations
adb shell settings put global window_animation_scale 0.0
adb shell settings put global transition_animation_scale 0.0
adb shell settings put global animator_duration_scale 0.0
echo -e "${GREEN}  ✓ Animations disabled${NC}"

# Force GPU rendering
adb shell settings put global force_gpu_rendering 1
adb shell settings put global hardware_ui 1
echo -e "${GREEN}  ✓ GPU rendering forced${NC}"

# Disable background check
adb shell settings put global activity_manager_constants "max_cached_processes=32"
adb shell settings put global always_finish_activities 1
echo -e "${GREEN}  ✓ Background processes optimized${NC}"

# Performance mode
adb shell cmd power set-fixed-performance-mode-enabled true 2>/dev/null
adb shell cmd power set-adaptive-power-saver-enabled false 2>/dev/null
echo -e "${GREEN}  ✓ Performance mode enabled${NC}"

# Network optimization
adb shell settings put global wifi_scan_always_enabled 0
adb shell settings put global mobile_data_always_on 1
adb shell settings put global tethering_always_on 0
echo -e "${GREEN}  ✓ Network optimized${NC}"

# Disable logging
adb shell settings put global activity_starts_logging_enabled 0
echo -e "${GREEN}  ✓ Logging reduced${NC}"

# GPU debug
adb shell setprop debug.hwui.renderer skiagl 2>/dev/null
adb shell setprop debug.hwui.fps_divisor 0 2>/dev/null
adb shell setprop persist.graphics.vulkan 1 2>/dev/null
echo -e "${GREEN}  ✓ GPU debug props set${NC}"

echo -e "\n${GREEN}[✓] Level 2 optimization complete!${NC}"
echo -e "${YELLOW}[!] Restart device for best results.${NC}"