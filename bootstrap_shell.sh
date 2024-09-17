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

# If ssh keys are not already added, add them
if ! ssh-add -l | grep -e 'ED25519\|RSA'; then
  ssh-add --apple-use-keychain ~/.ssh/id_*.key
fi

function installHomebrew() {
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Brew installs moved to Brewfile (brew bundle dump to generate)
  brew bundle
}

function installPythonPackages() {
  curl -LsSf https://astral.sh/uv/install.sh | sh # Install uv via astral

  pushd "$HOME"
  uv venv
  . venv/bin/activate
  popd
  uv pip3 install -U mu-repo oterm

  oterm --install-completion zsh
}

# Ensure we don't have those pesky ^ in our package.json files
npm config set save-exact=true

function installNpmPackages() {
  npm install -g npm-check-updates eslint prettier editorconfig \
    @typescript-eslint/parser typescript ts-node bash-language-server
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

function installGoPackages() {
  go install github.com/rhysd/actionlint/cmd/actionlint@latest
  go install github.com/nao1215/gup@latest # gup - updates go packages
  go install github.com/jesseduffield/lazydocker@latest
  go install github.com/rs/dnstrace@latest

}

function installCargoPackages() {
  if ! command -v cargo &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # Install rust via rustup
  fi

  # Install cargo packages
  cargo install cai code2prompt gitu lazycli
}

function installAsdf() {
  ### asdf ###

  ## install plugins
  # languages
  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf plugin-add yarn https://github.com/twuni/asdf-yarn.git
  asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
  asdf plugin-add rust https://github.com/code-lever/asdf-rust.git

  # asdf plugin-add python https://github.com/danhper/asdf-python.git

  # Tools that are only available via asdf
  asdf plugin-add action-validator https://github.com/mpalmer/action-validator.git
  asdf plugin-add semver https://github.com/mathew-fleisch/asdf-semver.git

  # # Terraform
  # asdf plugin-add tfenv https://github.com/carlduevel/asdf-tfenv.git
  # asdf plugin-add tfsec https://github.com/woneill/asdf-tfsec.git
  # asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
  # asdf plugin-add terraform-ls https://github.com/asdf-community/asdf-hashicorp.git
  # asdf plugin-add terraform-validator https://github.com/asdf-community/asdf-hashicorp.git
  # asdf plugin-add tfupdate https://github.com/yuokada/asdf-tfupdate.git
  # asdf plugin-add tfstate-lookup https://github.com/carnei-ro/asdf-tfstate-lookup.git

  # Install all asdf plugins
  asdf plugin-update --all
}

function installDockerCompose() {
  # Docker compose v2
  mkdir -p ~/.docker/cli-plugins/
  chmod +x ~/.docker/cli-plugins/docker-compose
  ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose "${HOME}/.docker/cli-plugins/docker-compose"
}

function installZshZgen() {
  mkdir -p "${HOME}/.zsh.d"
  grep -q -F '/opt/homebrew/bin/zsh' /etc/shells || echo '/opt/homebrew/bin/zsh' | sudo tee -a /etc/shells
  clone_repo "${HOME}/.zgen" "https://github.com/tarjoilija/zgen.git"
}

function installTmuxTpm() {
  clone_repo "${HOME}/.tmux/plugins/tpm"
}

## Local functions ##
function link_dotfile() {
  # Error if there are more than two arguments
  if [[ $# -gt 2 ]]; then
    echo "Too many arguments"
    return 1
  fi
  # Check if there is a second argument, if so, use it as the destination file name otherwise use the source file name
  if [ -z "$2" ]; then
    local DEST="${HOME}/${1}"
  else
    local DEST="${HOME}/${2}"
    # Check if the directories up to the destination file exist, if not, create them
    if [ ! -d "$(dirname "${DEST}")" ]; then
      mkdir -p "$(dirname "${DEST}")"
    fi
  fi
  if [[ -f "$DEST" ]]; then
    echo "File $DEST already exists"
    read -r -p "Do you want to replace it with a symlink to the file in this repo? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      rm -f "$DEST"
      ln -s "${THIS_REPO}/$1" "${HOME}/${DEST}"
    else
      exit 1
      #shellcheck disable=SC2317
      echo "No changes made to ${DEST}"
    fi

  fi
}

function gitConfig() {
  clone_repo "${HOME}/.git/fuzzy" "https://github.com/bigH/git-fuzzy.git" && ln -s "${HOME}/.git/fuzzy/bin/git-fuzzy" "${HOME}/bin/git-fuzzy"

  # git
  git config --global branch.autoSetupMerge true
  git config --global --add --bool push.autoSetupRemote true
  git config --global rerere.enabled true
  git config --global rerere.autoUpdate true
  git config --global branch.sort -committerdate
  git config --global alias.fpush push --force-with-lease
  git config --global help.autocorrect 1
  git config --global diff.algorithm histogram
  git config --global rebase.autosquash true
  git config --global merge.conflictstyle zdiff3
  git config --global fetch.prunetags true
  git config --global log.date iso
  git config --global diff.tool difftastic # brew install difftastic / cargo install --locked difftastic
  git config --global push.followtags true
  git maintenance start
  git maintenance register
}

function macOSConfig() {
  # Completion plugins
  gh completion -s zsh >/usr/local/share/zsh/site-functions/_gh

  # Increase the density of status bar icons
  defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 3

  echo "Do you want to enable touchID for sudo? [y/N]"
  read -r response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    source '9-functions.rc'
    touchid_sudo
  fi
}

function configureDotfiles() {
  # Link dotfiles
  dotfiles=(".gitignoreglobal" ".gitconfig" ".vimrc" ".gitconfig_nopush" ".gitconfig.private" ".dircolors" ".tmux.conf" ".zshrc" ".asdfrc")
  for dotfile in "${dotfiles[@]}"; do
    link_dotfile "$dotfile"
  done

  link_dotfile "bat-config" "/Users/samm/.config/bat/config"
  link_dotfile "rsyncd.conf" "/Users/samm/.rsyncd.conf"

  # TODO: clean this up
  ln -s /Users/samm/Library/Mobile\ Documents/com~apple~CloudDocs/Dropbox\ Import/dotfiles/aider/.aider.conf.yml $HOME/.aider.conf.yml
  ln -s /Users/samm/Library/Mobile\ Documents/com~apple~CloudDocs/Dropbox\ Import/dotfiles/aider/.aider.models.json $HOME/.aider.models.json
}

function main() {
  installHomebrew
  installPythonPackages
  installGoPackages
  installCargoPackages
  installNpmPackages

  installDockerCompose

  installZshZgen
  installTmuxTpm

  macOSConfig
  gitConfig
  configureDotfiles
}

# Run the main functions to install and configure
main

echo "Done"
