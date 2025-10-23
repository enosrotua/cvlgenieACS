#!/bin/bash

# CVL GenieACS Upload Script
# Script untuk mengupload instalasi GenieACS ke GitHub repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/enosrotua/cvlgenieACS.git"
# GITHUB_TOKEN should be set as environment variable
PROJECT_DIR="/root/cvlgenieACS"

echo -e "${BLUE}=== CVL GenieACS Upload Script ===${NC}"
echo -e "${YELLOW}Uploading GenieACS installation to GitHub repository${NC}"
echo ""

# Check if we're in the right directory
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}Error: Project directory $PROJECT_DIR not found${NC}"
    exit 1
fi

cd "$PROJECT_DIR"

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Initializing Git repository...${NC}"
    git init
    git branch -m main
fi

# Configure git user
echo -e "${YELLOW}Configuring Git user...${NC}"
git config user.name "enosrotua"
git config user.email "enosrotua@example.com"

# Add remote origin if not exists
if ! git remote get-url origin >/dev/null 2>&1; then
    echo -e "${YELLOW}Adding remote origin...${NC}"
    if [ -z "$GITHUB_TOKEN" ]; then
        echo -e "${RED}Error: GITHUB_TOKEN environment variable not set${NC}"
        echo -e "${YELLOW}Please set your GitHub token: export GITHUB_TOKEN=your_token_here${NC}"
        exit 1
    fi
    git remote add origin "https://${GITHUB_TOKEN}@github.com/enosrotua/cvlgenieACS.git"
fi

# Add all files
echo -e "${YELLOW}Adding files to Git...${NC}"
git add .

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo -e "${GREEN}No changes to commit${NC}"
else
    # Commit changes
    echo -e "${YELLOW}Committing changes...${NC}"
    git commit -m "Update GenieACS installation: $(date '+%Y-%m-%d %H:%M:%S')"
fi

# Push to GitHub
echo -e "${YELLOW}Pushing to GitHub...${NC}"
git push --force-with-lease origin main

echo ""
echo -e "${GREEN}✅ Successfully uploaded to GitHub!${NC}"
echo -e "${BLUE}Repository URL: https://github.com/enosrotua/cvlgenieACS${NC}"
echo ""
echo -e "${YELLOW}To clone this repository on another server, run:${NC}"
echo -e "${BLUE}git clone https://github.com/enosrotua/cvlgenieACS.git${NC}"
echo ""
echo -e "${YELLOW}To install on another server:${NC}"
echo -e "${BLUE}cd cvlgenieACS && chmod +x install.sh && sudo ./install.sh${NC}"