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

# Source google-cloud-sdk (breaks if you source later)
#source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
#source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# autoload -U +X bashcompinit && bashcompinit
# autoload -U +X compinit && compinit #zgen does this now

## Source all configs

if [[ -d $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config ]]; then
  for file in "$HOME"/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/*.rc; do
    source "$file"
  done
fi

## Add ssh keys to agent if not already added
bg_silent ssh-add-keys

### Below are items added by installer scripts (usually homebrew) ####

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /opt/homebrew/Cellar/fzf/*/shell/key-bindings.zsh

# Enable direnv - https://direnv.net
# eval "$(direnv hook zsh)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && bg_silent source "${HOME}/.iterm2_shell_integration.zsh"

autoload -Uz compinit && bg_silent compinit
autoload -U +X bashcompinit && bg_silent bashcompinit

zstyle ':completion:*' menu select
fpath+=~/.zfunc

####### PROFILING #######
# Uncomment below to enable debug timing
# zprof
#### END PROFILING ######

set -m # reenable job output
