#!/bin/bash
# =====================================================================
# HYPERBOOST - HONOR DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
HONOR_BLOAT=(
    "com.hihonor.appmarket" "com.hihonor.health" "com.hihonor.hiview"
    "com.hihonor.phoneservice" "com.hihonor.search" "com.hihonor.android.launcher"
    "com.hihonor.video" "com.hihonor.music" "com.hihonor.browser"
    "com.hihonor.compass" "com.hihonor.calculator" "com.hihonor.notepad"
    "com.facebook.appmanager" "com.facebook.system"
)
echo -e "${YELLOW}[*] Removing Honor bloatware...${NC}"
for pkg in "${HONOR_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] Honor debloat complete!${NC}"