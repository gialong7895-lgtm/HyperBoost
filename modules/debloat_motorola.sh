#!/bin/bash
# =====================================================================
# HYPERBOOST - MOTOROLA DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
MOTO_BLOAT=(
    "com.motorola.help" "com.motorola.genie" "com.motorola.motocare"
    "com.motorola.motosignature.app" "com.motorola.demo" "com.motorola.brapps"
    "com.motorola.weather" "com.motorola.compass" "com.motorola.gamemode"
    "com.facebook.appmanager" "com.facebook.system" "com.facebook.services"
)
echo -e "${YELLOW}[*] Removing Motorola bloatware...${NC}"
for pkg in "${MOTO_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] Motorola debloat complete!${NC}"