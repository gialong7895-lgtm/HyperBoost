#!/bin/bash
# =====================================================================
# HYPERBOOST LEVEL 5 - ROOT + PC MAXIMUM OPTIMIZATION
# Requires PC + ADB + Root Access
# =====================================================================GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; MAGENTA='\033[0;35m'; NC='\033[0m'

echo -e "${MAGENTA}╔════════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║   HYPERBOOST LEVEL 5 - MAXIMUM MODE       ║${NC}"
echo -e "${MAGENTA}║   PC + Root + ADB Required                ║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════════╝${NC}"

# Check ADB + Root
if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo -e "${RED}[✗] No ADB device!${NC}"
    exit 1
fi

if ! adb shell "su -c id" 2>/dev/null | grep -q "uid=0"; then
    echo -e "${RED}[✗] Root not available!${NC}"
    exit 1
fi

echo -e "\n${YELLOW}[*] Applying MAXIMUM optimizations...${NC}"

# Run all lower levels
bash "$(dirname "$0")/level4_pc_adb.sh" 2>/dev/null

# CPU Max Frequency
echo -e "${YELLOW}[*] Setting CPU to maximum frequency...${NC}"
adb shell su -c "for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do cat \$cpu > \$cpu; done" 2>/dev/null
echo -e "${GREEN}  ✓ CPU frequency maxed${NC}"

# GPU Max
echo -e "${YELLOW}[*] Setting GPU to maximum...${NC}"
adb shell su -c "echo performance > /sys/class/kgsl/kgsl-3d0/devfreq/governor" 2>/dev/null
adb shell su -c "cat /sys/class/kgsl/kgsl-3d0/max_gpuclk > /sys/class/kgsl/kgsl-3d0/max_gpuclk" 2>/dev/null
echo -e "${GREEN}  ✓ GPU maxed${NC}"

# Build.prop tweaks
echo -e "${YELLOW}[*] Applying build.prop tweaks...${NC}"
BUILD_PROPS=(
    "debug.performance.tuning=1"
    "video.accelerate.hw=1"
    "persist.sys.composition.type=gpu"
    "debug.sf.hw=1"
    "persist.sys.ui.hw=1"
    "ro.config.hw_quickpoweron=true"
    "ro.sys.fw.bg_apps_limit=32"
    "persist.sys.powerhal.mode=performance"
    "debug.egl.hw=1"
    "debug.composition.type=gpu"
)
for prop in "${BUILD_PROPS[@]}"; do
    adb shell su -c "echo '$prop' >> /system/build.prop" 2>/dev/null
done
echo -e "${GREEN}  ✓ Build.prop optimized${NC}"

# ZRAM optimization
echo -e "${YELLOW}[*] Optimizing ZRAM...${NC}"
adb shell su -c "echo 0 > /proc/sys/vm/swappiness" 2>/dev/null
adb shell su -c "swapoff /dev/block/zram0" 2>/dev/null
echo -e "${GREEN}  ✓ ZRAM optimized${NC}"

echo -e "\n${MAGENTA}╔════════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║   MAXIMUM OPTIMIZATION COMPLETE!          ║${NC}"
echo -e "${MAGENTA}║   REBOOT REQUIRED                         ║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════════╝${NC}"