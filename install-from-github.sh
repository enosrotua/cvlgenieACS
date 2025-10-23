#!/bin/bash

# CVL GenieACS Installation Script
# Script untuk menginstall GenieACS dari GitHub repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/enosrotua/cvlgenieACS.git"
INSTALL_DIR="/opt/cvlgenieACS"

echo -e "${BLUE}=== CVL GenieACS Installation Script ===${NC}"
echo -e "${YELLOW}Installing GenieACS from GitHub repository${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root (use sudo)${NC}"
    exit 1
fi

# Update system packages
echo -e "${YELLOW}Updating system packages...${NC}"
apt-get update

# Install required packages
echo -e "${YELLOW}Installing required packages...${NC}"
apt-get install -y git curl wget build-essential

# Install Node.js
echo -e "${YELLOW}Installing Node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Install Ruby and Rails
echo -e "${YELLOW}Installing Ruby and Rails...${NC}"
apt-get install -y ruby ruby-dev build-essential
gem install rails bundler

# Install MongoDB
echo -e "${YELLOW}Installing MongoDB...${NC}"
apt-get install -y mongodb
systemctl start mongodb
systemctl enable mongodb

# Clone repository
echo -e "${YELLOW}Cloning repository...${NC}"
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}Directory $INSTALL_DIR already exists. Removing...${NC}"
    rm -rf "$INSTALL_DIR"
fi

git clone "$REPO_URL" "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Set permissions
echo -e "${YELLOW}Setting permissions...${NC}"
chown -R root:root "$INSTALL_DIR"
chmod +x install.sh upload.sh

# Run installation script
echo -e "${YELLOW}Running installation script...${NC}"
./install.sh

echo ""
echo -e "${GREEN}✅ GenieACS installation completed!${NC}"
echo ""
echo -e "${YELLOW}Access points:${NC}"
echo -e "${BLUE}• GenieACS UI: http://your-server-ip:3000${NC}"
echo -e "${BLUE}• API Endpoint: http://your-server-ip:7557${NC}"
echo -e "${BLUE}• File Server: http://your-server-ip:7567${NC}"
echo ""
echo -e "${YELLOW}To update your installation:${NC}"
echo -e "${BLUE}cd $INSTALL_DIR && git pull && sudo ./install.sh --update${NC}"
