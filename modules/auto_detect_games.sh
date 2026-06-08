#!/bin/bash
# =====================================================================
# HYPERBOOST - AUTO GAME DETECTOR & SELECTOR v3.1
# Sửa lỗi chỉ lấy 1 app - Hiển thị TẤT CẢ package
# =====================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"

# Mảng lưu package và tên app
declare -a ALL_PACKAGES
declare -a ALL_NAMES
declare -a SELECTED_INDEXES

TOTAL_PACKAGES=0
OPTIMIZED_COUNT=0

# ==================== HIỂN THỊ LOGO ====================
clear
echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     🤖 AUTO GAME DETECTOR & SELECTOR v3.1                ║${NC}"
echo -e "${CYAN}║     Hiển thị TẤT CẢ app - Tự chọn package cần tối ưu    ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# ==================== KIỂM TRA KẾT NỐI ADB ====================
echo -e "${YELLOW}[*] Kiểm tra kết nối ADB...${NC}"
if ! command -v adb &>/dev/null; then
    echo -e "${RED}[✗] ADB không được cài đặt!${NC}"
    exit 1
fi

if ! adb devices 2>/dev/null | grep -q "device$"; then
    echo -e "${RED}[✗] Không tìm thấy thiết bị qua ADB!${NC}"
    exit 1
fi
echo -e "${GREEN}[✓] Thiết bị đã kết nối${NC}"
echo ""

# ==================== LẤY THÔNG TIN THIẾT BỊ ====================
DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
ANDROID_VERSION=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${BOLD}THÔNG TIN THIẾT BỊ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " Model:    ${GREEN}$DEVICE_MODEL${NC}"
echo -e " Android:  ${GREEN}$ANDROID_VERSION${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ==================== LẤY DANH SÁCH PACKAGE (ĐÃ SỬA) ====================
echo -e "${YELLOW}[*] Đang lấy danh sách ứng dụng...${NC}"

