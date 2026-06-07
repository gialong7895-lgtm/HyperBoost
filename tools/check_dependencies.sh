#!/bin/bash
# =====================================================================
# HYPERBOOST DEPENDENCY CHECKER
# Checks if all required packages are installed
# =====================================================================

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'

MISSING=0

check_cmd() {
    if command -v "$1" &>/dev/null; then
        echo -e " ${GREEN}[✓]${NC} $1 found"
    else
        echo -e " ${RED}[✗]${NC} $1 NOT FOUND"
        MISSING=$((MISSING+1))
    fi
}

echo "Checking dependencies..."
echo ""

check_cmd adb
check_cmd python3
check_cmd python
check_cmd git
check_cmd curl
check_cmd wget
check_cmd unzip
check_cmd grep
check_cmd sed
check_cmd awk

echo ""
if [ $MISSING -gt 0 ]; then
    echo -e "${RED}[!] $MISSING dependencies missing.${NC}"
    echo -e "${YELLOW}Run tools/dependency_installer.sh to install them.${NC}"
    exit 1
else
    echo -e "${GREEN}[✓] All dependencies satisfied!${NC}"
    exit 0
fi