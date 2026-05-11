# Dotfiles

Config cá nhân: tmux + Neovim + Fish shell + Lazygit.

## Quick Install

```bash
git clone https://github.com/P-Tiger/nvim.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Bao gồm

| Component | Mô tả |
|-----------|--------|
| **tmux** | Solarized theme, vim keybindings, lazygit popup (`prefix + g`) |
| **iTerm2** | Profile với Solarized colors, FiraCode Nerd Font, true color |
| **Font** | FiraCode Nerd Font Mono (auto-download) |

## Tmux Keybindings

| Key | Action |
|-----|--------|
| `C-b r` | Reload config |
| `C-b h/j/k/l` | Switch pane (vim-style) |
| `C-b C-h/j/k/l` | Resize pane |
| `C-b g` | Lazygit popup |
| `C-b e` | Kill all panes except current |
| `C-b o` | Open current path in Finder |
| `C-S-Left/Right` | Move window |

## Yêu cầu

- tmux >= 3.0
- curl, unzip (để download font)
- Terminal hỗ trợ true color (iTerm2, WezTerm, Ghostty...)

## Sau khi cài

- **iTerm2**: Restart iTerm2 → Profiles → chọn "Default" → Set as Default
- Font đã được set sẵn trong profile: **FiraCode Nerd Font Mono** size **12**
