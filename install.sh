#!/bin/zsh
# Symlink dotfiles into $HOME. Existing real files are backed up as <file>.backup.
# Add new entries to LINKS as "repo/path:target-in-home".
set -e
DOTFILES="${0:A:h}"
LINKS=(
  "zsh/.zshrc:.zshrc"
  "zsh/.zprofile:.zprofile"
)
for entry in $LINKS; do
  src="$DOTFILES/${entry%%:*}"; dst="$HOME/${entry##*:}"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then echo "ok   $dst"; continue; fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then mv "$dst" "$dst.backup"; echo "backup $dst -> $dst.backup"; fi
  mkdir -p "${dst:h}"; ln -s "$src" "$dst"; echo "link $dst -> $src"
done

# Oh My Zsh custom plugin used by .zshrc
FZF_TAB="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab"
[ -d "$FZF_TAB" ] || git clone --depth 1 https://github.com/Aloxaf/fzf-tab "$FZF_TAB"
