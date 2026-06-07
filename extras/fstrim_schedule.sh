#!/bin/bash
# =====================================================================
# HYPERBOOST - FSTRIM SCHEDULER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Running FSTRIM...${NC}"
adb shell "su -c 'fstrim -v /data'" 2>/dev/null || adb shell "fstrim -v /data" 2>/dev/null
adb shell "su -c 'fstrim -v /cache'" 2>/dev/null
adb shell "su -c 'fstrim -v /system'" 2>/dev/null
echo -e "${GREEN}[✓] FSTRIM complete!${NC}"