#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 Installing dotfiles from: $DOTFILES_DIR"

# --- Install tmux if not present ---
echo "📦 Checking tmux..."
if command -v tmux &>/dev/null; then
  echo "  ✅ tmux $(tmux -V | cut -d' ' -f2) already installed"
else
  echo "  ⬇️  Installing tmux..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install tmux
  else
    sudo apt-get update && sudo apt-get install -y tmux
  fi
  echo "  ✅ tmux installed"
fi

# --- Tmux config ---
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

# --- iTerm2 Font (Default profile) ---
echo "📦 Setting iTerm2 font on Default profile..."
if [[ "$OSTYPE" == "darwin"* ]] && [[ -d "/Applications/iTerm.app" || -d "$HOME/Applications/iTerm.app" ]]; then
  # Remove old dynamic profile if exists
  rm -f "$HOME/Library/Application Support/iTerm2/DynamicProfiles/dotfiles-profile.json"

  # Set font on Default profile via plist
  /usr/libexec/PlistBuddy -c "Set ':New Bookmarks:0:Normal Font' 'FiraCodeNFM-Reg 12'" \
    "$HOME/Library/Preferences/com.googlecode.iterm2.plist" 2>/dev/null || \
  /usr/libexec/PlistBuddy -c "Add ':New Bookmarks:0:Normal Font' string 'FiraCodeNFM-Reg 12'" \
    "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
  echo "  ✅ Font set to FiraCode Nerd Font Mono 12 on Default profile"
  echo "  ℹ️  Restart iTerm2 to apply"
else
  echo "  ⏭️  iTerm2 not found, skipping"
fi

echo ""
echo "🎉 Done! Open iTerm2 and it just works."
