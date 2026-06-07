#!/bin/bash
# =====================================================================
# HYPERBOOST - GPU RENDERING TWEAKS
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Tweaking GPU rendering...${NC}"
adb shell settings put global force_gpu_rendering 1 2>/dev/null
adb shell settings put global hardware_ui 1 2>/dev/null
adb shell setprop debug.hwui.renderer skiagl 2>/dev/null
adb shell setprop debug.hwui.fps_divisor 0 2>/dev/null
adb shell setprop debug.composition.type gpu 2>/dev/null
adb shell setprop persist.sys.composition.type gpu 2>/dev/null
echo -e "${GREEN}[✓] GPU rendering optimized!${NC}"