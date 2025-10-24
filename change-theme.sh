#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}==================== GENIEACS THEME CHANGER ==============================${NC}"
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

# Function to backup current CSS
backup_css() {
    local backup_dir="/root/cvlgenieACS/css-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    echo -e "${YELLOW}================== Backup Current CSS ==================${NC}"
    
    # Backup current CSS files
    if [ -f "/usr/lib/node_modules/genieacs/public/app-LU66VFYW.css" ]; then
        cp "/usr/lib/node_modules/genieacs/public/app-LU66VFYW.css" "$backup_dir/"
        echo -e "${GREEN}✓ Backed up app-LU66VFYW.css${NC}"
    fi
    
    echo -e "${GREEN}Backup tersimpan di: $backup_dir${NC}"
}

# Function to apply dark theme (like in the photo)
apply_dark_theme() {
    local css_file="/usr/lib/node_modules/genieacs/public/app-LU66VFYW.css"
    
    echo -e "${YELLOW}================== Apply Dark Theme ==================${NC}"
    
    # Create dark theme CSS modifications
    cat << 'EOF' > /tmp/dark_theme.css
/* Dark Theme Variables */
:root {
    --base-font-size: 13px;
    --base-line-height: 16px;
    --color1: #2c3e50;        /* Dark blue-gray borders */
    --color2: #34495e;        /* Darker blue-gray */
    --color3: #3a4a5c;        /* Hover background */
    --color4: #3498db;        /* Blue accent */
    --color5: #1a252f;        /* Very dark background */
    --fade: .2s;
    --disabled: #7f8c8d;
    --status-red: 0 80% 80%;
    --status-green: 125 80% 80%;
    --status-gray: 58 3% 80%;
    --status-yellow: 46 79% 80%
}

/* Dark background for body */
body {
    background-color: #1a252f !important;
    color: #ecf0f1 !important;
}

/* Dark header */
#header {
    background-color: #2c3e50 !important;
    border-bottom: 1px solid #34495e !important;
}

/* Dark navigation */
#header>nav>ul>li {
    background-color: #2c3e50 !important;
    border-right: 1px solid #34495e !important;
}

#header>nav>ul>li:is(.active, :hover) {
    background-color: #34495e !important;
}

/* Dark content wrapper */
#content-wrapper {
    background-color: #1a252f !important;
}

/* Dark tables */
table.table {
    background-color: #2c3e50 !important;
    color: #ecf0f1 !important;
}

table.table th {
    background-color: #34495e !important;
    color: #ecf0f1 !important;
    border-bottom: 1px solid #34495e !important;
}

table.table td {
    background-color: #2c3e50 !important;
    color: #ecf0f1 !important;
    border-bottom: 1px solid #34495e !important;
}

table.table.highlight>tbody>tr:hover {
    background-color: #3a4a5c !important;
}

/* Dark inputs and forms */
input, select, textarea {
    background-color: #34495e !important;
    color: #ecf0f1 !important;
    border: 1px solid #34495e !important;
}

input:focus, select:focus, textarea:focus {
    border-color: #3498db !important;
    background-color: #2c3e50 !important;
}

/* Dark buttons */
button {
    background-color: #34495e !important;
    color: #ecf0f1 !important;
    border: 1px solid #34495e !important;
}

button:hover {
    background-color: #3a4a5c !important;
}

/* Dark overlays */
.overlay-wrapper>.overlay {
    background-color: #2c3e50 !important;
    color: #ecf0f1 !important;
    border: 1px solid #34495e !important;
}

/* Dark drawer */
#header>.drawer-wrapper>.drawer {
    background-color: #2c3e50 !important;
    border: 1px solid #34495e !important;
}

/* Dark notifications */
#header>.drawer-wrapper>.notifications-wrapper>.notification {
    background-color: #2c3e50 !important;
    border: 1px solid #34495e !important;
    color: #ecf0f1 !important;
}

/* Dark autocomplete */
.autocomplete {
    background-color: #2c3e50 !important;
    border: 1px solid #34495e !important;
    color: #ecf0f1 !important;
}

/* Dark CodeMirror */
.CodeMirror {
    background-color: #34495e !important;
    color: #ecf0f1 !important;
}

.CodeMirror-gutters {
    background-color: #2c3e50 !important;
    border-right: 1px solid #34495e !important;
}

/* Dark progress bar */
.progress {
    background-color: #34495e !important;
}

.progress>.progress-bar {
    background-color: #3498db !important;
}

/* Dark headings */
h1, h2, h3, h4, h5, h6 {
    color: #3498db !important;
}

/* Dark links */
a {
    color: #3498db !important;
}

a:hover {
    color: #5dade2 !important;
}

/* Dark status indicators */
.status-indicator {
    color: #ecf0f1 !important;
}
EOF

    # Apply dark theme to CSS file
    cp "$css_file" "$css_file.backup"
    cat /tmp/dark_theme.css >> "$css_file"
    
    echo -e "${GREEN}✓ Dark theme applied successfully${NC}"
}

