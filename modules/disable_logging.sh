#!/bin/bash
# =====================================================================
# HYPERBOOST - DISABLE LOGGING
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Disabling system logging...${NC}"
adb shell settings put global activity_starts_logging_enabled 0 2>/dev/null
adb shell setprop log.tag.all "" 2>/dev/null
adb shell setprop persist.log.tag 0 2>/dev/null
adb shell setprop ro.logd.kernel false 2>/dev/null
adb shell setprop persist.logd.size 0 2>/dev/null
echo -e "${GREEN}[✓] Logging disabled!${NC}"