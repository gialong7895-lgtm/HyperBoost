#!/bin/bash
# =====================================================================
# HYPERBOOST - AUTO GAME DETECTOR & OPTIMIZER v2.0
# Tự động quét game đã cài, hiển thị danh sách
# Cho phép người dùng TÍCH CHỌN game cần tối ưu
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
GAME_LIST="$SCRIPT_DIR/data/game_list_complete.txt"
BACKUP_DIR="$SCRIPT_DIR/backup"
TEMP_SELECTED="/tmp/hyperboost_selected_games.txt"

# Mảng lưu game tìm thấy
declare -a FOUND_PKGS
declare -a FOUND_NAMES
declare -a FOUND_FPS
declare -a FOUND_VULKAN
declare -a SELECTED_INDEXES

FOUND_COUNT=0
OPTIMIZED_COUNT=0

# ==================== HIỂN THỊ LOGO ====================
clear
echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                          ║${NC}"
echo -e "${CYAN}║     🤖 AUTO GAME DETECTOR & SELECTOR v2.0                ║${NC}"
echo -e "${CYAN}║     Quét game đã cài - Tự chọn game cần tối ưu          ║${NC}"
echo -e "${CYAN}║                                                          ║${NC}"
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

# ==================== KIỂM TRA FILE DATABASE ====================
if [ ! -f "$GAME_LIST" ]; then
    echo -e "${RED}[✗] Không tìm thấy file game_list_complete.txt${NC}"
    exit 1
fi

# ==================== QUÉT GAME ĐÃ CÀI ====================
echo -e "${YELLOW}[*] Đang quét ứng dụng đã cài trên điện thoại...${NC}"

INSTALLED_PACKAGES=$(adb shell pm list packages 2>/dev/null | cut -d: -f2)

echo -e "${YELLOW}[*] Đang đối chiếu với database game...${NC}"
echo ""

