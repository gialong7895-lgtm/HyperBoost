#!/bin/bash
# =====================================================================
# HYPERBOOST - REALME DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
REALME_BLOAT=(
    "com.realme.link" "com.realme.appmarket" "com.realme.browser"
    "com.realme.games" "com.realme.music" "com.realme.video"
    "com.realme.compass" "com.realme.calculator" "com.realme.weather"
    "com.realme.note" "com.realme.soundrecorder" "com.coloros.gamespace"
    "com.heytap.browser" "com.heytap.market" "com.heytap.music"
    "com.facebook.appmanager" "com.facebook.system"
)
echo -e "${YELLOW}[*] Removing Realme bloatware...${NC}"
for pkg in "${REALME_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] Realme debloat complete!${NC}"