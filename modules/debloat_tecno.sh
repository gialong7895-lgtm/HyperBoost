#!/bin/bash
# =====================================================================
# HYPERBOOST - TECNO/INFINIX DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
TECNO_BLOAT=(
    "com.transsion.magazineservice" "com.transsion.weather" "com.transsion.compass"
    "com.transsion.calculator" "com.transsion.browser" "com.transsion.gallery"
    "com.transsion.video" "com.transsion.music" "com.transsion.phonemaster"
    "com.transsion.hicloud" "com.transsion.appmarket" "com.transsion.games"
    "com.facebook.appmanager" "com.facebook.system" "com.facebook.services"
    "com.google.android.apps.maps" "com.google.android.apps.photos"
)
echo -e "${YELLOW}[*] Removing TECNO bloatware...${NC}"
for pkg in "${TECNO_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] TECNO debloat complete!${NC}"