#!/bin/bash
# HyperBoost macOS Setup
echo "[*] Installing dependencies..."
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew install android-platform-tools python3 git curl wget
echo "[✓] macOS setup complete!"
echo "Run: bash setup.sh"