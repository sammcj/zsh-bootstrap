# shellcheck disable=SC2148
# ~/.zshrc

# There is an alias to jump to the directory with the various
# included zsh configs, simply type `zshconfig` at the prompt.

# Uncomment below AND zprof at the end of this file to debug timing
#zmodload zsh/zprof

# Source google-cloud-sdk (breaks if you source later)
#source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
#source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

## Source all configs

if [ -d $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config ]; then
  for file in $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/*.rc; do
    source $file
  done
fi

### Below are items added by installer scripts (usually homebrew) ####

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /opt/homebrew/Cellar/fzf/*/shell/key-bindings.zsh

# Enable direnv - https://direnv.net
# eval "$(direnv hook zsh)"

# Enable endgame AWS scanner
# https://users.aalto.fi/~saarit2/deoxy/gz_howy.htm

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/samm/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/samm/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/samm/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/samm/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Thefuck
eval "$(thefuck --alias)"
