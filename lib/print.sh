#!/bin/sh

BOLD="\033[1m"
WHITE="\033[0;37m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
NC="\033[0m"

function step {
  echo
  echo "${YELLOW}❯❯❯ ${WHITE}${BOLD}$1${NC} ${YELLOW}❮❮❮${NC}"
}

function finish {
  echo "${GREEN}✔ ${WHITE}${BOLD}Done!${NC} 🎉"
}