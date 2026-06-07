#!/usr/bin/env bash
# =====================================================================
# HYPERBOOST ULTIMATE v5.0 - MAIN SETUP SCRIPT
# Auto-install all dependencies from scratch
# Works on: Termux (Android), Linux, macOS, Windows (Git Bash/WSL)
# Android 11-16 | 5 Performance Levels | 100+ Games
# =====================================================================
set -e

# ==================== COLORS ====================
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'
WHITE='\033[1;37m'; NC='\033[0m'; BOLD='\033[1m'

# ==================== GLOBAL VARIABLES ====================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="unknown"
ARCH="unknown"
HAS_ROOT=false
HAS_ADB=false
ADB_DEVICE=false
DEVICE_MODEL="Unknown"
ANDROID_VERSION="Unknown"
CHIPSET="Unknown"
GPU="Unknown"
LEVEL=1
LEVEL_NAME="Level 1 - Basic (No Root/ADB/PC)"

# ==================== LOGO ====================
show_logo() {
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
    echo "║                   ULTIMATE EDITION v5.0                      ║"
    echo "║         100+ Games | 120FPS | Vulkan | Anti-Lag              ║"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo "║   Android 11-16 | 5 Levels | Termux | PC | Auto-Setup       ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# ==================== ERROR HANDLER ====================
error_exit() {
    echo -e "${RED}[✗] ERROR: $1${NC}"
    echo -e "${YELLOW}[!] Please check the error above and try again.${NC}"
    exit 1
}

warning_msg() {
    echo -e "${YELLOW}[!] WARNING: $1${NC}"
}

success_msg() {
    echo -e "${GREEN}[✓] $1${NC}"
}

info_msg() {
    echo -e "${BLUE}[*] $1${NC}"
}

# ==================== OS DETECTION ====================
detect_os() {
    info_msg "Detecting operating system..."
    
    case "$OSTYPE" in
        linux-android*)
            OS="termux"
            info_msg "OS: Android Termux"
            ;;
        linux-gnu*)
            OS="linux"
            info_msg "OS: Linux"
            ;;
        darwin*)
            OS="macos"
            info_msg "OS: macOS"
            ;;
        msys*|cygwin*|mingw*)
            OS="windows"
            info_msg "OS: Windows (Git Bash/WSL)"
            ;;
        *)
            OS="unknown"
            warning_msg "Unknown OS: $OSTYPE"
            ;;
    esac
    
    # Detect architecture
    ARCH=$(uname -m)
    case "$ARCH" in
        aarch64|arm64) ARCH="arm64" ;;
        armv7l|armv8l) ARCH="arm" ;;
        x86_64|amd64) ARCH="x86_64" ;;
        i386|i686) ARCH="x86" ;;
        *) ARCH="unknown" ;;
    esac
    info_msg "Architecture: $ARCH"
}

