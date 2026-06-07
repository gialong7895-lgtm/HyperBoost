#!/bin/bash
# =====================================================================
# HYPERBOOST - BATTERY SAVER TWEAKS
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Applying battery saver tweaks...${NC}"
adb shell settings put global aggressive_idle_enabled 1 2>/dev/null
adb shell settings put global aggressive_standby_enabled 1 2>/dev/null
adb shell settings put global app_standby_enabled 1 2>/dev/null
adb shell settings put system intelligent_sleep_mode 1 2>/dev/null
adb shell cmd power set-adaptive-power-saver-enabled true 2>/dev/null
echo -e "${GREEN}[✓] Battery saver tweaks applied!${NC}"