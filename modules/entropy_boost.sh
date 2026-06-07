#!/bin/bash
# =====================================================================
# HYPERBOOST - ENTROPY BOOST
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Boosting entropy...${NC}"
if adb shell "su -c 'echo 128 > /proc/sys/kernel/random/read_wakeup_threshold'" 2>/dev/null; then
    adb shell su -c "echo 256 > /proc/sys/kernel/random/write_wakeup_threshold" 2>/dev/null
    adb shell su -c "echo 512 > /proc/sys/kernel/random/entropy_avail" 2>/dev/null
    echo -e "${GREEN}  ✓ Root entropy boost applied${NC}"
fi
adb shell settings put global entropy_level 512 2>/dev/null
echo -e "${GREEN}[✓] Entropy boosted!${NC}"