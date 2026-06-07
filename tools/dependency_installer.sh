#!/bin/bash
# =====================================================================
# HYPERBOOST DEPENDENCY INSTALLER
# Auto-installs all required packages for any environment
# =====================================================================
set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

install_all() {
    echo -e "${GREEN}[*] Starting full dependency installation...${NC}"
    
    # Detect OS
    case "$OSTYPE" in
        linux-android*)
            echo -e "${YELLOW}[*] Termux detected${NC}"
            pkg update -y
            pkg upgrade -y
            pkg install -y termux-api android-tools python python-pip git curl wget openssh
            pip install requests psutil colorama
            ;;
            
        linux-gnu*)
            echo -e "${YELLOW}[*] Linux detected${NC}"
            if command -v apt-get &>/dev/null; then
                sudo apt-get update -y
                sudo apt-get install -y adb fastboot android-sdk-platform-tools-common python3 python3-pip git curl wget unzip
            elif command -v pacman &>/dev/null; then
                sudo pacman -Syu --noconfirm android-tools python python-pip git curl wget unzip
            elif command -v dnf &>/dev/null; then
                sudo dnf install -y android-tools python3 python3-pip git curl wget unzip
            fi
            pip3 install requests psutil colorama
            ;;
            
        darwin*)
            echo -e "${YELLOW}[*] macOS detected${NC}"
            if ! command -v brew &>/dev/null; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install android-platform-tools python3 git curl wget
            pip3 install requests psutil colorama
            ;;
            
        msys*|cygwin*|mingw*)
            echo -e "${YELLOW}[*] Windows detected${NC}"
            echo "Please install manually:"
            echo "1. Git for Windows: https://git-scm.com/download/win"
            echo "2. Python 3: https://python.org/downloads/"
            echo "3. Platform Tools: https://developer.android.com/studio/releases/platform-tools"
            ;;
    esac
    
    echo -e "${GREEN}[✓] All dependencies installed!${NC}"
}

install_all