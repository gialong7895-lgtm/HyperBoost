#!/bin/bash
# =====================================================================
# HYPERBOOST - HUAWEI DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
HUAWEI_BLOAT=(
    "com.huawei.appmarket" "com.huawei.health" "com.huawei.hwdetectrepair"
    "com.huawei.hiview" "com.huawei.phoneservice" "com.huawei.search"
    "com.huawei.browser" "com.huawei.video" "com.huawei.music"
    "com.huawei.compass" "com.huawei.calculator" "com.huawei.notepad"
    "com.huawei.himovie" "com.huawei.wallet" "com.huawei.android.tips"
    "com.facebook.appmanager" "com.facebook.system"
)
echo -e "${YELLOW}[*] Removing Huawei bloatware...${NC}"
for pkg in "${HUAWEI_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] Huawei debloat complete!${NC}"