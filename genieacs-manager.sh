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
echo -e "${GREEN}==================== GENIEACS MANAGEMENT SUITE =========================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}==================== CV LINTAS MULTIMEDIA ================================${NC}"
echo -e "${GREEN}============================================================================${NC}"

# Get local IP
local_ip=$(hostname -I | awk '{print $1}')

# Function to check service status
check_service() {
    if systemctl is-active --quiet $1; then
        echo -e "${GREEN}✓ $1 is running${NC}"
        return 0
    else
        echo -e "${RED}✗ $1 is not running${NC}"
        return 1
    fi
}

# Function to show system status
show_status() {
    echo -e "${BLUE}================== System Status ==================${NC}"
    echo -e "OS: $(lsb_release -d | cut -f2)"
    echo -e "IP Address: $local_ip"
    echo -e "Date: $(date)"
    echo -e ""
    
    echo -e "${BLUE}================== Services Status ==================${NC}"
    check_service "mongod"
    check_service "genieacs-cwmp"
    check_service "genieacs-fs"
    check_service "genieacs-ui"
    check_service "genieacs-nbi"
    echo -e ""
    
    echo -e "${BLUE}================== GenieACS Access ==================${NC}"
    echo -e "${GREEN}URL: http://$local_ip:3000${NC}"
    echo -e "${GREEN}Username: admin${NC}"
    echo -e "${GREEN}Password: admin${NC}"
    echo -e ""
}

# Main menu
while true; do
    echo -e "${CYAN}================== GENIEACS MANAGEMENT MENU ==================${NC}"
    echo -e "${YELLOW}1. Install GenieACS (Dark Mode)${NC}"
    echo -e "${YELLOW}2. Install GenieACS (Original Theme)${NC}"
    echo -e "${YELLOW}3. Change Logo${NC}"
    echo -e "${YELLOW}4. Change Theme/Background Color${NC}"
    echo -e "${YELLOW}5. Backup Configuration${NC}"
    echo -e "${YELLOW}6. Test Installation${NC}"
    echo -e "${YELLOW}7. Show System Status${NC}"
    echo -e "${YELLOW}8. Restart GenieACS Services${NC}"
    echo -e "${YELLOW}9. View Logs${NC}"
    echo -e "${YELLOW}10. Exit${NC}"
    echo -e "${CYAN}============================================================================${NC}"
    
    read -p "Pilih opsi (1-10): " choice
    
    case $choice in
        1)
            echo -e "${GREEN}================== Installing GenieACS Dark Mode ==================${NC}"
            bash darkmode.sh
            ;;
        2)
            echo -e "${GREEN}================== Installing GenieACS Original Theme ==================${NC}"
            bash install.sh
            ;;
        3)
            echo -e "${GREEN}================== Change Logo ==================${NC}"
            bash change-logo.sh
            ;;
        4)
            echo -e "${GREEN}================== Change Theme ==================${NC}"
            bash change-theme.sh
            ;;
        5)
            echo -e "${GREEN}================== Backup Configuration ==================${NC}"
            bash backup.sh
            ;;
        6)
            echo -e "${GREEN}================== Test Installation ==================${NC}"
            bash test-installation.sh
            ;;
        7)
            show_status
            ;;
        8)
            echo -e "${GREEN}================== Restarting GenieACS Services ==================${NC}"
            systemctl restart genieacs-cwmp genieacs-fs genieacs-ui genieacs-nbi
            sleep 5
            echo -e "${GREEN}Services restarted. Checking status...${NC}"
            check_service "genieacs-ui"
            ;;
        9)
            echo -e "${GREEN}================== View Logs ==================${NC}"
            echo -e "${YELLOW}1. GenieACS UI Logs${NC}"
            echo -e "${YELLOW}2. MongoDB Logs${NC}"
            echo -e "${YELLOW}3. System Logs${NC}"
            echo -e "${YELLOW}4. All GenieACS Logs${NC}"
            
            read -p "Pilih log (1-4): " log_choice
            
            case $log_choice in
                1) journalctl -u genieacs-ui -f --no-pager ;;
                2) journalctl -u mongod -f --no-pager ;;
                3) journalctl -f --no-pager ;;
                4) journalctl -u genieacs-* -f --no-pager ;;
                *) echo -e "${RED}Pilihan tidak valid${NC}" ;;
            esac
            ;;
        10)
            echo -e "${GREEN}============================================================================${NC}"
            echo -e "${GREEN}=================== TERIMA KASIH =================${NC}"
            echo -e "${GREEN}============================================================================${NC}"
            echo -e "${GREEN}GenieACS Management Suite - CV Lintas Multimedia${NC}"
            echo -e "${GREEN}WhatsApp: 081947215703${NC}"
            echo -e "${GREEN}============================================================================${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opsi tidak valid. Silakan pilih 1-10.${NC}"
            ;;
    esac
    
    echo -e "${CYAN}Tekan Enter untuk melanjutkan...${NC}"
    read
    clear
done
