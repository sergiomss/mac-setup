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
#setopt complete_aliases          # complete alisases
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
HISTFILE=~/.zsh_history         # where to store zsh config
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
# heimdall
##
export AWS_PROFILE=heimdall

# extra settings
[[ -f ~/.zshlocal ]] && source ~/.zshlocal
[[ -f ~/.zshrc.env ]] && source ~/.zshrc.env

# powerlevel10k theme
#ZSH_THEME=powerlevel10k/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source $ZSH/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh