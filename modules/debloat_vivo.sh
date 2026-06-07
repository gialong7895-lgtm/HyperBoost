#!/bin/bash
# =====================================================================
# HYPERBOOST - VIVO DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
VIVO_BLOAT=(
    "com.vivo.browser" "com.vivo.music" "com.video.vivo" "com.vivo.gallery"
    "com.vivo.compass" "com.vivo.calculator" "com.vivo.weather" "com.vivo.note"
    "com.vivo.easyshare" "com.vivo.game" "com.vivo.appstore" "com.vivo.assistant"
    "com.vivo.smartmultiwindow" "com.vivo.smartshot" "com.vivo.vivokaraoke"
    "com.facebook.appmanager" "com.facebook.system"
)
echo -e "${YELLOW}[*] Removing Vivo bloatware...${NC}"
for pkg in "${VIVO_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] Vivo debloat complete!${NC}"