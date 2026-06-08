#!/bin/bash
# =====================================================================
# HYPERBOOST v1.1 - ANGLE SYSTEM-WIDE ENABLER
# Bật ANGLE cho tất cả ứng dụng hỗ trợ
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     ANGLE SYSTEM-WIDE ENABLER v1.1        ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}[1/4] Kiểm tra Vulkan...${NC}"
VULKAN=$(adb shell getprop ro.hardware.vulkan 2>/dev/null)
if [ "$VULKAN" != "1" ]; then
    echo -e "${RED}[!] Thiết bị không hỗ trợ Vulkan. ANGLE có thể không hoạt động.${NC}"
else
    echo -e "${GREEN}[✓] Vulkan được hỗ trợ${NC}"
fi

echo -e "${YELLOW}[2/4] Bật ANGLE system-wide...${NC}"
adb shell settings put global angle_enabled 1 2>/dev/null
adb shell settings put global show_angle_gl_driver 1 2>/dev/null
adb shell setprop debug.angle.enabled 1 2>/dev/null
adb shell setprop persist.graphics.vulkan 1 2>/dev/null
echo -e "${GREEN}  ✓ ANGLE enabled${NC}"

echo -e "${YELLOW}[3/4] Cấu hình ANGLE cho tất cả app...${NC}"
# Lấy tất cả package
ALL_PKGS=$(adb shell pm list packages -3 2>/dev/null | cut -d: -f2 | tr '\n' ';')
ALL_PKGS=${ALL_PKGS%;}

if [ -n "$ALL_PKGS" ]; then
    # Tạo giá trị angle tương ứng
    COUNT=$(echo "$ALL_PKGS" | tr ';' '\n' | wc -l)
    VALUES=""
    for i in $(seq 1 $COUNT); do
        VALUES="${VALUES}angle;"
    done
    VALUES=${VALUES%;}
    
    adb shell settings put global angle_gl_driver_selection_pkgs "$ALL_PKGS" 2>/dev/null
    adb shell settings put global angle_gl_driver_selection_values "$VALUES" 2>/dev/null
    echo -e "${GREEN}  ✓ ANGLE configured for $COUNT apps${NC}"
fi

echo -e "${YELLOW}[4/4] Áp dụng...${NC}"
adb shell setprop debug.hwui.renderer vulkan 2>/dev/null
echo -e "${GREEN}  ✓ Done${NC}"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ ANGLE SYSTEM-WIDE ENABLED!            ║${NC}"
echo -e "${GREEN}║   Restart to apply changes                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"