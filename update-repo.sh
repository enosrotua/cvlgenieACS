#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}==================== UPDATE REPOSITORY SCRIPT =============================${NC}"
echo -e "${GREEN}============================================================================${NC}"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: Not in a git repository. Please run this script from the repository root.${NC}"
    exit 1
fi

# Check git status
echo -e "${GREEN}================== Checking Git Status ==================${NC}"
git status

# Add all changes
echo -e "${GREEN}================== Adding Changes ==================${NC}"
git add .

# Commit changes
echo -e "${GREEN}================== Committing Changes ==================${NC}"
git commit -m "Update GenieACS installer scripts

- Fixed darkmode.sh for complete installation including MongoDB
- Updated install.sh with better error handling
- Added backup.sh script for configuration backup
- Updated README.md with comprehensive documentation
- Added systemd service improvements with restart policies
- Updated MongoDB to version 6.0
- Added proper logging and status checking
- Fixed permission issues and service dependencies"

# Push to repository
echo -e "${GREEN}================== Pushing to Repository ==================${NC}"
git push origin main

echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}=================== REPOSITORY UPDATE COMPLETE =================${NC}"
echo -e "${GREEN}============================================================================${NC}"
echo -e "${GREEN}Repository telah diupdate dengan konfigurasi terbaru.${NC}"
echo -e "${GREEN}Script sekarang siap untuk digunakan di server baru.${NC}"
echo -e "${GREEN}============================================================================${NC}"
