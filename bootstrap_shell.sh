#!/bin/bash

# Sets up my zsh shell just the way I like it
#
# Requirements:
#
# - Dropbox installed and synced
# - Internet access
# - Homebrew, git installed

brew install fzf tmux zsh git sekey gpg jq youtube-dl nmap mtr testssl \
  ncdu xz kube-ps1 appcleaner handbrake imageoptim launchcontrol onyx stay wireshark \
  speedtest-cli jq awscli iperf3 quicklook-json qlmarkdown qlstephen qlcolorcode vlc \
  drawio launchrocket haptic-touch-bar vyprvpn qbittorrent osxfuse git-quick-stats \
  bat git-delta duf cheat hyperfine testssl terraforming telnet cheat aria2 tflint \
  tfenv kubernetes-cli podman docker lima colima

grep -q -F '/usr/local/bin/zsh' /etc/shells || echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells

# Disabled antigen in favour of zgen for performance
# if [ ! -d "${HOME}/.antigen" ]; then
#   git clone https://github.com/zsh-users/antigen.git "${HOME}/.antigen"
# fi

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
mkdir -p .config/youtube-dl && echo "-f 'bestvideo+bestaudio'" > ~/.config/youtube-dl/config
