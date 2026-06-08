#!/bin/bash
# =====================================================================
# HYPERBOOST v1.1 - MINI BENCHMARK
# Chấm điểm hiệu năng điện thoại
# =====================================================================

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'
RED='\033[0;31m'; BLUE='\033[0;34m'; MAGENTA='\033[0;35m'
WHITE='\033[1;37m'; BOLD='\033[1m'; NC='\033[0m'

SCORE_CPU=0; SCORE_GPU=0; SCORE_RAM=0; SCORE_STORAGE=0; SCORE_NETWORK=0
TOTAL_SCORE=0

clear
echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║          📊 HYPERBOOST MINI BENCHMARK v1.1               ║${NC}"
echo -e "${CYAN}║          Chấm điểm hiệu năng thiết bị                    ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# ==================== CPU BENCHMARK ====================
echo -e "${YELLOW}[1/5] CPU Benchmark...${NC}"
CPU_CORES=$(adb shell cat /proc/cpuinfo 2>/dev/null | grep -c processor)
CPU_MAX_FREQ=$(adb shell cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq 2>/dev/null)
CPU_MIN_FREQ=$(adb shell cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq 2>/dev/null)

if [ -n "$CPU_MAX_FREQ" ]; then
    CPU_FREQ_MHZ=$((CPU_MAX_FREQ / 1000))
else
    CPU_FREQ_MHZ=0
fi

echo -e "  Cores: ${GREEN}$CPU_CORES${NC}"
echo -e "  Max Freq: ${GREEN}${CPU_FREQ_MHZ} MHz${NC}"

# Tính điểm CPU
if [ $CPU_CORES -ge 8 ]; then SCORE_CPU=$((SCORE_CPU + 30))
elif [ $CPU_CORES -ge 6 ]; then SCORE_CPU=$((SCORE_CPU + 20))
else SCORE_CPU=$((SCORE_CPU + 10)); fi

if [ $CPU_FREQ_MHZ -ge 3000 ]; then SCORE_CPU=$((SCORE_CPU + 30))
elif [ $CPU_FREQ_MHZ -ge 2500 ]; then SCORE_CPU=$((SCORE_CPU + 25))
elif [ $CPU_FREQ_MHZ -ge 2000 ]; then SCORE_CPU=$((SCORE_CPU + 20))
elif [ $CPU_FREQ_MHZ -ge 1500 ]; then SCORE_CPU=$((SCORE_CPU + 10))
else SCORE_CPU=$((SCORE_CPU + 5)); fi

echo -e "  ${CYAN}CPU Score: ${GREEN}$SCORE_CPU/60${NC}"
echo ""

# ==================== GPU BENCHMARK ====================
echo -e "${YELLOW}[2/5] GPU Benchmark...${NC}"
GPU_RENDERER=$(adb shell getprop debug.hwui.renderer 2>/dev/null)
VULKAN_SUPPORT=$(adb shell getprop ro.hardware.vulkan 2>/dev/null)
GPU_MAX_FREQ=$(adb shell cat /sys/class/kgsl/kgsl-3d0/max_gpuclk 2>/dev/null || echo 0)

if [ -n "$GPU_MAX_FREQ" ] && [ "$GPU_MAX_FREQ" -gt 0 ]; then
    GPU_FREQ_MHZ=$((GPU_MAX_FREQ / 1000000))
else
    GPU_FREQ_MHZ=0
fi

echo -e "  GPU Max Freq: ${GREEN}${GPU_FREQ_MHZ} MHz${NC}"
echo -e "  Vulkan: ${GREEN}$VULKAN_SUPPORT${NC}"

