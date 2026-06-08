#!/bin/bash
# =====================================================================
# HYPERBOOST ULTIMATE v1.1 - INTERACTIVE SETUP
# Menu tương tác đầy đủ: 29 chức năng
# Game | System | Network | Display | Debloat | Kernel | Benchmark
# =====================================================================
set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'
WHITE='\033[1;37m'; NC='\033[0m'; BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Biến toàn cục
DEVICE_MODEL="Unknown"
ANDROID_VERSION="Unknown"
LEVEL=1
LEVEL_NAME="Level 1 - Basic"

# ==================== LẤY THÔNG TIN THIẾT BỊ ====================
get_device_info() {
    if command -v adb &>/dev/null && adb devices 2>/dev/null | grep -q "device$"; then
        DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
        ANDROID_VERSION=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
        
        # Check level
        if adb shell "su -c 'id'" 2>/dev/null | grep -q "uid=0"; then
            LEVEL=5; LEVEL_NAME="Level 5 - Root + PC"
        elif adb devices 2>/dev/null | grep -q "device$"; then
            LEVEL=4; LEVEL_NAME="Level 4 - ADB + PC"
        fi
    fi
}

get_device_info

# ==================== HIỂN THỊ BANNER ====================
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
    echo "║              INTERACTIVE SETUP v1.1                          ║"
    echo "║     🚀 29 Chức Năng | 🎮 Game | ⚡ Hiệu Năng | 📊 Benchmark ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# ==================== MAIN MENU ====================
