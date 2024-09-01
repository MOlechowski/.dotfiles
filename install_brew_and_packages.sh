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

# Check if Brewfile exists
if [ ! -f "Brewfile" ]; then
    echo "Brewfile not found in the current directory."
    echo "Please create a Brewfile or specify its path."
    exit 1
fi

# Install packages from Brewfile
echo "Installing packages from Brewfile..."
brew bundle

echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

echo "Installation complete!"