# Tính điểm GPU
if [ $GPU_FREQ_MHZ -ge 1000 ]; then SCORE_GPU=$((SCORE_GPU + 30))
elif [ $GPU_FREQ_MHZ -ge 800 ]; then SCORE_GPU=$((SCORE_GPU + 25))
elif [ $GPU_FREQ_MHZ -ge 600 ]; then SCORE_GPU=$((SCORE_GPU + 20))
elif [ $GPU_FREQ_MHZ -ge 400 ]; then SCORE_GPU=$((SCORE_GPU + 10))
else SCORE_GPU=$((SCORE_GPU + 5)); fi

if [ "$VULKAN_SUPPORT" = "1" ]; then SCORE_GPU=$((SCORE_GPU + 10)); fi

echo -e "  ${CYAN}GPU Score: ${GREEN}$SCORE_GPU/40${NC}"
echo ""

# ==================== RAM BENCHMARK ====================
echo -e "${YELLOW}[3/5] RAM Benchmark...${NC}"
RAM_TOTAL=$(adb shell cat /proc/meminfo 2>/dev/null | grep MemTotal | awk '{print $2}')
RAM_FREE=$(adb shell cat /proc/meminfo 2>/dev/null | grep MemAvailable | awk '{print $2}')

if [ -n "$RAM_TOTAL" ]; then
    RAM_TOTAL_MB=$((RAM_TOTAL / 1024))
    RAM_FREE_MB=$((RAM_FREE / 1024))
    RAM_USED_PERCENT=$((100 - (RAM_FREE * 100 / RAM_TOTAL)))
else
    RAM_TOTAL_MB=0; RAM_FREE_MB=0; RAM_USED_PERCENT=0
fi

echo -e "  Total RAM: ${GREEN}${RAM_TOTAL_MB} MB${NC}"
echo -e "  Available: ${GREEN}${RAM_FREE_MB} MB${NC}"
echo -e "  Used: ${YELLOW}${RAM_USED_PERCENT}%${NC}"

# Tính điểm RAM
if [ $RAM_TOTAL_MB -ge 12000 ]; then SCORE_RAM=$((SCORE_RAM + 30))
elif [ $RAM_TOTAL_MB -ge 8000 ]; then SCORE_RAM=$((SCORE_RAM + 25))
elif [ $RAM_TOTAL_MB -ge 6000 ]; then SCORE_RAM=$((SCORE_RAM + 20))
elif [ $RAM_TOTAL_MB -ge 4000 ]; then SCORE_RAM=$((SCORE_RAM + 15))
else SCORE_RAM=$((SCORE_RAM + 10)); fi

echo -e "  ${CYAN}RAM Score: ${GREEN}$SCORE_RAM/30${NC}"
echo ""

# ==================== STORAGE BENCHMARK ====================
echo -e "${YELLOW}[4/5] Storage Benchmark...${NC}"
STORAGE_TOTAL=$(adb shell df /data 2>/dev/null | tail -1 | awk '{print $2}')
STORAGE_FREE=$(adb shell df /data 2>/dev/null | tail -1 | awk '{print $4}')

if [ -n "$STORAGE_TOTAL" ]; then
    STORAGE_TOTAL_GB=$((STORAGE_TOTAL / 1024 / 1024))
    STORAGE_FREE_GB=$((STORAGE_FREE / 1024 / 1024))
else
    STORAGE_TOTAL_GB=0; STORAGE_FREE_GB=0
fi

echo -e "  Total Storage: ${GREEN}${STORAGE_TOTAL_GB} GB${NC}"
echo -e "  Free: ${GREEN}${STORAGE_FREE_GB} GB${NC}"

# Test tốc độ ghi
echo -e "  ${YELLOW}[*] Testing write speed...${NC}"
WRITE_SPEED=$(adb shell "dd if=/dev/zero of=/data/local/tmp/test_hyperboost bs=1M count=50 2>&1" 2>/dev/null | grep -o "[0-9.]* MB/s" | head -1)
adb shell rm -f /data/local/tmp/test_hyperboost 2>/dev/null
echo -e "  Write Speed: ${GREEN}${WRITE_SPEED:-N/A}${NC}"

