#!/bin/bash

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install useful packages
brew install fish python nvim tmux fzf ripgrep git ctags bat fastmod

brew install --cask firefox
brew install --cask iterm2

# run install step of fzf for command purposes
$(brew --prefix)/opt/fzf/install

echo "linking all config files" 
mkdir -p ~/.config/nvim > /dev/null
ln ~/dotfiles/config.fish ~/.config/fish/ > /dev/null
ln ~/dotfiles/init.vim ~/.config/nvim/ > /dev/null
ln ~/dotfiles/.tmux.conf ~/ > /dev/null
ln ~/dotfiles/.astylerc ~/ > /dev/null
ln ~/dotfiles/.ripgreprc ~/ > /dev/null
ln ~/dotfiles/.xvimrc ~/ > /dev/null

pip3 install pynvim virtualfish pdbpp ipython flake8

# Install vundle and all git plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
nvim +PluginInstall +qall
nvim +PythonSupportInitPython3 +qall

git clone https://github.com/powerline/fonts ~/Downloads
chmod +x ~/Downloads/fonts/install.sh
bash -c "~/Downloads/fonts/install.sh"

# Remove all icons from desktop
defaults write com.apple.finder CreateDesktop false
killall Finder

echo "Make sure to change your startup command in iTerm preferences->Profiles->General to be " 
echo "tmux attach -t init; or tmux new -s init"
echo "set fonts for powerline in Iterm Preferences->Profiles->Text->Non-ASCII Font ProFont for Powerline"
