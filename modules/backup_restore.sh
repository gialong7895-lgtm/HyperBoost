#!/bin/bash
# =====================================================================
# HYPERBOOST - BACKUP & RESTORE
# =====================================================================
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup/$(date +%Y%m%d_%H%M%S)"

backup() {
    echo -e "${BLUE}[*] Creating backup...${NC}"
    mkdir -p "$BACKUP_DIR"
    adb shell settings list global > "$BACKUP_DIR/global_settings.txt" 2>/dev/null
    adb shell settings list system > "$BACKUP_DIR/system_settings.txt" 2>/dev/null
    adb shell settings list secure > "$BACKUP_DIR/secure_settings.txt" 2>/dev/null
    adb shell pm list packages -d > "$BACKUP_DIR/disabled_packages.txt" 2>/dev/null
    adb shell getprop > "$BACKUP_DIR/build_props.txt" 2>/dev/null
    echo -e "${GREEN}[✓] Backup saved to: $BACKUP_DIR${NC}"
}

restore() {
    echo -e "${YELLOW}[*] Available backups:${NC}"
    select backup_folder in "$SCRIPT_DIR/backup/"*/; do
        if [ -d "$backup_folder" ]; then
            echo -e "${BLUE}[*] Restoring from $backup_folder...${NC}"
            while IFS= read -r line; do
                [ -z "$line" ] && continue
                key=$(echo "$line" | cut -d= -f1)
                val=$(echo "$line" | cut -d= -f2-)
                adb shell settings put global "$key" "$val" 2>/dev/null
            done < "$backup_folder/global_settings.txt"
            echo -e "${GREEN}[✓] Restore complete!${NC}"
            break
        fi
    done
}

case "${1:-}" in
    --backup) backup ;;
    --restore) restore ;;
    --interactive)
        echo "1) Backup"
        echo "2) Restore"
        read -p "Choose: " c
        [ "$c" = "1" ] && backup || restore
        ;;
    *) echo "Usage: $0 [--backup|--restore|--interactive]" ;;
esac