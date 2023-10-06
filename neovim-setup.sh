#!/bin/bash

OS="$(uname)"

# Remove any existing neovim configurations
echo "Removing existing Neovim configurations..."
rm -rf ~/.config/nvim
rm -rf ~/.vimrc
rm -rf ~/.local/share/nvim

install_mac() {
    local package="$1"
    if ! brew list "$package" &>/dev/null; then
        brew install "$package"
    else
        echo "$package is already installed!"
    fi
}

install_linux() {
    local package="$1"
    local installer="$2"
    local install_command="$3"
    
    if ! command -v "$package" &>/dev/null; then
        sudo "$installer" "$install_command" -y "$package"
    else
        echo "$package is already installed!"
    fi
}

# Install packages based on OS and Distribution
if [[ "$OS" == "Darwin" ]]; then
    echo "Detected MacOS. Installing using Homebrew..."
    
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not detected. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    install_mac "neovim"
    install_mac "fzf"
    install_mac "fd"
    install_mac "tmux"
    brew install --HEAD fzf-tmux 

elif [[ "$OS" == "Linux" ]]; then
    # Linux
    if command -v apt &>/dev/null; then
        echo "Detected Ubuntu/Debian. Installing..."
        install_linux "neovim" "apt-get" "install"
        install_linux "fzf" "apt-get" "install"
        install_linux "fd-find" "apt-get" "install" 
        install_linux "tmux" "apt-get" "install"
        echo "For fzf-tmux, ensure fzf is sourced in your shell."

    elif command -v dnf &>/dev/null; then
        echo "Detected Fedora. Installing..."
        install_linux "neovim" "dnf" "install"
        install_linux "fzf" "dnf" "install"
        install_linux "fd-find" "dnf" "install" 
        install_linux "tmux" "dnf" "install"
        echo "For fzf-tmux, ensure fzf is sourced in your shell."

    elif command -v emerge &>/dev/null; then
        echo "Detected Gentoo. Installing..."
        sudo emerge -av app-editors/neovim
        sudo emerge -av app-shells/fzf
        sudo emerge -av sys-apps/fd
        sudo emerge -av app-misc/tmux
        echo "For fzf-tmux, ensure fzf is sourced in your shell."

    elif command -v pacman &>/dev/null; then
        echo "Detected Arch. Installing..."
        install_linux "neovim" "pacman" "-S"
        install_linux "fzf" "pacman" "-S"
        install_linux "fd" "pacman" "-S"
        install_linux "tmux" "pacman" "-S"
        echo "For fzf-tmux, ensure fzf is sourced in your shell."

    else
        echo "Unsupported Linux distribution detected. Exiting."
        exit 1
    fi

else
    echo "Unsupported OS detected. Exiting."
    exit 1
fi

echo "Installation complete!"
