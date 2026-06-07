#!/bin/bash
# HyperBoost Linux Setup
echo "[*] Installing dependencies..."
sudo apt update
sudo apt install -y adb fastboot python3 python3-pip git curl wget
echo "[✓] Linux setup complete!"
echo "Run: bash setup.sh"