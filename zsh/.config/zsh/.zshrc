# zsh Options
setopt HIST_IGNORE_ALL_DUPS

# Setup plugins and completions
plugins=(git
         kubectl
         fzf
         zsh-completions
         zsh-autosuggestions
         terraform
         ssh-agent
         autoupdate
         )

autoload -U compinit && compinit

eval "$(/opt/homebrew/bin/brew shellenv)" # brew setup
eval "$(starship init zsh)"               # starship prompt
eval "$(mise activate zsh)"               # activating mise without shims
eval "$(zoxide init zsh)"                 # zoxide 
source <(fzf --zsh)                       # fzf key bindings and fuzzy completion
source "${XDG_CONFIG_HOME}/op/plugins.sh" # op plugin

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

neofetch
