#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get local IP
local_ip=$(hostname -I | awk '{print $1}')

# Banner
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}===========================================================================${NC}"   
echo -e "${GREEN}============================================================================${NC}" 
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}${NC}"
echo -e "${GREEN}Autoinstall GenieACS dengan Dark Mode Theme.${NC}"
echo -e "${GREEN}${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${RED}${NC}"
echo -e "${GREEN} Apakah anda ingin melanjutkan instalasi? (y/n)${NC}"
read confirmation

if [ "$confirmation" != "y" ]; then
    echo -e "${GREEN}Install dibatalkan. Tidak ada perubahan dalam ubuntu server anda.${NC}"
    exit 1
fi

for ((i = 5; i >= 1; i--)); do
	sleep 1
    echo "Melanjutkan dalam $i. Tekan ctrl+c untuk membatalkan"
done

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Node.js version
check_node_version() {
    if command_exists node; then
        NODE_VERSION=$(node -v | cut -d 'v' -f 2)
        NODE_MAJOR_VERSION=$(echo $NODE_VERSION | cut -d '.' -f 1)
        NODE_MINOR_VERSION=$(echo $NODE_VERSION | cut -d '.' -f 2)

        if [ "$NODE_MAJOR_VERSION" -lt 12 ] || { [ "$NODE_MAJOR_VERSION" -eq 12 ] && [ "$NODE_MINOR_VERSION" -lt 13 ]; } || [ "$NODE_MAJOR_VERSION" -gt 22 ]; then
            return 1
        else
            return 0
        fi
    else
        return 1
    fi
}

# Update system packages
echo -e "${GREEN}================== Update System Packages ==================${NC}"
apt update && apt upgrade -y
apt install -y curl wget git gnupg2 software-properties-common apt-transport-https ca-certificates

# Install Node.js
if ! check_node_version; then
    echo -e "${GREEN}================== Menginstall NodeJS ==================${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
    apt-get install -y nodejs
    echo -e "${GREEN}================== Sukses NodeJS ==================${NC}"
else
    NODE_VERSION=$(node -v | cut -d 'v' -f 2)
    echo -e "${GREEN}============================================================================${NC}"
    echo -e "${GREEN}============== NodeJS sudah terinstall versi ${NODE_VERSION}. ==============${NC}"
    echo -e "${GREEN}========================= Lanjut install GenieACS ==========================${NC}"
fi

# Install MongoDB
if ! systemctl is-active --quiet mongod; then
    echo -e "${GREEN}================== Menginstall MongoDB ==================${NC}"
    
    # Add MongoDB GPG key
    curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg
    
    # Add MongoDB repository
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
    
    # Update package list and install MongoDB
    apt update
    apt install -y mongodb-org
    
    # Start and enable MongoDB
    systemctl start mongod
    systemctl enable mongod
    
    # Verify MongoDB installation
    sleep 5
    mongosh --eval 'db.runCommand({ connectionStatus: 1 })' || mongo --eval 'db.runCommand({ connectionStatus: 1 })'
    
    echo -e "${GREEN}================== Sukses MongoDB ==================${NC}"
else
    echo -e "${GREEN}============================================================================${NC}"
    echo -e "${GREEN}=================== MongoDB sudah terinstall sebelumnya. ===================${NC}"
fi

# Install GenieACS
if ! systemctl is-active --quiet genieacs-ui; then
    echo -e "${GREEN}================== Menginstall GenieACS ==================${NC}"
    
    # Install GenieACS globally
    npm install -g genieacs@1.2.13
    
    # Create genieacs user
    useradd --system --no-create-home --user-group genieacs || true
    
    # Create directories
    mkdir -p /opt/genieacs/ext
    mkdir -p /var/log/genieacs
    
    # Set permissions
    chown genieacs:genieacs /opt/genieacs/ext
    chown genieacs:genieacs /var/log/genieacs
    
    # Create environment file
    cat << EOF > /opt/genieacs/genieacs.env
GENIEACS_CWMP_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-cwmp-access.log
GENIEACS_NBI_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-nbi-access.log
GENIEACS_FS_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-fs-access.log
GENIEACS_UI_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-ui-access.log
GENIEACS_DEBUG_FILE=/var/log/genieacs/genieacs-debug.yaml
GENIEACS_EXT_DIR=/opt/genieacs/ext
GENIEACS_UI_JWT_SECRET=secret
EOF
    
    chown genieacs:genieacs /opt/genieacs/genieacs.env
    chmod 600 /opt/genieacs/genieacs.env
    
    # Create systemd service files
    # CWMP Service
    cat << EOF > /etc/systemd/system/genieacs-cwmp.service
[Unit]
Description=GenieACS CWMP
After=network.target mongod.service

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/bin/genieacs-cwmp
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    # NBI Service
    cat << EOF > /etc/systemd/system/genieacs-nbi.service
[Unit]
Description=GenieACS NBI
After=network.target mongod.service

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/bin/genieacs-nbi
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    # FS Service
    cat << EOF > /etc/systemd/system/genieacs-fs.service
[Unit]
Description=GenieACS FS
After=network.target mongod.service

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/bin/genieacs-fs
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    # UI Service
    cat << EOF > /etc/systemd/system/genieacs-ui.service
[Unit]
Description=GenieACS UI
After=network.target mongod.service

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/bin/genieacs-ui
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    # Configure logrotate
    cat << EOF > /etc/logrotate.d/genieacs
