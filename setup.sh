#!/usr/bin/env bash
set -euo pipefail

echo "=== Installing system packages ==="
sudo apt-get update
sudo apt-get install -y zsh curl tmux ripgrep htop git software-properties-common build-essential python3 python3-venv

echo "=== Setting up Zsh ==="

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting 2>/dev/null || true
curl -fsSL https://raw.githubusercontent.com/wilson1yan/dotfiles/refs/heads/main/.zshrc -o ~/.zshrc
sudo chsh -s "$(which zsh)" "$(whoami)" || echo "Could not change shell automatically. Run: sudo chsh -s \$(which zsh) \$(whoami)"

echo "=== Installing uv ==="
curl -LsSf https://astral.sh/uv/install.sh | sh
# Make uv available for the rest of this script
export PATH="$HOME/.local/bin:$PATH"

echo "=== Installing Rust ==="
curl https://sh.rustup.rs -sSf | sh -s -- -y
. "$HOME/.cargo/env"

echo "=== Installing Claude Code ==="
curl -fsSL https://claude.ai/install.sh | bash

echo "=== Setting up tmux ==="
curl -fsSL https://raw.githubusercontent.com/wilson1yan/dotfiles/refs/heads/main/.tmux.conf -o ~/.tmux.conf

echo "=== Installing Neovim ==="
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y neovim
mkdir -p ~/.config/nvim
curl -fsSL https://raw.githubusercontent.com/wilson1yan/dotfiles/refs/heads/main/.config/nvim/init.lua -o ~/.config/nvim/init.lua

echo "=== Installing GitHub ==="
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt-get update \
  && sudo apt-get install -y gh

curl -fsSL https://raw.githubusercontent.com/wilson1yan/dotfiles/refs/heads/main/.gitconfig -o ~/.gitconfig

cargo install worktrunk
echo "y" | wt config shell install