# ==================== DEPENDENCY CHECK & INSTALL ====================
install_dependencies() {
    info_msg "Checking and installing dependencies..."
    
    case "$OS" in
        termux)
            info_msg "Setting up Termux environment..."
            
            # Update package lists
            pkg update -y -o Dpkg::Options::="--force-confnew" 2>/dev/null || true
            pkg upgrade -y -o Dpkg::Options::="--force-confnew" 2>/dev/null || true
            
            # Install core packages
            info_msg "Installing core packages for Termux..."
            pkg install -y \
                termux-api \
                android-tools \
                python \
                python-pip \
                git \
                curl \
                wget \
                openssh \
                termux-tools \
                coreutils \
                findutils \
                grep \
                sed \
                gawk \
                busybox \
                2>/dev/null || true
            
            # Setup storage access
            termux-setup-storage 2>/dev/null || true
            
            # Install Python packages
            pip install --upgrade pip 2>/dev/null || true
            pip install requests psutil 2>/dev/null || true
            ;;
            
        linux)
            info_msg "Installing dependencies for Linux..."
            
            # Detect package manager
            if command -v apt-get &>/dev/null; then
                # Debian/Ubuntu
                sudo apt-get update -y
                sudo apt-get install -y \
                    adb \
                    fastboot \
                    android-sdk-platform-tools \
                    python3 \
                    python3-pip \
                    git \
                    curl \
                    wget \
                    unzip \
                    coreutils \
                    2>/dev/null || true
                    
            elif command -v pacman &>/dev/null; then
                # Arch Linux
                sudo pacman -Syu --noconfirm
                sudo pacman -S --noconfirm \
                    android-tools \
                    python \
                    python-pip \
                    git \
                    curl \
                    wget \
                    unzip \
                    2>/dev/null || true
                    
            elif command -v dnf &>/dev/null; then
                # Fedora/RHEL
                sudo dnf install -y \
                    android-tools \
                    python3 \
                    python3-pip \
                    git \
                    curl \
                    wget \
                    unzip \
                    2>/dev/null || true
            fi
            
            pip3 install --upgrade pip 2>/dev/null || true
            pip3 install requests psutil 2>/dev/null || true
            ;;
            
        macos)
            info_msg "Installing dependencies for macOS..."
            
            # Check Homebrew
            if ! command -v brew &>/dev/null; then
                info_msg "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            
            brew install \
                android-platform-tools \
                python3 \
                git \
                curl \
                wget \
                2>/dev/null || true
            
            pip3 install --upgrade pip 2>/dev/null || true
            pip3 install requests psutil 2>/dev/null || true
            ;;
            
        windows)
            info_msg "Setting up for Windows..."
            
            # Check if running in Git Bash
            if ! command -v git &>/dev/null; then
                error_exit "Git Bash not found. Please install Git for Windows first."
            fi
            
            # Check for ADB
            if ! command -v adb &>/dev/null; then
                info_msg "ADB not found. Downloading Platform Tools..."
                bash "$SCRIPT_DIR/tools/get_adb.sh"
            fi
            
            # Check for Python
            if ! command -v python &>/dev/null && ! command -v python3 &>/dev/null; then
                warning_msg "Python not found. Please install Python 3 from python.org"
            fi
            ;;
    esac
    
    success_msg "Dependencies installation complete!"
}

# ==================== ADB SETUP ====================
setup_adb() {
    info_msg "Setting up ADB..."
    
    # Download ADB if not present
    if ! command -v adb &>/dev/null; then
        info_msg "ADB not found. Downloading..."
        if [ -f "$SCRIPT_DIR/tools/get_adb.sh" ]; then
            bash "$SCRIPT_DIR/tools/get_adb.sh"
            export PATH="$SCRIPT_DIR/tools:$PATH"
        else
            warning_msg "ADB downloader not found. Please install ADB manually."
            return 1
        fi
    fi
    
    # Check if ADB works
    if command -v adb &>/dev/null; then
        HAS_ADB=true
        success_msg "ADB is ready!"
        
        # Check for connected devices
        if adb devices 2>/dev/null | grep -q "device$"; then
            ADB_DEVICE=true
            success_msg "Android device connected via ADB!"
        else
            warning_msg "No ADB device connected. Some features will be limited."
            echo -e "${YELLOW}    To connect:${NC}"
            echo -e "${YELLOW}    1. Enable USB Debugging on your phone${NC}"
            echo -e "${YELLOW}    2. Connect via USB cable${NC}"
            echo -e "${YELLOW}    3. Or use Wireless ADB option later${NC}"
        fi
    else
        warning_msg "ADB setup failed. Some features will be limited."
        return 1
    fi
}

# ==================== DEVICE INFO ====================
get_device_info() {
    if [ "$ADB_DEVICE" = true ]; then
        info_msg "Getting device information..."
        
        DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r' || echo "Unknown")
        ANDROID_VERSION=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r' || echo "Unknown")
        CHIPSET=$(adb shell getprop ro.board.platform 2>/dev/null | tr -d '\r' || echo "Unknown")
        GPU=$(adb shell getprop ro.hardware.vulkan 2>/dev/null | tr -d '\r' || echo "Unknown")
        
        success_msg "Device: $DEVICE_MODEL"
        success_msg "Android: $ANDROID_VERSION"
        success_msg "Chipset: $CHIPSET"
        success_msg "GPU: $GPU"
        
        # Check root status
        if adb shell "su -c 'id'" 2>/dev/null | grep -q "uid=0"; then
            HAS_ROOT=true
            success_msg "Root access: YES"
        else
            warning_msg "Root access: NO (Limited features)"
        fi
    else
        # Try Termux local detection
        if [ "$OS" = "termux" ]; then
            DEVICE_MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
            ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null || echo "Unknown")
            CHIPSET=$(getprop ro.board.platform 2>/dev/null || echo "Unknown")
            
            # Check root in Termux
            if command -v su &>/dev/null && su -c "id" 2>/dev/null | grep -q "uid=0"; then
                HAS_ROOT=true
                success_msg "Root access: YES"
            fi
        fi
    fi
}

