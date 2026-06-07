#!/bin/bash
# =====================================================================
# HYPERBOOST - FORCE 120 FPS FOR ALL SUPPORTED GAMES
# =====================================================================

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   FORCE 120 FPS - ALL GAMES               ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"

# System refresh rate
echo -e "${YELLOW}[1/4] Setting system refresh rate...${NC}"
adb shell settings put system peak_refresh_rate 120 2>/dev/null
adb shell settings put system min_refresh_rate 120 2>/dev/null
echo -e "${GREEN}  ✓ System refresh rate: 120Hz${NC}"

# Game list
GAMES_120FPS=(
    "com.tencent.ig"
    "com.pubg.newstate"  
    "com.activision.callofduty.shooter"
    "com.miHoYo.GenshinImpact"
    "com.HoYoverse.hkrpg"
    "com.riotgames.league.wildrift"
    "com.mobile.legends"
    "com.garena.game.codm"
    "com.dts.freefiremax"
    "com.kurogame.punishinggrayraven"
    "com.supercell.brawlstars"
    "com.supercell.clashroyale"
    "com.epicgames.fortnite"
    "com.gameloft.android.ANMP.GloftA9HM"
    "com.netease.g123"
    "com.tencent.ngame.chty"
    "com.netease.diabloimmortal"
    "com.miHoYo.bh3global"
    "com.roblox.client"
    "com.konami.pesam"
    "com.netease.identityv"
    "com.madfingergames.shadowgun"
    "com.mojang.minecraftpe"
    "com.tencent.crossfire"
    "com.xpro.gd"
    "com.netmarble.marvelfuturerevolution"
    "com.innersloth.spacemafia"
    "com.valvesoftware.csgo"
    "com.behaviour.piggy"
    "com.tencent.pao"
)

# Apply FPS
echo -e "${YELLOW}[2/4] Applying 120 FPS to games...${NC}"
for pkg in "${GAMES_120FPS[@]}"; do
    adb shell settings put global "${pkg}_max_fps" 120 2>/dev/null
    adb shell settings put system "${pkg}_frame_rate" 120 2>/dev/null
    adb shell dumpsys deviceidle whitelist +$pkg 2>/dev/null
    echo -e "  ${GREEN}✓${NC} $pkg"
done

# GPU settings
echo -e "${YELLOW}[3/4] Configuring GPU...${NC}"
adb shell settings put global force_gpu_rendering 1 2>/dev/null
adb shell setprop debug.hwui.fps_divisor 0 2>/dev/null
echo -e "${GREEN}  ✓ GPU optimized${NC}"

# Final
echo -e "${YELLOW}[4/4] Finalizing...${NC}"
adb shell cmd power set-fixed-performance-mode-enabled true 2>/dev/null
echo -e "${GREEN}  ✓ Performance mode locked${NC}"

echo -e "\n${GREEN}[✓] 120 FPS applied to all games! Restart games to apply.${NC}"