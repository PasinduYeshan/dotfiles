#!/bin/zsh
# Set up a Mac from this repo. Safe to re-run: every step skips what is already done.
#   ./install.sh          everything (Homebrew packages, Oh My Zsh, links, Node)
#   ./install.sh --links  only the symlinks
set -e
DOTFILES="${0:A:h}"

# "repo/path:target-in-home". Existing real files are backed up as <target>.backup.
LINKS=(
  "zsh/.zshrc:.zshrc"
  "zsh/.zprofile:.zprofile"
  "git/.gitconfig:.gitconfig"
  "nvim:.config/nvim"
  "claude/CLAUDE.md:.claude/CLAUDE.md"
)

link_all() {
  echo "==> Symlinks"
  for entry in $LINKS; do
    src="$DOTFILES/${entry%%:*}"; dst="$HOME/${entry##*:}"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then echo "ok     ~/${entry##*:}"; continue; fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then mv "$dst" "$dst.backup"; echo "backup ~/${entry##*:} -> ~/${entry##*:}.backup"; fi
    mkdir -p "${dst:h}"; ln -s "$src" "$dst"; echo "link   ~/${entry##*:}"
  done
}

if [ "$1" = "--links" ]; then link_all; exit 0; fi

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Install the Command Line Tools first: xcode-select --install"; exit 1
fi

echo "==> Homebrew"
if [ ! -x /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file="$DOTFILES/Brewfile"

echo "==> Oh My Zsh"
if [ ! -d ~/.oh-my-zsh ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
FZF_TAB="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab"
[ -d "$FZF_TAB" ] || git clone --depth 1 https://github.com/Aloxaf/fzf-tab "$FZF_TAB"

link_all

echo "==> Node (nvm)"
mkdir -p ~/.nvm
export NVM_DIR="$HOME/.nvm"
. /opt/homebrew/opt/nvm/nvm.sh
nvm ls default >/dev/null 2>&1 || { nvm install --lts; nvm alias default 'lts/*'; }
# pnpm: Corepack picks the version each repo pins. Node 25+ no longer ships Corepack.
if command -v corepack >/dev/null; then corepack enable
elif ! command -v pnpm >/dev/null; then npm install -g pnpm
fi

echo
echo "Done. Open a new terminal (or run: exec zsh)."
echo "Still manual: gh auth login, SSH key for GitHub, open Rancher Desktop once, sign in to VS Code Settings Sync."