# ==================== LEVEL DETECTION ====================
detect_level() {
    info_msg "Determining optimization level..."
    
    if [ "$OS" = "termux" ]; then
        if [ "$HAS_ROOT" = true ]; then
            LEVEL=3
            LEVEL_NAME="Level 3 - Root Access (Termux)"
        elif [ "$ADB_DEVICE" = true ]; then
            LEVEL=2
            LEVEL_NAME="Level 2 - ADB Shell (Termux)"
        else
            LEVEL=1
            LEVEL_NAME="Level 1 - Basic (No Root/ADB)"
        fi
    else
        # PC environment
        if [ "$ADB_DEVICE" = true ]; then
            if [ "$HAS_ROOT" = true ]; then
                LEVEL=5
                LEVEL_NAME="Level 5 - Root + PC (Maximum)"
            else
                LEVEL=4
                LEVEL_NAME="Level 4 - ADB + PC"
            fi
        else
            LEVEL=1
            LEVEL_NAME="Level 1 - Basic (No Device Connected)"
        fi
    fi
    
    success_msg "Current Level: $LEVEL_NAME"
}

# ==================== MENU ====================
show_menu() {
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}HYPERBOOST v5.0 - MAIN MENU${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) 🚀 Auto-Optimize (Recommended)"
    echo -e " ${GREEN}2${NC}) 🎮 Game Optimization Menu"
    echo -e " ${GREEN}3${NC}) ⚡ System Performance Tuning"
    echo -e " ${GREEN}4${NC}) 🗑️  Debloat Menu (Remove Bloatware)"
    echo -e " ${GREEN}5${NC}) 🔧 Kernel & GPU Advanced Tuning"
    echo -e " ${GREEN}6${NC}) 💾 Backup & Restore"
    echo -e " ${GREEN}7${NC}) 📱 Device Information"
    echo -e " ${GREEN}8${NC}) 🔌 Wireless ADB Connection"
    echo -e " ${GREEN}9${NC}) 📋 List All Supported Games"
    echo -e " ${GREEN}10${NC}) 📖 Help & Documentation"
    echo -e " ${GREEN}11${NC}) 🔄 Check for Updates"
    echo -e " ${GREEN}0${NC}) ❌ Exit"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${CYAN}Current Level:${NC} ${GREEN}$LEVEL_NAME${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Choose [0-11]: " choice
    
    case $choice in
        1) auto_optimize ;;
        2) game_menu ;;
        3) performance_menu ;;
        4) debloat_menu ;;
        5) kernel_menu ;;
        6) bash "$SCRIPT_DIR/modules/backup_restore.sh" --interactive 2>/dev/null || warning_msg "Backup module not found" ;;
        7) show_device_info ;;
        8) bash "$SCRIPT_DIR/tools/wireless_adb_connect.sh" 2>/dev/null || warning_msg "Wireless ADB module not found" ;;
        9) show_game_list ;;
        10) show_help ;;
        11) check_updates ;;
        0) 
            echo -e "${GREEN}Thank you for using HyperBoost!${NC}"
            exit 0 
            ;;
        *) 
            warning_msg "Invalid choice. Please try again."
            show_menu 
            ;;
    esac
}

