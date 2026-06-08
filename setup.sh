#!/usr/bin/env bash
# =====================================================================
# HYPERBOOST ULTIMATE v2.0 - MAIN SETUP SCRIPT
# =====================================================================
# ⚠️ DISCLAIMER: USE AT YOUR OWN RISK
# Authors not responsible for any damage or data loss
# =====================================================================
set -e

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'
WHITE='\033[1;37m'; NC='\033[0m'; BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="2.0"

# Device info
DEVICE_MODEL="Unknown"
ANDROID_VERSION="Unknown"
CHIPSET="Unknown"
LEVEL=1
LEVEL_NAME="Level 1 - Basic"

# ==================== DISCLAIMER ====================
show_disclaimer() {
    clear
    echo -e "${RED}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║  ⚠️  TUYÊN BỐ MIỄN TRỪ TRÁCH NHIỆM - PLEASE READ!        ║"
    echo "║                                                          ║"
    echo "╠══════════════════════════════════════════════════════════╣"
    echo "║                                                          ║"
    echo "║  PHẦN MỀM NÀY ĐƯỢC CUNG CẤP \"NHƯ HIỆN TẠI\"               ║"
    echo "║  KHÔNG CÓ BẤT KỲ BẢO ĐẢM NÀO.                           ║"
    echo "║                                                          ║"
    echo "║  SỬ DỤNG PHẦN MỀM NÀY CÓ THỂ:                            ║"
    echo "║  • Gây hư hỏng phần cứng vĩnh viễn                       ║"
    echo "║  • Làm mất bảo hành thiết bị                              ║"
    echo "║  • Gây bootloop, brick máy                                ║"
    echo "║  • Mất dữ liệu                                            ║"
    echo "║                                                          ║"
    echo "║  TÁC GIẢ KHÔNG CHỊU TRÁCH NHIỆM VỀ BẤT KỲ THIỆT HẠI NÀO ║"
    echo "║                                                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Bạn đã đọc và đồng ý với các điều khoản trên?${NC}"
    echo -e "  ${GREEN}y${NC} = Tôi đồng ý, tiếp tục"
    echo -e "  ${RED}n${NC} = Tôi không đồng ý, thoát"
    read -p "👉 Lựa chọn (y/n): " agree
    
    if [ "$agree" != "y" ] && [ "$agree" != "Y" ]; then
        echo -e "${GREEN}Đã thoát. Thiết bị của bạn an toàn.${NC}"
        exit 0
    fi
}

# ==================== OS DETECTION ====================
detect_os() {
    case "$OSTYPE" in
        linux-android*) OS="termux" ;;
        linux-gnu*) OS="linux" ;;
        darwin*) OS="macos" ;;
        msys*|cygwin*|mingw*) OS="windows" ;;
        *) OS="unknown" ;;
    esac
}

# ==================== GET DEVICE INFO ====================
get_device_info() {
    if command -v adb &>/dev/null && adb devices 2>/dev/null | grep -q "device$"; then
        DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
        ANDROID_VERSION=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
        CHIPSET=$(adb shell getprop ro.board.platform 2>/dev/null | tr -d '\r')
        
        # Level detection
        if adb shell "su -c 'id'" 2>/dev/null | grep -q "uid=0"; then
            LEVEL=5; LEVEL_NAME="Level 5 - Root + PC"
        elif adb devices 2>/dev/null | grep -q "device$"; then
            LEVEL=4; LEVEL_NAME="Level 4 - ADB + PC"
        fi
    elif command -v su &>/dev/null && su -c "id" 2>/dev/null | grep -q "uid=0"; then
        LEVEL=3; LEVEL_NAME="Level 3 - Root"
    elif command -v adb &>/dev/null; then
        LEVEL=2; LEVEL_NAME="Level 2 - ADB"
    fi
}

# ==================== INSTALL DEPENDENCIES ====================
install_deps() {
    clear
    echo -e "${CYAN}[*] Kiểm tra phụ thuộc...${NC}"
    case "$OS" in
        termux)
            pkg update -y 2>/dev/null
            pkg install -y termux-api android-tools python git curl wget 2>/dev/null
            ;;
        linux)
            sudo apt update -y 2>/dev/null
            sudo apt install -y adb fastboot python3 git curl wget 2>/dev/null
            ;;
    esac
    echo -e "${GREEN}[✓] Hoàn tất!${NC}"
    sleep 1
}

