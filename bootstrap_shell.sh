#!/bin/bash

# Sets up my zsh shell just the way I like it
#
# Requirements:
#
# - Dropbox installed and synced
# - Internet access
# - Homebrew, git installed

brew install -y fzf tmux tmux-cssh zsh git sekey

grep -q -F '/usr/local/bin/zsh' /etc/shells || echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells

if [ ! -d "$HOME/.antigen" ]; then
  git clone https://github.com/zsh-users/antigen.git "$HOME/.antigen"
fi

rm -f ~/.zshrc
ln -s ~/Dropbox/dotfiles/shell_config/zshrc ~/.zshrc

if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  rm -f ~/.zprezto

  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

  zsh
  setopt EXTENDED_GLOB

  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md\(.N\); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done

  ln -s ~/Dropbox/dotfiles/shell_config/zpreztorc ~/.zprezto
fi
