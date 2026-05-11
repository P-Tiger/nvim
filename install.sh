#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 Installing dotfiles from: $DOTFILES_DIR"

# --- Tmux ---
echo "📦 Setting up tmux config..."
mkdir -p ~/.config/tmux
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" ~/.config/tmux/tmux.conf
ln -sf "$DOTFILES_DIR/tmux/statusline.conf" ~/.config/tmux/statusline.conf
ln -sf "$DOTFILES_DIR/tmux/utility.conf" ~/.config/tmux/utility.conf
ln -sf "$DOTFILES_DIR/tmux/macos.conf" ~/.config/tmux/macos.conf
echo "  ✅ Tmux config linked"

# --- Font: FiraCode Nerd Font ---
echo "📦 Installing FiraCode Nerd Font..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  FONT_DIR="$HOME/Library/Fonts"
else
  FONT_DIR="$HOME/.local/share/fonts"
  mkdir -p "$FONT_DIR"
fi

if ls "$FONT_DIR"/FiraCodeNerdFont* &>/dev/null; then
  echo "  ✅ FiraCode Nerd Font already installed"
else
  echo "  ⬇️  Downloading FiraCode Nerd Font..."
  TMP_DIR=$(mktemp -d)
  curl -fsSL -o "$TMP_DIR/FiraCode.zip" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
  unzip -qo "$TMP_DIR/FiraCode.zip" -d "$FONT_DIR"
  rm -rf "$TMP_DIR"
  if [[ "$OSTYPE" != "darwin"* ]]; then
    fc-cache -f
  fi
  echo "  ✅ FiraCode Nerd Font installed"
fi

# --- iTerm2 Profile ---
echo "📦 Setting up iTerm2 profile..."
ITERM2_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
if [[ -d "$HOME/Library/Application Support/iTerm2" ]]; then
  mkdir -p "$ITERM2_DIR"
  cp "$DOTFILES_DIR/iterm2/profile.json" "$ITERM2_DIR/dotfiles-profile.json"
  echo "  ✅ iTerm2 profile installed (restart iTerm2 to apply)"
else
  echo "  ⏭️  iTerm2 not found, skipping"
fi

echo ""
echo "🎉 Done! Restart tmux or run: tmux source ~/.config/tmux/tmux.conf"
echo ""
echo "⚠️  iTerm2: Go to Profiles → select 'Default' → Set as Default"
