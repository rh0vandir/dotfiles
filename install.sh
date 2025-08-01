#!/bin/bash


# -----------------------------------------------------------------------------
#  install.sh - Dotfiles installation script
#
#  Creator: Rhovandir
#  License: MIT
#  Created: 2025-07-20
#  Version: 1.0.9
#
# -----------------------------------------------------------------------------

set -e

# script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Single package array for Ubuntu/Debian
PACKAGES=("hstr" "autojump")

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Installing dotfiles...${NC}"


# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Determine if sudo is available
if command_exists sudo; then
    APT_CMD="sudo apt"
else
    APT_CMD="apt"
fi

# Function to check if we're in a dotfiles directory
is_dotfiles_dir() {
    local dir="$1"
    [[ -f "$dir/.bashrc" ]] && [[ -f "$dir/.bash_aliases" ]] && [[ -f "$dir/install.sh" ]]
}

# Check if we're in the right directory (should contain .bashrc and .bash_aliases)
if ! is_dotfiles_dir "$SCRIPT_DIR"; then
    echo -e "${YELLOW}Not in a dotfiles directory. Attempting to clone from GitHub...${NC}"
    
    # Check if git is available
    if ! command_exists git; then
        echo -e "Installing git..."
        $APT_CMD update && $APT_CMD install -y git
    fi
    
    # Create a temporary directory for cloning
    TEMP_DIR="$HOME/temp"
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    
    echo -e "Cloning dotfiles repository..."
    if git clone https://github.com/rh0vandir/dotfiles.git; then
        cd dotfiles
        SCRIPT_DIR="$(pwd)"
        echo -e "${GREEN}Successfully cloned dotfiles to $SCRIPT_DIR${NC}"
    else
        echo -e "${RED}Failed to clone dotfiles repository${NC}"
        rm -rf "$TEMP_DIR/dotfiles"
        exit 1
    fi
fi

# Function to install packages
install_packages() {
    echo -e "Installing required packages..."
    
    # Check if we're on Ubuntu/Debian
    if ! command_exists apt; then
        echo -e "${RED}This script only supports Ubuntu/Debian systems${NC}"
        echo "Please install the following packages manually:"
        echo "- eza or exa (sudo apt install eza or sudo apt install exa)"
        echo "- hstr"
        echo "- autojump"
        return 1
    fi
    
    # Update package list
    $APT_CMD update
    
    # Install modern ls replacement (eza or exa)
    if command_exists eza; then
        echo -e "${GREEN}eza is already installed${NC}"
    elif command_exists exa; then
        echo -e "${GREEN}exa is already installed${NC}"
    else
        echo -e "Installing modern ls replacement..."
        
        # Try to install eza first (preferred)
        if $APT_CMD install -y eza; then
            echo -e "${GREEN}Installed eza via apt${NC}"
            return 0
        fi
        
        # Fall back to exa if eza is not available
        if $APT_CMD install -y exa; then
            echo -e "${GREEN}Installed exa via apt${NC}"
            return 0
        fi
        
        # If both failed
        echo -e "${YELLOW}Neither eza nor exa available via apt${NC}"
        echo -e "${YELLOW}Will use standard ls with colors${NC}"
        return 1
    fi
    
    # Install other packages only if not already installed
    to_install=()
    for pkg in "${PACKAGES[@]}"; do
        if ! dpkg -s "$pkg" >/dev/null 2>&1; then
            to_install+=("$pkg")
        else
            echo -e "$pkg is already installed"
        fi
    done

    if [ "${#to_install[@]}" -gt 0 ]; then
        echo "Installing packages: ${to_install[*]}"
        $APT_CMD install -y "${to_install[@]}"
    else
        echo -e "${GREEN}All packages are already installed${NC}"
    fi
}

# Function to backup and copy file
install_file() {
    local source="$1"
    local target="$2"
    
    # Check if source file exists
    if [[ ! -f "$source" ]]; then
        echo -e "${RED}Source file $source does not exist!${NC}"
        return 1
    fi
    
    # Create backup directory if it doesn't exist
    mkdir -p "$SCRIPT_DIR/backup"
    
    if [[ -f "$target" ]]; then
        echo -e "${YELLOW}Backing up existing $target${NC}"
        timestamp=$(date +"%Y%m%d-%H%M")
        cp "$target" "$SCRIPT_DIR/backup/$(basename "$target").$timestamp"
    fi
    
    echo "Installing $target"
    cp "$source" "$target"
}



# Install required packages
if ! install_packages; then
    echo -e "${RED}Package installation failed. Exiting.${NC}"
    exit 1
fi

# Install dotfiles
if ! install_file "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"; then
    echo -e "${RED}Failed to install .bashrc. Exiting.${NC}"
    exit 1
fi

if ! install_file "$SCRIPT_DIR/.bash_aliases" "$HOME/.bash_aliases"; then
    echo -e "${RED}Failed to install .bash_aliases. Exiting.${NC}"
    exit 1
fi

echo -e "${GREEN}Installation complete!${NC}"
echo "Backups are stored in the backup/ directory"
echo "Run 'source ~/.bashrc' to apply changes"

echo ""
echo -e "${BLUE}Installed packages:${NC}"
echo "- eza/exa: Modern replacement for ls (via package manager)"
echo "- hstr: Command history search (Ctrl+R)"
echo "- autojump: Smart directory navigation"
echo ""
echo -e "${BLUE}Personal customizations:${NC}"
echo "- Create ~/.bashrc.local to add local paths and settings"
 