main_menu() {
    show_banner
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}${WHITE}HYPERBOOST v1.1 - MAIN MENU${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${CYAN}─── 🚀 TỐI ƯU NHANH ───${NC}"
    echo -e " ${GREEN}1${NC})  🚀 Auto-Optimize (Khuyên dùng)"
    echo -e " ${GREEN}2${NC})  🤖 Auto-Detect & Tối ưu App Đã Cài"
    echo -e ""
    echo -e " ${CYAN}─── 🎮 GAME ───${NC}"
    echo -e " ${GREEN}3${NC})  🎯 Force 120 FPS"
    echo -e " ${GREEN}4${NC})  🎯 Force 90 FPS"
    echo -e " ${GREEN}5${NC})  🔥 Enable Vulkan"
    echo -e " ${GREEN}6${NC})  🎮 ANGLE/Vulkan Injector"
    echo -e " ${GREEN}7${NC})  🔓 FPS Unlocker"
    echo -e " ${GREEN}8${NC})  📊 Game-Specific Tweak"
    echo -e " ${GREEN}9${NC})  💾 Backup Game Settings"
    echo -e " ${GREEN}10${NC}) 🔄 Restore Game Settings"
    echo -e ""
    echo -e " ${CYAN}─── ⚡ HIỆU NĂNG ───${NC}"
    echo -e " ${GREEN}11${NC}) ⚡ Performance Levels (1-5)"
    echo -e " ${GREEN}12${NC}) ⚡ Max Performance Mode"
    echo -e " ${GREEN}13${NC}) 🔥 CPU Overclock (Root)"
    echo -e " ${GREEN}14${NC}) 🔥 GPU Overclock (Root)"
    echo -e " ${GREEN}15${NC}) 🧠 RAM Optimizer"
    echo -e " ${GREEN}16${NC}) 🗑️  Clean Cache"
    echo -e ""
    echo -e " ${CYAN}─── 🌐 MẠNG ───${NC}"
    echo -e " ${GREEN}17${NC}) 🚀 Internet Speed Booster"
    echo -e " ${GREEN}18${NC}) 📶 Network Boost"
    echo -e " ${GREEN}19${NC}) 🔌 Wireless ADB"
    echo -e ""
    echo -e " ${CYAN}─── 🎨 HIỂN THỊ & CẢM ỨNG ───${NC}"
    echo -e " ${GREEN}20${NC}) 📱 Touch Sensitivity Boost"
    echo -e " ${GREEN}21${NC}) 🎬 Animation Tweaks"
    echo -e " ${GREEN}22${NC}) 🌐 ANGLE System-Wide"
    echo -e ""
    echo -e " ${CYAN}─── 🗑️ DỌN DẸP ───${NC}"
    echo -e " ${GREEN}23${NC}) 🗑️  Debloat (15+ Hãng)"
    echo -e " ${GREEN}24${NC}) 💾 Backup/Restore System"
    echo -e ""
    echo -e " ${CYAN}─── 🔧 NÂNG CAO ───${NC}"
    echo -e " ${GREEN}25${NC}) 🔧 Kernel & GPU Tuning"
    echo -e " ${GREEN}26${NC}) 🔥 Thermal Unlocker ⚠️"
    echo -e " ${GREEN}27${NC}) 📊 Mini Benchmark"
    echo -e ""
    echo -e " ${CYAN}─── 📖 THÔNG TIN ───${NC}"
    echo -e " ${GREEN}28${NC}) 📱 Device Info"
    echo -e " ${GREEN}29${NC}) 📋 Game List"
    echo -e " ${GREEN}0${NC})  ❌ Exit"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${CYAN}Device:${NC} ${GREEN}$DEVICE_MODEL${NC} | ${CYAN}Android:${NC} ${GREEN}$ANDROID_VERSION${NC} | ${CYAN}Level:${NC} ${GREEN}$LEVEL_NAME${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "👉 Chọn [0-29]: " choice
    
    case $choice in
        1) auto_optimize ;;
        2) bash "$SCRIPT_DIR/modules/auto_detect_games.sh" 2>/dev/null || not_found ;;
        3) bash "$SCRIPT_DIR/modules/force_120fps_all.sh" 2>/dev/null || not_found ;;
        4) bash "$SCRIPT_DIR/modules/force_90fps_all.sh" 2>/dev/null || not_found ;;
        5) bash "$SCRIPT_DIR/modules/enable_vulkan_all.sh" 2>/dev/null || not_found ;;
        6) bash "$SCRIPT_DIR/modules/angle_vulkan_injector.sh" 2>/dev/null || not_found ;;
        7) bash "$SCRIPT_DIR/exploits/fps_unlocker.sh" 2>/dev/null || not_found ;;
        8) game_specific_menu ;;
        9) backup_game_settings ;;
        10) restore_game_settings ;;
        11) performance_menu ;;
        12) bash "$SCRIPT_DIR/modules/performance_mode.sh" 2>/dev/null || not_found ;;
        13) bash "$SCRIPT_DIR/modules/cpu_overclock.sh" 2>/dev/null || not_found ;;
        14) bash "$SCRIPT_DIR/modules/gpu_overclock.sh" 2>/dev/null || not_found ;;
        15) bash "$SCRIPT_DIR/modules/ram_optimizer.sh" 2>/dev/null || not_found ;;
        16) bash "$SCRIPT_DIR/modules/clean_cache.sh" 2>/dev/null || not_found ;;
        17) bash "$SCRIPT_DIR/modules/internet_booster.sh" 2>/dev/null || not_found ;;
        18) bash "$SCRIPT_DIR/modules/boost_network.sh" 2>/dev/null || not_found ;;
        19) bash "$SCRIPT_DIR/tools/wireless_adb_connect.sh" 2>/dev/null || not_found ;;
        20) bash "$SCRIPT_DIR/modules/touch_sensitivity.sh" 2>/dev/null || not_found ;;
        21) bash "$SCRIPT_DIR/modules/tweak_animation.sh" 2>/dev/null || not_found ;;
        22) bash "$SCRIPT_DIR/modules/angle_system_wide.sh" 2>/dev/null || not_found ;;
        23) debloat_menu ;;
        24) backup_menu ;;
        25) kernel_menu ;;
        26) bash "$SCRIPT_DIR/modules/thermal_unlocker.sh" 2>/dev/null || not_found ;;
        27) bash "$SCRIPT_DIR/modules/benchmark_mini.sh" 2>/dev/null || not_found ;;
        28) device_info ;;
        29) show_game_list ;;
        0) echo -e "${GREEN}👋 Tạm biệt!${NC}"; exit 0 ;;
        *) echo -e "${RED}[✗] Lựa chọn không hợp lệ!${NC}"; sleep 1; main_menu ;;
    esac
    
    echo ""
    read -p "↵ Nhấn Enter để về menu..."
    main_menu
}

# ==================== NOT FOUND ====================
not_found() {
    echo -e "${RED}[✗] Module không tìm thấy!${NC}"
    echo -e "${YELLOW}[!] Kiểm tra lại thư mục modules/${NC}"
}

