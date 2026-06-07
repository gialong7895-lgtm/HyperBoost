# Brick Recovery Guide

## Soft Brick (Boot Loop)
1. Boot into Recovery (Power + Volume Down)
2. Wipe cache partition
3. Reboot

## Hard Brick (No Power)
1. Use EDL mode (Qualcomm) or SP Flash Tool (MTK)
2. Flash stock ROM

## ADB Recovery
```bash
adb reboot recovery
# Then wipe cache