#!/bin/bash
# =====================================================================
# HYPERBOOST - ONEPLUS DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ONEPLUS_BLOAT=(
    "com.oneplus.brickmode" "com.oneplus.gallery" "com.oneplus.music"
    "com.oneplus.calculator" "com.oneplus.compass" "com.oneplus.weather"
    "com.oneplus.note" "com.oneplus.soundrecorder" "com.oneplus.gamespace"
    "com.oneplus.opbugreport" "net.oneplus.weather" "com.oneplus.dialer"
    "com.facebook.appmanager" "com.facebook.system"
)
echo -e "${YELLOW}[*] Removing OnePlus bloatware...${NC}"
for pkg in "${ONEPLUS_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] OnePlus debloat complete!${NC}"