# ==================== MAIN MENU ====================
show_menu() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║    ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ██████╗      ║"
    echo "║    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗     ║"
    echo "║    ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝██████╔╝     ║"
    echo "║    ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██╔══██╗     ║"
    echo "║    ██║  ██║   ██║   ██║     ███████╗██║  ██║██████╔╝     ║"
    echo "║    ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═════╝      ║"
    echo "║                                                          ║"
    echo "║              ULTIMATE EDITION v${VERSION}                        ║"
    echo "║     ⚠️  USE AT YOUR OWN RISK - NO WARRANTY              ║"
    echo "╠══════════════════════════════════════════════════════════╣"
    echo "║  ${GREEN}Device:${NC} $DEVICE_MODEL | ${GREEN}Android:${NC} $ANDROID_VERSION | ${GREEN}Level:${NC} $LEVEL_NAME"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}${WHITE}HYPERBOOST v${VERSION} - MAIN MENU${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${CYAN}─── 🚀 QUICK OPTIMIZE ───${NC}"
    echo -e " ${GREEN}1${NC})  🚀 Auto-Optimize Full System"
    echo -e " ${GREEN}2${NC})  🤖 Auto-Detect & Optimize Apps"
    echo -e ""
    echo -e " ${CYAN}─── 🎮 GAMING ───${NC}"
    echo -e " ${GREEN}3${NC})  🎯 Force 120 FPS All Games"
    echo -e " ${GREEN}4${NC})  🔥 Enable Vulkan All Games"
    echo -e " ${GREEN}5${NC})  🎮 ANGLE/Vulkan Injector"
    echo -e " ${GREEN}6${NC})  📊 Game-Specific Tweak"
    echo -e " ${GREEN}7${NC})  💾 Game Backup/Restore"
    echo -e ""
    echo -e " ${CYAN}─── ⚡ PERFORMANCE ───${NC}"
    echo -e " ${GREEN}8${NC})  ⚡ Performance Levels (1-5)"
    echo -e " ${GREEN}9${NC})  ⚡ Max Performance Mode"
    echo -e " ${GREEN}10${NC}) 🔥 CPU Overclock ${RED}(ROOT)${NC}"
    echo -e " ${GREEN}11${NC}) 🔥 GPU Overclock ${RED}(ROOT)${NC}"
    echo -e " ${GREEN}12${NC}) 🧠 RAM Optimizer"
    echo -e ""
    echo -e " ${CYAN}─── 🌐 NETWORK ───${NC}"
    echo -e " ${GREEN}13${NC}) 🚀 Internet Speed Booster"
    echo -e " ${GREEN}14${NC}) 🔌 Wireless ADB (Port 5555)"
    echo -e ""
    echo -e " ${CYAN}─── 🎨 DISPLAY & TOUCH ───${NC}"
    echo -e " ${GREEN}15${NC}) 📱 Touch Sensitivity Boost"
    echo -e " ${GREEN}16${NC}) 🎬 Animation Tweaks"
    echo -e " ${GREEN}17${NC}) 🌐 ANGLE System-Wide"
    echo -e ""
    echo -e " ${CYAN}─── 🗑️ CLEANUP ───${NC}"
    echo -e " ${GREEN}18${NC}) 🗑️  Debloat (16 Brands)"
    echo -e " ${GREEN}19${NC}) 🧹 Clean Cache"
    echo -e " ${GREEN}20${NC}) 💾 Backup/Restore System"
    echo -e ""
    echo -e " ${CYAN}─── 🔧 ADVANCED ───${NC}"
    echo -e " ${GREEN}21${NC}) 🔧 Kernel & GPU Tuning"
    echo -e " ${GREEN}22${NC}) 🔥 Thermal Unlocker ${RED}⚠️ DANGER${NC}"
    echo -e " ${GREEN}23${NC}) 📊 Mini Benchmark"
    echo -e ""
    echo -e " ${CYAN}─── 📖 INFO ───${NC}"
    echo -e " ${GREEN}24${NC}) 📱 Device Info"
    echo -e " ${GREEN}25${NC}) 📋 Game List"
    echo -e " ${GREEN}26${NC}) 📖 Help"
    echo -e " ${GREEN}0${NC})  ❌ Exit"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "👉 Chọn [0-26]: " choice
    
    case $choice in
        1) run_module "auto_optimize" ;;
        2) run_module "auto_detect_games.sh" ;;
        3) run_module "force_120fps_all.sh" ;;
        4) run_module "enable_vulkan_all.sh" ;;
        5) run_module "angle_vulkan_injector.sh" ;;
        6) game_specific ;;
        7) run_module "backup_restore.sh --interactive" ;;
        8) performance_menu ;;
        9) run_module "performance_mode.sh" ;;
        10) run_module "cpu_overclock.sh" ;;
        11) run_module "gpu_overclock.sh" ;;
        12) run_module "ram_optimizer.sh" ;;
        13) run_module "internet_booster.sh" ;;
        14) run_tool "auto_build_adb.sh" ;;
        15) run_module "touch_sensitivity.sh" ;;
        16) run_module "tweak_animation.sh" ;;
        17) run_module "angle_system_wide.sh" ;;
        18) debloat_menu ;;
        19) run_module "clean_cache.sh" ;;
        20) run_module "backup_restore.sh" ;;
        21) kernel_menu ;;
        22) run_module "thermal_unlocker.sh" ;;
        23) run_module "benchmark_mini.sh" ;;
        24) device_info ;;
        25) show_game_list ;;
        26) show_help ;;
        0) clear; echo -e "${GREEN}👋 Tạm biệt!${NC}"; exit 0 ;;
        *) show_menu ;;
    esac
}

