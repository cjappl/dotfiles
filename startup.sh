#!/bin/bash

# exit on errors
set -e

# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install useful packages
brew install python2 python3 nvim tmux fzf ripgrep git 

# run install step of fzf for command purposes
$(brew --prefix)/opt/fzf/install

# clone configs to ~/dotfiles
mkdir ~/dotfiles
git clone https://github.com/cjappl/configs.git ~/dotfiles
ls ~/dotfiles/config.fish > /dev/null

echo "linking all config files" 
mkdir -p ~/.config/nvim > /dev/null
ln ~/dotfiles/config.fish ~/.config/fish/ > /dev/null
ln ~/dotfiles/init.vim ~/.config/nvim/ > /dev/null
ln ~/dotfiles/.tmux.conf ~/ > /dev/null
ln ~/dotfiles/.astylerc ~/ > /dev/null
ln ~/dotfiles/.ripgreprc ~/ > /dev/null

echo "Make sure to change your startup command in iTerm preferences->Profiles->General to be " 
echo "tmux attach -t init; or tmux new -s init"
