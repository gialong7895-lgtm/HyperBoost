#!/bin/bash
# =====================================================================
# HYPERBOOST - FORCE 90 FPS FOR ALL SUPPORTED GAMES
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   FORCE 90 FPS - ALL GAMES                ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"

echo -e "${YELLOW}[*] Setting refresh rate to 90Hz...${NC}"
adb shell settings put system peak_refresh_rate 90 2>/dev/null
adb shell settings put system min_refresh_rate 90 2>/dev/null

GAMES_90FPS=(
    "com.dts.freefireth" "com.netease.lostlight" "com.tencent.subnautica"
    "com.netease.mir4" "com.nexon.v4" "com.netease.dbsoftware"
    "com.tencent.l4d" "com.valvesoftware.csgo"
    "com.netease.diabloimmortal" "com.tencent.pao"
    "com.ea.gp.fifamobile" "com.gameloft.android.GloftGHHM"
    "com.garena.game.kgvn"
)
for pkg in "${GAMES_90FPS[@]}"; do
    adb shell settings put global "${pkg}_max_fps" 90 2>/dev/null
    adb shell dumpsys deviceidle whitelist +$pkg 2>/dev/null
done
echo -e "${GREEN}[✓] 90 FPS applied to all compatible games!${NC}"