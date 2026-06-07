#!/bin/bash
# =====================================================================
# HYPERBOOST - XIAOMI/HYPEROS DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
XIAOMI_BLOAT=(
    "com.miui.analytics" "com.miui.msa.global" "com.xiaomi.glgm"
    "com.miui.player" "com.miui.video" "com.miui.notes"
    "com.miui.compass" "com.miui.weather2" "com.miui.cleanmaster"
    "com.miui.powerkeeper" "com.xiaomi.payment" "com.mipay.wallet"
    "com.xiaomi.midrop" "com.miui.bugreport" "com.miui.daemon"
    "com.xiaomi.mirecycle" "com.miui.android.fashiongallery"
    "com.miui.gallery" "com.miui.miservice" "com.miui.newhome"
    "com.xiaomi.scanner" "com.miui.yellowpage" "com.miui.hybrid"
    "com.facebook.appmanager" "com.facebook.system"
)
echo -e "${YELLOW}[*] Removing Xiaomi bloatware...${NC}"
for pkg in "${XIAOMI_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
adb shell settings put secure miui_ad_filter_enabled 1 2>/dev/null
adb shell settings put system msa_show_ad 0 2>/dev/null
echo -e "${GREEN}[✓] Xiaomi debloat complete!${NC}"