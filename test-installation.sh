#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}==================== GENIEACS TEST SCRIPT ==================================${NC}"
echo -e "${GREEN}============================================================================${NC}"

# Get local IP
local_ip=$(hostname -I | awk '{print $1}')

# Function to check service status
check_service() {
    local service_name=$1
    if systemctl is-active --quiet $service_name; then
        echo -e "${GREEN}✓ $service_name is running${NC}"
        return 0
    else
        echo -e "${RED}✗ $service_name is not running${NC}"
        return 1
    fi
}

# Function to check port
check_port() {
    local port=$1
    if ss -tlnp | grep -q ":$port " || lsof -i :$port > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Port $port is listening${NC}"
        return 0
    else
        echo -e "${RED}✗ Port $port is not listening${NC}"
        return 1
    fi
}

# Function to check URL accessibility
check_url() {
    local url=$1
    if curl -s --connect-timeout 5 "$url" > /dev/null; then
        echo -e "${GREEN}✓ $url is accessible${NC}"
        return 0
    else
        echo -e "${RED}✗ $url is not accessible${NC}"
        return 1
    fi
}

echo -e "${BLUE}================== System Information ==================${NC}"
echo -e "OS: $(lsb_release -d | cut -f2)"
echo -e "Kernel: $(uname -r)"
echo -e "IP Address: $local_ip"
echo -e "Date: $(date)"

echo -e "${BLUE}================== Checking Dependencies ==================${NC}"

# Check Node.js
if command -v node > /dev/null 2>&1; then
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✓ Node.js installed: $NODE_VERSION${NC}"
else
    echo -e "${RED}✗ Node.js not installed${NC}"
fi

# Check npm
if command -v npm > /dev/null 2>&1; then
    NPM_VERSION=$(npm -v)
    echo -e "${GREEN}✓ npm installed: $NPM_VERSION${NC}"
else
    echo -e "${RED}✗ npm not installed${NC}"
fi

# Check MongoDB
if command -v mongod > /dev/null 2>&1; then
    MONGODB_VERSION=$(mongod --version | head -n1 | cut -d' ' -f3)
    echo -e "${GREEN}✓ MongoDB installed: $MONGODB_VERSION${NC}"
else
    echo -e "${RED}✗ MongoDB not installed${NC}"
fi

# Check GenieACS
if command -v genieacs-ui > /dev/null 2>&1; then
    echo -e "${GREEN}✓ GenieACS installed${NC}"
else
    echo -e "${RED}✗ GenieACS not installed${NC}"
fi

echo -e "${BLUE}================== Checking Services ==================${NC}"

# Check MongoDB service
check_service "mongod"

# Check GenieACS services
check_service "genieacs-cwmp"
check_service "genieacs-fs"
check_service "genieacs-ui"
check_service "genieacs-nbi"

echo -e "${BLUE}================== Checking Ports ==================${NC}"

# Check MongoDB port
check_port "27017"

# Check GenieACS ports
check_port "3000"  # UI
check_port "7547"  # CWMP
check_port "7557"  # FS
check_port "7557"  # NBI

echo -e "${BLUE}================== Checking URLs ==================${NC}"

# Check GenieACS UI
check_url "http://localhost:3000"
check_url "http://$local_ip:3000"

echo -e "${BLUE}================== Database Status ==================${NC}"

# Check MongoDB connection
if mongosh --eval 'db.runCommand({ connectionStatus: 1 })' > /dev/null 2>&1; then
    echo -e "${GREEN}✓ MongoDB connection successful${NC}"
    
    # Check GenieACS database
    if mongosh genieacs --eval 'db.stats()' > /dev/null 2>&1; then
        echo -e "${GREEN}✓ GenieACS database exists${NC}"
        
        # Count collections
        COLLECTIONS=$(mongosh genieacs --quiet --eval 'db.getCollectionNames().length')
        echo -e "${GREEN}✓ Collections count: $COLLECTIONS${NC}"
    else
        echo -e "${RED}✗ GenieACS database not found${NC}"
    fi
else
    echo -e "${RED}✗ MongoDB connection failed${NC}"
fi

echo -e "${BLUE}================== Log Files ==================${NC}"

# Check log files
LOG_DIR="/var/log/genieacs"
if [ -d "$LOG_DIR" ]; then
    echo -e "${GREEN}✓ Log directory exists: $LOG_DIR${NC}"
    
    # List log files
    LOG_FILES=$(ls -la "$LOG_DIR"/*.log 2>/dev/null | wc -l)
    echo -e "${GREEN}✓ Log files count: $LOG_FILES${NC}"
    
    # Show recent errors
    echo -e "${YELLOW}Recent errors:${NC}"
    grep -i error "$LOG_DIR"/*.log 2>/dev/null | tail -5 || echo "No errors found"
else
    echo -e "${RED}✗ Log directory not found${NC}"
fi

echo -e "${BLUE}================== Configuration Files ==================${NC}"

# Check configuration files
CONFIG_FILES=(
    "/opt/genieacs/genieacs.env"
    "/etc/systemd/system/genieacs-cwmp.service"
    "/etc/systemd/system/genieacs-fs.service"
    "/etc/systemd/system/genieacs-ui.service"
    "/etc/systemd/system/genieacs-nbi.service"
    "/etc/logrotate.d/genieacs"
)

for config_file in "${CONFIG_FILES[@]}"; do
    if [ -f "$config_file" ]; then
        echo -e "${GREEN}✓ $config_file exists${NC}"
    else
        echo -e "${RED}✗ $config_file not found${NC}"
    fi
done

echo -e "${BLUE}================== Summary ==================${NC}"

# Count successful checks
TOTAL_CHECKS=0
SUCCESSFUL_CHECKS=0

# Count service checks
for service in mongod genieacs-cwmp genieacs-fs genieacs-ui genieacs-nbi; do
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if systemctl is-active --quiet $service; then
        SUCCESSFUL_CHECKS=$((SUCCESSFUL_CHECKS + 1))
    fi
done

# Count port checks
for port in 27017 3000 7547 7557; do
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if ss -tlnp | grep -q ":$port " || lsof -i :$port > /dev/null 2>&1; then
        SUCCESSFUL_CHECKS=$((SUCCESSFUL_CHECKS + 1))
    fi
done

SUCCESS_RATE=$((SUCCESSFUL_CHECKS * 100 / TOTAL_CHECKS))

if [ $SUCCESS_RATE -ge 80 ]; then
    echo -e "${GREEN}✓ Overall Status: EXCELLENT ($SUCCESS_RATE% success rate)${NC}"
elif [ $SUCCESS_RATE -ge 60 ]; then
    echo -e "${YELLOW}⚠ Overall Status: GOOD ($SUCCESS_RATE% success rate)${NC}"
else
    echo -e "${RED}✗ Overall Status: NEEDS ATTENTION ($SUCCESS_RATE% success rate)${NC}"
fi

echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}=================== TEST COMPLETE =================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}GenieACS UI: http://$local_ip:3000${NC}"
echo -e "${GREEN}Username: admin${NC}"
echo -e "${GREEN}Password: admin${NC}"
echo -e "${GREEN}============================================================================${NC}"
