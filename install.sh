#!/usr/bin/env bash

# Dotfiles Installation Script

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_SRC_DIR="$DOTFILES_DIR/dotfiles"

echo "🏠 Installing dotfiles from $DOTFILES_DIR"

# Function to clean up broken symlinks in home directory
cleanup_broken_symlinks() {
    echo "🧹 Cleaning up broken symlinks in home directory..."
    find "$HOME" -maxdepth 1 -type l ! -exec test -e {} \; -print | while read -r broken_link; do
        echo "Removing broken symlink: $broken_link"
        rm "$broken_link"
    done
}

# Function to create symlinks
create_symlink() {
    local src="$1"
    local dest="$2"
    
    # Check if symlink already exists and points to correct target
    if [ -L "$dest" ]; then
        local current_target=$(readlink "$dest")
        if [ "$current_target" = "$src" ]; then
            echo "✅ Symlink already correct: $dest -> $src"
            return 0
        else
            echo "Updating symlink: $dest (was pointing to $current_target)"
            rm "$dest"
        fi
    elif [ -f "$dest" ] || [ -d "$dest" ]; then
        echo "Backing up existing file/directory: $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi
    
    echo "Creating symlink: $dest -> $src"
    ln -sf "$src" "$dest"
}

# Clean up broken symlinks first
cleanup_broken_symlinks

# Create necessary directories
mkdir -p ~/.config

# Create symlinks for all dotfiles
echo "🔗 Creating symlinks for dotfiles..."
for src_item in "$DOTFILES_SRC_DIR"/.* "$DOTFILES_SRC_DIR"/*; do
    # Skip . and .. directories
    if [[ "$(basename "$src_item")" == "." || "$(basename "$src_item")" == ".." ]]; then
        continue
    fi
    
    if [[ -f "$src_item" || -d "$src_item" ]]; then
        dest_name=$(basename "$src_item")
        create_symlink "$src_item" "$HOME/$dest_name"
    fi
done

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session
    if [[ -d /opt/homebrew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d /usr/local/Homebrew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed"
fi

# Install packages from Brewfile
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo "📦 Installing packages from Brewfile..."
    cd "$DOTFILES_DIR"
    brew bundle
else
    echo "⚠️  No Brewfile found, skipping package installation"
fi

# Set macOS defaults
if [ -f "$DOTFILES_DIR/scripts/macos-defaults.sh" ]; then
    echo "⚙️  Setting macOS defaults..."
    bash "$DOTFILES_DIR/scripts/macos-defaults.sh"
else
    echo "⚠️  No macOS defaults script found, skipping"
fi

# Install WezTerm session manager
if command -v wezterm &> /dev/null; then
    echo "📺 Installing WezTerm session manager..."
    if [ ! -d "$HOME/.config/wezterm/wezterm-session-manager" ]; then
        git clone https://github.com/danielcopper/wezterm-session-manager.git "$HOME/.config/wezterm/wezterm-session-manager"
        echo "✅ WezTerm session manager installed"
    else
        echo "✅ WezTerm session manager already installed"
    fi
else
    echo "⚠️  WezTerm not found, skipping session manager installation"
fi

echo "🎉 Dotfiles installation complete!"
echo "🔄 Please restart your terminal or run 'source ~/.zshrc' to apply changes."