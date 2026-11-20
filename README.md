# dotfiles

My Mac setup: shell, CLI tools, git, Neovim and Claude Code config.

## New Mac

```bash
xcode-select --install
git clone git@github.com:PasinduYeshan/dotfiles.git ~/project/personal/dotfiles
~/project/personal/dotfiles/install.sh
```

`install.sh` is safe to re-run. It installs Homebrew and everything in the `Brewfile`, Oh My Zsh with the fzf-tab plugin, symlinks the configs below into `~`, and installs the latest Node LTS through nvm with Corepack enabled (for pnpm).

Then, by hand:

- `gh auth login`, and add an SSH key to GitHub.
- Open Rancher Desktop once to finish its setup (it provides `docker`).
- Sign in to VS Code Settings Sync. Settings and extensions come from there, not from this repo.
- `sudo xcodebuild -license accept` if a tool complains about the Xcode license.

## What's linked

| Repo | Home |
| --- | --- |
| `zsh/.zshrc`, `zsh/aliases.zsh` | `~/.zshrc` |
| `zsh/.zprofile` | `~/.zprofile` |
| `git/.gitconfig` | `~/.gitconfig` |
| `nvim/` | `~/.config/nvim` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |

Edit files here, not in `~`. To add a config, put it in this repo, add a line to `LINKS` in `install.sh`, and run `./install.sh --links`.

## Shell cheatsheet

- Theme: Oh My Zsh `robbyrussell`, plain `ls`.
- `z <part>` jumps to a remembered folder. `z <part><Tab>` lists every match.
- `y` opens yazi and moves the shell to the folder you quit in.
- Ctrl-R searches history (atuin). Ctrl-T finds files, Alt-C finds folders (fzf).
- Grey suggestions come from history. Press → to accept.
- `cpwd` copies the current path. `cdesk [dir]` opens a folder in the Claude desktop app.
- `lt` tree view, `lg` lazygit, `du1` ncdu, `reload` restarts zsh.
- Git, for fork + upstream repos: `gsync` updates main from upstream, `gnb <name>` starts a branch from upstream main, `grbu` rebases on it, `gpf` force-pushes safely. See `zsh/aliases.zsh` for the rest.

## For an AI agent setting up a new Mac

1. Check the Command Line Tools: `xcode-select -p`. If missing, ask the user to run `xcode-select --install` and wait.
2. Clone this repo to `~/project/personal/dotfiles` (accept GitHub's host key only after checking its fingerprint) and run `install.sh`. Homebrew may ask for the user's password, so run it in the user's terminal.
3. Run `exec zsh` and check: `z`, `y`, `nvim`, `delta`, `atuin` and `node` resolve, and `git config user.name` is set.
4. Leave GitHub sign-in, SSH keys and VS Code Settings Sync to the user.
5. For a repo with an `.nvmrc`, run `nvm install` inside it to get its Node version.
