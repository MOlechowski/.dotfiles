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

# Install zsh-vim-mode plugin
echo "Installing zsh-vim-mode plugin..."
git clone https://github.com/softmoth/zsh-vim-mode.git ~/.oh-my-zsh/plugins/zsh-vim-mode

# Add zsh-vim-mode to plugins in .zshrc if it's not already there
if ! grep -q "zsh-vim-mode" ~/.zshrc; then
    echo "Adding zsh-vim-mode to plugins in .zshrc..."
    sed -i '' 's/plugins=(git)/plugins=(git zsh-vim-mode)/' ~/.zshrc
else
    echo "zsh-vim-mode is already in plugins in .zshrc."
fi

# Set KEYTIMEOUT in .zshrc if it's not already set
if ! grep -q "KEYTIMEOUT=" ~/.zshrc; then
    echo "Setting KEYTIMEOUT in .zshrc..."
    echo "export KEYTIMEOUT=1" >> ~/.zshrc
else
    echo "KEYTIMEOUT is already set in .zshrc."
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

# Copy .wezterm.lua to home directory
if [ -f ".wezterm.lua" ]; then
    echo "Copying .wezterm.lua to home directory..."
    cp .wezterm.lua ~/
else
    echo ".wezterm.lua not found in the current directory."
    echo "Please make sure .wezterm.lua exists in the current directory."
fi

echo "Installation complete!"
