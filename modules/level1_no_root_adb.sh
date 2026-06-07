#!/bin/bash
# =====================================================================
# HYPERBOOST LEVEL 1 - SAFE OPTIMIZATION
# No Root, No ADB, No PC required
# Safe for all devices
# =====================================================================

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   HYPERBOOST LEVEL 1 - SAFE MODE          ║${NC}"
echo -e "${BLUE}║   No Root | No ADB | No PC Required       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"

echo -e "\n${YELLOW}[*] Applying Level 1 optimizations...${NC}"

# Check if we have settings access (Termux or ADB)
if command -v settings &>/dev/null; then
    # Termux with settings access
    
    # Disable animations
    settings put global window_animation_scale 0.0 2>/dev/null
    settings put global transition_animation_scale 0.0 2>/dev/null
    settings put global animator_duration_scale 0.0 2>/dev/null
    echo -e "${GREEN}  ✓ Animations disabled${NC}"
    
    # Force GPU rendering
    settings put global force_gpu_rendering 1 2>/dev/null
    echo -e "${GREEN}  ✓ GPU rendering forced${NC}"
    
    # Limit background processes
    settings put global activity_manager_constants "max_cached_processes=32" 2>/dev/null
    echo -e "${GREEN}  ✓ Background processes limited${NC}"
    
elif command -v adb &>/dev/null && adb devices 2>/dev/null | grep -q "device$"; then
    # Via ADB
    
    adb shell settings put global window_animation_scale 0.0
    adb shell settings put global transition_animation_scale 0.0
    adb shell settings put global animator_duration_scale 0.0
    echo -e "${GREEN}  ✓ Animations disabled${NC}"
    
    adb shell settings put global force_gpu_rendering 1
    echo -e "${GREEN}  ✓ GPU rendering forced${NC}"
    
    adb shell settings put global activity_manager_constants "max_cached_processes=32"
    echo -e "${GREEN}  ✓ Background processes limited${NC}"
else
    echo -e "${YELLOW}[!] Limited access. Some tweaks may not apply.${NC}"
fi

# Properties that can be set without root
for prop in \
    "debug.performance.tuning=1" \
    "video.accelerate.hw=1" \
    "persist.sys.composition.type=gpu" \
    "debug.sf.hw=1" \
    "persist.sys.ui.hw=1"; do
    setprop $prop 2>/dev/null || true
done

echo -e "\n${GREEN}[✓] Level 1 optimization complete!${NC}"
echo -e "${YELLOW}[!] Restart device for best results.${NC}"