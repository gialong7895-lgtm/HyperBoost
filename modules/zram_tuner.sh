#!/bin/bash
# =====================================================================
# HYPERBOOST - ZRAM TUNER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Tuning ZRAM...${NC}"
adb shell "su -c 'swapoff /dev/block/zram0'" 2>/dev/null
adb shell "su -c 'echo 1 > /sys/block/zram0/reset'" 2>/dev/null
adb shell "su -c 'echo 0 > /proc/sys/vm/swappiness'" 2>/dev/null
echo -e "${GREEN}[✓] ZRAM tuned!${NC}"