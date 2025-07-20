#!/bin/bash

# Simple Dotfiles Installation Script

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Installing dotfiles...${NC}"

# Single package array for Ubuntu/Debian
PACKAGES=("hstr" "autojump")

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install exa
install_exa() {
    echo -e "${BLUE}Installing exa...${NC}"
    
    # Try to install exa via apt first
    if sudo apt install -y exa; then
        echo "Installed exa via apt"
        return 0
    fi
    
    # If package manager installation failed, try source compilation
    echo -e "${YELLOW}exa not available via apt${NC}"
    if [[ -f "install_exa.sh" ]]; then
        echo -e "${BLUE}Installing exa from source...${NC}"
        chmod +x install_exa.sh
        ./install_exa.sh
    else
        echo -e "${RED}install_exa.sh not found in current directory${NC}"
        echo -e "${YELLOW}Will use standard ls with colors${NC}"
        return 1
    fi
}

# Function to install packages
install_packages() {
    echo -e "${BLUE}Installing required packages...${NC}"
    
    # Check if we're on Ubuntu/Debian
    if ! command_exists apt; then
        echo -e "${RED}This script only supports Ubuntu/Debian systems${NC}"
        echo "Please install the following packages manually:"
        echo "- exa (or use ./install_exa.sh)"
        echo "- hstr"
        echo "- autojump"
        return 1
    fi
    
    # Update package list
    sudo apt update
    
    # Install exa first
    install_exa
    
    # Install other packages
    echo "Installing packages: ${PACKAGES[*]}"
    sudo apt install -y "${PACKAGES[@]}"
}

# Function to backup and copy file
install_file() {
    local source="$1"
    local target="$2"
    
    if [[ -f "$target" ]]; then
        echo -e "${YELLOW}Backing up existing $target${NC}"
        cp "$target" "backup/$(basename "$target")"
    fi
    
    echo "Installing $target"
    cp "$source" "$target"
}

# Create backup directory
mkdir -p backup

# Install required packages
install_packages

# Install dotfiles
install_file ".bashrc" "$HOME/.bashrc"
install_file ".bash_aliases" "$HOME/.bash_aliases"
install_file ".profile" "$HOME/.profile"
install_file ".gitconfig" "$HOME/.gitconfig"

echo -e "${GREEN}Installation complete!${NC}"
echo "Backups are stored in the backup/ directory"
echo "Run 'source ~/.bashrc' to apply changes"
echo ""
echo -e "${BLUE}Installed packages:${NC}"
echo "- exa: Modern replacement for ls (via package manager or source)"
echo "- hstr: Command history search (Ctrl+R)"
echo "- autojump: Smart directory navigation" 