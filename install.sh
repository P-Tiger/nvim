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

# --- iTerm2 Profile ---
echo "📦 Setting up iTerm2 profile..."
if [[ "$OSTYPE" == "darwin"* ]] && [[ -d "/Applications/iTerm.app" || -d "$HOME/Applications/iTerm.app" ]]; then
  ITERM2_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  mkdir -p "$ITERM2_DIR"
  cp "$DOTFILES_DIR/iterm2/profile.json" "$ITERM2_DIR/dotfiles-profile.json"
  # Set as default profile for new windows/tabs
  /usr/libexec/PlistBuddy -c "Delete ':New Bookmarks'" ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null || true
  /usr/libexec/PlistBuddy -c "Add ':New Bookmarks' array" ~/Library/Preferences/com.googlecode.iterm2.plist
  /usr/libexec/PlistBuddy -c "Add ':New Bookmarks:0' dict" ~/Library/Preferences/com.googlecode.iterm2.plist
  /usr/libexec/PlistBuddy -c "Add ':New Bookmarks:0:Guid' string 'dotfiles-profile'" ~/Library/Preferences/com.googlecode.iterm2.plist
  defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "dotfiles-profile"
  echo "  ✅ iTerm2 profile 'Dotfiles' installed & set as default"
else
  echo "  ⏭️  iTerm2 not found, skipping"
fi

echo ""
echo "🎉 Done! Open iTerm2 and it just works."
