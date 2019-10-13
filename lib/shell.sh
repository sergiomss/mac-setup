#!/bin/sh

SHELL_PATH=$(command -v zsh)

if ! grep "$SHELL_PATH" /etc/shells > /dev/null 2>&1 ; then
  sudo sh -c "echo $SHELL_PATH >> /etc/shells"
fi

sudo chsh -s "$SHELL_PATH" "$USER"