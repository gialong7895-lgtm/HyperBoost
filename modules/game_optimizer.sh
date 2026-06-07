#!/bin/bash
# =====================================================================
# HYPERBOOST - GAME OPTIMIZER
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
echo -e "${CYAN}[*] Running game optimization suite...${NC}"
bash "$(dirname "$0")/force_120fps_all.sh" 2>/dev/null
bash "$(dirname "$0")/enable_vulkan_all.sh" 2>/dev/null
bash "$(dirname "$0")/tweak_gpu_rendering.sh" 2>/dev/null
bash "$(dirname "$0")/boost_network.sh" 2>/dev/null
echo -e "${GREEN}[✓] All game optimizations applied!${NC}"