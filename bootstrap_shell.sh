#!/bin/bash

# Sets up my zsh shell just the way I like it
#
# Requirements:
#
# - iCloud synced, internet access
# - Homebrew, git installed

# Items required for the shell
brew install fzf tmux zsh git gpg jq kube-ps1 bat git-delta cheat aria2 \
  bash bash-completion grep gawk lzo lz4 wget zlib zstd zsh-autosuggestions \
  zsh-completions zsh-history-substring-search zsh-navigation-tools

# Favour installing apps from the App store as they come with security sandboxing

brew install mas
mas install 1532419400 904280696 1289583905 1166066070 937984704 425424353 1262957439 \
  1006739057 411643860 1529448980 1091189122 803453959 1048732801 409183694 1333542190 \
  1569813296 1270075435 921923693 490179405 1497506650 413969927 1538761576

# 1333542190 1Password 7
# 1569813296 1Password for Safari
# 1270075435 Strongbox
# 1532419400 MeetingBar
# 904280696 Things
# 1289583905 Pixelmator Pro
# 1166066070 Bumpr
# 409183694 Keynote
# 937984704 Amphetamine
# 425424353 The Unarchiver
# 1262957439 Textual IRC Client
# 1006739057 NepTunes
# 411643860 DaisyDisk
# 1529448980 Reeder
# 409201541 Pages
# 1091189122 Bear
# 803453959 Slack
# 1048732801 NZB Control
# 921923693 LibreOffice Vanilla
# 490179405 Okta Verify
# 1497506650 Yubico Authenticator
# 413969927 Audiobook Binder
# 1538761576 Authy Authenticator App

# The following brew installs aren't required to bootstrap the shell

# Git related
brew install git-delta git-quick-stats git-secrets gitleaks gh icdiff pre-commit gitahead

pip3 install mu-repo

# Cloud things
brew install aws-cdk aws-iam-authenticator aws-okta aws-sam-cli aws-shell aws-sso-util \
  awscli aws-azure-login terraforming terraform cfn-lint tfenv tflint eksctl lazygit s3cmd \
  terraform-docs terraform-ls google-cloud-sdk

# Build and dev related
brew install golang autoconf autoenv automake cmake go gcc make node hadolint nvm pyenv \
  rust ruby-completion shellcheck yq yarn jsonlint

npm install -G husky npm-check-updates eslint prettier

# Containers related
brew install docker-slim podman docker lima colima kubernetes-cli docker-compose-completion \
  dive helm k9s lens

# Other tools/apps
brew install appcleaner launchcontrol stay drawio launchrocket qbittorrent osxfuse ncdu xz \
  duf telnet gnu-sed gnupg graphviz fd htop lftp k3d links parallel pandoc p7zip \
  openssl@3 rsync authy bettertouchtool appcleaner calibre drawio fedora-media-writer knockknock \
  ngrok macdown launchcontrol launchrocket monodraw onyx qlvideo pdfshaver qbittorrent \
  sekey send-to-kindle serial Secretive asdf

# Testing related
brew install fio nmap mtr testssl speedtest-cli iperf3 wireshark hyperfine mtr siege \
  testssl paw postman

# Media related
brew install yt-dlp handbrake imageoptim vlc flac fnm ffmpeg x265 x264 xvid lame xld

##### End installs #####

grep -q -F '/usr/local/bin/zsh' /etc/shells || echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells

if [ ! -d "${HOME}/.zgen" ]; then
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
fi

# Setup global gitignore file
if [ ! -d "${HOME}/.gitignoreglobal" ]; then
  ln -s $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/.gitignoreglobal $HOME/.gitignoreglobal
  git config --global core.excludesfile ~/.gitignoreglobal
fi

rm -f ~/.zshrc
ln -s $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/zshrc ~/.zshrc

if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  rm -f ~/.zprezto

  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

  zsh
  setopt EXTENDED_GLOB

  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md\(.N\); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done

  ln -s $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/zpreztorc ~/.zprezto
fi

# Configure .gitconfig
ln -sf ~/Library/Mobile\ Documents/com~apple~CloudDocs/Dropbox\ Import/dotfiles/gitconfig ~/.gitconfig

# Configure youtube-dl to always get the best video and audio quality
mkdir -p .config/youtube-dl && echo "-f 'bestvideo+bestaudio'" >~/.config/youtube-dl/config

# https://github.com/barthr/redo
go install github.com/barthr/redo@latest
