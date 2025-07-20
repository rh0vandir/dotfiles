#!/bin/bash


# -----------------------------------------------------------------------------
#  install.sh - Dotfiles installation script
#
#  Creator: Rhovandir
#  License: MIT
#  Created: 2025-07-20
#  Version: 1.0.5
#
# -----------------------------------------------------------------------------




# Simple Dotfiles Installation Script

set -e

# script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
        bash "$SCRIPT_DIR/install_exa.sh"
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
        echo "- exa (or use $SCRIPT_DIR/install_exa.sh)"
        echo "- hstr"
        echo "- autojump"
        return 1
    fi
    
    # Update package list
    sudo apt update
    
    # Install exa first
    if command_exists exa; then
        echo -e "${GREEN}exa is already installed${NC}"
    else
        install_exa
    fi
    
    # Install other packages only if not already installed
    to_install=()
    for pkg in "${PACKAGES[@]}"; do
        if ! dpkg -s "$pkg" >/dev/null 2>&1; then
            to_install+=("$pkg")
        else
            echo -e "${GREEN}$pkg is already installed${NC}"
        fi
    done

    if [ "${#to_install[@]}" -gt 0 ]; then
        echo "Installing packages: ${to_install[*]}"
        sudo apt install -y "${to_install[@]}"
    else
        echo -e "${GREEN}All packages are already installed${NC}"
    fi
}

# Function to backup and copy file
install_file() {
    local source="$1"
    local target="$2"
    
    if [[ -f "$target" ]]; then
        echo -e "${YELLOW}Backing up existing $target${NC}"
        cp "$target" "$SCRIPT_DIR/backup/$(basename "$target")"
    fi
    
    echo "Installing $target"
    cp "$source" "$target"
}

# Create backup directory
mkdir -p "$SCRIPT_DIR/backup"

# Install required packages
install_packages

# Install dotfiles
install_file "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
install_file "$SCRIPT_DIR/.bash_aliases" "$HOME/.bash_aliases"

echo -e "${GREEN}Installation complete!${NC}"
echo "Backups are stored in the backup/ directory"
echo "Run 'source ~/.bashrc' to apply changes"
echo ""
echo -e "${BLUE}Installed packages:${NC}"
echo "- exa: Modern replacement for ls (via package manager or source)"
echo "- hstr: Command history search (Ctrl+R)"
echo "- autojump: Smart directory navigation"
echo ""
echo -e "${BLUE}Personal customizations:${NC}"
echo "- Create ~/.bashrc.local to add local paths and settings"
 