# Function to apply custom color theme
apply_custom_theme() {
    local css_file="/usr/lib/node_modules/genieacs/public/app-LU66VFYW.css"
    
    echo -e "${YELLOW}================== Apply Custom Color Theme ==================${NC}"
    
    echo -e "${CYAN}Pilih warna utama untuk tema:${NC}"
    echo -e "${YELLOW}1. Biru Tua (Dark Blue) - #1a252f${NC}"
    echo -e "${YELLOW}2. Hijau Tua (Dark Green) - #1a2f1a${NC}"
    echo -e "${YELLOW}3. Merah Tua (Dark Red) - #2f1a1a${NC}"
    echo -e "${YELLOW}4. Ungu Tua (Dark Purple) - #2a1a2f${NC}"
    echo -e "${YELLOW}5. Abu-abu Tua (Dark Gray) - #2a2a2a${NC}"
    echo -e "${YELLOW}6. Custom Hex Color${NC}"
    
    read -p "Pilih warna (1-6): " color_choice
    
    case $color_choice in
        1) primary_color="#1a252f"; secondary_color="#2c3e50"; accent_color="#3498db" ;;
        2) primary_color="#1a2f1a"; secondary_color="#2c4e2c"; accent_color="#27ae60" ;;
        3) primary_color="#2f1a1a"; secondary_color="#4e2c2c"; accent_color="#e74c3c" ;;
        4) primary_color="#2a1a2f"; secondary_color="#4c2c4e"; accent_color="#9b59b6" ;;
        5) primary_color="#2a2a2a"; secondary_color="#4a4a4a"; accent_color="#95a5a6" ;;
        6) 
            read -p "Masukkan hex color (contoh: #1a252f): " custom_color
            primary_color="$custom_color"
            secondary_color=$(echo "$custom_color" | sed 's/#/#4/')
            accent_color="#3498db"
            ;;
        *) echo -e "${RED}Pilihan tidak valid${NC}"; return 1 ;;
    esac
    
    # Create custom theme CSS
    cat << EOF > /tmp/custom_theme.css
/* Custom Theme Variables */
:root {
    --base-font-size: 13px;
    --base-line-height: 16px;
    --color1: $secondary_color;
    --color2: $secondary_color;
    --color3: $secondary_color;
    --color4: $accent_color;
    --color5: $primary_color;
    --fade: .2s;
    --disabled: #7f8c8d;
    --status-red: 0 80% 80%;
    --status-green: 125 80% 80%;
    --status-gray: 58 3% 80%;
    --status-yellow: 46 79% 80%
}

/* Custom background */
body {
    background-color: $primary_color !important;
    color: #ecf0f1 !important;
}

#header {
    background-color: $secondary_color !important;
    border-bottom: 1px solid $secondary_color !important;
}

#content-wrapper {
    background-color: $primary_color !important;
}

table.table {
    background-color: $secondary_color !important;
    color: #ecf0f1 !important;
}

table.table th {
    background-color: $secondary_color !important;
    color: #ecf0f1 !important;
}

table.table td {
    background-color: $secondary_color !important;
    color: #ecf0f1 !important;
}

h1, h2, h3, h4, h5, h6 {
    color: $accent_color !important;
}

a {
    color: $accent_color !important;
}
EOF

    # Apply custom theme
    cp "$css_file" "$css_file.backup"
    cat /tmp/custom_theme.css >> "$css_file"
    
    echo -e "${GREEN}✓ Custom theme applied successfully${NC}"
}

# Function to restore original theme
restore_original_theme() {
    local css_file="/usr/lib/node_modules/genieacs/public/app-LU66VFYW.css"
    
    echo -e "${YELLOW}================== Restore Original Theme ==================${NC}"
    
    if [ -f "$css_file.backup" ]; then
        cp "$css_file.backup" "$css_file"
        echo -e "${GREEN}✓ Original theme restored${NC}"
    else
        echo -e "${RED}✗ Backup file not found${NC}"
        return 1
    fi
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
echo -e "${BLUE}================== Current Theme Status ==================${NC}"
check_file "/usr/lib/node_modules/genieacs/public/app-LU66VFYW.css"

echo -e "${BLUE}================== Theme Options ==================${NC}"
echo -e "${YELLOW}1. Apply Dark Theme (seperti di foto)${NC}"
echo -e "${YELLOW}2. Apply Custom Color Theme${NC}"
echo -e "${YELLOW}3. Restore Original Theme${NC}"
echo -e "${YELLOW}4. View Current Theme Info${NC}"
echo -e "${YELLOW}5. Exit${NC}"

read -p "Pilih opsi (1-5): " choice

case $choice in
    1)
        echo -e "${GREEN}================== Applying Dark Theme ==================${NC}"
        backup_css
        apply_dark_theme
        restart_ui
        ;;
    2)
        echo -e "${GREEN}================== Applying Custom Theme ==================${NC}"
        backup_css
        apply_custom_theme
        restart_ui
        ;;
    3)
        echo -e "${GREEN}================== Restoring Original Theme ==================${NC}"
        restore_original_theme
        restart_ui
        ;;
    4)
        echo -e "${GREEN}================== Current Theme Info ==================${NC}"
        echo -e "${YELLOW}CSS File:${NC}"
        ls -la /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css
        
        echo -e "${YELLOW}File size:${NC}"
        du -h /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css
        
        echo -e "${YELLOW}Last modified:${NC}"
        stat -c %y /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css
        
        echo -e "${YELLOW}Backup available:${NC}"
        if [ -f "/usr/lib/node_modules/genieacs/public/app-LU66VFYW.css.backup" ]; then
            echo -e "${GREEN}✓ Backup file exists${NC}"
        else
            echo -e "${RED}✗ No backup file${NC}"
        fi
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
echo -e "${GREEN}=================== THEME CHANGE COMPLETE =================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}Tema telah berhasil diubah.${NC}"
echo -e "${GREEN}Silakan refresh browser untuk melihat perubahan tema.${NC}"
echo -e "${GREEN}============================================================================${NC}"
