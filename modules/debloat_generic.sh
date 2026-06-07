#!/bin/bash
# =====================================================================
# HYPERBOOST - GENERIC DEBLOATER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
GENERIC_BLOAT=(
    "com.google.android.apps.maps" "com.google.android.apps.photos"
    "com.google.android.videos" "com.google.android.music"
    "com.google.android.apps.docs" "com.google.android.apps.tachyon"
    "com.google.android.apps.youtube.music" "com.google.android.apps.podcasts"
    "com.facebook.appmanager" "com.facebook.system" "com.facebook.services"
    "com.instagram.android" "com.twitter.android"
    "com.netflix.mediaclient" "com.netflix.partner.activation"
    "com.microsoft.office.excel" "com.microsoft.office.word"
    "com.microsoft.office.powerpoint" "com.dropbox.android"
    "com.spotify.music" "com.amazon.mShop.android.shopping"
)
echo -e "${YELLOW}[*] Removing generic bloatware...${NC}"
echo -e "${RED}[!] Some apps may be useful. Review carefully.${NC}"
for pkg in "${GENERIC_BLOAT[@]}"; do
    if adb shell pm list packages 2>/dev/null | grep -q "$pkg"; then
        read -p "Remove $pkg? (y/n): " confirm
        [ "$confirm" = "y" ] && adb shell pm uninstall --user 0 "$pkg" 2>/dev/null && echo -e "${GREEN}  ✓ Removed${NC}"
    fi
done
echo -e "${GREEN}[✓] Generic debloat complete!${NC}"