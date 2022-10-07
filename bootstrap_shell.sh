#!/usr/bin/env bash

# Sets up my zsh shell just the way I like it
#
# Requirements:
#
# - iCloud synced, internet access
# - Homebrew, git installed

THIS_REPO="${HOME}/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/"

# Brew installs moved to Brewfile (brew bundle dump to generate)
brew bundle

# Git related
pip3 install -U mu-repo

# Ensure we don't have those pesky ^ in our package.json files
npm config set save-exact=true

npm install -G husky npm-check-updates eslint prettier aws-azure-login editorconfig \
  @typescript-eslint/parser typescript

go install github.com/rhysd/actionlint/cmd/actionlint@latest

##### End installs #####

# Completion plugins
gh completion -s zsh >/usr/local/share/zsh/site-functions/_gh

# Docker compose v2

mkdir -p ~/.docker/cli-plugins/
chmod +x ~/.docker/cli-plugins/docker-compose
ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose

####

grep -q -F '/opt/homebrew/bin/zsh' /etc/shells || echo '/opt/homebrew/bin/zsh' | sudo tee -a /etc/shells

if [[ ! -d "${HOME}/.zgen" ]]; then
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen" --depth=1
fi

if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
  mkdir -p "${HOME}/.tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm" --depth=1
fi

# link global gitignore file
if [[ ! -f "${HOME}/.gitignoreglobal" ]]; then
  ln -s "${THIS_REPO}/.gitignoreglobal" "${HOME}/.gitignoreglobal"
  git config --global core.excludesfile ~/.gitignoreglobal
fi

# link global gitconfig file
if [[ ! -f "${HOME}/.gitconfig" ]]; then
  ln -s "${THIS_REPO}/.gitconfig" "${HOME}/.gitconfig"
fi

# link global gitconfig for nopush branches
if [[ ! -f "${HOME}/.gitconfig_nopush" ]]; then
  ln -s "${THIS_REPO}/.gitconfig_nopush" "${HOME}/.gitconfig_nopush"
fi

# link private gitconfig file if it exists
if [[ ! -f "${HOME}/.gitconfig.private" ]]; then
  if [[ ! -f ".gitconfig.private" ]]; then
    echo "Error: .gitconfig.private not found - won't link"
  else
    ln -s "${THIS_REPO}/.gitconfig.private" "${HOME}/.gitconfig.private"
  fi
fi

rm -f "${HOME}/.zshrc"
ln -s "${THIS_REPO}/zshrc" ~/.zshrc

if [[ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
  rm -f ~/.zprezto

  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" --depth=1

  zsh
  setopt EXTENDED_GLOB

  # shellcheck disable=SC2043
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md\(.N\); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done

  ln -s "${THIS_REPO}/zpreztorc" ~/.zprezto
fi

# Configure youtube-dl to always get the best video and audio quality
mkdir -p .config/youtube-dl && echo "-f 'bestvideo+bestaudio'" >~/.config/youtube-dl/config

# 1Password CLI (not actually using this at the moment)
# brew install --cask 1password/tap/1password-cli

# link main zshrc
rm -f ~/.zshrc
ln -s /Users/samm/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/zshrc ~/.zshrc
