#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

# Vim stuff
mkdir -p ~/.vim/undodir

function doIt() {
	rsync --exclude ".git/" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE" \
		--exclude *.yml \
		-avh --no-perms . ~;
	echo "Installing powerline9k theme for zsh...";
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k;
        echo "";
        echo "Cloning Menlo for Powerline Font. Switch it on using Shell preferences.";
	git clone https://github.com/abertsch/Menlo-for-Powerline.git ~/.fonts/;
	source ~/.zshrc;
}

function install_conda() {
	wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda3.sh;
	bash /tmp/miniconda3.sh;
        conda env create -f base_env.yml;
        jupyter labextension install @ryantam626/jupyterlab_code_formatter
        jupyter serverextension enable --py jupyterlab_code_formatter
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
if [ "$2" == "--install_conda" ]; then
	install_conda;
fi;
unset doIt;
unset install_conda;