# ==================== RUN MODULE WITH CLEAR ====================
run_module() {
    local module="$1"
    clear
    bash "$SCRIPT_DIR/modules/$module" 2>/dev/null || {
        echo -e "${RED}[✗] Module không tìm thấy: $module${NC}"
    }
    echo ""
    read -p "↵ Enter để về menu..."
    show_menu
}

run_tool() {
    local tool="$1"
    clear
    bash "$SCRIPT_DIR/tools/$tool" 2>/dev/null || {
        echo -e "${RED}[✗] Tool không tìm thấy: $tool${NC}"
    }
    echo ""
    read -p "↵ Enter để về menu..."
    show_menu
}

# ==================== AUTO OPTIMIZE ====================
auto_optimize() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          🚀 AUTO OPTIMIZATION v${VERSION}                       ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    read -p "👉 Bắt đầu tối ưu tự động? (y/n): " confirm
    [ "$confirm" != "y" ] && [ "$confirm" != "Y" ] && { show_menu; return; }
    
    clear
    echo -e "${CYAN}━━━ 📊 BENCHMARK TRƯỚC ━━━${NC}"
    bash "$SCRIPT_DIR/modules/benchmark_mini.sh" 2>/dev/null
    read -p "↵ Enter để tiếp tục..."
    
    clear
    echo -e "${CYAN}━━━ ⚡ TỐI ƯU HỆ THỐNG (Level $LEVEL) ━━━${NC}"
    case $LEVEL in
        1) bash "$SCRIPT_DIR/modules/level1_no_root_adb.sh" 2>/dev/null ;;
        2) bash "$SCRIPT_DIR/modules/level2_adb.sh" 2>/dev/null ;;
        3) bash "$SCRIPT_DIR/modules/level3_root.sh" 2>/dev/null ;;
        4) bash "$SCRIPT_DIR/modules/level4_pc_adb.sh" 2>/dev/null ;;
        5) bash "$SCRIPT_DIR/modules/level5_pc_root.sh" 2>/dev/null ;;
    esac
    read -p "↵ Enter để tiếp tục..."
    
    clear
    echo -e "${CYAN}━━━ 🧹 DỌN DẸP & TỐI ƯU ━━━${NC}"
    bash "$SCRIPT_DIR/modules/clean_cache.sh" 2>/dev/null
    bash "$SCRIPT_DIR/modules/tweak_animation.sh" 2>/dev/null
    bash "$SCRIPT_DIR/modules/internet_booster.sh" 2>/dev/null
    bash "$SCRIPT_DIR/modules/touch_sensitivity.sh" 2>/dev/null
    read -p "↵ Enter để tiếp tục..."
    
    clear
    echo -e "${CYAN}━━━ 🎮 TỐI ƯU GAME ━━━${NC}"
    if [ -f "$SCRIPT_DIR/modules/auto_detect_games.sh" ]; then
        bash "$SCRIPT_DIR/modules/auto_detect_games.sh" 2>/dev/null
    fi
    read -p "↵ Enter để tiếp tục..."
    
    clear
    echo -e "${CYAN}━━━ 📊 BENCHMARK SAU ━━━${NC}"
    bash "$SCRIPT_DIR/modules/benchmark_mini.sh" 2>/dev/null
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     ✓ AUTO-OPTIMIZE HOÀN TẤT!                           ║${NC}"
    echo -e "${GREEN}║     Khởi động lại máy để áp dụng                        ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    read -p "↵ Enter để về menu..."
    show_menu
}

