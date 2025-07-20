#!/bin/bash

# Script to install exa from source if not available via package manager

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Installing exa...${NC}"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if exa is already installed
if command_exists exa; then
    echo -e "${GREEN}exa is already installed!${NC}"
    exa --version
    exit 0
fi

# Function to try package manager installation
try_package_manager() {
    echo -e "${BLUE}Trying package manager installation...${NC}"
    
    # Check if we're on Ubuntu/Debian
    if ! command_exists apt; then
        echo -e "${RED}This script only supports Ubuntu/Debian systems${NC}"
        return 1
    fi
    
    if sudo apt update && sudo apt install -y exa; then
        echo -e "${GREEN}Installed exa via apt${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}exa not available via apt${NC}"
    return 1
}

# Function to install Rust
install_rust() {
    echo -e "${YELLOW}Rust/cargo not found. Installing Rust...${NC}"
    
    # Check for curl
    if ! command_exists curl; then
        echo -e "${RED}curl not found. Installing curl first...${NC}"
        
        if command_exists apt; then
            sudo apt update && sudo apt install -y curl
        else
            echo -e "${RED}Could not install curl. Please install it manually:${NC}"
            echo "sudo apt install curl  # Ubuntu/Debian"
            exit 1
        fi
    fi
    
    echo "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    
    # Source Rust environment
    source "$HOME/.cargo/env"
    
    # Add to PATH for current session
    export PATH="$HOME/.cargo/bin:$PATH"
    
    echo -e "${GREEN}Rust installed successfully!${NC}"
}

# Function to install exa from source
install_exa_source() {
    echo -e "${BLUE}Installing exa from source...${NC}"
    
    # Check if Rust is installed
    if ! command_exists cargo; then
        install_rust
    else
        echo -e "${GREEN}Rust/cargo found!${NC}"
    fi
    
    # Ensure cargo is in PATH
    if ! command_exists cargo; then
        source "$HOME/.cargo/env"
        export PATH="$HOME/.cargo/bin:$PATH"
    fi
    
    # Install exa using cargo
    echo -e "${BLUE}Installing exa using cargo...${NC}"
    cargo install exa
    
    # Verify installation
    if command_exists exa; then
        echo -e "${GREEN}exa installed successfully from source!${NC}"
        exa --version
        
        # Add cargo bin to PATH permanently if not already there
        if ! grep -q "cargo/bin" "$HOME/.bashrc"; then
            echo "" >> "$HOME/.bashrc"
            echo "# Add Rust cargo bin to PATH" >> "$HOME/.bashrc"
            echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.bashrc"
            echo -e "${YELLOW}Added cargo/bin to PATH in ~/.bashrc${NC}"
        fi
        
        return 0
    else
        echo -e "${RED}Source installation failed!${NC}"
        return 1
    fi
}

# Main installation logic
main() {
    # Try package manager first
    if try_package_manager; then
        echo -e "${GREEN}Installation complete!${NC}"
        return 0
    fi
    
    # Fall back to source installation
    if install_exa_source; then
        echo ""
        echo -e "${GREEN}Installation complete!${NC}"
        echo "You may need to restart your terminal or run: source ~/.bashrc"
        return 0
    fi
    
    # If both failed
    echo -e "${RED}Installation failed!${NC}"
    echo "Could not install exa via package manager or source compilation."
    echo "You can try installing it manually or use standard ls with colors."
    return 1
}

# Run main function
main "$@" 