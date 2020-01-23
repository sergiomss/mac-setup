#!/bin/sh

MAC_SETUP_DIR="$HOME/mac-setup"
source $MAC_SETUP_DIR/lib/print.sh

pause(){
	echo 
	read -p "Press [Enter] key to continue... " fackEnterKey
	echo
}

verify_ssh_key(){
	path="$HOME/.ssh/id_ed25519.pub"
	step "Verifying ssh key in path: $path"
	if [ ! -f "$path" ]; then
		step "Generating SSH key"
		ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519"
		step "Copy and paste the public portion of the key (below) to GitHub"
		step "============ Public key ============="
		cat ~/.ssh/id_ed25519.pub
		step "====================================="
	else
		step "ssh key already exists"
		step "skipping..."
	fi
	step "Adding the SSH key to the agent now to avoid multiple prompts"
	if ! ssh-add -L -q > /dev/null ; then
		ssh-add
	fi

	finish
}

homebrew(){
	step "Checking Homebrew"
	if ! type brew > /dev/null; then
	step "Installing..."
	/usr/bin/ruby -e \
		"$(curl \
		-fsSL \
		https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
	step "Homebrew is installed!"

	finish
}

install_zsh(){
	step "Installing zsh"
	brew list zsh || brew install zsh

	step "Changing shell to zsh"
	"$MAC_SETUP_DIR/lib/shell.sh"

	step "Installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	step "zsh setup complete!"

	finish
}

hostnames(){
	step "Setting hostnames"
	printf "Insert hostname (ENTER to skip): "
	read hostname
	if [[ -z "$hostname" ]]; then
		echo "skipping..."
	else
		if [[ $(scutil --get HostName) != "$hostname" ]]; then
			step "Setting hostName to '$hostname'"
			scutil --set HostName "$hostname"
		else 
			step "HostName is already '$hostname'. Skipping..."
		fi
		if [[ $(scutil --get LocalHostName) != "$hostname" ]]; then
			step "Setting LocalHostName to '$hostname'"
			scutil --set LocalHostName "$hostname"
		else 
			step "LocalHostName is already '$hostname'. Skipping..."
		fi
		if [[ $(scutil --get ComputerName) != "$hostname" ]]; then
			step "Setting ComputerName to '$hostname'"
			scutil --set ComputerName "$hostname"
		else 
			step "ComputerName is already '$hostname'. Skipping..."
		fi
	fi

	finish
}

iterm2(){
	step "Installing iterm2"
	brew cask install "iterm2"

	finish
}

brew_bundle(){
	step "Installing Homebrew bundle"
	brew bundle --file="$MAC_SETUP_DIR/Brewfile"

	finish
}

config_macos(){
	step "Tweaking macOS config settings (may take a while)"
	"$MAC_SETUP_DIR/lib/macos.sh"

	finish
}

install_zsh_plugins(){
	step "Installing Custom zsh plugins"

	if [[ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
		step "powerlevel10k already installed"
	else 
		step "installing powerlevel10k zsh custom theme" 
		git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
	fi 

	if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
		step "zsh-autosuggestions already installed"
	else 
		step "installing zsh-autosuggestions"
		git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	fi 

	if [ -d "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting" ]; then
		step "fast-syntax-highlighting already installed"
	else 
		step "installing fast-syntax-highlighting"
		git clone https://github.com/zdharma/fast-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
	fi 

	if [ -d "$HOME/.oh-my-zsh/custom/plugins/alias-tips" ]; then
		step "alias-tips already installed"
	else 
		step "installing alias-tips" 
		git clone https://github.com/djui/alias-tips.git ~/.oh-my-zsh/custom/plugins/alias-tips
	fi 

	finish
}

dotfiles(){
	step "checking Vundle"
	if [[ ! -f "$HOME/.vim/bundle/Vundle.vim" ]]; then
		step "installing Vundle"
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	else 
		step "Vundle already installed"
	fi 


	step "Backing up existing dot files"
	mkdir -p $MAC_SETUP_DIR/backup
	cp -ivL ~/.gitconfig $MAC_SETUP_DIR/backup/.gitconfig.old
	cp -ivL ~/.zsh/.p10k.zsh $MAC_SETUP_DIR/backup/.p10k.zsh.old
	cp -ivL ~/.zsh/.zshrc $MAC_SETUP_DIR/backup/.zshrc.old
	cp -ivL ~/.zsh/.zshenv $MAC_SETUP_DIR/backup/.zshenv.old
	cp -ivL ~/.vimrc $MAC_SETUP_DIR/backup/.vimrc.old

	step "Adding symlinks to dot files"
	cp -ivL $MAC_SETUP_DIR/lib/dotfiles/.gitconfig ~/.gitconfig
	mkdir -p $HOME/.zsh
	ln -sfnv $MAC_SETUP_DIR/lib/dotfiles/.zshenv ~/.zshenv
	ln -sfnv $MAC_SETUP_DIR/lib/dotfiles/zsh/.p10k.zsh ~/.zsh/.p10k.zsh
	ln -sfnv $MAC_SETUP_DIR/lib/dotfiles/zsh/.zshrc ~/.zsh/.zshrc
	ln -sfnv $MAC_SETUP_DIR/lib/dotfiles/zsh/.zshenv ~/.zsh/.zshenv
	ln -sfnv $MAC_SETUP_DIR/lib/dotfiles/.vimrc ~/.vimrc

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

	step "Remove backups with 'rm -ir $MAC_SETUP_DIR/backup.*.old'"

	finish
}

setup_all(){
	verify_ssh_key
	homebrew
	install_zsh
	hostnames
	iterm2
	brew_bundle
	config_macos
	install_zsh_plugins
	dotfiles
}

show_menus() {
	clear
	title "mac setup scripts"
	menu_item "0" " all"
	menu_item "1" " ssh key"
	menu_item "2" " homebrew"
	menu_item "3" " zsh and oh-my-zsh"
	menu_item "4" " hostname and computer name"
	menu_item "5" " iterm2"
	menu_item "6" " brew formulas from bundle"
	menu_item "7" " macOS configs"
	menu_item "8" " zsh plugins"
	menu_item "9" " dotfiles"
	menu_item "10" "exit"
}


read_options(){
	echo 
	local choice
	read -p "Enter choice [1-10] " choices
	echo 
	for choice in $choices; do
		case $choice in
			0) title "all" && setup_all && pause ;;
			1) title "ssh key" && verify_ssh_key && pause ;;
			2) title "homebrew" && homebrew && pause ;;
			3) title "zsh and oh-my-zsh" && install_zsh && pause ;;
			4) title "hostname and computer name" && hostnames && pause ;;
			5) title "iterm2" && iterm2 && pause ;;
			6) title "brew formulas from bundle" && brew_bundle && pause ;;
			7) title "macOS configs" && config_macos && pause ;;
			8) title "zsh plugins" && install_zsh_plugins && pause ;;
			9) title "dotfiles" && dotfiles && pause ;;
			10) exit 0;;
			*) echo -e "${RED}Error...${STD}" && sleep 1
		esac
	done 
}

# This is annoying
# trap '' SIGINT SIGQUIT SIGTSTP

while true
do
	show_menus
	read_options
done
