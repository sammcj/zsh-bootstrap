#!/usr/bin/env bash

# Sets up my zsh shell just the way I like it
#
# Requirements:
#
# - iCloud synced, internet access
# - Homebrew, git installed

# Brew installs moved to Brewfile (brew bundle dump to generate)
brew bundle

# Git related
pip3 install mu-repo

# Ensure we don't have those pesky ^ in our package.json files
npm config set save-exact=true

npm install -G husky npm-check-updates eslint prettier aws-azure-login editorconfig \
  @typescript-eslint/parser typescript vue-eslint-parser

go install github.com/rhysd/actionlint/cmd/actionlint@latest

##### End installs #####

# Docker compose v2

mkdir -p ~/.docker/cli-plugins/
chmod +x ~/.docker/cli-plugins/docker-compose
ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose

####

grep -q -F '/usr/local/bin/zsh' /etc/shells || echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells

if [ ! -d "${HOME}/.zgen" ]; then
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
  mkdir -p "$HOME"/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
fi

# Setup global gitignore file
if [ ! -d "${HOME}/.gitignoreglobal" ]; then
  ln -s "$HOME"/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/.gitignoreglobal "$HOME"/.gitignoreglobal
  git config --global core.excludesfile ~/.gitignoreglobal
fi

rm -f "$HOME"/.zshrc
ln -s "$HOME"/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/zshrc ~/.zshrc

if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  rm -f ~/.zprezto

  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

  zsh
  setopt EXTENDED_GLOB

  # shellcheck disable=SC2043
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md\(.N\); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done

  ln -s "$HOME"/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/zpreztorc ~/.zprezto
fi

# Configure .gitconfig
ln -sf ~/Library/Mobile\ Documents/com~apple~CloudDocs/Dropbox\ Import/dotfiles/gitconfig ~/.gitconfig
ln -s ~/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/ ~/.gitconfig-no_push

# Configure youtube-dl to always get the best video and audio quality
mkdir -p .config/youtube-dl && echo "-f 'bestvideo+bestaudio'" >~/.config/youtube-dl/config

# https://github.com/barthr/redo
# go install github.com/barthr/redo@latest

# 1Password CLI (not actually using this at the moment)
# brew install --cask 1password/tap/1password-cli

# link main zshrc
rm -f ~/.zshrc
ln -s /Users/samm/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/zshrc ~/.zshrc