# ==================== AUTO OPTIMIZE ====================
auto_optimize() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}AUTO OPTIMIZATION${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}This will apply all optimizations for your current level.${NC}"
    echo -e "${YELLOW}Level: $LEVEL_NAME${NC}"
    echo ""
    read -p "Continue? (y/n): " confirm
    
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        show_menu
        return
    fi
    
    info_msg "Starting auto-optimization..."
    
    case $LEVEL in
        1)
            info_msg "Running Level 1 optimizations..."
            bash "$SCRIPT_DIR/modules/level1_no_root_adb.sh" 2>/dev/null || warning_msg "Level 1 module failed"
            ;;
        2)
            info_msg "Running Level 2 optimizations..."
            bash "$SCRIPT_DIR/modules/level2_adb.sh" 2>/dev/null || warning_msg "Level 2 module failed"
            bash "$SCRIPT_DIR/modules/tweak_animation.sh" 2>/dev/null
            bash "$SCRIPT_DIR/modules/clean_cache.sh" 2>/dev/null
            ;;
        3)
            info_msg "Running Level 3 optimizations..."
            bash "$SCRIPT_DIR/modules/level3_root.sh" 2>/dev/null || warning_msg "Level 3 module failed"
            bash "$SCRIPT_DIR/modules/kernel_tuner.sh" 2>/dev/null
            bash "$SCRIPT_DIR/modules/ram_optimizer.sh" 2>/dev/null
            ;;
        4)
            info_msg "Running Level 4 optimizations..."
            bash "$SCRIPT_DIR/modules/level4_pc_adb.sh" 2>/dev/null || warning_msg "Level 4 module failed"
            bash "$SCRIPT_DIR/modules/force_120fps_all.sh" 2>/dev/null
            bash "$SCRIPT_DIR/modules/enable_vulkan_all.sh" 2>/dev/null
            ;;
        5)
            info_msg "Running Level 5 optimizations..."
            bash "$SCRIPT_DIR/modules/level5_pc_root.sh" 2>/dev/null || warning_msg "Level 5 module failed"
            bash "$SCRIPT_DIR/modules/force_120fps_all.sh" 2>/dev/null
            bash "$SCRIPT_DIR/modules/enable_vulkan_all.sh" 2>/dev/null
            bash "$SCRIPT_DIR/modules/kernel_tuner.sh" 2>/dev/null
            bash "$SCRIPT_DIR/extras/gpu_tuning.sh" 2>/dev/null
            ;;
    esac
    
    # Common optimizations
    bash "$SCRIPT_DIR/modules/clean_cache.sh" 2>/dev/null
    bash "$SCRIPT_DIR/modules/boost_network.sh" 2>/dev/null
    bash "$SCRIPT_DIR/modules/tweak_animation.sh" 2>/dev/null
    
    success_msg "Auto-optimization complete!"
    echo -e "${YELLOW}[!] Please restart your device for all changes to take effect.${NC}"
    read -p "Press Enter to continue..."
    show_menu
}

# ==================== GAME MENU ====================
game_menu() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}GAME OPTIMIZATION MENU${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) 🎯 Force 120 FPS for ALL Games"
    echo -e " ${GREEN}2${NC}) 🎯 Force 90 FPS for ALL Games"
    echo -e " ${GREEN}3${NC}) 🔥 Enable Vulkan for ALL Games"
    echo -e " ${GREEN}4${NC}) 🎮 ANGLE/Vulkan Injector"
    echo -e " ${GREEN}5${NC}) 🔓 FPS Unlocker (Advanced)"
    echo -e " ${GREEN}6${NC}) 📊 Game-Specific Tweaks"
    echo -e " ${GREEN}0${NC}) 🔙 Back to Main Menu"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Choose [0-6]: " choice
    
    case $choice in
        1) bash "$SCRIPT_DIR/modules/force_120fps_all.sh" 2>/dev/null || warning_msg "Module not available" ;;
        2) bash "$SCRIPT_DIR/modules/force_90fps_all.sh" 2>/dev/null || warning_msg "Module not available" ;;
        3) bash "$SCRIPT_DIR/modules/enable_vulkan_all.sh" 2>/dev/null || warning_msg "Module not available" ;;
        4) bash "$SCRIPT_DIR/modules/angle_vulkan_injector.sh" 2>/dev/null || warning_msg "Module not available" ;;
        5) bash "$SCRIPT_DIR/exploits/fps_unlocker.sh" 2>/dev/null || warning_msg "Module not available" ;;
        6) game_specific_menu ;;
        0) show_menu ;;
        *) game_menu ;;
    esac
    read -p "Press Enter to continue..."
    game_menu
}

