#!/usr/bin/env bash

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
  1569813296 1270075435 921923693 490179405 1497506650 413969927 1538761576 1233965871 \
  1365531024

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
# 1233965871 Screenbrush
# 1365531024 1blocker for safari

# The following brew installs aren't required to bootstrap the shell

# Git related
brew install git-delta git-quick-stats git-secrets gitleaks gh icdiff pre-commit detect-secrets

pip3 install mu-repo

# Cloud things
brew install aws-cdk aws-iam-authenticator aws-okta aws-shell aws-sso-util \
  awscli terraforming terraform cfn-lint tfenv tflint eksctl lazygit s3cmd \
  terraform-docs terraform-ls

brew tap aws/tap
brew install aws-sam-cli

# Build and dev related
brew install golang autoconf autoenv automake cmake go gcc make node hadolint pyenv \
  rust ruby-completion shellcheck yq yarn jsonlint docker-credential-helper fnm \
  gnu-getopt shfmt shottr

brew install noahgorstein/tap/jqp # https://github.com/noahgorstein/jqp

# Ensure we don't have those pesky ^ in our package.json files
npm config set save-exact=true

npm install -G husky npm-check-updates eslint prettier aws-azure-login editorconfig \
  @typescript-eslint/parser typescript vue-eslint-parser

# Containers related
brew install docker-slim podman docker lima colima docker-compose-completion dive docker-compose

# K8s related
brew install kubernetes-cli k9s lens helm

# Other tools/apps
brew install appcleaner launchcontrol stay drawio launchrocket qbittorrent osxfuse ncdu xz \
  duf telnet gnu-sed gnupg graphviz fd htop lftp k3d links parallel pandoc p7zip \
  openssl@3 rsync authy bettertouchtool appcleaner calibre drawio fedora-media-writer knockknock \
  ngrok macdown launchcontrol launchrocket monodraw onyx qlvideo pdfshaver qbittorrent \
  sekey send-to-kindle serial Secretive thefuck hot

# # Quicklook plugins https://github.com/sindresorhus/quick-look-plugins
# replaced with Peek from the app store.
# brew install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize apparency qlvideo webpquicklook
# xattr -d -r com.apple.quarantine ~/Library/QuickLook

# Testing related
brew install fio nmap mtr testssl speedtest-cli iperf3 wireshark hyperfine mtr siege \
  testssl paw

go install github.com/rhysd/actionlint/cmd/actionlint@latest

# Media related
brew install yt-dlp handbrake imageoptim vlc flac ffmpeg x265 x264 xvid lame xld

# Fonts
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
brew install font-blex-mono-nerd-font

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