# ==================== AUTO OPTIMIZE ====================
auto_optimize() {
    show_banner
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          🚀 AUTO OPTIMIZATION v1.1                       ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}[*] Level: ${GREEN}$LEVEL_NAME${NC}"
    echo -e "${YELLOW}[*] Các bước:${NC}"
    echo -e "  ✓ Benchmark trước"
    echo -e "  ✓ Tối ưu hệ thống"
    echo -e "  ✓ Dọn cache"
    echo -e "  ✓ Tăng tốc mạng"
    echo -e "  ✓ Tăng nhạy màn hình"
    echo -e "  ✓ Tối ưu game"
    echo -e "  ✓ Benchmark sau"
    echo ""
    read -p "👉 Bắt đầu? (y/n): " confirm
    [ "$confirm" != "y" ] && [ "$confirm" != "Y" ] && { main_menu; return; }
    
    echo ""
    echo -e "${CYAN}━━━ 📊 BENCHMARK TRƯỚC ━━━${NC}"
    bash "$SCRIPT_DIR/modules/benchmark_mini.sh" 2>/dev/null
    echo ""
    
    echo -e "${CYAN}━━━ ⚡ TỐI ƯU HỆ THỐNG ━━━${NC}"
    case $LEVEL in
        1) bash "$SCRIPT_DIR/modules/level1_no_root_adb.sh" 2>/dev/null ;;
        2) bash "$SCRIPT_DIR/modules/level2_adb.sh" 2>/dev/null ;;
        3) bash "$SCRIPT_DIR/modules/level3_root.sh" 2>/dev/null ;;
        4) bash "$SCRIPT_DIR/modules/level4_pc_adb.sh" 2>/dev/null ;;
        5) bash "$SCRIPT_DIR/modules/level5_pc_root.sh" 2>/dev/null ;;
    esac
    
    echo -e "${CYAN}━━━ 🧹 DỌN DẸP ━━━${NC}"
    bash "$SCRIPT_DIR/modules/clean_cache.sh" 2>/dev/null
    bash "$SCRIPT_DIR/modules/tweak_animation.sh" 2>/dev/null
    
    echo -e "${CYAN}━━━ 🌐 MẠNG ━━━${NC}"
    bash "$SCRIPT_DIR/modules/internet_booster.sh" 2>/dev/null
    bash "$SCRIPT_DIR/modules/boost_network.sh" 2>/dev/null
    
    echo -e "${CYAN}━━━ 📱 CẢM ỨNG ━━━${NC}"
    bash "$SCRIPT_DIR/modules/touch_sensitivity.sh" 2>/dev/null
    
    echo -e "${CYAN}━━━ 🎮 GAME ━━━${NC}"
    if [ -f "$SCRIPT_DIR/modules/auto_detect_games.sh" ]; then
        bash "$SCRIPT_DIR/modules/auto_detect_games.sh" 2>/dev/null
    else
        bash "$SCRIPT_DIR/modules/force_120fps_all.sh" 2>/dev/null
        bash "$SCRIPT_DIR/modules/enable_vulkan_all.sh" 2>/dev/null
    fi
    
    echo -e "${CYAN}━━━ 📊 BENCHMARK SAU ━━━${NC}"
    bash "$SCRIPT_DIR/modules/benchmark_mini.sh" 2>/dev/null
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     ✓ AUTO-OPTIMIZE HOÀN TẤT!                           ║${NC}"
    echo -e "${GREEN}║     Khởi động lại máy để áp dụng tất cả                 ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
}

# ==================== GAME SPECIFIC ====================
game_specific_menu() {
    echo ""
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}GAME-SPECIFIC TWEAK${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) PUBG Mobile       ${GREEN}6${NC}) Wild Rift"
    echo -e " ${GREEN}2${NC}) CODM              ${GREEN}7${NC}) Fortnite"
    echo -e " ${GREEN}3${NC}) Genshin Impact    ${GREEN}8${NC}) Roblox"
    echo -e " ${GREEN}4${NC}) Free Fire MAX     ${GREEN}9${NC}) Minecraft"
    echo -e " ${GREEN}5${NC}) Mobile Legends    ${GREEN}10${NC}) Custom"
    echo -e " ${GREEN}0${NC}) Back"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "👉 Chọn game [0-10]: " game
    
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
        0) main_menu; return ;;
        *) game_specific_menu; return ;;
    esac
    
    echo -e "${GREEN}[*] Tối ưu $name...${NC}"
    adb shell settings put global "${pkg}_max_fps" 120 2>/dev/null
    adb shell settings put system "${pkg}_frame_rate" 120 2>/dev/null
    adb shell settings put global "${pkg}_vulkan_enabled" 1 2>/dev/null
    adb shell dumpsys deviceidle whitelist +"$pkg" 2>/dev/null
    echo -e "${GREEN}[✓] $name đã được tối ưu!${NC}"
}

