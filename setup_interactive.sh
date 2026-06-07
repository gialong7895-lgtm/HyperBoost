#!/bin/bash
# =====================================================================
# HYPERBOOST INTERACTIVE SETUP v5.0
# Step-by-step interactive menu
# =====================================================================
set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║    ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ██████╗          ║"
    echo "║    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗         ║"
    echo "║    ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝██████╔╝         ║"
    echo "║    ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██╔══██╗         ║"
    echo "║    ██║  ██║   ██║   ██║     ███████╗██║  ██║██████╔╝         ║"
    echo "║    ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═════╝          ║"
    echo "║                                                              ║"
    echo "║              INTERACTIVE SETUP v5.0                          ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

main_menu() {
    show_banner
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}MAIN MENU${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) 🚀 Quick Auto-Optimize"
    echo -e " ${GREEN}2${NC}) 🎮 Game Optimization"
    echo -e " ${GREEN}3${NC}) ⚡ Performance Level (1-5)"
    echo -e " ${GREEN}4${NC}) 🗑️  Debloat Device"
    echo -e " ${GREEN}5${NC}) 🔧 Advanced Tuning"
    echo -e " ${GREEN}6${NC}) 📱 Device Info"
    echo -e " ${GREEN}7${NC}) 💾 Backup Settings"
    echo -e " ${GREEN}8${NC}) 🔄 Restore Settings"
    echo -e " ${GREEN}9${NC}) 📋 Game List"
    echo -e " ${GREEN}10${NC}) 📖 Help"
    echo -e " ${GREEN}0${NC}) ❌ Exit"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Choose [0-10]: " choice
    
    case $choice in
        1) quick_optimize ;;
        2) game_menu ;;
        3) level_menu ;;
        4) debloat_menu ;;
        5) advanced_menu ;;
        6) device_info ;;
        7) bash "$SCRIPT_DIR/modules/backup_restore.sh" --backup ;;
        8) bash "$SCRIPT_DIR/modules/backup_restore.sh" --restore ;;
        9) show_game_list ;;
        10) show_help ;;
        0) echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
        *) main_menu ;;
    esac
}

quick_optimize() {
    echo -e "${YELLOW}[*] Running quick optimization...${NC}"
    bash "$SCRIPT_DIR/modules/level1_no_root_adb.sh" 2>/dev/null
    bash "$SCRIPT_DIR/modules/clean_cache.sh" 2>/dev/null
    bash "$SCRIPT_DIR/modules/tweak_animation.sh" 2>/dev/null
    bash "$SCRIPT_DIR/modules/boost_network.sh" 2>/dev/null
    echo -e "${GREEN}[✓] Quick optimization complete!${NC}"
    read -p "Press Enter..."
    main_menu
}

game_menu() {
    show_banner
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}GAME OPTIMIZATION${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) Force 120 FPS All Games"
    echo -e " ${GREEN}2${NC}) Force 90 FPS All Games"
    echo -e " ${GREEN}3${NC}) Enable Vulkan All Games"
    echo -e " ${GREEN}4${NC}) ANGLE Injector"
    echo -e " ${GREEN}5${NC}) Game-Specific Tweak"
    echo -e " ${GREEN}0${NC}) Back"
    read -p "Choose [0-5]: " choice
    
    case $choice in
        1) bash "$SCRIPT_DIR/modules/force_120fps_all.sh" ;;
        2) bash "$SCRIPT_DIR/modules/force_90fps_all.sh" ;;
        3) bash "$SCRIPT_DIR/modules/enable_vulkan_all.sh" ;;
        4) bash "$SCRIPT_DIR/modules/angle_vulkan_injector.sh" ;;
        5) game_specific ;;
        0) main_menu ;;
    esac
    read -p "Press Enter..."
    game_menu
}

game_specific() {
    echo -e "${MAGENTA}Select Game:${NC}"
    echo -e "1) PUBG Mobile    6) Wild Rift"
    echo -e "2) CODM           7) Fortnite"
    echo -e "3) Genshin Impact 8) Roblox"
    echo -e "4) Free Fire      9) Minecraft"
    echo -e "5) Mobile Legends 10) Custom"
    read -p "Choose [1-10]: " game
    
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
        10) read -p "Enter package: " pkg; name="Custom" ;;
        *) game_menu; return ;;
    esac
    
    echo -e "${GREEN}[*] Optimizing $name...${NC}"
    adb shell settings put global "${pkg}_max_fps" 120 2>/dev/null
    adb shell settings put system "${pkg}_frame_rate" 120 2>/dev/null
    adb shell dumpsys deviceidle whitelist +$pkg 2>/dev/null
    echo -e "${GREEN}[✓] $name optimized for 120 FPS!${NC}"
}

level_menu() {
    show_banner
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}PERFORMANCE LEVELS${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) Level 1 - Safe (No Root/ADB)"
    echo -e " ${GREEN}2${NC}) Level 2 - ADB Shell"
    echo -e " ${GREEN}3${NC}) Level 3 - Root Required"
    echo -e " ${GREEN}4${NC}) Level 4 - PC + ADB"
    echo -e " ${GREEN}5${NC}) Level 5 - PC + Root (Maximum)"
    echo -e " ${GREEN}0${NC}) Back"
    read -p "Choose [0-5]: " choice
    
    case $choice in
        1) bash "$SCRIPT_DIR/modules/level1_no_root_adb.sh" ;;
        2) bash "$SCRIPT_DIR/modules/level2_adb.sh" ;;
        3) bash "$SCRIPT_DIR/modules/level3_root.sh" ;;
        4) bash "$SCRIPT_DIR/modules/level4_pc_adb.sh" ;;
        5) bash "$SCRIPT_DIR/modules/level5_pc_root.sh" ;;
        0) main_menu ;;
    esac
    read -p "Press Enter..."
    level_menu
}

