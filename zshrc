# ~/.zshrc

# There is an alias to jump to the directory with the various
# included zsh configs, simply type `zshconfig` at the prompt.

# Uncomment below AND zprof at the end of this file to debug timing
#zmodload zsh/zprof

# Source google-cloud-sdk (breaks if you source later)
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

## Source all configs

if [ -d $HOME/Dropbox/dotfiles/shell_config ]; then
  for file in $HOME/Dropbox/dotfiles/shell_config/*.rc; do
    source $file
  done
fi


### Below are items added by installer scripts (usually homebrew) ####

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="/usr/local/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Uncomment below to enable debug timing
#zprof


