#!/bin/bash
# =====================================================================
# HYPERBOOST - KERNEL TUNER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
echo -e "${YELLOW}[*] Tuning kernel parameters...${NC}"

# CPU Governor
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    adb shell "su -c 'echo performance > $cpu'" 2>/dev/null
done
echo -e "${GREEN}  ✓ CPU Governor: performance${NC}"

# I/O Scheduler
for queue in /sys/block/*/queue/scheduler; do
    adb shell "su -c 'echo fiops > $queue'" 2>/dev/null
    adb shell "su -c 'echo maple > $queue'" 2>/dev/null
done
echo -e "${GREEN}  ✓ I/O Scheduler: fiops${NC}"

# VM Tweaks
adb shell "su -c 'echo 20 > /proc/sys/vm/swappiness'" 2>/dev/null
adb shell "su -c 'echo 50 > /proc/sys/vm/vfs_cache_pressure'" 2>/dev/null
adb shell "su -c 'echo 15 > /proc/sys/vm/dirty_ratio'" 2>/dev/null
echo -e "${GREEN}  ✓ VM parameters tuned${NC}"

# Network
adb shell "su -c 'echo 1 > /proc/sys/net/ipv4/tcp_low_latency'" 2>/dev/null
echo -e "${GREEN}  ✓ Network latency reduced${NC}"

echo -e "${GREEN}[✓] Kernel tuning complete!${NC}"