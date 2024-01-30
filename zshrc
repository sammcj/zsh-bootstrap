# shellcheck disable=SC2148 disable=SC1090 shell=bash

# ~/.zshrc

# set -x

set +m # Make jobs quiet by default

# There is an alias to jump to the directory with the various
# included zsh configs, simply type `zshconfig` at the prompt.

####### PROFILING #######
# Uncomment below to enable debug timing
# zmodload zsh/zprof
# Remember to uncomment zprof at the end of the file!
#### END PROFILING ######

bg_silent() {
  # background a task quietly and disown
  { "$@" 2>&3 & } 3>&2 2>/dev/null
  disown &>/dev/null
}

## Source all configs

if [[ -d $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config ]]; then
  for file in "$HOME"/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/*.rc; do
    source "$file"
  done
fi

## Add ssh keys to agent if not already added
ssh-add-keys

### Below are items added by installer scripts (usually homebrew) ####

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /opt/homebrew/Cellar/fzf/*/shell/key-bindings.zsh

# Enable direnv - https://direnv.net
# eval "$(direnv hook zsh)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

zstyle ':completion:*' menu select
fpath+=~/.zfunc

set -m # reenable job output

####### PROFILING #######
# Uncomment below to enable debug timing
# zprof
#### END PROFILING ######
