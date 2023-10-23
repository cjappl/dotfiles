#!/bin/bash

set -e

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' > $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
 
brew bundle

brew tap homebrew/cask-fonts
brew install font-hack-nerd-font

# run install step of fzf for command purposes
$(brew --prefix)/opt/fzf/install

echo "linking all config files" 

dotfiles_dir=$(pwd)

mkdir -p $HOME/.config/fish > /dev/null
ln $dotfiles_dir/config.fish $HOME/.config/fish/ > /dev/null

mkdir -p $HOME/.config/nvim > /dev/null
ln $dotfiles_dir/init.vim $HOME/.config/nvim/ > /dev/null

ln $dotfiles_dir/.tmux.conf $HOME/.tmux.conf > /dev/null
ln $dotfiles_dir/.astylerc $HOME/.astylerc > /dev/null
ln $dotfiles_dir/.ripgreprc $HOME/.ripgreprc > /dev/null
ln $dotfiles_dir/.xvimrc $HOME/.xvimrc > /dev/null
ln $dotfiles_dir/.gitconfig $HOME/.gitconfig > /dev/null
ln $dotfiles_dir/.gitignore $HOME/.gitignore > /dev/null
ln $dotfiles_dir/.ideavimrc $HOME/.ideavimrc > /dev/null

git config --global core.excludesfile ~/.gitignore

pip3 install pynvim virtualfish pdbpp ipython flake8 jupyter --user

nvim +PlugInstall +qall

THIS_DIR=$(pwd)
cd $HOME/.local/share/nvim/plugged/coc.nvim
npm ci
cd $THIS_DIR
nvim +CocInstall coc-clangd +qall
nvim +CocInstall coc-pyright +qall

patch -p1 -d $HOME/.local/share/nvim/plugged/ayu-vim < $dotfiles_dir/dark_background.ayu.vim.diff

# Remove all icons from desktop
defaults write com.apple.finder CreateDesktop false
killall Finder

mkdir -p $HOME/code/
git clone https://github.com/wfxr/forgit.git $HOME/code/forgit

# set fish as your shell
which fish | sudo tee -a /etc/shells
chsh -s $(which fish)

echo "Make sure to change your startup command in iTerm preferences->Profiles->General to be " 
echo "tmux attach -t init; or tmux new -s init" 
echo "tmux attach -t init || tmux new -s init"
echo ""
echo "set fonts for powerline in Iterm Preferences->Profiles->Text->Non-ASCII Font->Hacker Nerd Font Mono"
echo ""
echo "Allow left alt to scroll in forgit: Iterm Preferences->Profile->Keys->Below the window->Left Option Key = Esc+"
echo ""
echo "Alternatively, try to load the existing profile in the existing json file"
