#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}================== Restore GenieACS Configuration ==================${NC}"

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

echo -e "${GREEN}================== Restore Complete ==================${NC}"
