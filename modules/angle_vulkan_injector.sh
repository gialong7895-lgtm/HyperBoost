#!/bin/bash
# =====================================================================
# HYPERBOOST - ANGLE/VULKAN INJECTOR
# Force OpenGL ES to Vulkan translation for better performance
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     ANGLE / VULKAN INJECTOR               ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"

echo -e "${YELLOW}[*] Enabling ANGLE for supported games...${NC}"

ANGLE_PKGS="com.miHoYo.GenshinImpact;com.activision.callofduty.shooter;com.pubg.newstate;com.tencent.ig;com.dts.freefiremax;com.riotgames.league.wildrift;com.kurogame.punishinggrayraven;com.garena.game.kgvn"
ANGLE_VALS="angle;angle;angle;angle;angle;angle;angle"

adb shell settings put global angle_gl_driver_selection_pkgs "$ANGLE_PKGS" 2>/dev/null
adb shell settings put global angle_gl_driver_selection_values "$ANGLE_VALS" 2>/dev/null

adb shell setprop persist.graphics.vulkan 1 2>/dev/null
adb shell setprop debug.hwui.renderer vulkan 2>/dev/null

echo -e "${GREEN}[✓] ANGLE/Vulkan injected successfully!${NC}"
echo -e "${YELLOW}[!] Restart games to apply changes${NC}"