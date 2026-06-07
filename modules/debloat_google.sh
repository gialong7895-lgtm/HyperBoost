#!/bin/bash
# =====================================================================
# HYPERBOOST - GOOGLE PIXEL DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
GOOGLE_BLOAT=(
    "com.google.android.apps.maps" "com.google.android.apps.photos"
    "com.google.android.apps.docs" "com.google.android.apps.tachyon"
    "com.google.android.videos" "com.google.android.music"
    "com.google.android.apps.youtube.music" "com.google.android.apps.podcasts"
    "com.google.android.apps.nbu.files" "com.google.android.apps.wellbeing"
    "com.google.android.apps.subscriptions.red" "com.google.android.apps.recorder"
    "com.google.android.apps.googleassistant"
)
echo -e "${YELLOW}[*] Removing Google bloatware...${NC}"
for pkg in "${GOOGLE_BLOAT[@]}"; do
    adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${NC}" || echo -e "  ${YELLOW}⊘ $pkg${NC}"
done
echo -e "${GREEN}[✓] Google debloat complete!${NC}"