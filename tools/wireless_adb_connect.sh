#!/bin/bash
# =====================================================================
# HYPERBOOST WIRELESS ADB CONNECTOR
# Connect to Android device wirelessly
# =====================================================================

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${BLUE}[*] Wireless ADB Connection${NC}"
echo -e "${YELLOW}Make sure phone and PC are on same WiFi network${NC}"
echo ""

# Check if device is connected via USB first
if adb devices 2>/dev/null | grep -q "device$"; then
    echo -e "${GREEN}[✓] USB device detected${NC}"
    
    # Get device IP
    IP=$(adb shell ip route 2>/dev/null | awk '{print $9}' | head -1)
    
    if [ -z "$IP" ]; then
        IP=$(adb shell ifconfig wlan0 2>/dev/null | grep "inet addr" | cut -d: -f2 | awk '{print $1}')
    fi
    
    if [ -z "$IP" ]; then
        echo -e "${RED}[✗] Cannot detect device IP${NC}"
        read -p "Enter device IP manually: " IP
    fi
    
    echo -e "${GREEN}[*] Device IP: $IP${NC}"
    
    # Enable TCP/IP
    adb tcpip 5555
    sleep 2
    
    # Connect wirelessly
    adb connect "$IP:5555"
    
    echo -e "${GREEN}[✓] Connected wirelessly! You can unplug USB.${NC}"
else
    echo -e "${YELLOW}[!] No USB device found.${NC}"
    read -p "Enter device IP:Port (e.g., 192.168.1.10:5555): " IP_PORT
    adb connect "$IP_PORT"
fi

adb devices
echo -e "${GREEN}[✓] Done!${NC}"