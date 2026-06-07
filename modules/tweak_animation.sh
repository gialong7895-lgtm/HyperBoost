#!/bin/bash
# =====================================================================
# HYPERBOOST - ANIMATION TWEAKS
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Tweaking animations...${NC}"
adb shell settings put global window_animation_scale 0.0 2>/dev/null
adb shell settings put global transition_animation_scale 0.0 2>/dev/null
adb shell settings put global animator_duration_scale 0.0 2>/dev/null
echo -e "${GREEN}[✓] Animations disabled for max speed!${NC}"