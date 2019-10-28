##
# oh-my-zsh
##
export ZSH="$HOME/.oh-my-zsh"
export TERM="xterm-256color"

##
# Plugins
##
plugins=(
  kubectl
  alias-tips
  dirhistory
  fast-syntax-highlighting
  git
  zsh-autosuggestions
  zsh-navigation-tools
  helm
  thefuck
)

##
# Completion
##
autoload -U compinit
compinit
zmodload -i zsh/complist
setopt hash_list_all            # hash everything before completion
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word
setopt complete_in_word         # allow completion from within a word/phrase
setopt correct                  # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.

# sections completion !
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # case insensitive completion
zstyle ':completion:*' menu select=1 _complete _ignored _approximate # enable completion menu

##
# Pushd
##
setopt auto_pushd               # make cd push old dir in dir stack
setopt pushd_ignore_dups        # no duplicates in dir stack
setopt pushd_silent             # no dir stack after pushd or popd
setopt pushd_to_home            # `pushd` = `pushd $HOME`

##
# History
##
HISTFILE=~/.zsh/.zsh_history    # where to store zsh config
HISTSIZE=1024                   # big history
SAVEHIST=1024                   # big history
setopt append_history           # append
setopt hist_ignore_all_dups     # no duplicate
unsetopt hist_ignore_space      # ignore space prefixed commands
setopt hist_reduce_blanks       # trim blanks
setopt hist_verify              # show before executing history commands
setopt inc_append_history       # add commands as they are typed, don't wait until shell exit
setopt share_history            # share hist between sessions
setopt bang_hist                # !keyword

##
# Various
##
setopt auto_cd                  # if command is a path, cd into it
setopt auto_remove_slash        # self explicit
setopt chase_links              # resolve symlinks
setopt correct                  # try to correct spelling of commands
setopt extended_glob            # activate complex pattern globbing
setopt glob_dots                # include dotfiles in globbing
setopt print_exit_value         # print return value if non-zero
unsetopt beep                   # no bell on error
unsetopt bg_nice                # no lower prio for background jobs
unsetopt clobber                # must use >| to truncate existing files
unsetopt hist_beep              # no bell on error in history
unsetopt hup                    # no hup signal at shell exit
unsetopt ignore_eof             # do not exit on end-of-file
unsetopt list_beep              # no bell on ambiguous completion
unsetopt rm_star_silent         # ask for confirmation for `rm *' or `rm path/*'
unsetopt prompt_cr prompt_sp    # disable % at the end of the line
print -Pn "\e]0; %n@%M: %~\a"   # terminal title

source $ZSH/oh-my-zsh.sh

##
# Extra Settings
##
[[ -f $ZDOTDIR/.zshlocal ]] && source $ZDOTDIR/.zshlocal
[[ -f $ZDOTDIR/.zshenv ]] && source $ZDOTDIR/.zshenv

##
# powerlevel10k theme
##
source $ZSH/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
[[ -f $ZDOTDIR/.p10k.zsh ]] && source $ZDOTDIR/.p10k.zsh

##
# Aliases
##

# Easier navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

# Always enable colored `grep` output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ls="command ls ${colorflag}"                                                # Always use color output for `ls`
alias sudo='sudo '                                                                # Enable aliases to be sudo’ed
alias week='date +%V'                                                             # Get week number
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'     # Google Chrome
alias c="tr -d '\n' | pbcopy"                                                     # Trim new lines and copy to clipboard
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"                     # Recursively delete `.DS_Store` files
alias stfu="osascript -e 'set volume output muted true'"                          # Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias pumpitup="osascript -e 'set volume output volume 100'"
alias reload="exec ${SHELL} -l"                                                   # Reload the shell (i.e. invoke as a login shell)
alias path='echo -e ${PATH//:/\\n}'                                               # Print each PATH entry on a separate line
alias watch='watch '                                                              # make aliases work with 'watch'

# Kill all the tabs in Chrome to free up memory
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

##
# Functions
##
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != *"nothing to commit"* ]] && echo "*"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}