# ==================== GAME SPECIFIC ====================
game_specific() {
    clear
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}GAME-SPECIFIC TWEAK${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) PUBG Mobile       ${GREEN}6${NC}) Wild Rift"
    echo -e " ${GREEN}2${NC}) CODM              ${GREEN}7${NC}) Fortnite"
    echo -e " ${GREEN}3${NC}) Genshin Impact    ${GREEN}8${NC}) Roblox"
    echo -e " ${GREEN}4${NC}) Free Fire MAX     ${GREEN}9${NC}) Minecraft"
    echo -e " ${GREEN}5${NC}) Mobile Legends    ${GREEN}10${NC}) Custom"
    echo -e " ${GREEN}0${NC}) Back"
    read -p "👉 Chọn [0-10]: " game
    
    case $game in
        1) pkg="com.tencent.ig"; name="PUBG Mobile" ;;
        2) pkg="com.activision.callofduty.shooter"; name="CODM" ;;
        3) pkg="com.miHoYo.GenshinImpact"; name="Genshin Impact" ;;
        4) pkg="com.dts.freefiremax"; name="Free Fire MAX" ;;
        5) pkg="com.mobile.legends"; name="Mobile Legends" ;;
        6) pkg="com.riotgames.league.wildrift"; name="Wild Rift" ;;
        7) pkg="com.epicgames.fortnite"; name="Fortnite" ;;
        8) pkg="com.roblox.client"; name="Roblox" ;;
        9) pkg="com.mojang.minecraftpe"; name="Minecraft" ;;
        10) read -p "Package: " pkg; name="Custom" ;;
        0) show_menu; return ;;
        *) game_specific; return ;;
    esac
    
    clear
    echo -e "${GREEN}[*] Tối ưu $name...${NC}"
    adb shell settings put global "${pkg}_max_fps" 120 2>/dev/null
    adb shell settings put system "${pkg}_frame_rate" 120 2>/dev/null
    adb shell settings put global "${pkg}_vulkan_enabled" 1 2>/dev/null
    adb shell dumpsys deviceidle whitelist +"$pkg" 2>/dev/null
    echo -e "${GREEN}[✓] $name đã được tối ưu!${NC}"
    read -p "↵ Enter..."
    show_menu
}

# ==================== PERFORMANCE MENU ====================
performance_menu() {
    clear
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}PERFORMANCE LEVELS${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) Level 1 - Safe (No Root/ADB)"
    echo -e " ${GREEN}2${NC}) Level 2 - ADB Shell"
    echo -e " ${GREEN}3${NC}) Level 3 - Root"
    echo -e " ${GREEN}4${NC}) Level 4 - PC + ADB"
    echo -e " ${GREEN}5${NC}) Level 5 - PC + Root (Max)"
    echo -e " ${GREEN}0${NC}) Back"
    read -p "👉 Chọn [0-5]: " choice
    
    case $choice in
        1) clear; bash "$SCRIPT_DIR/modules/level1_no_root_adb.sh" 2>/dev/null ;;
        2) clear; bash "$SCRIPT_DIR/modules/level2_adb.sh" 2>/dev/null ;;
        3) clear; bash "$SCRIPT_DIR/modules/level3_root.sh" 2>/dev/null ;;
        4) clear; bash "$SCRIPT_DIR/modules/level4_pc_adb.sh" 2>/dev/null ;;
        5) clear; bash "$SCRIPT_DIR/modules/level5_pc_root.sh" 2>/dev/null ;;
        0) show_menu; return ;;
    esac
    read -p "↵ Enter..."
    performance_menu
}

