# Animation
adb shell settings put global window_animation_scale 0.0

# GPU Render
adb shell settings put global force_gpu_rendering 1

# Performance Mode
adb shell cmd power set-fixed-performance-mode-enabled true
---

### **docs/FAQ.md**
```markdown
# Frequently Asked Questions

## Is HyperBoost safe?
Levels 1-2 are safe. Levels 3-5 require root and caution.

## Does it work without root?
Yes! Levels 1, 2, and 4 work without root.

## Will it drain battery?
Performance mode may increase battery consumption.

## How to restore?
Run `bash modules/backup_restore.sh --restore`

## Which games are supported?
100+ games listed in `data/game_list_complete.txt`