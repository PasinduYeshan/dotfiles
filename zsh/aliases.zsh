# Personal aliases. Oh My Zsh's git plugin already gives you gst, gco, gcb,
# gaa, gcmsg, gp, gl, glog, grb, gsw ... (run `alias | grep git` for all).

# ---- general ----
alias cpwd='pwd | tr -d "\n" | pbcopy && echo "copied: $PWD"'
alias lt='eza --tree --level=2 --git-ignore'   # plain tree, no icons
alias reload='exec zsh'
alias zshrc='code ~/project/personal/dotfiles'
alias lg='lazygit'
alias du1='ncdu --color dark'

# ---- git: fork (origin) + upstream workflow ----
# default branch of upstream (main/master), falls back to origin
_git_main() { local b; b=$(git symbolic-ref --short refs/remotes/upstream/HEAD 2>/dev/null) && echo "${b#upstream/}" || git_main_branch; }
alias gfu='git fetch upstream --prune'
# update local main from upstream and push it to your fork
gsync() {
  local b=$(_git_main); [ -z "$b" ] && b=main
  git fetch upstream --prune && git switch "$b" && git merge --ff-only "upstream/$b" && git push origin "$b"
}
# rebase the current branch onto latest upstream main
alias grbu='git fetch upstream && git rebase upstream/$(_git_main)'
# new branch from latest upstream main: gnb feat/my-thing
gnb() { git fetch upstream && git switch -c "$1" "upstream/$(_git_main)"; }
alias gpf='git push --force-with-lease'
alias gpsu='git push -u origin HEAD'
alias gundo='git reset --soft HEAD~1'
alias gwip='git add -A && git commit -m "wip" --no-verify'
alias glo='git log --oneline --graph --decorate -20'
alias gclean='git branch --merged | grep -vE "^\*|main|master|develop" | xargs -n1 git branch -d'

# ---- thunder-desk ----
# desk [open|start|stop|restart|status|sync|publish|logs|dir]: run the desk from anywhere
alias desk="$HOME/project/personal/thunder-desk/bin/desk"

# ---- Claude ----
# cdesk [dir]: open a Claude desktop app session in dir (default: current folder)
cdesk() { (cd "${1:-.}" && claude --desktop); }
