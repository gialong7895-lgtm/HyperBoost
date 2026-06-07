#!/bin/bash
# =====================================================================
# HYPERBOOST - ZTE DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ZTE_BLOAT=(
    "com.zte.browser" "com.zte.music" "com.zte.video" "com.zte.gallery"
    "com.zte.compass" "com.zte.calculator" "com.zte.weather" "com.zte.note"
    "com.zte.appmarket" "com.zte.gamecenter" "com.zte.heartyservice"
    "com.zte.backup" "com.zte.mipop" "com.facebook.appmanager"
)
echo -e "${YELLOW}[*] Removing ZTE bloatware...${NC}"
for pkg in "${ZTE_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] ZTE debloat complete!${NC}"