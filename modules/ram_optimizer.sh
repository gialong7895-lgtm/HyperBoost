#!/bin/bash
# =====================================================================
# HYPERBOOST - RAM OPTIMIZER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Optimizing RAM...${NC}"
adb shell settings put global activity_manager_constants "max_cached_processes=32" 2>/dev/null
adb shell settings put global always_finish_activities 1 2>/dev/null
adb shell "su -c 'echo 1 > /proc/sys/vm/overcommit_memory'" 2>/dev/null
adb shell "su -c 'echo 100 > /proc/sys/vm/overcommit_ratio'" 2>/dev/null
adb shell "su -c 'echo 0 > /proc/sys/vm/oom_kill_allocating_task'" 2>/dev/null
echo -e "${GREEN}[✓] RAM optimized!${NC}"