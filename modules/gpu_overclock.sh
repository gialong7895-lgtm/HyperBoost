#!/bin/bash
# =====================================================================
# HYPERBOOST v1.1 - GPU OVERCLOCK (ROOT)
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
echo -e "${RED}║     GPU OVERCLOCK v1.1 (ROOT REQUIRED)     ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
echo ""

if ! adb shell "su -c 'id'" 2>/dev/null | grep -q "uid=0"; then
    echo -e "${RED}[✗] Yêu cầu Root!${NC}"
    exit 1
fi

GPU_PATH="/sys/class/kgsl/kgsl-3d0"
GPU_MAX_FREQ=$(adb shell cat $GPU_PATH/max_gpuclk 2>/dev/null)

if [ -z "$GPU_MAX_FREQ" ]; then
    echo -e "${RED}[✗] Không tìm thấy GPU sysfs!${NC}"
    exit 1
fi

echo -e "${YELLOW}[*] GPU Max Freq hiện tại: ${GPU_MAX_FREQ} Hz${NC}"
echo -e "${YELLOW}[*] Đang ép xung GPU...${NC}"

# Set governor performance
adb shell "su -c 'echo performance > $GPU_PATH/devfreq/governor'" 2>/dev/null

# Set max freq
adb shell "su -c 'echo $GPU_MAX_FREQ > $GPU_PATH/max_gpuclk'" 2>/dev/null

# Set min freq = 50% max
MIN_GPU=$((GPU_MAX_FREQ / 2))
adb shell "su -c 'echo $MIN_GPU > $GPU_PATH/min_gpuclk'" 2>/dev/null

echo -e "${GREEN}[✓] GPU Overclock hoàn tất!${NC}"
echo -e "  Governor: ${GREEN}performance${NC}"
echo -e "  Max: ${GREEN}${GPU_MAX_FREQ} Hz${NC}"
echo -e "  Min: ${GREEN}${MIN_GPU} Hz${NC}"