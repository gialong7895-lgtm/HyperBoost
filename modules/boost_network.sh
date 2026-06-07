#!/bin/bash
# =====================================================================
# HYPERBOOST - NETWORK BOOST
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
echo -e "${BLUE}[*] Boosting network performance...${NC}"
adb shell settings put global wifi_scan_always_enabled 0 2>/dev/null
adb shell settings put global mobile_data_always_on 1 2>/dev/null
adb shell settings put global tcp_default_init_rwnd 60 2>/dev/null
adb shell setprop net.tcp.buffersize.default 4096,87380,256960,4096,16384,256960 2>/dev/null
adb shell setprop net.tcp.buffersize.wifi 4096,87380,256960,4096,16384,256960 2>/dev/null
adb shell setprop net.tcp.buffersize.lte 4096,87380,256960,4096,16384,256960 2>/dev/null
adb shell setprop net.dns1 1.1.1.1 2>/dev/null
adb shell setprop net.dns2 8.8.8.8 2>/dev/null
echo -e "${GREEN}[✓] Network boosted!${NC}"