#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}==================== GENIEACS LOGO REPLACER ==============================${NC}"
echo -e "${GREEN}============================================================================${NC}"

# Function to check if file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓ File found: $1${NC}"
        return 0
    else
        echo -e "${RED}✗ File not found: $1${NC}"
        return 1
    fi
}

# Function to backup current logo
backup_logo() {
    local backup_dir="/root/cvlgenieACS/logo-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    echo -e "${YELLOW}================== Backup Current Logo ==================${NC}"
    
    # Backup current logos
    if [ -f "/usr/lib/node_modules/genieacs/public/logo.svg" ]; then
        cp "/usr/lib/node_modules/genieacs/public/logo.svg" "$backup_dir/"
        echo -e "${GREEN}✓ Backed up logo.svg${NC}"
    fi
    
    if [ -f "/usr/lib/node_modules/genieacs/public/logo-3976e73d.svg" ]; then
        cp "/usr/lib/node_modules/genieacs/public/logo-3976e73d.svg" "$backup_dir/"
        echo -e "${GREEN}✓ Backed up logo-3976e73d.svg${NC}"
    fi
    
    echo -e "${GREEN}Backup tersimpan di: $backup_dir${NC}"
}

# Function to replace logo
replace_logo() {
    local new_logo="$1"
    
    if [ ! -f "$new_logo" ]; then
        echo -e "${RED}Error: File logo tidak ditemukan: $new_logo${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}================== Replace Logo ==================${NC}"
    
    # Copy new logo to GenieACS public directory
    cp "$new_logo" "/usr/lib/node_modules/genieacs/public/logo.svg"
    cp "$new_logo" "/usr/lib/node_modules/genieacs/public/logo-3976e73d.svg"
    
    # Set proper permissions
    chown root:root "/usr/lib/node_modules/genieacs/public/logo.svg"
    chown root:root "/usr/lib/node_modules/genieacs/public/logo-3976e73d.svg"
    
    echo -e "${GREEN}✓ Logo berhasil diganti${NC}"
}

# Function to restart GenieACS UI
restart_ui() {
    echo -e "${YELLOW}================== Restart GenieACS UI ==================${NC}"
    systemctl restart genieacs-ui
    sleep 5
    
    if systemctl is-active --quiet genieacs-ui; then
        echo -e "${GREEN}✓ GenieACS UI restarted successfully${NC}"
    else
        echo -e "${RED}✗ Failed to restart GenieACS UI${NC}"
        return 1
    fi
}

# Main script
echo -e "${BLUE}================== Current Logo Locations ==================${NC}"
echo -e "1. Repository logo: /root/cvlgenieACS/logo.svg"
echo -e "2. GenieACS logo: /usr/lib/node_modules/genieacs/public/logo.svg"
echo -e "3. GenieACS logo (hashed): /usr/lib/node_modules/genieacs/public/logo-3976e73d.svg"

echo -e "${BLUE}================== Current Logo Files ==================${NC}"
check_file "/root/cvlgenieACS/logo.svg"
check_file "/usr/lib/node_modules/genieacs/public/logo.svg"
check_file "/usr/lib/node_modules/genieacs/public/logo-3976e73d.svg"

echo -e "${BLUE}================== Logo Replacement Options ==================${NC}"
echo -e "${YELLOW}1. Ganti logo dengan file dari repository${NC}"
echo -e "${YELLOW}2. Ganti logo dengan file custom${NC}"
echo -e "${YELLOW}3. Restore logo dari backup${NC}"
echo -e "${YELLOW}4. Lihat informasi logo saat ini${NC}"
echo -e "${YELLOW}5. Keluar${NC}"

read -p "Pilih opsi (1-5): " choice

case $choice in
    1)
        echo -e "${GREEN}================== Menggunakan Logo dari Repository ==================${NC}"
        backup_logo
        replace_logo "/root/cvlgenieACS/logo.svg"
        restart_ui
        ;;
    2)
        echo -e "${GREEN}================== Menggunakan Logo Custom ==================${NC}"
        read -p "Masukkan path lengkap ke file logo baru: " custom_logo
        backup_logo
        replace_logo "$custom_logo"
        restart_ui
        ;;
    3)
        echo -e "${GREEN}================== Restore Logo dari Backup ==================${NC}"
        echo -e "${YELLOW}Backup directories yang tersedia:${NC}"
        ls -la /root/cvlgenieACS/logo-backup-* 2>/dev/null | head -10
        
        read -p "Masukkan path ke backup directory: " backup_path
        if [ -d "$backup_path" ]; then
            if [ -f "$backup_path/logo.svg" ]; then
                cp "$backup_path/logo.svg" "/usr/lib/node_modules/genieacs/public/logo.svg"
                echo -e "${GREEN}✓ Restored logo.svg${NC}"
            fi
            if [ -f "$backup_path/logo-3976e73d.svg" ]; then
                cp "$backup_path/logo-3976e73d.svg" "/usr/lib/node_modules/genieacs/public/logo-3976e73d.svg"
                echo -e "${GREEN}✓ Restored logo-3976e73d.svg${NC}"
            fi
            restart_ui
        else
            echo -e "${RED}Error: Backup directory tidak ditemukan${NC}"
        fi
        ;;
    4)
        echo -e "${GREEN}================== Informasi Logo Saat Ini ==================${NC}"
        echo -e "${YELLOW}Repository logo:${NC}"
        ls -la /root/cvlgenieACS/logo.svg 2>/dev/null
        
        echo -e "${YELLOW}GenieACS logo:${NC}"
        ls -la /usr/lib/node_modules/genieacs/public/logo.svg 2>/dev/null
        ls -la /usr/lib/node_modules/genieacs/public/logo-3976e73d.svg 2>/dev/null
        
        echo -e "${YELLOW}File size:${NC}"
        du -h /usr/lib/node_modules/genieacs/public/logo*.svg 2>/dev/null
        ;;
    5)
        echo -e "${GREEN}Keluar dari script.${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Opsi tidak valid.${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}=================== LOGO REPLACEMENT COMPLETE =================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}Logo telah berhasil diganti.${NC}"
echo -e "${GREEN}Silakan refresh browser untuk melihat perubahan logo.${NC}"
echo -e "${GREEN}============================================================================${NC}"
