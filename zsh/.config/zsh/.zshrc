# zsh Options
setopt HIST_IGNORE_ALL_DUPS

# Setup plugins and completions
plugins=(git
         kubectl
         fzf
         zsh-completions
         zsh-autosuggestions
         terraform
         )

autoload -U compinit && compinit

eval "$(/opt/homebrew/bin/brew shellenv)" # brew setup
eval "$(starship init zsh)"               # starship prompt
eval "$(mise activate zsh)"               # activating mise without shims
eval "$(zoxide init zsh)"                 # zoxide 
source <(fzf --zsh)                       # fzf key bindings and fuzzy completion

# Load 1password plugin
[ -f "${XDG_CONFIG_HOME}/op/plugins.sh" ] && source "${XDG_CONFIG_HOME}/op/plugins.sh"

# Load oh-my-zsh
[ -f "$ZSH/oh-my-zsh.sh" ] && source $ZSH/oh-my-zsh.sh

# Load custom zshrc
[ -f "$ZDOTDIR/.zshrc.user" ] && source $ZDOTDIR/.zshrc.user

# Aliases
alias cd='z'

# -- a better cat --
alias cat='bat'
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

# -- a better ls --
alias ls='eza -1 --icons=always --group-directories-first --color=always'
alias ll='eza --long --no-permissions --no-user --time-style=long-iso --total-size'

# -- fix wget --
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

# custom stuff'
alias runtf='terraform init && terraform plan -out "plan" && gum confirm && terraform apply "plan"'

# Only start tmux if not already inside a tmux session
if [ -z "$TMUX" ]; then
    tmux attach-session -t 0 || tmux new-session -s 0
fi

ksc() {
  local dir="${1:-$HOME/.kube}"
  local f names=() sel
  for f in "$dir"/*; do
    [ -f "$f" ] || continue
    names+=("${f##*/}")
  done
  sel=$(printf '%s\n' "${names[@]}" | fzf --layout=reverse) || return
  [ -n "$sel" ] && export KUBECONFIG="$dir/$sel"
}

as() {
  local -A acct
  local name id

  while IFS=$'\t' read -r name id; do
    acct[$name]=$id
  done < <(az account list --query "[].[name,id]" -o tsv) || return

  name=$(printf '%s\n' "${(@k)acct}" | gum filter --placeholder "Select Azure subscription") || return
  echo -e "Setting Azure subscription to \e[33m${name}\e[0m"
  az account set --subscription "${acct[$name]}"
}

gworktree() {
  local branch dir
  branch=$(git branch --all --format='%(refname:short)' | sed 's|^origin/||' | sort -u | fzf) || return
  [[ -z "$branch" ]] && return
  dir="${branch//\//-}"
  git worktree add "$dir" "$branch"
}

gclone() {
  if [[ "$1" != */* ]]; then
    echo "usage: gclone <org>/<repo>" >&2
    return 1
  fi

  local org="${1%%/*}"
  local repo="${1##*/}"
  repo="${repo%.git}"

  mkdir "$repo" && cd "$repo" || return 1
  git clone --bare "git@github.com:$org/$repo.git" .bare || return 1
  git -C .bare config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git -C .bare fetch origin
  echo "gitdir: ./.bare" > .git

  if [[ $(git worktree list | wc -l) -eq 1 ]]; then
    gworktree
  fi
}