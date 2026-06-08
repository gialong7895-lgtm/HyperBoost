#!/bin/bash
# =====================================================================
# HYPERBOOST v1.1 - MAX PERFORMANCE MODE
# Bật tất cả chế độ hiệu năng
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
echo -e "${RED}║     MAX PERFORMANCE MODE v1.1              ║${NC}"
echo -e "${RED}║     HIỆU NĂNG TỐI ĐA                      ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}[1/8] CPU Performance...${NC}"
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    adb shell "su -c 'echo performance > $cpu'" 2>/dev/null
done
adb shell cmd power set-fixed-performance-mode-enabled true 2>/dev/null
echo -e "${GREEN}  ✓ CPU Governor: PERFORMANCE${NC}"

echo -e "${YELLOW}[2/8] GPU Performance...${NC}"
adb shell "su -c 'echo performance > /sys/class/kgsl/kgsl-3d0/devfreq/governor'" 2>/dev/null
adb shell setprop persist.graphics.vulkan 1 2>/dev/null
echo -e "${GREEN}  ✓ GPU Governor: PERFORMANCE${NC}"

echo -e "${YELLOW}[3/8] I/O Performance...${NC}"
for queue in /sys/block/*/queue/scheduler; do
    adb shell "su -c 'echo fiops > $queue'" 2>/dev/null
done
echo -e "${GREEN}  ✓ I/O Scheduler: FIOPS${NC}"

echo -e "${YELLOW}[4/8] RAM Optimization...${NC}"
adb shell "su -c 'echo 20 > /proc/sys/vm/swappiness'" 2>/dev/null
adb shell "su -c 'echo 50 > /proc/sys/vm/vfs_cache_pressure'" 2>/dev/null
echo -e "${GREEN}  ✓ RAM optimized${NC}"

echo -e "${YELLOW}[5/8] Network Boost...${NC}"
adb shell "su -c 'echo 1 > /proc/sys/net/ipv4/tcp_low_latency'" 2>/dev/null
adb shell settings put global wifi_scan_always_enabled 0 2>/dev/null
echo -e "${GREEN}  ✓ Network low latency${NC}"

echo -e "${YELLOW}[6/8] Thermal Unlock...${NC}"
adb shell "su -c 'stop thermal-engine'" 2>/dev/null
echo -e "${RED}  ⚠ Thermal disabled - Monitor temperature!${NC}"

echo -e "${YELLOW}[7/8] Animation Speed...${NC}"
adb shell settings put global window_animation_scale 0.0 2>/dev/null
adb shell settings put global transition_animation_scale 0.0 2>/dev/null
adb shell settings put global animator_duration_scale 0.0 2>/dev/null
echo -e "${GREEN}  ✓ Animations disabled${NC}"

echo -e "${YELLOW}[8/8] Dalvik/ART Optimization...${NC}"
adb shell "su -c 'rm -rf /data/dalvik-cache/*'" 2>/dev/null
echo -e "${GREEN}  ✓ Dalvik cache cleared${NC}"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ MAX PERFORMANCE MODE ACTIVATED!        ║${NC}"
echo -e "${GREEN}║   ⚠ REBOOT REQUIRED                       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"