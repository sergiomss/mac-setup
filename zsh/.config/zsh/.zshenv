# XDG setup
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_STATE_HOME=${HOME}/.local/state
export XDG_CACHE_HOME=${HOME}/.cache

# AWS vars
export AWS_SHARED_CREDENTIALS_FILE=${XDG_CONFIG_HOME}/aws/credentials
export AWS_CONFIG_FILE=${XDG_CONFIG_HOME}/aws/config

# ZSH vars
export ZSH=${XDG_DATA_HOME}/oh-my-zsh
export ZDOTDIR=${ZDOTDIR:=${XDG_CONFIG_HOME}/zsh}
export HISTFILE=${XDG_CONFIG_HOME}/zsh/.zsh_history
export UPDATE_ZSH_DAYS=1
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/ohmyzsh"
export COMPLETION_WAITING_DOTS=true

# Starship vars
export STARSHIP_CONFIG=${XDG_CONFIG_HOME}/starship/starship.toml
export STARSHIP_CACHE=${XDG_CACHE_HOME}/starship

# Go vars
export GOPATH="$XDG_DATA_HOME"/go

# NPM vars
export NPM_CONFIG_USERCONFIG=${XDG_CONFIG_HOME}/npm/npmrc

# Mise 
export MISE_CACHE_DIR=${XDG_CACHE_HOME}/mise

# Magefile
export MAGEFILE_CACHE=${XDG_CACHE_HOME}/magefile

# Terminfo - commented out because it was showing an error: tput unknown terminal "xterm-kitty"
# export TERMINFO="$XDG_DATA_HOME"/terminfo                                     
# export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo

# Docker 
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker

# Rust
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

# less
export LESSHISTFILE="$XDG_STATE_HOME"/less/history

# PATH
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/opt/homebrew/bin
export PATH="$PATH:$(npm config get prefix)/bin"

[ -f "$XDG_DATA_HOME/cargo/env" ] && . "$XDG_DATA_HOME/cargo/env"
