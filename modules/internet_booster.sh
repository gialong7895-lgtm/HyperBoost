#!/bin/bash
# =====================================================================
# HYPERBOOST v1.1 - INTERNET SPEED BOOSTER
# Tăng tốc Internet (WiFi + Mobile Data)
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     INTERNET SPEED BOOSTER v1.1           ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}[1/6] DNS Optimization...${NC}"
adb shell setprop net.dns1 1.1.1.1 2>/dev/null
adb shell setprop net.dns2 8.8.8.8 2>/dev/null
adb shell setprop net.dns3 9.9.9.9 2>/dev/null
adb shell settings put global private_dns_mode hostname 2>/dev/null
adb shell settings put global private_dns_specifier dns.google 2>/dev/null
echo -e "${GREEN}  ✓ DNS: Cloudflare + Google${NC}"

echo -e "${YELLOW}[2/6] TCP/IP Optimization...${NC}"
adb shell "su -c 'echo 1 > /proc/sys/net/ipv4/tcp_low_latency'" 2>/dev/null
adb shell "su -c 'echo 0 > /proc/sys/net/ipv4/tcp_timestamps'" 2>/dev/null
adb shell "su -c 'echo 1 > /proc/sys/net/ipv4/tcp_sack'" 2>/dev/null
adb shell "su -c 'echo 1 > /proc/sys/net/ipv4/tcp_window_scaling'" 2>/dev/null
echo -e "${GREEN}  ✓ TCP/IP optimized${NC}"

echo -e "${YELLOW}[3/6] Buffer Optimization...${NC}"
adb shell setprop net.tcp.buffersize.default 4096,87380,256960,4096,16384,256960 2>/dev/null
adb shell setprop net.tcp.buffersize.wifi 4096,87380,256960,4096,16384,256960 2>/dev/null
adb shell setprop net.tcp.buffersize.lte 4096,87380,256960,4096,16384,256960 2>/dev/null
echo -e "${GREEN}  ✓ Buffers optimized${NC}"

echo -e "${YELLOW}[4/6] WiFi Optimization...${NC}"
adb shell settings put global wifi_scan_always_enabled 0 2>/dev/null
adb shell settings put global wifi_scan_throttle_enabled 1 2>/dev/null
adb shell "su -c 'echo 1 > /proc/sys/net/ipv4/ip_no_pmtu_disc'" 2>/dev/null
echo -e "${GREEN}  ✓ WiFi optimized${NC}"

echo -e "${YELLOW}[5/6] Mobile Data Optimization...${NC}"
adb shell settings put global mobile_data_always_on 1 2>/dev/null
adb shell settings put system intelligent_network_mode 1 2>/dev/null
echo -e "${GREEN}  ✓ Mobile data optimized${NC}"

echo -e "${YELLOW}[6/6] Speed Test...${NC}"
echo -e "  ${CYAN}[*] Testing ping...${NC}"
PING_MS=$(adb shell "ping -c 3 -W 2 1.1.1.1 2>/dev/null" | grep "avg" | awk -F/ '{print $4}' | cut -d. -f1)
echo -e "  ${GREEN}Ping: ${PING_MS:-N/A} ms${NC}"

echo ""
echo -e "${GREEN}[✓] Internet speed boosted!${NC}"