#!/bin/bash
# =====================================================================
# HYPERBOOST - ASUS DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ASUS_BLOAT=(
    "com.asus.calculator" "com.asus.camera" "com.asus.email"
    "com.asus.filemanager" "com.asus.gallery" "com.asus.browser"
    "com.asus.weathertime" "com.asus.soundrecorder" "com.asus.deskclock"
    "com.asus.livedemo" "com.asus.ia.asusapp" "com.asus.zentalk"
    "com.facebook.appmanager" "com.facebook.system" "com.netflix.mediaclient"
)
echo -e "${YELLOW}[*] Removing ASUS bloatware...${NC}"
for pkg in "${ASUS_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] ASUS debloat complete!${NC}"