# Lấy danh sách package vào mảng
mapfile -t ALL_PACKAGES < <(adb shell pm list packages 2>/dev/null | cut -d: -f2 | tr -d '\r')
TOTAL_PACKAGES=${#ALL_PACKAGES[@]}

if [ $TOTAL_PACKAGES -eq 0 ]; then
    echo -e "${RED}[✗] Không lấy được danh sách ứng dụng!${NC}"
    exit 1
fi

echo -e "${GREEN}[✓] Tìm thấy ${TOTAL_PACKAGES} ứng dụng${NC}"
echo ""

# Lấy tên ứng dụng
echo -e "${YELLOW}[*] Đang lấy tên ứng dụng...${NC}"

for i in $(seq 0 $((TOTAL_PACKAGES - 1))); do
    pkg="${ALL_PACKAGES[$i]}"
    
    # Thử nhiều cách lấy tên
    label=""
    
    # Cách 1: pm dump nhanh
    label=$(adb shell pm dump "$pkg" 2>/dev/null | grep -m1 "label=" | head -1 | sed 's/.*label=//' | sed 's/ .*//' | tr -d '\r')
    
    # Cách 2: Nếu không được
    if [ -z "$label" ] || [ "$label" = "null" ] || [ "$label" = "0" ]; then
        label=$(adb shell dumpsys package "$pkg" 2>/dev/null | grep -m1 "labelRes" | sed 's/.*labelRes=//' | cut -d' ' -f1 | tr -d '\r')
    fi
    
    # Cách 3: Dùng tên package
    if [ -z "$label" ] || [ "$label" = "null" ] || [ "$label" = "0" ]; then
        label=$(echo "$pkg" | awk -F. '{print $NF}')
    fi
    
    ALL_NAMES+=("$label")
    
    # Hiển thị tiến độ
    if [ $(( (i + 1) % 50 )) -eq 0 ] || [ $((i + 1)) -eq $TOTAL_PACKAGES ]; then
        echo -e "  ${CYAN}...đã xử lý $((i + 1))/$TOTAL_PACKAGES app${NC}"
    fi
done

echo -e "${GREEN}[✓] Hoàn tất lấy danh sách!${NC}"
echo ""

# ==================== HỎI SỐ LƯỢNG HIỂN THỊ ====================
echo -e "${YELLOW}[?] Bạn muốn hiển thị bao nhiêu ứng dụng?${NC}"
echo -e "    ${GREEN}1${NC}) Tất cả (${TOTAL_PACKAGES} app)"
echo -e "    ${GREEN}2${NC}) Chỉ app người dùng (user apps)"
echo -e "    ${GREEN}3${NC}) Lọc theo từ khóa"
echo -e "    ${GREEN}4${NC}) Gợi ý game phổ biến"
echo -e "    ${GREEN}5${NC}) 50 app đầu tiên"
read -p "    Chọn [1-5]: " filter_choice

case $filter_choice in
    2)
        echo -e "${YELLOW}[*] Đang lọc app người dùng...${NC}"
        TEMP_PKGS=()
        TEMP_NAMES=()
        for i in $(seq 0 $((TOTAL_PACKAGES - 1))); do
            pkg="${ALL_PACKAGES[$i]}"
            if adb shell pm list packages -3 2>/dev/null | grep -q "$pkg"; then
                TEMP_PKGS+=("$pkg")
                TEMP_NAMES+=("${ALL_NAMES[$i]}")
            fi
        done
        ALL_PACKAGES=("${TEMP_PKGS[@]}")
        ALL_NAMES=("${TEMP_NAMES[@]}")
        TOTAL_PACKAGES=${#ALL_PACKAGES[@]}
        echo -e "${GREEN}[✓] Còn ${TOTAL_PACKAGES} app người dùng${NC}"
        ;;
    3)
        read -p "    Nhập từ khóa: " keyword
        TEMP_PKGS=()
        TEMP_NAMES=()
        for i in $(seq 0 $((TOTAL_PACKAGES - 1))); do
            pkg="${ALL_PACKAGES[$i]}"
            name="${ALL_NAMES[$i]}"
            if echo "$pkg $name" | grep -qi "$keyword"; then
                TEMP_PKGS+=("$pkg")
                TEMP_NAMES+=("$name")
            fi
        done
        ALL_PACKAGES=("${TEMP_PKGS[@]}")
        ALL_NAMES=("${TEMP_NAMES[@]}")
        TOTAL_PACKAGES=${#ALL_PACKAGES[@]}
        echo -e "${GREEN}[✓] Tìm thấy ${TOTAL_PACKAGES} app phù hợp${NC}"
        ;;
    4)
        GAME_KEYWORDS="tencent|garena|mihoyo|hoyoverse|activision|epicgames|supercell|netease|gameloft|mojang|roblox|riotgames|kurogame|dts|pubg|cod|genshin|freefire|mlbb|wildrift|fortnite|minecraft|brawl|clash|honkai|valorant|lienquan"
        TEMP_PKGS=()
        TEMP_NAMES=()
        for i in $(seq 0 $((TOTAL_PACKAGES - 1))); do
            pkg="${ALL_PACKAGES[$i]}"
            if echo "$pkg" | grep -qiE "$GAME_KEYWORDS"; then
                TEMP_PKGS+=("$pkg")
                TEMP_NAMES+=("${ALL_NAMES[$i]}")
            fi
        done
        ALL_PACKAGES=("${TEMP_PKGS[@]}")
        ALL_NAMES=("${TEMP_NAMES[@]}")
        TOTAL_PACKAGES=${#ALL_PACKAGES[@]}
        echo -e "${GREEN}[✓] Tìm thấy ${TOTAL_PACKAGES} game${NC}"
        ;;
    5)
        TOTAL_PACKAGES=50
        echo -e "${GREEN}[✓] Hiển thị 50 app đầu tiên${NC}"
        ;;
esac

echo ""

# ==================== HIỂN THỊ DANH SÁCH ====================
echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     📋 DANH SÁCH ỨNG DỤNG TRÊN MÁY                      ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e " ${BOLD}Tổng: ${CYAN}$TOTAL_PACKAGES${NC} ứng dụng${NC}"
echo ""