# ==================== DEBLOAT MENU ====================
debloat_menu() {
    clear
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}DEBLOAT (16 BRANDS)${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) Samsung     ${GREEN}9${NC}) Nokia"
    echo -e " ${GREEN}2${NC}) Xiaomi      ${GREEN}10${NC}) Motorola"
    echo -e " ${GREEN}3${NC}) OPPO        ${GREEN}11${NC}) Lenovo"
    echo -e " ${GREEN}4${NC}) Vivo        ${GREEN}12${NC}) Sony"
    echo -e " ${GREEN}5${NC}) Huawei      ${GREEN}13${NC}) ASUS"
    echo -e " ${GREEN}6${NC}) OnePlus     ${GREEN}14${NC}) Google"
    echo -e " ${GREEN}7${NC}) Realme      ${GREEN}15${NC}) Nothing"
    echo -e " ${GREEN}8${NC}) TECNO       ${GREEN}16${NC}) Generic"
    echo -e " ${GREEN}0${NC}) Back"
    read -p "👉 Chọn [0-16]: " choice
    
    case $choice in
        1) clear; bash "$SCRIPT_DIR/modules/debloat_samsung.sh" 2>/dev/null ;;
        2) clear; bash "$SCRIPT_DIR/modules/debloat_xiaomi.sh" 2>/dev/null ;;
        3) clear; bash "$SCRIPT_DIR/modules/debloat_oppo.sh" 2>/dev/null ;;
        4) clear; bash "$SCRIPT_DIR/modules/debloat_vivo.sh" 2>/dev/null ;;
        5) clear; bash "$SCRIPT_DIR/modules/debloat_huawei.sh" 2>/dev/null ;;
        6) clear; bash "$SCRIPT_DIR/modules/debloat_oneplus.sh" 2>/dev/null ;;
        7) clear; bash "$SCRIPT_DIR/modules/debloat_realme.sh" 2>/dev/null ;;
        8) clear; bash "$SCRIPT_DIR/modules/debloat_tecno.sh" 2>/dev/null ;;
        9) clear; bash "$SCRIPT_DIR/modules/debloat_nokia.sh" 2>/dev/null ;;
        10) clear; bash "$SCRIPT_DIR/modules/debloat_motorola.sh" 2>/dev/null ;;
        11) clear; bash "$SCRIPT_DIR/modules/debloat_lenovo.sh" 2>/dev/null ;;
        12) clear; bash "$SCRIPT_DIR/modules/debloat_sony.sh" 2>/dev/null ;;
        13) clear; bash "$SCRIPT_DIR/modules/debloat_asus.sh" 2>/dev/null ;;
        14) clear; bash "$SCRIPT_DIR/modules/debloat_google.sh" 2>/dev/null ;;
        15) clear; bash "$SCRIPT_DIR/modules/debloat_nothing.sh" 2>/dev/null ;;
        16) clear; bash "$SCRIPT_DIR/modules/debloat_generic.sh" 2>/dev/null ;;
        0) show_menu; return ;;
    esac
    read -p "↵ Enter..."
    debloat_menu
}