debloat_menu() {
    show_banner
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}DEBLOAT MENU${NC}"
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
    read -p "Choose [0-16]: " choice
    
    case $choice in
        1) bash "$SCRIPT_DIR/modules/debloat_samsung.sh" ;;
        2) bash "$SCRIPT_DIR/modules/debloat_xiaomi.sh" ;;
        3) bash "$SCRIPT_DIR/modules/debloat_oppo.sh" ;;
        4) bash "$SCRIPT_DIR/modules/debloat_vivo.sh" ;;
        5) bash "$SCRIPT_DIR/modules/debloat_huawei.sh" ;;
        6) bash "$SCRIPT_DIR/modules/debloat_oneplus.sh" ;;
        7) bash "$SCRIPT_DIR/modules/debloat_realme.sh" ;;
        8) bash "$SCRIPT_DIR/modules/debloat_tecno.sh" ;;
        9) bash "$SCRIPT_DIR/modules/debloat_nokia.sh" ;;
        10) bash "$SCRIPT_DIR/modules/debloat_motorola.sh" ;;
        11) bash "$SCRIPT_DIR/modules/debloat_lenovo.sh" ;;
        12) bash "$SCRIPT_DIR/modules/debloat_sony.sh" ;;
        13) bash "$SCRIPT_DIR/modules/debloat_asus.sh" ;;
        14) bash "$SCRIPT_DIR/modules/debloat_google.sh" ;;
        15) bash "$SCRIPT_DIR/modules/debloat_nothing.sh" ;;
        16) bash "$SCRIPT_DIR/modules/debloat_generic.sh" ;;
        0) main_menu ;;
    esac
    read -p "Press Enter..."
    debloat_menu
}

advanced_menu() {
    show_banner
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}ADVANCED TUNING${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) Kernel Tuner"
    echo -e " ${GREEN}2${NC}) GPU Tuner"
    echo -e " ${GREEN}3${NC}) RAM Optimizer"
    echo -e " ${GREEN}4${NC}) ZRAM Tuner"
    echo -e " ${GREEN}5${NC}) Entropy Boost"
    echo -e " ${GREEN}6${NC}) FSTRIM"
    echo -e " ${GREEN}7${NC}) Clean Cache"
    echo -e " ${GREEN}8${NC}) Thermal Unlocker ⚠️"
    echo -e " ${GREEN}0${NC}) Back"
    read -p "Choose [0-8]: " choice
    
    case $choice in
        1) bash "$SCRIPT_DIR/modules/kernel_tuner.sh" ;;
        2) bash "$SCRIPT_DIR/extras/gpu_tuning.sh" ;;
        3) bash "$SCRIPT_DIR/modules/ram_optimizer.sh" ;;
        4) bash "$SCRIPT_DIR/modules/zram_tuner.sh" ;;
        5) bash "$SCRIPT_DIR/modules/entropy_boost.sh" ;;
        6) bash "$SCRIPT_DIR/modules/fstrim_optimizer.sh" ;;
        7) bash "$SCRIPT_DIR/modules/clean_cache.sh" ;;
        8) bash "$SCRIPT_DIR/modules/thermal_unlocker.sh" ;;
        0) main_menu ;;
    esac
    read -p "Press Enter..."
    advanced_menu
}

device_info() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}DEVICE INFORMATION${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    if command -v adb &>/dev/null && adb devices 2>/dev/null | grep -q "device$"; then
        echo " Model: $(adb shell getprop ro.product.model 2>/dev/null)"
        echo " Brand: $(adb shell getprop ro.product.brand 2>/dev/null)"
        echo " Android: $(adb shell getprop ro.build.version.release 2>/dev/null)"
        echo " Chipset: $(adb shell getprop ro.board.platform 2>/dev/null)"
        echo " RAM: $(adb shell cat /proc/meminfo 2>/dev/null | grep MemTotal)"
        echo " Resolution: $(adb shell wm size 2>/dev/null)"
        echo " Density: $(adb shell wm density 2>/dev/null)"
    else
        echo " No ADB device connected"
    fi
    read -p "Press Enter..."
    main_menu
}

show_game_list() {
    if [ -f "$SCRIPT_DIR/data/game_list_complete.txt" ]; then
        cat "$SCRIPT_DIR/data/game_list_complete.txt" | head -50
        echo ""
        echo "Total games: $(grep -c '|' "$SCRIPT_DIR/data/game_list_complete.txt" 2>/dev/null)"
    else
        echo "Game list not found"
    fi
    read -p "Press Enter..."
    main_menu
}

show_help() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}HELP${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo " Quick commands:"
    echo "   bash setup.sh --auto      Auto-optimize"
    echo "   bash setup.sh --game      Game menu"
    echo "   bash setup.sh --debloat   Debloat menu"
    echo "   bash setup.sh --help      This help"
    echo ""
    echo " Documentation: docs/FAQ.md"
    echo " Game list: data/game_list_complete.txt"
    read -p "Press Enter..."
    main_menu
}

# Start
main_menu