for i in $(seq 0 $((TOTAL_PACKAGES - 1))); do
    NUM=$((i + 1))
    printf " ${CYAN}%4d${NC}) ${WHITE}%-35s${NC} ${YELLOW}%s${NC}\n" "$NUM" "${ALL_NAMES[$i]:0:35}" "${ALL_PACKAGES[$i]}"
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ==================== HƯỚNG DẪN CHỌN ====================
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║     📝 CHỌN PACKAGE CẦN TỐI ƯU                          ║${NC}"
echo -e "${YELLOW}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${YELLOW}║${NC}  all | 1 3 5 | 10-20 | game | skip | ?              ${YELLOW}║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# ==================== HÀM PARSE ====================
parse_selection() {
    local input=$1
    case "$input" in
        "all"|"ALL") seq 1 $TOTAL_PACKAGES ;;
        "game"|"GAME")
            GAME_KEYWORDS="tencent|garena|mihoyo|hoyoverse|activision|epicgames|supercell|netease|gameloft|mojang|roblox|riotgames|kurogame|dts"
            for i in $(seq 0 $((TOTAL_PACKAGES - 1))); do
                echo "${ALL_PACKAGES[$i]}" | grep -qiE "$GAME_KEYWORDS" && echo $((i + 1))
            done
            ;;
        *)
            for part in $input; do
                if [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
                    [ "${BASH_REMATCH[1]}" -le "${BASH_REMATCH[2]}" ] && [ "${BASH_REMATCH[2]}" -le $TOTAL_PACKAGES ] && seq "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
                elif [[ "$part" =~ ^[0-9]+$ ]] && [ "$part" -ge 1 ] && [ "$part" -le $TOTAL_PACKAGES ]; then
                    echo "$part"
                fi
            done
            ;;
    esac
}

# ==================== VÒNG LẶP CHỌN ====================
while true; do
    read -p "🎯 Chọn package: " user_input
    
    case "$user_input" in
        "?")
            for i in $(seq 0 $((TOTAL_PACKAGES - 1))); do
                NUM=$((i + 1))
                [[ " ${SELECTED_INDEXES[*]} " =~ " $NUM " ]] && echo -e " ${GREEN}[✓]${NC} $NUM. ${ALL_NAMES[$i]}" || echo -e "     $NUM. ${ALL_NAMES[$i]}"
            done
            echo ""
            continue
            ;;
        "skip"|"SKIP"|"")
            [ ${#SELECTED_INDEXES[@]} -eq 0 ] && { echo -e "${YELLOW}[!] Thoát.${NC}"; exit 0; }
            break
            ;;
        *)
            SELECTED_INDEXES=($(parse_selection "$user_input" | sort -nu))
            [ ${#SELECTED_INDEXES[@]} -eq 0 ] && { echo -e "${RED}[✗] Không hợp lệ.${NC}"; continue; }
            
            echo ""
            echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e " ${BOLD}ĐÃ CHỌN ${#SELECTED_INDEXES[@]} PACKAGE:${NC}"
            echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            for idx in "${SELECTED_INDEXES[@]}"; do
                i=$((idx - 1))
                echo -e " ${GREEN}✓${NC} ${ALL_NAMES[$i]} (${ALL_PACKAGES[$i]})"
            done
            echo ""
            
            read -p "Xác nhận? (y/n/s): " confirm
            case "$confirm" in "y"|"Y") break ;; "s"|"S") SELECTED_INDEXES=(); continue ;; *) exit 0 ;; esac
            ;;
    esac
done

# ==================== HỎI FPS ====================
echo ""
echo -e "${YELLOW}[?] Set FPS:${NC} 1=60 2=90 3=120 4=Tùy chỉnh"
read -p "Chọn [1-4]: " fps_choice
case $fps_choice in 1) TARGET_FPS=60 ;; 2) TARGET_FPS=90 ;; 3) TARGET_FPS=120 ;; 4) read -p "FPS: " TARGET_FPS ;; *) TARGET_FPS=120 ;; esac

# ==================== TỐI ƯU ====================
echo ""
echo -e "${CYAN}[*] Đang tối ưu ${#SELECTED_INDEXES[@]} package...${NC}"
echo ""

for idx in "${SELECTED_INDEXES[@]}"; do
    i=$((idx - 1))
    pkg="${ALL_PACKAGES[$i]}"
    name="${ALL_NAMES[$i]}"
    OPTIMIZED_COUNT=$((OPTIMIZED_COUNT + 1))
    
    echo -e "${GREEN}[$OPTIMIZED_COUNT]${NC} $name"
    adb shell settings put global "${pkg}_max_fps" "$TARGET_FPS" 2>/dev/null
    adb shell settings put system "${pkg}_frame_rate" "$TARGET_FPS" 2>/dev/null
    adb shell dumpsys deviceidle whitelist +"$pkg" 2>/dev/null
    echo -e "  ${GREEN}✓${NC} FPS: $TARGET_FPS | Tắt tiết kiệm pin"
    echo ""
done

echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✓ ĐÃ TỐI ƯU $OPTIMIZED_COUNT PACKAGE - FPS: $TARGET_FPS                   ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
