#!/bin/bash
# =====================================================================
# HYPERBOOST - NOTHING PHONE DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
NOTHING_BLOAT=(
    "com.nothing.weather" "com.nothing.recorder" "com.nothing.launcher"
    "com.nothing.gallery" "com.nothing.calculator" "com.nothing.compass"
    "com.facebook.appmanager" "com.facebook.system"
)
echo -e "${YELLOW}[*] Removing Nothing bloatware...${NC}"
for pkg in "${NOTHING_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] Nothing debloat complete!${NC}"