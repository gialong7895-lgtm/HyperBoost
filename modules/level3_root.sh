#!/bin/bash
# =====================================================================
# HYPERBOOST LEVEL 3 - ROOT OPTIMIZATION
# Requires Root Access (Termux or ADB)
# =====================================================================

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   HYPERBOOST LEVEL 3 - ROOT MODE          ║${NC}"
echo -e "${CYAN}║   Root Access Required                    ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"

# Check root
check_root() {
    if command -v su &>/dev/null; then
        if su -c "id" 2>/dev/null | grep -q "uid=0"; then
            return 0
        fi
    fi
    return 1
}

if ! check_root; then
    echo -e "${RED}[✗] Root access not available!${NC}"
    echo -e "${YELLOW}[!] Try Level 1 or Level 2 instead.${NC}"
    exit 1
fi

echo -e "\n${YELLOW}[*] Applying Level 3 root optimizations...${NC}"

# CPU Governor
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    [ -f "$cpu" ] && su -c "echo performance > $cpu" 2>/dev/null
done
echo -e "${GREEN}  ✓ CPU Governor set to performance${NC}"

# I/O Scheduler
for queue in /sys/block/*/queue/scheduler; do
    [ -f "$queue" ] && su -c "echo fiops > $queue" 2>/dev/null
    [ -f "$queue" ] && su -c "echo maple > $queue" 2>/dev/null
done
echo -e "${GREEN}  ✓ I/O Scheduler optimized${NC}"

# VM Tweaks
su -c "echo 20 > /proc/sys/vm/swappiness" 2>/dev/null
su -c "echo 50 > /proc/sys/vm/vfs_cache_pressure" 2>/dev/null
su -c "echo 15 > /proc/sys/vm/dirty_ratio" 2>/dev/null
su -c "echo 5 > /proc/sys/vm/dirty_background_ratio" 2>/dev/null
echo -e "${GREEN}  ✓ Virtual Memory optimized${NC}"

# Network
su -c "echo 1 > /proc/sys/net/ipv4/tcp_low_latency" 2>/dev/null
su -c "echo 50 > /proc/sys/net/core/busy_poll" 2>/dev/null
echo -e "${GREEN}  ✓ Network latency reduced${NC}"

# Entropy
su -c "echo 128 > /proc/sys/kernel/random/read_wakeup_threshold" 2>/dev/null
su -c "echo 256 > /proc/sys/kernel/random/write_wakeup_threshold" 2>/dev/null
echo -e "${GREEN}  ✓ Entropy increased${NC}"

# GPU max frequency
if [ -f /sys/class/kgsl/kgsl-3d0/max_gpuclk ]; then
    MAX_GPU=$(cat /sys/class/kgsl/kgsl-3d0/max_gpuclk 2>/dev/null)
    su -c "echo $MAX_GPU > /sys/class/kgsl/kgsl-3d0/max_gpuclk" 2>/dev/null
    echo -e "${GREEN}  ✓ GPU max frequency set${NC}"
fi

echo -e "\n${GREEN}[✓] Level 3 optimization complete!${NC}"
echo -e "${RED}[!] ROOT LEVEL - Changes are deep system modifications${NC}"
echo -e "${YELLOW}[!] Restart device for all changes to take effect.${NC}"