/var/log/genieacs/*.log /var/log/genieacs/*.yaml {
    daily
    rotate 30
    compress
    delaycompress
    dateext
    missingok
    notifempty
    create 644 genieacs genieacs
}
EOF

    echo -e "${GREEN}========== Install GenieACS selesai... ==============${NC}"
    
    # Reload systemd and start services
    systemctl daemon-reload
    systemctl enable genieacs-cwmp genieacs-fs genieacs-ui genieacs-nbi
    systemctl start genieacs-cwmp genieacs-fs genieacs-ui genieacs-nbi
    
    echo -e "${GREEN}================== Sukses GenieACS ==================${NC}"
else
    echo -e "${GREEN}============================================================================${NC}"
    echo -e "${GREEN}=================== GenieACS sudah terinstall sebelumnya. ==================${NC}"
fi

# Wait for services to start
echo -e "${GREEN}================== Menunggu services start... ==================${NC}"
sleep 10

# Install Dark Mode Theme and Logo
echo -e "${GREEN}================== Install Dark Mode Theme ==================${NC}"
echo -e "${GREEN}Sekarang install Dark Mode Theme dan Logo. Apakah anda ingin melanjutkan? (y/n)${NC}"
read confirmation

if [ "$confirmation" != "y" ]; then
    echo -e "${GREEN}Install theme dibatalkan.${NC}"
    exit 1
fi

for ((i = 5; i >= 1; i--)); do
    sleep 1
    echo "Lanjut Install Theme $i. Tekan ctrl+c untuk membatalkan"
done

# Backup existing database if it exists
if [ -d "db" ]; then
    echo -e "${GREEN}================== Backup Database Existing ==================${NC}"
    mongodump --db=genieacs --out=genieacs-backup-$(date +%Y%m%d_%H%M%S) || true
fi

# Restore database with configurations
echo -e "${GREEN}================== Restore Database Configuration ==================${NC}"
mongorestore --db genieacs --drop db/

# Restart GenieACS services
echo -e "${GREEN}================== Restart GenieACS Services ==================${NC}"
systemctl restart genieacs-cwmp genieacs-fs genieacs-ui genieacs-nbi

# Wait for services to restart
sleep 10

# Apply Dark Mode CSS
echo -e "${GREEN}================== Apply Dark Mode CSS ==================${NC}"
if [ -f "app-LU66VFYW.css" ]; then
    # Copy dark mode CSS to GenieACS UI directory
    cp app-LU66VFYW.css /usr/lib/node_modules/genieacs/public/css/ || true
    cp app-LU66VFYW.css /opt/genieacs/public/css/ || true
    
    # Try to find GenieACS UI public directory
    GENIEACS_UI_DIR=$(find /usr/lib/node_modules -name "genieacs" -type d 2>/dev/null | head -1)
    if [ -n "$GENIEACS_UI_DIR" ] && [ -d "$GENIEACS_UI_DIR/public/css" ]; then
        cp app-LU66VFYW.css "$GENIEACS_UI_DIR/public/css/"
        echo -e "${GREEN}Dark mode CSS applied to: $GENIEACS_UI_DIR/public/css/${NC}"
    fi
fi

# Apply Logo
echo -e "${GREEN}================== Apply Logo ==================${NC}"
if [ -f "logo.svg" ]; then
    # Copy logo to GenieACS UI directory
    cp logo.svg /usr/lib/node_modules/genieacs/public/ || true
    cp logo.svg /opt/genieacs/public/ || true
    
    # Try to find GenieACS UI public directory
    GENIEACS_UI_DIR=$(find /usr/lib/node_modules -name "genieacs" -type d 2>/dev/null | head -1)
    if [ -n "$GENIEACS_UI_DIR" ] && [ -d "$GENIEACS_UI_DIR/public" ]; then
        cp logo.svg "$GENIEACS_UI_DIR/public/"
        echo -e "${GREEN}Logo applied to: $GENIEACS_UI_DIR/public/${NC}"
    fi
fi

# Final restart
echo -e "${GREEN}================== Final Restart Services ==================${NC}"
systemctl restart genieacs-ui

# Wait for final restart
sleep 15

# Check service status
echo -e "${GREEN}================== Service Status ==================${NC}"
systemctl status genieacs-ui --no-pager -l
systemctl status mongod --no-pager -l

# Success message
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}=================== INSTALASI BERHASIL SELESAI =================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}========== GenieACS UI akses port 3000. : http://$local_ip:3000 ============${NC}"
echo -e "${GREEN}=================== Dark Mode Theme Applied =======================${NC}"
echo -e "${GREEN}=================== Logo Applied ===================================${NC}"
echo -e "${GREEN}=================== Informasi: Whatsapp 081368888498 =============${NC}"
echo -e "${GREEN}============================================================================${NC}"

# Show final instructions
echo -e "${YELLOW}================== INSTRUKSI FINAL ==================${NC}"
echo -e "${YELLOW}1. Akses GenieACS UI di: http://$local_ip:3000${NC}"
echo -e "${YELLOW}2. Login dengan username: admin, password: admin${NC}"
echo -e "${YELLOW}3. Jika ACS URL berbeda, edit di Admin >> Provisions >> inform${NC}"
echo -e "${YELLOW}4. Dark Mode theme sudah diterapkan${NC}"
echo -e "${YELLOW}5. Logo sudah diterapkan${NC}"
echo -e "${YELLOW}============================================================================${NC}"
