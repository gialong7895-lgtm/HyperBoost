#!/bin/bash
# =====================================================================
# HYPERBOOST - ENABLE VULKAN FOR ALL SUPPORTED GAMES
# =====================================================================

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   ENABLE VULKAN - ALL GAMES               ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"

# System Vulkan
echo -e "${YELLOW}[*] Enabling Vulkan system-wide...${NC}"
adb shell setprop persist.graphics.vulkan 1 2>/dev/null
adb shell setprop debug.hwui.renderer vulkan 2>/dev/null
adb shell setprop ro.hardware.vulkan 1 2>/dev/null
echo -e "${GREEN}  ✓ System Vulkan enabled${NC}"

# ANGLE configuration
echo -e "${YELLOW}[*] Configuring ANGLE...${NC}"
ANGLE_PKGS="com.miHoYo.GenshinImpact;com.activision.callofduty.shooter;com.pubg.newstate;com.tencent.ig;com.dts.freefiremax;com.riotgames.league.wildrift;com.kurogame.punishinggrayraven;com.HoYoverse.hkrpg;com.netease.g123;com.epicgames.fortnite;com.gameloft.android.ANMP.GloftA9HM;com.madfingergames.shadowgun;com.netease.identityv;com.badflyinteractive.deadtrigger2;com.miHoYo.bh3global;com.netease.diabloimmortal;com.tencent.crossfire;com.roblox.client;com.konami.pesam"
ANGLE_VALS="angle;angle;angle;angle;angle;angle;angle;angle;angle;angle;angle;angle;angle;angle;angle;angle;angle;angle;angle"

adb shell settings put global angle_gl_driver_selection_pkgs "$ANGLE_PKGS" 2>/dev/null
adb shell settings put global angle_gl_driver_selection_values "$ANGLE_VALS" 2>/dev/null
echo -e "${GREEN}  ✓ ANGLE configured for all games${NC}"

echo -e "\n${GREEN}[✓] Vulkan enabled! Restart games to apply.${NC}"