# ==================== KERNEL MENU ====================
kernel_menu() {
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}KERNEL & GPU ADVANCED${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) Kernel Tuner"
    echo -e " ${GREEN}2${NC}) GPU Tuner"
    echo -e " ${GREEN}3${NC}) ZRAM Optimizer"
    echo -e " ${GREEN}4${NC}) Entropy Boost"
    echo -e " ${GREEN}5${NC}) FSTRIM"
    echo -e " ${GREEN}6${NC}) Dalvik Optimizer"
    echo -e " ${GREEN}0${NC}) Back"
    read -p "👉 Chọn [0-6]: " choice
    
    case $choice in
        1) clear; bash "$SCRIPT_DIR/modules/kernel_tuner.sh" 2>/dev/null ;;
        2) clear; bash "$SCRIPT_DIR/extras/gpu_tuning.sh" 2>/dev/null ;;
        3) clear; bash "$SCRIPT_DIR/modules/zram_tuner.sh" 2>/dev/null ;;
        4) clear; bash "$SCRIPT_DIR/modules/entropy_boost.sh" 2>/dev/null ;;
        5) clear; bash "$SCRIPT_DIR/modules/fstrim_optimizer.sh" 2>/dev/null ;;
        6) clear; bash "$SCRIPT_DIR/modules/optimize_dalvik.sh" 2>/dev/null ;;
        0) show_menu; return ;;
    esac
    read -p "↵ Enter..."
    kernel_menu
}

# ==================== DEVICE INFO ====================
device_info() {
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}DEVICE INFORMATION${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    if command -v adb &>/dev/null && adb devices 2>/dev/null | grep -q "device$"; then
        echo " Model:      $(adb shell getprop ro.product.model 2>/dev/null)"
        echo " Brand:      $(adb shell getprop ro.product.brand 2>/dev/null)"
        echo " Android:    $(adb shell getprop ro.build.version.release 2>/dev/null)"
        echo " SDK:        $(adb shell getprop ro.build.version.sdk 2>/dev/null)"
        echo " Chipset:    $(adb shell getprop ro.board.platform 2>/dev/null)"
        echo " CPU:        $(adb shell cat /proc/cpuinfo 2>/dev/null | grep Hardware | head -1)"
        echo " RAM:        $(adb shell cat /proc/meminfo 2>/dev/null | grep MemTotal)"
        echo " Resolution: $(adb shell wm size 2>/dev/null)"
        echo " Density:    $(adb shell wm density 2>/dev/null)"
        echo " Vulkan:     $(adb shell getprop ro.hardware.vulkan 2>/dev/null)"
        echo " ANGLE:      $(adb shell settings get global angle_enabled 2>/dev/null)"
    else
        echo " Không có thiết bị ADB"
    fi
    read -p "↵ Enter..."
    show_menu
}

# ==================== SHOW GAME LIST ====================
show_game_list() {
    clear
    if [ -f "$SCRIPT_DIR/data/game_list_complete.txt" ]; then
        head -40 "$SCRIPT_DIR/data/game_list_complete.txt"
        TOTAL=$(grep -c '|' "$SCRIPT_DIR/data/game_list_complete.txt" 2>/dev/null || echo 0)
        echo ""
        echo -e "${GREEN}Tổng: $TOTAL games trong database${NC}"
    fi
    read -p "↵ Enter..."
    show_menu
}

# ==================== HELP ====================
show_help() {
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}HYPERBOOST v${VERSION} - HELP${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo " Quick Commands:"
    echo "   bash setup.sh              Main menu"
    echo "   bash setup.sh --auto       Auto-optimize"
    echo "   bash setup.sh --game       Game menu"
    echo "   bash setup.sh --debloat    Debloat menu"
    echo "   bash setup.sh --benchmark  Run benchmark"
    echo ""
    echo " Wireless ADB:"
    echo "   bash tools/auto_build_adb.sh"
    echo ""
    echo " ⚠️  DISCLAIMER: USE AT YOUR OWN RISK"
    echo " Documentation: docs/FAQ.md"
    echo " License: LICENSE"
    read -p "↵ Enter..."
    show_menu
}

# ==================== MAIN ====================
main() {
    show_disclaimer
    detect_os
    install_deps
    get_device_info
    
    case "${1:-}" in
        --auto) auto_optimize; exit 0 ;;
        --game) game_specific; exit 0 ;;
        --debloat) debloat_menu; exit 0 ;;
        --benchmark) clear; bash "$SCRIPT_DIR/modules/benchmark_mini.sh"; exit 0 ;;
        --help|-h) show_help; exit 0 ;;
        --adb) clear; bash "$SCRIPT_DIR/tools/auto_build_adb.sh"; exit 0 ;;
        *) show_menu ;;
    esac
}

main "$@"