game_specific_menu() {
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}GAME-SPECIFIC OPTIMIZATIONS${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) PUBG Mobile / BGMI"
    echo -e " ${GREEN}2${NC}) Call of Duty Mobile"
    echo -e " ${GREEN}3${NC}) Genshin Impact"
    echo -e " ${GREEN}4${NC}) Free Fire / Free Fire MAX"
    echo -e " ${GREEN}5${NC}) Mobile Legends"
    echo -e " ${GREEN}6${NC}) League of Legends: Wild Rift"
    echo -e " ${GREEN}7${NC}) Fortnite"
    echo -e " ${GREEN}8${NC}) Roblox"
    echo -e " ${GREEN}9${NC}) Minecraft"
    echo -e " ${GREEN}10${NC}) Custom Game Package"
    echo -e " ${GREEN}0${NC}) Back"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Choose [0-10]: " game
    
    case $game in
        1)
            info_msg "Optimizing PUBG Mobile..."
            [ -f "$SCRIPT_DIR/data/pubg_configs.txt" ] && source "$SCRIPT_DIR/data/pubg_configs.txt" 2>/dev/null
            adb shell settings put global pubg_max_fps 120 2>/dev/null
            adb shell settings put system tencent_ig_frame_rate 120 2>/dev/null
            success_msg "PUBG Mobile optimized!"
            ;;
        2)
            info_msg "Optimizing Call of Duty Mobile..."
            adb shell settings put global codm_max_fps 120 2>/dev/null
            adb shell settings put system activision_frame_rate 120 2>/dev/null
            success_msg "CODM optimized!"
            ;;
        3)
            info_msg "Optimizing Genshin Impact..."
            adb shell settings put global genshin_fps 120 2>/dev/null
            adb shell settings put system mihoyo_frame_rate 120 2>/dev/null
            success_msg "Genshin Impact optimized!"
            ;;
        4)
            info_msg "Optimizing Free Fire..."
            adb shell settings put global freefire_max_fps 120 2>/dev/null
            success_msg "Free Fire optimized!"
            ;;
        5)
            info_msg "Optimizing Mobile Legends..."
            adb shell settings put global mlbb_fps 120 2>/dev/null
            success_msg "Mobile Legends optimized!"
            ;;
        6)
            info_msg "Optimizing Wild Rift..."
            adb shell settings put global wildrift_fps 120 2>/dev/null
            success_msg "Wild Rift optimized!"
            ;;
        7)
            info_msg "Optimizing Fortnite..."
            adb shell settings put global fortnite_fps 120 2>/dev/null
            success_msg "Fortnite optimized!"
            ;;
        8)
            info_msg "Optimizing Roblox..."
            adb shell settings put global roblox_fps 120 2>/dev/null
            success_msg "Roblox optimized!"
            ;;
        9)
            info_msg "Optimizing Minecraft..."
            adb shell settings put global minecraft_fps 120 2>/dev/null
            success_msg "Minecraft optimized!"
            ;;
        10)
            read -p "Enter game package name: " custom_pkg
            read -p "Enter max FPS: " custom_fps
            adb shell settings put global "${custom_pkg}_max_fps" "$custom_fps" 2>/dev/null
            adb shell settings put system "${custom_pkg}_frame_rate" "$custom_fps" 2>/dev/null
            success_msg "Custom game optimized!"
            ;;
        0) game_menu ;;
    esac
    read -p "Press Enter to continue..."
    game_specific_menu
}

# ==================== PERFORMANCE MENU ====================
performance_menu() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}PERFORMANCE TUNING MENU${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) Level 1 - Safe Optimization (No Root/ADB)"
    echo -e " ${GREEN}2${NC}) Level 2 - ADB Shell Optimization"
    echo -e " ${GREEN}3${NC}) Level 3 - Root Optimization"
    echo -e " ${GREEN}4${NC}) Level 4 - ADB + PC Optimization"
    echo -e " ${GREEN}5${NC}) Level 5 - Root + PC Maximum"
    echo -e " ${GREEN}6${NC}) RAM Optimizer"
    echo -e " ${GREEN}7${NC}) Network Boost"
    echo -e " ${GREEN}8${NC}) Animation Tweaks"
    echo -e " ${GREEN}9${NC}) Clean Cache"
    echo -e " ${GREEN}0${NC}) Back"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Choose [0-9]: " choice
    
    case $choice in
        1) bash "$SCRIPT_DIR/modules/level1_no_root_adb.sh" 2>/dev/null ;;
        2) bash "$SCRIPT_DIR/modules/level2_adb.sh" 2>/dev/null ;;
        3) bash "$SCRIPT_DIR/modules/level3_root.sh" 2>/dev/null ;;
        4) bash "$SCRIPT_DIR/modules/level4_pc_adb.sh" 2>/dev/null ;;
        5) bash "$SCRIPT_DIR/modules/level5_pc_root.sh" 2>/dev/null ;;
        6) bash "$SCRIPT_DIR/modules/ram_optimizer.sh" 2>/dev/null ;;
        7) bash "$SCRIPT_DIR/modules/boost_network.sh" 2>/dev/null ;;
        8) bash "$SCRIPT_DIR/modules/tweak_animation.sh" 2>/dev/null ;;
        9) bash "$SCRIPT_DIR/modules/clean_cache.sh" 2>/dev/null ;;
        0) show_menu ;;
    esac
    read -p "Press Enter to continue..."
    performance_menu
}

