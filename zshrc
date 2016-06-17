# ~/.zshrc
#
# Install steps:
#
# 1. Install and sync dropbox
# 2. ln -s $HOME/Dropbox/dotfiles/shell_config/zshrc $HOME/.zshrc
# 3. git clone https://github.com/zsh-users/antigen.git ~/.antigen
#

### Source all configs

if [ -d $HOME/Dropbox/dotfiles/shell_config ]; then
  for file in $HOME/Dropbox/dotfiles/shell_config/*.rc; do
    source $file
  done
fi

### Items added by installer scripts (usually homebrew)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source /Users/samm/.iterm2_shell_integration.zsh 

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
