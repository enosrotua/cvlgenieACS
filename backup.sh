#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}==================== GENIEACS BACKUP SCRIPT ===============================${NC}"
echo -e "${GREEN}============================================================================${NC}"

# Create backup directory with timestamp
BACKUP_DIR="genieacs-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo -e "${GREEN}================== Backup Database ==================${NC}"
mongodump --db=genieacs --out="$BACKUP_DIR"

echo -e "${GREEN}================== Backup Configuration Files ==================${NC}"
# Backup GenieACS configuration files
if [ -f "/opt/genieacs/genieacs.env" ]; then
    cp /opt/genieacs/genieacs.env "$BACKUP_DIR/"
fi

# Backup systemd service files
if [ -f "/etc/systemd/system/genieacs-cwmp.service" ]; then
    cp /etc/systemd/system/genieacs-*.service "$BACKUP_DIR/"
fi

# Backup logrotate configuration
if [ -f "/etc/logrotate.d/genieacs" ]; then
    cp /etc/logrotate.d/genieacs "$BACKUP_DIR/"
fi

# Backup custom CSS and logo if they exist
if [ -f "/usr/lib/node_modules/genieacs/public/css/app-LU66VFYW.css" ]; then
    mkdir -p "$BACKUP_DIR/public/css"
    cp /usr/lib/node_modules/genieacs/public/css/app-LU66VFYW.css "$BACKUP_DIR/public/css/"
fi

if [ -f "/usr/lib/node_modules/genieacs/public/logo.svg" ]; then
    mkdir -p "$BACKUP_DIR/public"
    cp /usr/lib/node_modules/genieacs/public/logo.svg "$BACKUP_DIR/public/"
fi

echo -e "${GREEN}================== Create Restore Script ==================${NC}"
cat << EOF > "$BACKUP_DIR/restore.sh"
#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "\${GREEN}================== Restore GenieACS Configuration ==================\${NC}"

# Stop GenieACS services
systemctl stop genieacs-cwmp genieacs-fs genieacs-ui genieacs-nbi

# Restore database
mongorestore --db=genieacs --drop genieacs/

# Restore configuration files
if [ -f "genieacs.env" ]; then
    cp genieacs.env /opt/genieacs/
    chown genieacs:genieacs /opt/genieacs/genieacs.env
    chmod 600 /opt/genieacs/genieacs.env
fi

# Restore systemd service files
if [ -f "genieacs-cwmp.service" ]; then
    cp genieacs-*.service /etc/systemd/system/
    systemctl daemon-reload
fi

# Restore logrotate configuration
if [ -f "genieacs" ]; then
    cp genieacs /etc/logrotate.d/
fi

# Restore custom CSS and logo
if [ -f "public/css/app-LU66VFYW.css" ]; then
    cp public/css/app-LU66VFYW.css /usr/lib/node_modules/genieacs/public/css/
fi

if [ -f "public/logo.svg" ]; then
    cp public/logo.svg /usr/lib/node_modules/genieacs/public/
fi

# Start GenieACS services
systemctl start genieacs-cwmp genieacs-fs genieacs-ui genieacs-nbi

echo -e "\${GREEN}================== Restore Complete ==================\${NC}"
EOF

chmod +x "$BACKUP_DIR/restore.sh"

echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}=================== BACKUP BERHASIL SELESAI =================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}Backup tersimpan di: $BACKUP_DIR${NC}"
echo -e "${GREEN}Untuk restore, jalankan: cd $BACKUP_DIR && ./restore.sh${NC}"
echo -e "${GREEN}============================================================================${NC}"
