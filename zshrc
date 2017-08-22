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

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
