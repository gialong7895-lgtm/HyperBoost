#!/bin/bash
# =====================================================================
# HYPERBOOST - NOKIA DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
NOKIA_BLOAT=(
    "com.hmdglobal.app.help" "com.hmdglobal.support" "com.evenwell.customerfeedback"
    "com.evenwell.usage" "com.evenwell.powersuite" "com.evenwell.autoregistration"
    "com.nokia.weather" "com.nokia.compass" "com.nokia.calculator"
    "com.facebook.appmanager" "com.facebook.system"
)
echo -e "${YELLOW}[*] Removing Nokia bloatware...${NC}"
for pkg in "${NOKIA_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] Nokia debloat complete!${NC}"