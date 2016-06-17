#!/bin/bash

# Sets up my zsh shell just the way I like it
#
# Requirements:
#
# - Dropbox installed and synced
# - Internet access
# - Homebrew installed

brew install -y fzf tmux tmux-cssh zsh git

grep -q -F '/usr/local/bin/zsh' /etc/shells || echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells

if [ ! -d "$HOME/.antigen" ]; then
  git clone https://github.com/zsh-users/antigen.git "$HOME/.antigen"
fi

rm -f ~/.zshrc
ln -s ~/Dropbox/dotfiles/shell_config/zshrc ~/.zshrc

