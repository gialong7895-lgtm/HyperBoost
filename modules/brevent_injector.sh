#!/bin/bash
# =====================================================================
# HYPERBOOST - BREVENT INJECTOR
# Optimize app standby via Brevent-compatible settings
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Applying Brevent-compatible optimizations...${NC}"
adb shell settings put global app_standby_enabled 1 2>/dev/null
adb shell settings put global aggressive_idle_enabled 1 2>/dev/null
adb shell settings put global aggressive_standby_enabled 1 2>/dev/null
adb shell dumpsys deviceidle enable 2>/dev/null
adb shell dumpsys deviceidle force-idle 2>/dev/null
echo -e "${GREEN}[✓] Brevent optimizations applied!${NC}"