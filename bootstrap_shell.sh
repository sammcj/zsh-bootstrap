#!/usr/bin/env bash

# Sets up my:
# - zsh shell
# - dotfiles
# - packages
#
# Requirements:
# - macOS
# - iCloud synced, internet access
# - Homebrew, git installed
# - Probably some other things I've forgotten

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

## Local functions ##
function link_dotfile() {
  if [[ -f "$1" ]]; then
    echo "File $1 already exists"
    read -r -p "Do you want to replace it with a symlink to the file in this repo? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      rm -f "$1"
      ln -s "${THIS_REPO}/$1" "${HOME}/$1"
    fi
  else
    echo "No changes made to $1"
  fi
}

function clone_repo() {
  if [[ -d "$1" ]]; then
    echo "Directory $1 already exists"
    read -r -p "Do you want to replace it with a clone of the repo $2? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      rm -rf "$1"
      git clone "$2" "$1" --depth=1
    fi
  else
    echo "No changes made to $1"
  fi
}
## End local functions ##

# Completion plugins
gh completion -s zsh >/usr/local/share/zsh/site-functions/_gh

# Docker compose v2
mkdir -p ~/.docker/cli-plugins/
chmod +x ~/.docker/cli-plugins/docker-compose
ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose "${HOME}/.docker/cli-plugins/docker-compose"
####

grep -q -F '/opt/homebrew/bin/zsh' /etc/shells || echo '/opt/homebrew/bin/zsh' | sudo tee -a /etc/shells

clone_repo "${HOME}/.zgen" "https://github.com/tarjoilija/zgen.git"
clone_repo "${HOME}/.tmux/plugins/tpm" "https://github.com/tmux-plugins/tpm"

# Link dotfiles
dotfiles=(".gitignoreglobal" ".gitconfig" ".vimrc" ".gitconfig_nopush" ".gitconfig.private" ".dircolors" ".tmux.conf" ".zshrc")
for dotfile in "${dotfiles[@]}"; do
  link_dotfile "$dotfile"
done
