#!/bin/bash

# Script to migrate ~/.config directories to ~/mac-setup dotfiles repo
# Run this from your ~/mac-setup directory

DOTFILES_DIR="$PWD"
CONFIG_DIR="$HOME/.config"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting migration of config directories to $DOTFILES_DIR${NC}"
echo ""

# List of directories to migrate (all real directories in ~/.config)
configs_to_migrate=(
    "bat"
    "borders"
    "btop"
    "gh"
    "git"
    "homebrew"
    "k9s"
    "kitty"
    "lazygit"
    "mise"
    "neofetch"
    "rustup"
    "starship"
    "tmux"
    "wezterm"
    "yabai"
    "zsh"
)

# Skip directories that are already symlinks (managed by stow)
skip_if_symlink() {
    local config_name="$1"
    if [[ -L "$CONFIG_DIR/$config_name" ]]; then
        echo -e "${YELLOW}Skipping $config_name (already a symlink - managed by stow)${NC}"
        return 0
    fi
    return 1
}

# Process each config directory
for config in "${configs_to_migrate[@]}"; do
    echo -e "${GREEN}Processing $config...${NC}"
    
    # Skip if already a symlink
    if skip_if_symlink "$config"; then
        continue
    fi
    
    # Check if the source directory exists
    if [[ ! -d "$CONFIG_DIR/$config" ]]; then
        echo -e "${RED}Warning: $CONFIG_DIR/$config doesn't exist, skipping${NC}"
        continue
    fi
    
    # Create the stow package structure
    echo "  Creating package structure for $config"
    mkdir -p "$DOTFILES_DIR/$config/.config"
    
    # Copy the config directory to the stow package
    echo "  Copying $CONFIG_DIR/$config to $DOTFILES_DIR/$config/.config/"
    cp -r "$CONFIG_DIR/$config" "$DOTFILES_DIR/$config/.config/"
    
    # Remove the original directory
    echo "  Removing original $CONFIG_DIR/$config"
    rm -rf "$CONFIG_DIR/$config"
    
    # Stow the package
    echo "  Stowing $config package"
    stow "$config"
    
    # Verify the symlink was created
    if [[ -L "$CONFIG_DIR/$config" ]]; then
        echo -e "${GREEN}  ✓ Successfully stowed $config${NC}"
    else
        echo -e "${RED}  ✗ Failed to stow $config${NC}"
    fi
    
    echo ""
done

echo -e "${GREEN}Migration complete!${NC}"
echo ""
echo "Verify your setup:"
echo "  ls -la ~/.config/"
echo ""
echo "To unstow everything: stow -D */"
echo "To restow everything: stow */"