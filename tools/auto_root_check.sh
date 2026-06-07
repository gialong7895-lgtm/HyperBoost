#!/bin/bash
# =====================================================================
# HYPERBOOST - AUTO ROOT CHECKER
# Tự động phát hiện root qua nhiều phương thức
# =====================================================================
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

ROOT_STATUS=0
ROOT_METHOD=""

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     HYPERBOOST - ROOT DETECTOR            ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
echo ""

# Method 1: Check su binary in common locations
echo -e "${YELLOW}[*] Method 1: Checking su binary...${NC}"
SU_PATHS=("/system/bin/su" "/system/xbin/su" "/sbin/su" "/system/sbin/su" "/vendor/bin/su" "/data/local/su" "/su/bin/su")
for path in "${SU_PATHS[@]}"; do
    if adb shell "test -f $path" 2>/dev/null; then
        echo -e "  ${GREEN}✓ Found: $path${NC}"
        ROOT_STATUS=1
        ROOT_METHOD="su_binary"
    fi
done

# Method 2: Check via id command
echo -e "${YELLOW}[*] Method 2: Checking UID...${NC}"
if adb shell "su -c 'id'" 2>/dev/null | grep -q "uid=0"; then
    echo -e "  ${GREEN}✓ Root UID detected${NC}"
    ROOT_STATUS=1
    ROOT_METHOD="su_id"
elif adb shell "id" 2>/dev/null | grep -q "uid=0"; then
    echo -e "  ${GREEN}✓ Already running as root${NC}"
    ROOT_STATUS=1
    ROOT_METHOD="adb_root"
fi

# Method 3: Check Magisk
echo -e "${YELLOW}[*] Method 3: Checking Magisk...${NC}"
if adb shell "which magisk" 2>/dev/null | grep -q "magisk"; then
    echo -e "  ${GREEN}✓ Magisk detected${NC}"
    ROOT_STATUS=1
    ROOT_METHOD="magisk"
fi
if adb shell "pm list packages 2>/dev/null | grep -q com.topjohnwu.magisk"; then
    echo -e "  ${GREEN}✓ Magisk Manager installed${NC}"
    ROOT_STATUS=1
    [ -z "$ROOT_METHOD" ] && ROOT_METHOD="magisk_app"
fi

# Method 4: Check SuperSU
echo -e "${YELLOW}[*] Method 4: Checking SuperSU...${NC}"
if adb shell "pm list packages 2>/dev/null | grep -q eu.chainfire.supersu"; then
    echo -e "  ${GREEN}✓ SuperSU detected${NC}"
    ROOT_STATUS=1
    [ -z "$ROOT_METHOD" ] && ROOT_METHOD="supersu"
fi

# Method 5: Check /system mount
echo -e "${YELLOW}[*] Method 5: Checking system mount...${NC}"
MOUNT_OUTPUT=$(adb shell "mount 2>/dev/null | grep /system")
if echo "$MOUNT_OUTPUT" | grep -q "rw"; then
    echo -e "  ${GREEN}✓ System mounted as read-write${NC}"
    ROOT_STATUS=1
    [ -z "$ROOT_METHOD" ] && ROOT_METHOD="system_rw"
elif echo "$MOUNT_OUTPUT" | grep -q "ro"; then
    echo -e "  ${YELLOW}⊘ System mounted as read-only${NC}"
fi

# Method 6: Check BusyBox
echo -e "${YELLOW}[*] Method 6: Checking BusyBox...${NC}"
if adb shell "which busybox" 2>/dev/null | grep -q "busybox"; then
    echo -e "  ${GREEN}✓ BusyBox detected (often installed with root)${NC}"
    # BusyBox doesn't guarantee root but is a strong indicator
fi

# Method 7: Try accessing /data/data directly
echo -e "${YELLOW}[*] Method 7: Checking /data access...${NC}"
if adb shell "ls /data/data/com.android.settings 2>/dev/null" | grep -q "cache"; then
    echo -e "  ${GREEN}✓ Can access protected /data directories${NC}"
    ROOT_STATUS=1
    [ -z "$ROOT_METHOD" ] && ROOT_METHOD="data_access"
fi

# Method 8: Check SELinux status
echo -e "${YELLOW}[*] Method 8: Checking SELinux...${NC}"
SELINUX_STATUS=$(adb shell "getenforce 2>/dev/null")
if [ "$SELINUX_STATUS" = "Permissive" ]; then
    echo -e "  ${GREEN}✓ SELinux is Permissive (root likely)${NC}"
elif [ "$SELINUX_STATUS" = "Enforcing" ]; then
    echo -e "  ${YELLOW}⊘ SELinux is Enforcing${NC}"
fi

# Method 9: Check for KingRoot/KingoRoot
echo -e "${YELLOW}[*] Method 9: Checking alternative root apps...${NC}"
ALT_ROOT_APPS=("com.kingroot.kinguser" "com.kingo.root" "com.iroot" "com.oneclickroot" "com.dashi.dsroot")
for app in "${ALT_ROOT_APPS[@]}"; do
    if adb shell "pm list packages 2>/dev/null | grep -q $app"; then
        echo -e "  ${GREEN}✓ Alternative root app: $app${NC}"
        ROOT_STATUS=1
        [ -z "$ROOT_METHOD" ] && ROOT_METHOD="alt_root_app"
    fi
done

# Method 10: Local check (Termux)
if [ "$(uname -o 2>/dev/null)" = "Android" ]; then
    echo -e "${YELLOW}[*] Method 10: Local Termux check...${NC}"
    if command -v su &>/dev/null; then
        if su -c "id" 2>/dev/null | grep -q "uid=0"; then
            echo -e "  ${GREEN}✓ Local root access confirmed${NC}"
            ROOT_STATUS=1
            ROOT_METHOD="termux_local"
        fi
    fi
fi

# Final result
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [ $ROOT_STATUS -eq 1 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     ✓ ROOT DETECTED                       ║${NC}"
    echo -e "${GREEN}║     Method: $ROOT_METHOD$(printf '%*s' $((35 - ${#ROOT_METHOD})) '')║${NC}"
    echo -e "${GREEN}║     Device has ROOT access                ║${NC}"
    echo -e "${GREEN}║     Full optimization available           ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
    
    # Save result
    echo "ROOT_DETECTED=true" > /tmp/hyperboost_root_status 2>/dev/null
    echo "ROOT_METHOD=$ROOT_METHOD" >> /tmp/hyperboost_root_status 2>/dev/null
    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║     ✗ NO ROOT DETECTED                    ║${NC}"
    echo -e "${RED}║     Limited optimization available        ║${NC}"
    echo -e "${RED}║     Use Level 1, 2, or 4                  ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    
    # Save result
    echo "ROOT_DETECTED=false" > /tmp/hyperboost_root_status 2>/dev/null
    exit 1
fi
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"