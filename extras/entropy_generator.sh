#!/bin/bash
# =====================================================================
# HYPERBOOST - ENTROPY GENERATOR
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Generating entropy...${NC}"
adb shell "su -c 'echo 512 > /proc/sys/kernel/random/entropy_avail'" 2>/dev/null
adb shell "su -c 'echo 128 > /proc/sys/kernel/random/read_wakeup_threshold'" 2>/dev/null
adb shell "su -c 'echo 256 > /proc/sys/kernel/random/write_wakeup_threshold'" 2>/dev/null
echo -e "${GREEN}[✓] Entropy boosted!${NC}"