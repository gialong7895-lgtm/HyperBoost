#!/bin/bash
# =====================================================================
# HYPERBOOST - GPU TUNING
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Tuning GPU...${NC}"
adb shell "su -c 'echo performance > /sys/class/kgsl/kgsl-3d0/devfreq/governor'" 2>/dev/null
if [ -f /sys/class/kgsl/kgsl-3d0/max_gpuclk ]; then
    MAX_GPU=$(adb shell cat /sys/class/kgsl/kgsl-3d0/max_gpuclk 2>/dev/null)
    adb shell "su -c 'echo $MAX_GPU > /sys/class/kgsl/kgsl-3d0/max_gpuclk'" 2>/dev/null
fi
adb shell setprop persist.graphics.vulkan 1 2>/dev/null
adb shell setprop debug.hwui.renderer vulkan 2>/dev/null
echo -e "${GREEN}[✓] GPU tuned!${NC}"