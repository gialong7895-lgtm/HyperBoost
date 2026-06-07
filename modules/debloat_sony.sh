#!/bin/bash
# =====================================================================
# HYPERBOOST - SONY DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
SONY_BLOAT=(
    "com.sonyericsson.music" "com.sonyericsson.video" "com.sonyericsson.album"
    "com.sonyericsson.calculator" "com.sonyericsson.compass" "com.sonyericsson.weather"
    "com.sonyericsson.textinput.chinese" "com.sonyericsson.xhs" "com.sonyericsson.updatecenter"
    "com.sonyericsson.support" "com.sonyericsson.lounge" "com.sonyericsson.trackid"
    "com.facebook.appmanager" "com.facebook.system"
)
echo -e "${YELLOW}[*] Removing Sony bloatware...${NC}"
for pkg in "${SONY_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] Sony debloat complete!${NC}"