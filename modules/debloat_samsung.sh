#!/bin/bash
# =====================================================================
# HYPERBOOST - SAMSUNG DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
SAMSUNG_BLOAT=(
    "com.samsung.android.bixby.wakeup" "com.samsung.android.bixby.agent"
    "com.samsung.android.bixby.agent.dummy" "com.samsung.android.bixbyvision.framework"
    "com.samsung.android.aremoji" "com.samsung.android.arzone"
    "com.samsung.android.game.gametools" "com.samsung.android.game.gamehome"
    "com.samsung.android.game.gos" "com.samsung.android.kidsinstaller"
    "com.samsung.android.service.peoplestripe" "com.samsung.android.spayfw"
    "com.samsung.android.samsungpass" "com.samsung.android.scloud"
    "com.samsung.android.kgclient" "com.samsung.android.mdx"
    "com.facebook.appmanager" "com.facebook.system" "com.facebook.services"
    "com.microsoft.skydrive" "com.microsoft.office.officehubrow"
)
echo -e "${YELLOW}[*] Removing Samsung bloatware...${NC}"
for pkg in "${SAMSUNG_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
adb shell settings put global sem_enhanced_cpu_responsiveness 1 2>/dev/null
adb shell settings put system game_auto_temperature_control 0 2>/dev/null
echo -e "${GREEN}[✓] Samsung debloat complete!${NC}"