#!/bin/bash
# =====================================================================
# HYPERBOOST - LENOVO DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
LENOVO_BLOAT=(
    "com.lenovo.browser" "com.lenovo.launcher" "com.lenovo.anyshare"
    "com.lenovo.ue.device" "com.lenovo.smartassistant" "com.lenovo.speechassist"
    "com.lenovo.weather" "com.lenovo.compass" "com.lenovo.calculator"
    "com.lenovo.video" "com.lenovo.music" "com.lenovo.appmarket"
    "com.facebook.appmanager" "com.facebook.system"
)
echo -e "${YELLOW}[*] Removing Lenovo bloatware...${NC}"
for pkg in "${LENOVO_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] Lenovo debloat complete!${NC}"