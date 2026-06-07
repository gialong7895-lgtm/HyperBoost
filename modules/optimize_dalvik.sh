#!/bin/bash
# =====================================================================
# HYPERBOOST - DALVIK OPTIMIZER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}[*] Optimizing Dalvik/ART...${NC}"
adb shell "su -c 'rm -rf /data/dalvik-cache/*'" 2>/dev/null
adb shell cmd package compile -m speed -f -a 2>/dev/null
echo -e "${GREEN}[✓] Dalvik cache optimized!${NC}"
echo -e "${YELLOW}[!] First boot may take longer${NC}"