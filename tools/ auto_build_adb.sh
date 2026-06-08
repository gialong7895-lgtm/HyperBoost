#!/bin/bash
# =====================================================================
# HYPERBOOST v2.0 - AUTO ADB CONNECTOR (PORT 5555)
# Tự động mở port 5555 trên điện thoại mới và kết nối
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   AUTO ADB CONNECTOR v2.0 (Port 5555)     ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
echo ""

# Kiểm tra ADB
if ! command -v adb &>/dev/null; then
    echo -e "${RED}[✗] ADB không được cài đặt!${NC}"
    echo -e "${YELLOW}[!] Chạy tools/get_adb.sh để tải ADB${NC}"
    exit 1
fi

echo -e "${YELLOW}[*] Đang quét thiết bị...${NC}"

# Kiểm tra thiết bị USB
USB_DEVICE=$(adb devices 2>/dev/null | grep -v "List" | grep "device$" | awk '{print $1}')

if [ -n "$USB_DEVICE" ]; then
    echo -e "${GREEN}[✓] Thiết bị USB phát hiện: $USB_DEVICE${NC}"
    
    # Lấy IP thiết bị
    echo -e "${YELLOW}[*] Đang lấy địa chỉ IP...${NC}"
    
    # Thử nhiều cách lấy IP
    IP=$(adb shell ip route 2>/dev/null | awk '{print $9}' | head -1)
    [ -z "$IP" ] && IP=$(adb shell ifconfig wlan0 2>/dev/null | grep "inet addr" | cut -d: -f2 | awk '{print $1}')
    [ -z "$IP" ] && IP=$(adb shell ip -f inet addr show wlan0 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d/ -f1)
    
    if [ -z "$IP" ]; then
        echo -e "${RED}[✗] Không thể lấy IP tự động${NC}"
        read -p "👉 Nhập IP thủ công: " IP
    fi
    
    echo -e "${GREEN}[✓] IP thiết bị: $IP${NC}"
    
    # Mở port 5555
    echo -e "${YELLOW}[*] Đang mở port TCP/IP 5555...${NC}"
    adb tcpip 5555
    sleep 2
    
    # Kết nối không dây
    echo -e "${YELLOW}[*] Đang kết nối không dây đến ${IP}:5555...${NC}"
    adb connect "${IP}:5555"
    
    # Kiểm tra kết nối
    sleep 1
    if adb devices | grep -q "${IP}:5555.*device"; then
        echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║  ✓ KẾT NỐI KHÔNG DÂY THÀNH CÔNG!          ║${NC}"
        echo -e "${GREEN}║  IP: ${IP}:5555                          ║${NC}"
        echo -e "${GREEN}║  Có thể rút cáp USB                       ║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
    else
        echo -e "${RED}[✗] Kết nối không dây thất bại${NC}"
        echo -e "${YELLOW}[!] Vẫn có thể dùng USB${NC}"
    fi
else
    # Không có USB, thử kết nối trực tiếp
    echo -e "${YELLOW}[!] Không tìm thấy thiết bị USB${NC}"
    echo -e "${YELLOW}[*] Đang thử kết nối không dây trực tiếp...${NC}"
    echo ""
    echo -e "${CYAN}Hướng dẫn trên điện thoại:${NC}"
    echo -e "  1. Vào Cài đặt → Tùy chọn nhà phát triển"
    echo -e "  2. Bật 'USB Debugging'"
    echo -e "  3. Bật 'ADB qua mạng' hoặc 'Wireless debugging'"
    echo -e "  4. Chọn 'Pair device with pairing code'"
    echo ""
    read -p "👉 Nhập IP:Port hiển thị trên màn hình (vd: 192.168.1.10:5555): " IP_PORT
    
    if [ -n "$IP_PORT" ]; then
        adb connect "$IP_PORT"
        sleep 1
        if adb devices | grep -q "${IP_PORT%%:*}:.*device"; then
            echo -e "${GREEN}[✓] Kết nối thành công!${NC}"
        else
            echo -e "${RED}[✗] Kết nối thất bại${NC}"
        fi
    fi
fi

echo ""
adb devices
echo ""
echo -e "${GREEN}[✓] Hoàn tất!${NC}"