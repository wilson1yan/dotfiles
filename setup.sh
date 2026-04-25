#!/usr/bin/env bash
set -euo pipefail

echo "=== Installing system packages ==="
sudo apt-get update
sudo apt-get install -y zsh curl tmux ripgrep htop git software-properties-common python3 python3-venv

# ---------------------------------------------------------------------------
# Neovim unstable (0.11+)
# ---------------------------------------------------------------------------
echo "=== Installing Neovim (unstable PPA) ==="
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y neovim

# ---------------------------------------------------------------------------
# uv (Python package/project manager)
# ---------------------------------------------------------------------------
echo "=== Installing uv ==="
curl -LsSf https://astral.sh/uv/install.sh | sh
# Make uv available for the rest of this script
export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------------
# GitHub CLI
# ---------------------------------------------------------------------------
echo "=== Installing GitHub CLI ==="
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt-get update \
  && sudo apt-get install -y gh

# ---------------------------------------------------------------------------
# Claude Code (native installer)
# ---------------------------------------------------------------------------
echo "=== Installing Claude Code ==="
curl -fsSL https://claude.ai/install.sh | bash

# ---------------------------------------------------------------------------
# Zsh setup (no Oh My Zsh)
# ---------------------------------------------------------------------------
echo "=== Setting up Zsh ==="

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions 2>/dev/null || true

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting 2>/dev/null || true

# Write .zshrc
cat > ~/.zshrc << 'EOF'
export PATH="$HOME/.claude/bin:$HOME/.local/bin:$PATH"

PROMPT='%F{111}%m%f %F{245}→%f %F{cyan}%1~%f %F{245}›%f '

alias ls='ls --color=auto'

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey -v
bindkey '^R' history-incremental-search-backward
EOF

# Set zsh as default shell
sudo chsh -s "$(which zsh)" "$(whoami)" || echo "Could not change shell automatically. Run: sudo chsh -s \$(which zsh) \$(whoami)"

# ---------------------------------------------------------------------------
# Tmux config (from wilson1yan/dotfiles)
# ---------------------------------------------------------------------------
echo "=== Setting up tmux ==="
curl -fsSL https://raw.githubusercontent.com/wilson1yan/dotfiles/refs/heads/main/.tmux.conf -o ~/.tmux.conf

# ---------------------------------------------------------------------------
# Neovim config (init.lua from danijar/dotfiles)
# ---------------------------------------------------------------------------
echo "=== Setting up Neovim config ==="
mkdir -p ~/.config/nvim
curl -fsSL https://raw.githubusercontent.com/danijar/dotfiles/refs/heads/master/.config/nvim/init.lua -o ~/.config/nvim/init.lua

echo ""
echo "=== Done! ==="
echo "Open a new terminal or run: exec zsh"
echo "Neovim version: $(nvim --version | head -1)"
echo "uv version: $(uv --version)"
