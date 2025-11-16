#!/bin/bash

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emojis
CHECK="✅"
CROSS="❌"
INFO="ℹ️ "

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Check if it's Arch Linux
    if [ -f /etc/arch-release ]; then
        echo -e "${CYAN}${INFO} Detected Arch Linux${NC}"

        # Check and install zsh
        if ! command -v zsh &> /dev/null; then
            echo -e "${YELLOW}${INFO} Installing zsh...${NC}"
            sudo pacman -S --noconfirm --needed zsh &> /dev/null
            echo -e "${GREEN}${CHECK} zsh installed${NC}"
        else
            echo -e "${GREEN}${CHECK} zsh is already installed${NC}"
        fi

        # Set zsh as default shell
        if [ "$SHELL" != "$(command -v zsh)" ]; then
            echo -e "${YELLOW}${INFO} Setting zsh as default shell...${NC}"
            chsh -s "$(command -v zsh)"
            echo -e "${GREEN}${CHECK} zsh set as default shell${NC}"
        else
            echo -e "${GREEN}${CHECK} zsh is already the default shell${NC}"
        fi

        # Switch to zsh for remainder of script
        if [ -z "$ZSH_VERSION" ]; then
            echo -e "${YELLOW}${INFO} Switching to zsh for remainder of script...${NC}"
            exec zsh "$0" "$@"
        fi

        # Check and install git
        if ! command -v git &> /dev/null; then
            echo -e "${YELLOW}${INFO} Installing git...${NC}"
            sudo pacman -S --noconfirm --needed git &> /dev/null
            echo -e "${GREEN}${CHECK} git installed${NC}"
        else
            echo -e "${GREEN}${CHECK} git is already installed${NC}"
        fi
        
        # Check and install chezmoi
        if ! command -v chezmoi &> /dev/null; then
            echo -e "${YELLOW}${INFO} Installing chezmoi...${NC}"
            sudo pacman -S --noconfirm --needed chezmoi &> /dev/null
            echo -e "${GREEN}${CHECK} chezmoi installed${NC}"
        else
            echo -e "${GREEN}${CHECK} chezmoi is already installed${NC}"
        fi
    else
        echo -e "${RED}${CROSS} This script only supports Arch Linux for Linux systems${NC}"
        exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${CYAN}${INFO} Detected macOS${NC}"

    # zsh is preinstalled on macOS, just check/set as default and switch shell
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        echo -e "${YELLOW}${INFO} Setting zsh as default shell...${NC}"
        chsh -s "$(command -v zsh)"
        echo -e "${GREEN}${CHECK} zsh set as default shell${NC}"
    else
        echo -e "${GREEN}${CHECK} zsh is already the default shell${NC}"
    fi

    if [ -z "$ZSH_VERSION" ]; then
        echo -e "${YELLOW}${INFO} Switching to zsh for remainder of script...${NC}"
        exec zsh "$0" "$@"
    fi

    # Check and install Homebrew
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}${INFO} Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &> /dev/null
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)" &> /dev/null
        fi
        echo -e "${GREEN}${CHECK} Homebrew installed${NC}"
    else
        echo -e "${GREEN}${CHECK} Homebrew is already installed${NC}"
    fi
    
    # Check and install git
    if ! command -v git &> /dev/null; then
        echo -e "${YELLOW}${INFO} Installing git...${NC}"
        brew install git &> /dev/null
        echo -e "${GREEN}${CHECK} git installed${NC}"
    else
        echo -e "${GREEN}${CHECK} git is already installed${NC}"
    fi
    
    # Check and install chezmoi
    if ! command -v chezmoi &> /dev/null; then
        echo -e "${YELLOW}${INFO} Installing chezmoi...${NC}"
        brew install chezmoi &> /dev/null
        echo -e "${GREEN}${CHECK} chezmoi installed${NC}"
    else
        echo -e "${GREEN}${CHECK} chezmoi is already installed${NC}"
    fi
else
    echo -e "${RED}${CROSS} Unsupported OS: $OSTYPE${NC}"
    exit 1
fi

echo -e "${GREEN}${CHECK} Installation complete!${NC}"
