#!/bin/bash
# =====================================================================
# HYPERBOOST - ENABLE VULKAN & ANGLE FOR ALL SUPPORTED GAMES
# =====================================================================

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   ENABLE VULKAN + ANGLE - ALL GAMES       ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"

# ==================== 1. BẬT VULKAN HỆ THỐNG ====================
echo -e "${YELLOW}[1/3] Enabling Vulkan system-wide...${NC}"
adb shell setprop persist.graphics.vulkan 1 2>/dev/null
adb shell setprop debug.hwui.renderer vulkan 2>/dev/null
adb shell setprop ro.hardware.vulkan 1 2>/dev/null
adb shell settings put global force_vulkan_apps "*" 2>/dev/null
echo -e "${GREEN}  ✓ System Vulkan enabled${NC}"

# ==================== 2. BẬT VULKAN CHO GAME HỖ TRỢ SẴN ====================
echo -e "${YELLOW}[2/3] Enabling native Vulkan for supported games...${NC}"

# Game hỗ trợ Vulkan gốc (không cần ANGLE)
VULKAN_NATIVE_GAMES=(
    "com.miHoYo.GenshinImpact"
    "com.activision.callofduty.shooter"
    "com.pubg.newstate"
    "com.dts.freefiremax"
    "com.riotgames.league.wildrift"
    "com.kurogame.punishinggrayraven"
    "com.HoYoverse.hkrpg"
    "com.epicgames.fortnite"
    "com.madfingergames.shadowgun"
    "com.netease.g123"
    "com.miHoYo.bh3global"
    "com.netease.diabloimmortal"
    "com.tencent.hero"
    "com.roblox.client"
    "com.konami.pesam"
    "com.netease.identityv"
    "com.badflyinteractive.deadtrigger2"
    "com.garena.game.kgvn"
)

for pkg in "${VULKAN_NATIVE_GAMES[@]}"; do
    # Bật Vulkan cho game
    adb shell settings put global "${pkg}_vulkan_enabled" 1 2>/dev/null
    adb shell settings put system "${pkg}_render_api" "vulkan" 2>/dev/null
    adb shell settings put global "${pkg}_graphics_api" "vulkan" 2>/dev/null
    
    # Xóa file cấu hình OpenGL cũ nếu có root
    adb shell "su -c 'rm -f /data/data/$pkg/shared_prefs/*opengl*.xml'" 2>/dev/null
    adb shell "su -c 'rm -f /data/data/$pkg/files/graphics_api'" 2>/dev/null
    
    # Tạo file cấu hình Vulkan
    adb shell "su -c 'mkdir -p /data/data/$pkg/files && echo vulkan > /data/data/$pkg/files/graphics_api'" 2>/dev/null
    
    echo -e "  ${GREEN}✓${NC} $pkg → Vulkan Native"
done

# ==================== 3. BẬT ANGLE CHO GAME CHƯA HỖ TRỢ VULKAN ====================
echo -e "${YELLOW}[3/3] Enabling ANGLE (OpenGL→Vulkan) for other games...${NC}"

# Game dùng ANGLE để dịch OpenGL ES → Vulkan
ANGLE_GAMES_PKGS=""
ANGLE_GAMES_VALUES=""

ANGLE_LIST=(
    "com.tencent.ig"          # PUBG Mobile
    "com.mobile.legends"       # MLBB
    "com.supercell.brawlstars" # Brawl Stars
    "com.supercell.clashroyale" # Clash Royale
    "com.gameloft.android.ANMP.GloftA9HM" # Asphalt 9
    "com.tencent.ngame.chty"   # Arena of Valor
    "com.garena.game.codm"     # CODM Garena
    "com.tencent.crossfire"    # CrossFire
    "com.xpro.gd"              # Geometry Dash
    "com.mojang.minecraftpe"   # Minecraft
)

for pkg in "${ANGLE_LIST[@]}"; do
    ANGLE_GAMES_PKGS+="$pkg;"
    ANGLE_GAMES_VALUES+="angle;"
done

# Xóa dấu ; cuối cùng
ANGLE_GAMES_PKGS=${ANGLE_GAMES_PKGS%;}
ANGLE_GAMES_VALUES=${ANGLE_GAMES_VALUES%;}

adb shell settings put global angle_gl_driver_selection_pkgs "$ANGLE_GAMES_PKGS" 2>/dev/null
adb shell settings put global angle_gl_driver_selection_values "$ANGLE_GAMES_VALUES" 2>/dev/null

# Bật ANGLE system-wide
adb shell settings put global angle_enabled 1 2>/dev/null
adb shell setprop debug.angle.enabled 1 2>/dev/null

echo -e "  ${GREEN}✓${NC} ANGLE configured for ${#ANGLE_LIST[@]} games"

# ==================== KẾT QUẢ ====================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ VULKAN + ANGLE ENABLED               ║${NC}"
echo -e "${GREEN}║   Native Vulkan: ${#VULKAN_NATIVE_GAMES[@]} games           ║${NC}"
echo -e "${GREEN}║   ANGLE (OGL→VK): ${#ANGLE_LIST[@]} games           ║${NC}"
echo -e "${GREEN}║   Restart games to apply!                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"