# ==================== DEBLOAT MENU ====================
debloat_menu() {
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}DEBLOAT MENU - Remove Unwanted Apps${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) Samsung"     && echo -e " ${GREEN}9${NC}) Nokia"
    echo -e " ${GREEN}2${NC}) Xiaomi"      && echo -e " ${GREEN}10${NC}) Motorola"
    echo -e " ${GREEN}3${NC}) OPPO"        && echo -e " ${GREEN}11${NC}) Lenovo"
    echo -e " ${GREEN}4${NC}) Vivo"        && echo -e " ${GREEN}12${NC}) Sony"
    echo -e " ${GREEN}5${NC}) Huawei"      && echo -e " ${GREEN}13${NC}) ASUS"
    echo -e " ${GREEN}6${NC}) OnePlus"     && echo -e " ${GREEN}14${NC}) TECNO/Infinix"
    echo -e " ${GREEN}7${NC}) Google Pixel" && echo -e " ${GREEN}15${NC}) Nothing"
    echo -e " ${GREEN}8${NC}) Realme"      && echo -e " ${GREEN}16${NC}) Generic (All)"
    echo -e " ${GREEN}0${NC}) Back"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Choose [0-16]: " choice
    
    case $choice in
        1) bash "$SCRIPT_DIR/modules/debloat_samsung.sh" 2>/dev/null ;;
        2) bash "$SCRIPT_DIR/modules/debloat_xiaomi.sh" 2>/dev/null ;;
        3) bash "$SCRIPT_DIR/modules/debloat_oppo.sh" 2>/dev/null ;;
        4) bash "$SCRIPT_DIR/modules/debloat_vivo.sh" 2>/dev/null ;;
        5) bash "$SCRIPT_DIR/modules/debloat_huawei.sh" 2>/dev/null ;;
        6) bash "$SCRIPT_DIR/modules/debloat_oneplus.sh" 2>/dev/null ;;
        7) bash "$SCRIPT_DIR/modules/debloat_google.sh" 2>/dev/null ;;
        8) bash "$SCRIPT_DIR/modules/debloat_realme.sh" 2>/dev/null ;;
        9) bash "$SCRIPT_DIR/modules/debloat_nokia.sh" 2>/dev/null ;;
        10) bash "$SCRIPT_DIR/modules/debloat_motorola.sh" 2>/dev/null ;;
        11) bash "$SCRIPT_DIR/modules/debloat_lenovo.sh" 2>/dev/null ;;
        12) bash "$SCRIPT_DIR/modules/debloat_sony.sh" 2>/dev/null ;;
        13) bash "$SCRIPT_DIR/modules/debloat_asus.sh" 2>/dev/null ;;
        14) bash "$SCRIPT_DIR/modules/debloat_tecno.sh" 2>/dev/null ;;
        15) bash "$SCRIPT_DIR/modules/debloat_nothing.sh" 2>/dev/null ;;
        16) bash "$SCRIPT_DIR/modules/debloat_generic.sh" 2>/dev/null ;;
        0) show_menu ;;
    esac
    read -p "Press Enter to continue..."
    debloat_menu
}