# ==================== BACKUP GAME ====================
backup_game_settings() {
    echo -e "${CYAN}[*] Backing up game settings...${NC}"
    mkdir -p "$SCRIPT_DIR/backup"
    BACKUP_FILE="$SCRIPT_DIR/backup/game_settings_$(date +%Y%m%d_%H%M%S).txt"
    
    echo "# HyperBoost Game Backup - $(date)" > "$BACKUP_FILE"
    adb shell settings list global 2>/dev/null | grep -E "_vulkan_enabled|_max_fps|_frame_rate|angle_" >> "$BACKUP_FILE"
    
    echo -e "${GREEN}[✓] Saved to: $BACKUP_FILE${NC}"
}

restore_game_settings() {
    echo -e "${YELLOW}[*] Available backups:${NC}"
    ls -1 "$SCRIPT_DIR/backup/game_settings_"*.txt 2>/dev/null || echo "  (None)"
    echo ""
    read -p "👉 Nhập tên file: " fname
    
    if [ -f "$SCRIPT_DIR/backup/$fname" ]; then
        while IFS='=' read -r key val; do
            [[ "$key" =~ ^#.* ]] && continue
            [ -z "$key" ] && continue
            adb shell settings put global "$key" "$val" 2>/dev/null
        done < "$SCRIPT_DIR/backup/$fname"
        echo -e "${GREEN}[✓] Restored!${NC}"
    else
        echo -e "${RED}[✗] File not found${NC}"
    fi
}

# ==================== PERFORMANCE MENU ====================
performance_menu() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}PERFORMANCE LEVELS${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) Level 1 - Safe"
    echo -e " ${GREEN}2${NC}) Level 2 - ADB Shell"
    echo -e " ${GREEN}3${NC}) Level 3 - Root"
    echo -e " ${GREEN}4${NC}) Level 4 - PC + ADB"
    echo -e " ${GREEN}5${NC}) Level 5 - PC + Root (Max)"
    echo -e " ${GREEN}0${NC}) Back"
    read -p "👉 Chọn [0-5]: " choice
    
    case $choice in
        1) bash "$SCRIPT_DIR/modules/level1_no_root_adb.sh" 2>/dev/null ;;
        2) bash "$SCRIPT_DIR/modules/level2_adb.sh" 2>/dev/null ;;
        3) bash "$SCRIPT_DIR/modules/level3_root.sh" 2>/dev/null ;;
        4) bash "$SCRIPT_DIR/modules/level4_pc_adb.sh" 2>/dev/null ;;
        5) bash "$SCRIPT_DIR/modules/level5_pc_root.sh" 2>/dev/null ;;
        0) main_menu; return ;;
    esac
    read -p "↵ Enter..."
    performance_menu
}

