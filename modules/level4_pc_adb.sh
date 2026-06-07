#!/bin/bash
# =====================================================================
# HYPERBOOST LEVEL 4 - PC + ADB OPTIMIZATION
# Requires PC with ADB connection
# =====================================================================

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   HYPERBOOST LEVEL 4 - PC + ADB MODE      ║${NC}"
echo -e "${BLUE}║   PC Required | ADB Connection            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"

# Check ADB
if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo -e "${RED}[✗] No ADB device connected!${NC}"
    exit 1
fi

echo -e "\n${YELLOW}[*] Applying Level 4 optimizations...${NC}"

# Run Level 2 first
echo -e "${YELLOW}[*] Running Level 2 base optimizations...${NC}"
bash "$(dirname "$0")/level2_adb.sh" 2>/dev/null

# Disable bloatware
echo -e "${YELLOW}[*] Disabling unnecessary services...${NC}"
BLOAT_SERVICES=(
    "com.google.android.apps.maps"
    "com.google.android.apps.photos"
    "com.google.android.videos"
    "com.google.android.music"
)
for svc in "${BLOAT_SERVICES[@]}"; do
    adb shell pm disable-user --user 0 "$svc" 2>/dev/null && echo -e "${GREEN}  ✓ Disabled: $svc${NC}"
done

# Force max refresh rate
adb shell settings put system peak_refresh_rate 120 2>/dev/null
adb shell settings put system min_refresh_rate 120 2>/dev/null
echo -e "${GREEN}  ✓ Refresh rate set to max${NC}"

# Game optimizations
adb shell settings put global angle_gl_driver_selection_pkgs "com.miHoYo.GenshinImpact;com.tencent.ig;com.activision.callofduty.shooter" 2>/dev/null
adb shell settings put global angle_gl_driver_selection_values "angle;angle;angle" 2>/dev/null
echo -e "${GREEN}  ✓ Game optimizations applied${NC}"

echo -e "\n${GREEN}[✓] Level 4 optimization complete!${NC}"