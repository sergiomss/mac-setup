#!/bin/sh

MAC_SETUP_DIR="$HOME/mac-setup"

BOLD="\033[1m"
WHITE="\033[0;37m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
NC="\033[0m"

step() {
  echo
  echo "${YELLOW}❯❯❯ ${WHITE}${BOLD}$1${NC} ${YELLOW}❮❮❮${NC}"
}

# Ask for the administrator password upfront
sudo -v

# Install brew bundles
step "Installing Homebrew bundle"
brew bundle --file="$MAC_SETUP_DIR/Brewfile"

# Tweak the hell out of macOS settings
step "Tweaking macOS config settings (takes a while)"
"$MAC_SETUP_DIR/lib/macos.sh"

step "Installing powerlevel10k zsh custom theme"
test -d ~/.oh-my-zsh/custom/themes/powerlevel10k || git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

step "Installing Custom zsh plugins"
test -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions || git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
test -d ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting || git clone https://github.com/zdharma/fast-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
test -d ~/.oh-my-zsh/custom/plugins/alias-tips || git clone https://github.com/djui/alias-tips.git ~/.oh-my-zsh/custom/plugins/alias-tips

step "Backing up existing dot files"
mkdir -p $MAC_SETUP_DIR/backup
cp -ivL ~/.gitconfig $MAC_SETUP_DIR/backup/.gitconfig.old
cp -ivL ~/.zshrc $MAC_SETUP_DIR/backup/.zshrc.old
cp -ivL ~/.p10k.zsh $MAC_SETUP_DIR/backup/.p10k.zsh.old

step "Adding symlinks to dot files"
cp -ivL $MAC_SETUP_DIR/lib/dotfiles/.gitconfig ~/.gitconfig
mkdir -p $HOME/.zsh
ln -sfnv $MAC_SETUP_DIR/lib/dotfiles/.zshenv ~/.zshenv
ln -sfnv $MAC_SETUP_DIR/lib/dotfiles/zsh/.p10k.zsh ~/.zsh/.p10k.zsh
ln -sfnv $MAC_SETUP_DIR/lib/dotfiles/zsh/.zshrc ~/.zsh/.zshrc
ln -sfnv $MAC_SETUP_DIR/lib/dotfiles/zsh/.zshlocal ~/.zsh/.zshlocal
ln -sfnv $MAC_SETUP_DIR/lib/dotfiles/zsh/.zshenv ~/.zsh/.zshenv

step "Setting up git email"
if [ -z "$(git config user.email)" ]; then
  printf "Insert git email: "
  read git_email
  git config --global user.email "${git_email}"
fi

step "Adding symlinks to scripts in bin"
mkdir -pv ~/.bin
for script in bin/*; do
    ln -sfnv ${MAC_SETUP_DIR}/${script} ~/.bin/${script/bin\//""}
done;

step "Remove backups with 'rm -ir $MAC_SETUP_DIR/.*.old'"
echo "${GREEN}✔ ${WHITE}${BOLD}Done!${NC} 🎉"
