#!/bin/bash
cd "$(dirname "$0")"

# Find all directories that contain .config subdirectories (your packages)
for package in */; do
    package_name=${package%/}  # Remove trailing slash
    
    # Skip non-package directories
    if [[ "$package_name" == "img" || "$package_name" == "old setup" || "$package_name" == "scripts" ]]; then
        continue
    fi
    
    # Only stow if it looks like a dotfiles package
    if [[ -d "$package/.config" || -f "$package/.*" ]]; then
        echo "Stowing $package_name..."
        stow "$package_name"
    fi
done
