#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if it's not already installed
if ! command_exists brew; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the current session
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# Check if .Brewfile exists in the current directory
if [ ! -f ".Brewfile" ]; then
    echo ".Brewfile not found in the current directory."
    echo "Please create a .Brewfile in the current directory."
    exit 1
fi

# Copy .Brewfile to home directory as .Brewfile
echo "Copying .Brewfile to home directory as .Brewfile..."
cp .Brewfile ~/.Brewfile

# Install packages from .Brewfile
echo "Installing packages from .Brewfile..."
brew bundle --global --verbose

# Add zsh-autosuggestions to .zshrc if it's not already there
if ! grep -q "zsh-autosuggestions.zsh" ~/.zshrc; then
    echo "Adding zsh-autosuggestions to .zshrc..."
    echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
else
    echo "zsh-autosuggestions is already in .zshrc."
fi

# Create ~/.config/aerospace directory if it doesn't exist
mkdir -p ~/.config/aerospace

# Copy aerospace.toml to ~/.config/aerospace
if [ -f "aerospace.toml" ]; then
    echo "Copying aerospace.toml to ~/.config/aerospace..."
    cp aerospace.toml ~/.config/aerospace/
else
    echo "aerospace.toml not found in the current directory."
    echo "Please make sure aerospace.toml exists in the current directory."
fi

echo "Installation complete!"
