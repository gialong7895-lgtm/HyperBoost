#!/bin/bash
# =====================================================================
# HYPERBOOST - BATTERY CALIBRATION
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Calibrating battery...${NC}"
adb shell "su -c 'rm -rf /data/system/batterystats.bin'" 2>/dev/null
adb shell dumpsys batterystats --reset 2>/dev/null
echo -e "${GREEN}[✓] Battery stats reset! Charge to 100% to complete calibration.${NC}"