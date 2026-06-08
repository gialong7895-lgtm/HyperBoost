#!/bin/bash
# =====================================================================
# HYPERBOOST v1.1 - CPU OVERCLOCK (ROOT)
# Ép xung CPU an toàn dựa trên database
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHIP_DB="$SCRIPT_DIR/data/chip_gpu_db.txt"

echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
echo -e "${RED}║     CPU OVERCLOCK v1.1 (ROOT REQUIRED)     ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
echo ""

# Kiểm tra root
if ! adb shell "su -c 'id'" 2>/dev/null | grep -q "uid=0"; then
    echo -e "${RED}[✗] Yêu cầu Root!${NC}"
    exit 1
fi

CHIPSET=$(adb shell getprop ro.board.platform 2>/dev/null)

echo -e "${YELLOW}[*] Chipset: $CHIPSET${NC}"
echo -e "${YELLOW}[*] Đang tìm thông số an toàn...${NC}"

# Tìm trong database
if [ -f "$CHIP_DB" ]; then
    MAX_FREQ=$(grep "$CHIPSET" "$CHIP_DB" | cut -d'|' -f3)
else
    MAX_FREQ=0
fi

if [ -z "$MAX_FREQ" ] || [ "$MAX_FREQ" -eq 0 ]; then
    # Lấy max hiện tại nếu không có trong DB
    MAX_FREQ=$(adb shell cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq 2>/dev/null)
fi

echo -e "${GREEN}[✓] Max safe freq: ${MAX_FREQ} KHz${NC}"
echo ""

echo -e "${YELLOW}[*] Đang ép xung CPU...${NC}"

for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do
    adb shell "su -c 'echo $MAX_FREQ > $cpu'" 2>/dev/null
done

# Set min freq cao hơn
MIN_FREQ=$((MAX_FREQ / 2))
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
    adb shell "su -c 'echo $MIN_FREQ > $cpu'" 2>/dev/null
done

echo -e "${GREEN}[✓] CPU Overclock hoàn tất!${NC}"
echo -e "  Max: ${GREEN}${MAX_FREQ} KHz${NC}"
echo -e "  Min: ${GREEN}${MIN_FREQ} KHz${NC}"