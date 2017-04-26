# ~/.zshrc

# There is an alias to jump to the directory with the various
# included zsh configs, simply type `zshconfig` at the prompt.

## Source all configs

if [ -d $HOME/Dropbox/dotfiles/shell_config ]; then
  for file in $HOME/Dropbox/dotfiles/shell_config/*.rc; do
    source $file
  done
fi

### Items added by installer scripts (usually homebrew)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source /Users/samm/.iterm2_shell_integration.zsh

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export PATH="/usr/local/bin:$PATH"