# ==================== DEBLOAT MENU ====================
debloat_menu() {
    echo ""
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}DEBLOAT - GỠ BLOAWARE${NC}"
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
        1) bash "$SCRIPT_DIR/modules/debloat_samsung.sh" 2>/dev/null ;;
        2) bash "$SCRIPT_DIR/modules/debloat_xiaomi.sh" 2>/dev/null ;;
        3) bash "$SCRIPT_DIR/modules/debloat_oppo.sh" 2>/dev/null ;;
        4) bash "$SCRIPT_DIR/modules/debloat_vivo.sh" 2>/dev/null ;;
        5) bash "$SCRIPT_DIR/modules/debloat_huawei.sh" 2>/dev/null ;;
        6) bash "$SCRIPT_DIR/modules/debloat_oneplus.sh" 2>/dev/null ;;
        7) bash "$SCRIPT_DIR/modules/debloat_realme.sh" 2>/dev/null ;;
        8) bash "$SCRIPT_DIR/modules/debloat_tecno.sh" 2>/dev/null ;;
        9) bash "$SCRIPT_DIR/modules/debloat_nokia.sh" 2>/dev/null ;;
        10) bash "$SCRIPT_DIR/modules/debloat_motorola.sh" 2>/dev/null ;;
        11) bash "$SCRIPT_DIR/modules/debloat_lenovo.sh" 2>/dev/null ;;
        12) bash "$SCRIPT_DIR/modules/debloat_sony.sh" 2>/dev/null ;;
        13) bash "$SCRIPT_DIR/modules/debloat_asus.sh" 2>/dev/null ;;
        14) bash "$SCRIPT_DIR/modules/debloat_google.sh" 2>/dev/null ;;
        15) bash "$SCRIPT_DIR/modules/debloat_nothing.sh" 2>/dev/null ;;
        16) bash "$SCRIPT_DIR/modules/debloat_generic.sh" 2>/dev/null ;;
        0) main_menu; return ;;
    esac
    read -p "↵ Enter..."
    debloat_menu
}

# ==================== BACKUP MENU ====================
backup_menu() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}BACKUP & RESTORE${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) 💾 Backup System"
    echo -e " ${GREEN}2${NC}) 🔄 Restore System"
    echo -e " ${GREEN}3${NC}) 💾 Backup Game Settings"
    echo -e " ${GREEN}4${NC}) 🔄 Restore Game Settings"
    echo -e " ${GREEN}0${NC}) Back"
    read -p "👉 Chọn [0-4]: " choice
    
    case $choice in
        1) bash "$SCRIPT_DIR/modules/backup_restore.sh" --backup 2>/dev/null ;;
        2) bash "$SCRIPT_DIR/modules/backup_restore.sh" --restore 2>/dev/null ;;
        3) backup_game_settings ;;
        4) restore_game_settings ;;
        0) main_menu; return ;;
    esac
    read -p "↵ Enter..."
    backup_menu
}

# ==================== KERNEL MENU ====================
kernel_menu() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}KERNEL & GPU TUNING${NC}"
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
        1) bash "$SCRIPT_DIR/modules/kernel_tuner.sh" 2>/dev/null ;;
        2) bash "$SCRIPT_DIR/extras/gpu_tuning.sh" 2>/dev/null ;;
        3) bash "$SCRIPT_DIR/modules/zram_tuner.sh" 2>/dev/null ;;
        4) bash "$SCRIPT_DIR/modules/entropy_boost.sh" 2>/dev/null ;;
        5) bash "$SCRIPT_DIR/modules/fstrim_optimizer.sh" 2>/dev/null ;;
        6) bash "$SCRIPT_DIR/modules/optimize_dalvik.sh" 2>/dev/null ;;
        0) main_menu; return ;;
    esac
    read -p "↵ Enter..."
    kernel_menu
}

# ==================== DEVICE INFO ====================
device_info() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}DEVICE INFORMATION${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    if command -v adb &>/dev/null && adb devices 2>/dev/null | grep -q "device$"; then
        echo " Model:      $(adb shell getprop ro.product.model 2>/dev/null)"
        echo " Brand:      $(adb shell getprop ro.product.brand 2>/dev/null)"
        echo " Android:    $(adb shell getprop ro.build.version.release 2>/dev/null)"
        echo " Chipset:    $(adb shell getprop ro.board.platform 2>/dev/null)"
        echo " RAM:        $(adb shell cat /proc/meminfo 2>/dev/null | grep MemTotal)"
        echo " Resolution: $(adb shell wm size 2>/dev/null)"
        echo " Vulkan:     $(adb shell getprop ro.hardware.vulkan 2>/dev/null)"
    else
        echo " No ADB device"
    fi
    read -p "↵ Enter..."
    main_menu
}

# ==================== SHOW GAME LIST ====================
show_game_list() {
    if [ -f "$SCRIPT_DIR/data/game_list_complete.txt" ]; then
        head -50 "$SCRIPT_DIR/data/game_list_complete.txt"
        echo ""
        echo "Total: $(grep -c '|' "$SCRIPT_DIR/data/game_list_complete.txt") games"
    else
        echo "Game list not found"
    fi
    read -p "↵ Enter..."
    main_menu
}

# ==================== START ====================
main_menu