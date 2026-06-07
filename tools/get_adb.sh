#!/bin/bash
# =====================================================================
# HYPERBOOST ADB DOWNLOADER
# Automatically downloads ADB for current OS
# =====================================================================
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR"

echo -e "${BLUE}[*] Downloading Android Platform Tools...${NC}"

# Detect OS
case "$(uname -s)" in
    Linux*)
        if [ "$(uname -m)" = "aarch64" ]; then
            URL="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
        else
            URL="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
        fi
        PLATFORM="linux"
        ;;
    Darwin*)
        URL="https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
        PLATFORM="macos"
        ;;
    CYGWIN*|MINGW*|MSYS*)
        URL="https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
        PLATFORM="windows"
        ;;
    *)
        echo "Unsupported OS"
        exit 1
        ;;
esac

# Download
echo -e "${YELLOW}[*] Downloading from Google...${NC}"
cd "$TOOLS_DIR"

if command -v curl &>/dev/null; then
    curl -L "$URL" -o platform-tools.zip
elif command -v wget &>/dev/null; then
    wget -O platform-tools.zip "$URL"
else
    echo "Need curl or wget to download"
    exit 1
fi

# Extract
echo -e "${YELLOW}[*] Extracting...${NC}"
unzip -o platform-tools.zip
cp platform-tools/adb* "$TOOLS_DIR/" 2>/dev/null || true
cp platform-tools/fastboot* "$TOOLS_DIR/" 2>/dev/null || true
chmod +x "$TOOLS_DIR/adb" 2>/dev/null || true
chmod +x "$TOOLS_DIR/fastboot" 2>/dev/null || true

# Cleanup
rm -rf platform-tools platform-tools.zip

# Add to PATH
export PATH="$TOOLS_DIR:$PATH"

echo -e "${GREEN}[✓] ADB installed successfully!${NC}"
echo -e "${YELLOW}[!] Add to PATH: export PATH=\"$TOOLS_DIR:\$PATH\"${NC}"