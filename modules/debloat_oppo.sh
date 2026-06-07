#!/bin/bash
# =====================================================================
# HYPERBOOST - OPPO DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
OPPO_BLOAT=(
    "com.oppo.market" "com.oppo.quicksearchbox" "com.oppo.browser"
    "com.oppo.games" "com.oppo.music" "com.oppo.video"
    "com.oppo.compass" "com.oppo.calculator" "com.oppo.weather"
    "com.oppo.note" "com.oppo.soundrecorder" "com.coloros.gamespace"
    "com.coloros.assistant" "com.coloros.widget" "com.heytap.browser"
    "com.heytap.market" "com.heytap.music" "com.heytap.video"
    "com.facebook.appmanager" "com.facebook.system"
)
echo -e "${YELLOW}[*] Removing OPPO bloatware...${NC}"
for pkg in "${OPPO_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] OPPO debloat complete!${NC}"