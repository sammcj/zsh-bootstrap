# ~/.zshrc

# There is an alias to jump to the directory with the various
# included zsh configs, simply type `zshconfig` at the prompt.

## Source all configs

if [ -d $HOME/Dropbox/dotfiles/shell_config ]; then
  for file in $HOME/Dropbox/dotfiles/shell_config/*.rc; do
    source $file
  done
fi


### Below are items added by installer scripts (usually homebrew) ####

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# If google-cloud-sdk is installed, source it

CLOUD_SDK_HOME=/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk
#source "${CLOUD_SDK_HOME}/path.zsh.inc"
source "${CLOUD_SDK_HOME}/completion.zsh.inc"

export PATH="/usr/local/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/samm/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/samm/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/samm/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/samm/google-cloud-sdk/completion.zsh.inc'; fi