# ==================== KERNEL MENU ====================
kernel_menu() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}KERNEL & GPU ADVANCED TUNING${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${GREEN}1${NC}) Kernel Tuner (CPU/GPU/I/O)"
    echo -e " ${GREEN}2${NC}) GPU Performance Tuning"
    echo -e " ${GREEN}3${NC}) Thermal Unlocker ⚠️ DANGER"
    echo -e " ${GREEN}4${NC}) ZRAM Optimizer"
    echo -e " ${GREEN}5${NC}) Entropy Boost"
    echo -e " ${GREEN}6${NC}) FSTRIM Optimizer"
    echo -e " ${GREEN}7${NC}) Dalvik Cache Optimizer"
    echo -e " ${GREEN}0${NC}) Back"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Choose [0-7]: " choice
    
    case $choice in
        1) bash "$SCRIPT_DIR/modules/kernel_tuner.sh" 2>/dev/null ;;
        2) bash "$SCRIPT_DIR/extras/gpu_tuning.sh" 2>/dev/null ;;
        3) bash "$SCRIPT_DIR/modules/thermal_unlocker.sh" 2>/dev/null ;;
        4) bash "$SCRIPT_DIR/modules/zram_tuner.sh" 2>/dev/null ;;
        5) bash "$SCRIPT_DIR/modules/entropy_boost.sh" 2>/dev/null ;;
        6) bash "$SCRIPT_DIR/modules/fstrim_optimizer.sh" 2>/dev/null ;;
        7) bash "$SCRIPT_DIR/modules/optimize_dalvik.sh" 2>/dev/null ;;
        0) show_menu ;;
    esac
    read -p "Press Enter to continue..."
    kernel_menu
}

# ==================== UTILITY FUNCTIONS ====================
show_device_info() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}DEVICE INFORMATION${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " Device Model: $DEVICE_MODEL"
    echo -e " Android Version: $ANDROID_VERSION"
    echo -e " Chipset: $CHIPSET"
    echo -e " GPU: $GPU"
    echo -e " Architecture: $ARCH"
    echo -e " Root Access: $HAS_ROOT"
    echo -e " ADB Available: $HAS_ADB"
    echo -e " ADB Device: $ADB_DEVICE"
    echo -e " Current Level: $LEVEL_NAME"
    echo -e " OS: $OS"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Press Enter to continue..."
    show_menu
}

show_game_list() {
    if [ -f "$SCRIPT_DIR/data/game_list_complete.txt" ]; then
        cat "$SCRIPT_DIR/data/game_list_complete.txt" | less
    else
        warning_msg "Game list file not found."
    fi
    show_menu
}

show_help() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${BOLD}HYPERBOOST HELP${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " Quick commands:"
    echo -e "   bash setup.sh              - Interactive menu"
    echo -e "   bash setup.sh --auto       - Auto-optimize"
    echo -e "   bash setup.sh --game       - Game menu"
    echo -e "   bash setup.sh --debloat    - Debloat menu"
    echo -e "   bash setup.sh --help       - This help"
    echo -e ""
    echo -e " For detailed documentation:"
    echo -e "   cat docs/FAQ.md"
    echo -e "   cat docs/SAFETY_GUIDE.md"
    echo -e "   cat docs/COMMANDS_REFERENCE.md"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Press Enter to continue..."
    show_menu
}

check_updates() {
    info_msg "Checking for updates..."
    if command -v git &>/dev/null && [ -d "$SCRIPT_DIR/.git" ]; then
        cd "$SCRIPT_DIR"
        git fetch 2>/dev/null
        LOCAL=$(git rev-parse HEAD 2>/dev/null)
        REMOTE=$(git rev-parse @{u} 2>/dev/null)
        
        if [ "$LOCAL" != "$REMOTE" ] && [ -n "$REMOTE" ]; then
            warning_msg "Update available!"
            read -p "Update now? (y/n): " update_choice
            if [ "$update_choice" = "y" ]; then
                git pull
                success_msg "Updated! Please restart setup.sh"
                exit 0
            fi
        else
            success_msg "Already up to date!"
        fi
    else
        warning_msg "Not a git repository. Please update manually."
    fi
    read -p "Press Enter to continue..."
    show_menu
}

# ==================== MAIN ====================
main() {
    show_logo
    detect_os
    install_dependencies
    setup_adb
    get_device_info
    detect_level
    
    # Handle command line arguments
    case "${1:-}" in
        --auto)
            auto_optimize
            exit 0
            ;;
        --game)
            game_menu
            exit 0
            ;;
        --debloat)
            debloat_menu
            exit 0
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        --info)
            show_device_info
            exit 0
            ;;
        *)
            show_menu
            ;;
    esac
}

# Run main
main "$@"