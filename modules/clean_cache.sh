#!/bin/bash
# =====================================================================
# HYPERBOOST - CACHE CLEANER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
echo -e "${CYAN}[*] Cleaning system cache...${NC}"
adb shell pm trim-caches 999999999 2>/dev/null
echo -e "${GREEN}  ✓ App caches trimmed${NC}"
if adb shell "su -c 'rm -rf /data/dalvik-cache/*'" 2>/dev/null; then
    echo -e "${GREEN}  ✓ Dalvik cache cleaned${NC}"
fi
adb shell "rm -rf /data/local/tmp/*" 2>/dev/null
echo -e "${GREEN}  ✓ Temp files cleaned${NC}"
echo -e "${GREEN}[✓] Cache cleaning complete!${NC}"