# Tìm game đã cài
while IFS='|' read -r pkg name fps vulkan category; do
    [[ "$pkg" =~ ^#.* ]] && continue
    [[ "$pkg" =~ ^=.* ]] && continue
    [ -z "$pkg" ] && continue
    
    if echo "$INSTALLED_PACKAGES" | grep -q "^$pkg$"; then
        FOUND_PKGS+=("$pkg")
        FOUND_NAMES+=("$name")
        FOUND_FPS+=("$fps")
        FOUND_VULKAN+=("$vulkan")
        FOUND_COUNT=$((FOUND_COUNT + 1))
    fi
done < "$GAME_LIST"

# ==================== KIỂM TRA CÓ GAME NÀO KHÔNG ====================
if [ $FOUND_COUNT -eq 0 ]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${RED}KHÔNG TÌM THẤY GAME NÀO TRONG DATABASE!${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${CYAN}Bạn có thể:${NC}"
    echo -e "  1. Cài thêm game từ Play Store"
    echo -e "  2. Dùng option 'Custom Package' trong menu Game-Specific"
    echo -e "  3. Cập nhật database game trong data/game_list_complete.txt"
    echo ""
    read -p "Press Enter to continue..."
    exit 0
fi

# ==================== HIỂN THỊ DANH SÁCH GAME TÌM THẤY ====================
echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     📋 DANH SÁCH GAME TÌM THẤY TRÊN MÁY                 ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e " ${BOLD}Tìm thấy ${GREEN}$FOUND_COUNT${NC} game trong database:${NC}"
echo ""

# Hiển thị danh sách game
for i in $(seq 0 $((FOUND_COUNT - 1))); do
    NUM=$((i + 1))
    printf " ${CYAN}%2d${NC}) ${WHITE}%-35s${NC}" "$NUM" "${FOUND_NAMES[$i]}"
    printf " ${YELLOW}%s FPS${NC}" "${FOUND_FPS[$i]}"
    if [ "${FOUND_VULKAN[$i]}" = "Yes" ]; then
        printf " ${GREEN}[Vulkan]${NC}"
    else
        printf " ${YELLOW}[ANGLE]${NC}"
    fi
    echo ""
    printf "     ${CYAN}%s${NC}\n" "${FOUND_PKGS[$i]}"
    echo ""
done

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ==================== HƯỚNG DẪN CHỌN ====================
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║     📝 HƯỚNG DẪN CHỌN GAME                              ║${NC}"
echo -e "${YELLOW}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${YELLOW}║${NC}  Nhập số thứ tự game bạn muốn tối ưu                  ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}  Có thể chọn nhiều game cùng lúc                       ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}                                                          ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}  Ví dụ:                                                  ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}    ${GREEN}1 3 5${NC}        → Chọn game số 1, 3, 5              ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}    ${GREEN}1-5${NC}          → Chọn game từ 1 đến 5             ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}    ${GREEN}all${NC}          → Chọn TẤT CẢ game                 ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}    ${GREEN}vulkan${NC}       → Chỉ chọn game hỗ trợ Vulkan     ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}    ${GREEN}angle${NC}        → Chỉ chọn game cần ANGLE          ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}    ${GREEN}skip${NC}         → Không tối ưu game nào (thoát)    ${YELLOW}║${NC}"
echo -e "${YELLOW}║${NC}    ${GREEN}?${NC}            → Xem lại danh sách                ${YELLOW}║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# ==================== HÀM XỬ LÝ LỰA CHỌN ====================
parse_selection() {
    local input=$1
    local -a result=()
    
    # Xử lý "all"
    if [ "$input" = "all" ] || [ "$input" = "ALL" ]; then
        seq 1 $FOUND_COUNT
        return
    fi
    
    # Xử lý "vulkan"
    if [ "$input" = "vulkan" ] || [ "$input" = "VULKAN" ]; then
        for i in $(seq 0 $((FOUND_COUNT - 1))); do
            [ "${FOUND_VULKAN[$i]}" = "Yes" ] && echo $((i + 1))
        done
        return
    fi
    
    # Xử lý "angle"
    if [ "$input" = "angle" ] || [ "$input" = "ANGLE" ]; then
        for i in $(seq 0 $((FOUND_COUNT - 1))); do
            [ "${FOUND_VULKAN[$i]}" != "Yes" ] && echo $((i + 1))
        done
        return
    fi
    
    # Xử lý các lựa chọn khác
    for part in $input; do
        if [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            # Dạng 1-5
            start=${BASH_REMATCH[1]}
            end=${BASH_REMATCH[2]}
            if [ $start -le $end ] && [ $end -le $FOUND_COUNT ]; then
                seq $start $end
            fi
        elif [[ "$part" =~ ^[0-9]+$ ]]; then
            # Dạng số đơn
            if [ "$part" -ge 1 ] && [ "$part" -le $FOUND_COUNT ]; then
                echo "$part"
            fi
        fi
    done
}

# ==================== VÒNG LẶP CHỌN GAME ====================
while true; do
    read -p "🎮 Chọn game (hoặc '?' để xem lại danh sách): " user_input
    
    case "$user_input" in
        "?")
            # Hiển thị lại danh sách
            echo ""
            for i in $(seq 0 $((FOUND_COUNT - 1))); do
                NUM=$((i + 1))
                if [[ " ${SELECTED_INDEXES[*]} " =~ " $NUM " ]]; then
                    echo -e " ${GREEN}[✓]${NC} $NUM. ${FOUND_NAMES[$i]} (${FOUND_PKGS[$i]})"
                else
                    echo -e "     $NUM. ${FOUND_NAMES[$i]} (${FOUND_PKGS[$i]})"
                fi
            done
            echo ""
            continue
            ;;
        "skip"|"SKIP"|"")
            if [ ${#SELECTED_INDEXES[@]} -eq 0 ]; then
                echo -e "${YELLOW}[!] Chưa chọn game nào. Thoát...${NC}"
                exit 0
            fi
            break
            ;;
        *)
            # Parse lựa chọn
            SELECTED_INDEXES=($(parse_selection "$user_input" | sort -nu))
            
            if [ ${#SELECTED_INDEXES[@]} -eq 0 ]; then
                echo -e "${RED}[✗] Lựa chọn không hợp lệ. Thử lại.${NC}"
                continue
            fi
            
            # Hiển thị game đã chọn
            echo ""
            echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e " ${BOLD}GAME ĐÃ CHỌN (${#SELECTED_INDEXES[@]} game):${NC}"
            echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            
            for idx in "${SELECTED_INDEXES[@]}"; do
                i=$((idx - 1))
                echo -e " ${GREEN}✓${NC} ${WHITE}${FOUND_NAMES[$i]}${NC}"
                echo -e "   ${CYAN}${FOUND_PKGS[$i]}${NC} | ${YELLOW}${FOUND_FPS[$i]} FPS${NC} | ${MAGENTA}Vulkan: ${FOUND_VULKAN[$i]}${NC}"
            done
            echo ""
            
            # Xác nhận
            read -p "Xác nhận tối ưu các game này? (y/n/sửa): " confirm
            
            case "$confirm" in
                "y"|"Y"|"yes"|"YES")
                    break
                    ;;
                "sửa"|"sua"|"edit"|"EDIT")
                    SELECTED_INDEXES=()
                    echo -e "${YELLOW}[*] Chọn lại...${NC}"
                    echo ""
                    continue
                    ;;
                *)
                    echo -e "${YELLOW}[!] Đã hủy.${NC}"
                    exit 0
                    ;;
            esac
            ;;
    esac
done

# ==================== BACKUP TRƯỚC KHI TỐI ƯU ====================
echo ""
echo -e "${YELLOW}[?] Backup cài đặt game trước khi tối ưu?${NC}"
echo -e "    ${GREEN}1${NC}) Có - Backup trước"
echo -e "    ${GREEN}2${NC}) Không - Tối ưu luôn"
read -p "    Chọn [1-2]: " backup_choice

if [ "$backup_choice" = "1" ]; then
    mkdir -p "$BACKUP_DIR"
    BACKUP_FILE="$BACKUP_DIR/game_settings_$(date +%Y%m%d_%H%M%S).txt"
    
    echo "# HyperBoost Game Settings Backup" > "$BACKUP_FILE"
    echo "# Date: $(date)" >> "$BACKUP_FILE"
    echo "# Device: $DEVICE_MODEL" >> "$BACKUP_FILE"
    echo "" >> "$BACKUP_FILE"
    
    echo "=== VULKAN_SETTINGS ===" >> "$BACKUP_FILE"
    adb shell settings list global 2>/dev/null | grep "_vulkan_enabled" >> "$BACKUP_FILE"
    
    echo "=== FPS_SETTINGS ===" >> "$BACKUP_FILE"
    adb shell settings list global 2>/dev/null | grep "_max_fps" >> "$BACKUP_FILE"
    
    echo "=== ANGLE_SETTINGS ===" >> "$BACKUP_FILE"
    adb shell settings get global angle_enabled 2>/dev/null >> "$BACKUP_FILE"
    adb shell settings get global angle_gl_driver_selection_pkgs 2>/dev/null >> "$BACKUP_FILE"
    
    echo -e "${GREEN}[✓] Đã backup vào: $BACKUP_FILE${NC}"
fi

# ==================== TỐI ƯU GAME ĐÃ CHỌN ====================
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${BOLD}ĐANG TỐI ƯU ${#SELECTED_INDEXES[@]} GAME...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

VULKAN_COUNT=0
ANGLE_COUNT=0
ANGLE_LIST=""

for idx in "${SELECTED_INDEXES[@]}"; do
    i=$((idx - 1))
    pkg="${FOUND_PKGS[$i]}"
    name="${FOUND_NAMES[$i]}"
    fps="${FOUND_FPS[$i]}"
    vulkan="${FOUND_VULKAN[$i]}"
    
    echo -e "${GREEN}[${OPTIMIZED_COUNT}]${NC} ${BOLD}$name${NC}"
    
    # Set FPS
    adb shell settings put global "${pkg}_max_fps" "$fps" 2>/dev/null
    adb shell settings put system "${pkg}_frame_rate" "$fps" 2>/dev/null
    echo -e "    ${GREEN}✓${NC} FPS: $fps"
    
    # Whitelist battery
    adb shell dumpsys deviceidle whitelist +"$pkg" 2>/dev/null
    echo -e "    ${GREEN}✓${NC} Battery optimization: OFF"
    
    # Vulkan hoặc ANGLE
    if [ "$vulkan" = "Yes" ]; then
        adb shell settings put global "${pkg}_vulkan_enabled" 1 2>/dev/null
        echo -e "    ${GREEN}✓${NC} Vulkan Native: BẬT"
        VULKAN_COUNT=$((VULKAN_COUNT + 1))
    else
        ANGLE_LIST="${ANGLE_LIST}${pkg};"
        echo -e "    ${YELLOW}→${NC} ANGLE: Sẽ cấu hình sau"
        ANGLE_COUNT=$((ANGLE_COUNT + 1))
    fi
    
    # GPU render
    adb shell settings put global "${pkg}_gpu_render" 1 2>/dev/null
    
    OPTIMIZED_COUNT=$((OPTIMIZED_COUNT + 1))
    echo ""
done

# ==================== CẤU HÌNH ANGLE ====================
if [ -n "$ANGLE_LIST" ]; then
    ANGLE_LIST=${ANGLE_LIST%;}
    ANGLE_VALUES=""
    for i in $(seq 1 $ANGLE_COUNT); do
        ANGLE_VALUES="${ANGLE_VALUES}angle;"
    done
    ANGLE_VALUES=${ANGLE_VALUES%;}
    
    echo -e "${CYAN}[*] Cấu hình ANGLE cho $ANGLE_COUNT game...${NC}"
    adb shell settings put global angle_enabled 1 2>/dev/null
    adb shell settings put global show_angle_gl_driver 1 2>/dev/null
    adb shell settings put global angle_gl_driver_selection_pkgs "$ANGLE_LIST" 2>/dev/null
    adb shell settings put global angle_gl_driver_selection_values "$ANGLE_VALUES" 2>/dev/null
    echo -e "${GREEN}  ✓ ANGLE đã sẵn sàng!${NC}"
    echo ""
fi

# ==================== TỔNG KẾT ====================
echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    📊 TỔNG KẾT                           ║${NC}"
echo -e "${GREEN}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║${NC}  Game tìm thấy:         ${CYAN}$FOUND_COUNT${NC}"
echo -e "${GREEN}║${NC}  Game đã chọn:          ${YELLOW}${#SELECTED_INDEXES[@]}${NC}"
echo -e "${GREEN}║${NC}  Game đã tối ưu:        ${GREEN}$OPTIMIZED_COUNT${NC}"
echo -e "${GREEN}║${NC}  Vulkan Native:          ${GREEN}$VULKAN_COUNT${NC}"
echo -e "${GREEN}║${NC}  ANGLE:                  ${GREEN}$ANGLE_COUNT${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}[✓] Tối ưu hoàn tất! Vào game test FPS ngay!${NC}"
echo -e "${YELLOW}[!] Mở game: adb shell monkey -p <package> 1${NC}"
echo -e "${YELLOW}[!] Xem FPS: adb shell dumpsys gfxinfo <package>${NC}"
echo ""