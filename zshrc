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

function conda_init() {

  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/opt/homebrew/Caskroom/mambaforge/base/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh" ]; then
      # . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh"  # commented out by conda initialize
    else
      # export PATH="/opt/homebrew/Caskroom/mambaforge/base/bin:$PATH"  # commented out by conda initialize
    fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<

}

# pnpm
export PNPM_HOME="/Users/samm/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# [ -f ~/.inshellisense/key-bindings.zsh ] && source ~/.inshellisense/key-bindings.zsh
