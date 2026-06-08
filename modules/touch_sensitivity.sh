#!/bin/bash
# =====================================================================
# HYPERBOOST v1.1 - TOUCH SENSITIVITY BOOSTER
# Tăng độ nhạy cảm ứng màn hình
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     TOUCH SENSITIVITY BOOSTER v1.1         ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}[*] Đang tối ưu cảm ứng...${NC}"

# Tăng tần số quét cảm ứng
adb shell settings put system touch_sensitivity 1 2>/dev/null
adb shell settings put system touch_screen_sensitivity 10 2>/dev/null
adb shell settings put secure touch_sensitivity 1 2>/dev/null

# Tăng tốc độ phản hồi touch
adb shell settings put system pointer_speed 7 2>/dev/null
adb shell settings put secure pointer_speed 7 2>/dev/null

# Touch sampling rate (nếu hỗ trợ)
adb shell settings put system touch_sampling_rate 360 2>/dev/null
adb shell settings put secure touch_sampling_rate 360 2>/dev/null

# Tap sensitivity
adb shell settings put system tap_duration_threshold 0.1 2>/dev/null
adb shell settings put system multi_tap_duration_threshold 0.3 2>/dev/null

# Game mode touch
adb shell settings put system game_touch_sensitivity 1 2>/dev/null
adb shell settings put global game_mode_touch_boost 1 2>/dev/null

# GPU render touch
adb shell settings put global force_gpu_rendering 1 2>/dev/null
adb shell setprop debug.sf.touchpressure 1 2>/dev/null
adb shell setprop persist.sys.touch.boost 1 2>/dev/null

echo -e "${GREEN}[✓] Độ nhạy màn hình đã được tối ưu!${NC}"
echo -e "${YELLOW}[!] Khởi động lại để cảm nhận rõ nhất${NC}"