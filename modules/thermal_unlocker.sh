#!/bin/bash
# =====================================================================
# HYPERBOOST - THERMAL UNLOCKER
# ⚠️ EXTREMELY DANGEROUS - CAN DAMAGE DEVICE PERMANENTLY
# =====================================================================
RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; NC='\033[0m'
echo -e "${RED}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║  ⚠️  THERMAL UNLOCKER - CỰC KỲ NGUY HIỂM                 ║${NC}"
echo -e "${RED}║  CÓ THỂ GÂY CHÁY CPU/GPU - HƯ HỎNG PHẦN CỨNG VĨNH VIỄN  ║${NC}"
echo -e "${RED}║  TÁC GIẢ KHÔNG CHỊU TRÁCH NHIỆM                         ║${NC}"
echo -e "${RED}╚══════════════════════════════════════════════════════════╝${NC}"
read -p "Gõ 'TOI_DONG_Y_PHA_HUY_THIET_BI' để tiếp tục: " confirm
if [ "$confirm" != "TOI_DONG_Y_PHA_HUY_THIET_BI" ]; then
    echo -e "${GREEN}Đã hủy. Thiết bị an toàn.${NC}"
    exit 0
fi
echo -e "${RED}[!] Disabling thermal protection...${NC}"
adb shell "su -c 'stop thermal-engine'" 2>/dev/null
adb shell "su -c 'stop thermalservice'" 2>/dev/null
adb shell "su -c 'echo disabled > /sys/class/thermal/thermal_zone0/mode'" 2>/dev/null
echo -e "${RED}[✓] Thermal disabled. Monitor temperature carefully!${NC}"