# Tính điểm Storage
if [ $STORAGE_TOTAL_GB -ge 256 ]; then SCORE_STORAGE=$((SCORE_STORAGE + 25))
elif [ $STORAGE_TOTAL_GB -ge 128 ]; then SCORE_STORAGE=$((SCORE_STORAGE + 20))
elif [ $STORAGE_TOTAL_GB -ge 64 ]; then SCORE_STORAGE=$((SCORE_STORAGE + 15))
else SCORE_STORAGE=$((SCORE_STORAGE + 10)); fi

echo -e "  ${CYAN}Storage Score: ${GREEN}$SCORE_STORAGE/25${NC}"
echo ""

# ==================== NETWORK BENCHMARK ====================
echo -e "${YELLOW}[5/5] Network Benchmark...${NC}"

# Test ping
echo -e "  ${YELLOW}[*] Testing ping to 8.8.8.8...${NC}"
PING_RESULT=$(adb shell "ping -c 3 -W 2 8.8.8.8 2>/dev/null" | grep "avg" | awk -F/ '{print $4}' | cut -d. -f1)
echo -e "  Ping: ${GREEN}${PING_RESULT:-N/A} ms${NC}"

# Tính điểm Network
if [ -n "$PING_RESULT" ]; then
    if [ "$PING_RESULT" -le 30 ]; then SCORE_NETWORK=$((SCORE_NETWORK + 20))
    elif [ "$PING_RESULT" -le 60 ]; then SCORE_NETWORK=$((SCORE_NETWORK + 15))
    elif [ "$PING_RESULT" -le 100 ]; then SCORE_NETWORK=$((SCORE_NETWORK + 10))
    else SCORE_NETWORK=$((SCORE_NETWORK + 5)); fi
else
    SCORE_NETWORK=10
fi

echo -e "  ${CYAN}Network Score: ${GREEN}$SCORE_NETWORK/20${NC}"
echo ""

# ==================== TỔNG KẾT ====================
TOTAL_SCORE=$((SCORE_CPU + SCORE_GPU + SCORE_RAM + SCORE_STORAGE + SCORE_NETWORK))
MAX_SCORE=175

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    📊 TỔNG ĐIỂM                          ║${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC}  CPU:     ${GREEN}$SCORE_CPU/60${NC}"
echo -e "${BLUE}║${NC}  GPU:     ${GREEN}$SCORE_GPU/40${NC}"
echo -e "${BLUE}║${NC}  RAM:     ${GREEN}$SCORE_RAM/30${NC}"
echo -e "${BLUE}║${NC}  Storage: ${GREEN}$SCORE_STORAGE/25${NC}"
echo -e "${BLUE}║${NC}  Network: ${GREEN}$SCORE_NETWORK/20${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣"

# Đánh giá tổng
PERCENT=$((TOTAL_SCORE * 100 / MAX_SCORE))
echo -e "${BLUE}║${NC}  ${BOLD}TOTAL: ${GREEN}$TOTAL_SCORE/$MAX_SCORE${NC} (${GREEN}${PERCENT}%${NC})"

# Xếp hạng
if [ $PERCENT -ge 90 ]; then RANK="${GREEN}★★★★★ XUẤT SẮC - Flagship${NC}"
elif [ $PERCENT -ge 70 ]; then RANK="${CYAN}★★★★☆ TỐT - High-End${NC}"
elif [ $PERCENT -ge 50 ]; then RANK="${YELLOW}★★★☆☆ KHÁ - Mid-Range${NC}"
elif [ $PERCENT -ge 30 ]; then RANK="${MAGENTA}★★☆☆☆ TRUNG BÌNH - Entry Level${NC}"
else RANK="${RED}★☆☆☆☆ THẤP - Cần nâng cấp${NC}"; fi

echo -e "${BLUE}║${NC}  Rating: $RANK"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}[✓] Benchmark hoàn tất!${NC}"