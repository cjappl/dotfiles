#!/bin/bash

set -e

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' > ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
 
brew bundle

# run install step of fzf for command purposes
$(brew --prefix)/opt/fzf/install

echo "linking all config files" 

dotfiles_dir=$(pwd)

mkdir -p ~/.config/fish > /dev/null
ln $dotfiles_dir/config.fish ~/.config/fish/ > /dev/null

mkdir -p ~/.config/nvim > /dev/null
ln $dotfiles_dir/init.vim ~/.config/nvim/ > /dev/null

ln $dotfiles_dir/.tmux.conf ~/.tmux.conf > /dev/null
ln $dotfiles_dir/.astylerc ~/.astylerc > /dev/null
ln $dotfiles_dir/.ripgreprc ~/.ripgreprc > /dev/null
ln $dotfiles_dir/.xvimrc ~/.xvimrc > /dev/null
ln $dotfiles_dir/gitconfig ~/.gitconfig > /dev/null
ln $dotfiles_dir/gitignore ~/.gitignore > /dev/null
ln $dotfiles_dir/.ideavimrc ~/.ideavimrc > /dev/null

pip3 install pynvim virtualfish pdbpp ipython flake8 jupyter --user

# Install vundle and all git plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
nvim +PluginInstall +qall

yarn install --cwd ~/.vim/bundle/coc.nvim
nvim +CocInstall coc-clangd +qall
nvim +CocInstall coc-pyright +qall

git clone https://github.com/powerline/fonts ~/Downloads/fonts
chmod +x ~/Downloads/fonts/install.sh
bash -c "~/Downloads/fonts/install.sh"

# Remove all icons from desktop
defaults write com.apple.finder CreateDesktop false
killall Finder

mkdir -p ~/code/personal/
git clone https://github.com/wfxr/forgit.git ~/code/personal/forgit

# set fish as your shell
which fish | sudo tee -a /etc/shells
chsh -s $(which fish)

echo "Make sure to change your startup command in iTerm preferences->Profiles->General to be " 
echo "tmux attach -t init; or tmux new -s init" 
echo "tmux attach -t init || tmux new -s init"
echo ""
echo "set fonts for powerline in Iterm Preferences->Profiles->Text->Non-ASCII Font ProFont for Powerline"
echo ""
echo "Allow left alt to scroll in forgit: Iterm Preferences->Profile->Keys->Below the window->Left Option Key = Esc+"
