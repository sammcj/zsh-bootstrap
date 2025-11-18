
### q slow debugging ###
# date
# echo "STARTING: amazon q pre block loading from .zshrc"
# # set zsh to echo verbose
# set -x
# ###
# only run if LOADING_Q is true
if [[ "$LOADING_Q" == "true" ]]; then
  # Kiro CLI post block. Keep at the bottom of this file.
  # This is in an if statement because Amazon Q / Kiro CLI is _really_ poorly written and slows down your terminal
  # See https://github.com/aws/amazon-q-developer-cli/discussions/202
  [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
fi
# ### q slow debugging ###
# date
# # unset zsh to echo verbose
# set +x
# echo "DONE: amazon q pre block loaded from .zshrc"
###
## AMAZON Q MAKES EVERYTHING SLOWWWWWW

# shellcheck disable=SC2148 disable=SC1090 shell=bash
# ~/.zshrc

# set +x

# only run set +m if we're interactive
if [[ $- == *i* ]]; then
    set +m # Make jobs quiet by default
fi
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
# ssh-add-keys # TODO: disabled 2025-03-16 to see if it helps performance, reenable if ssh stops working

### Below are items added by installer scripts (usually homebrew) ####

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /opt/homebrew/Cellar/fzf/*/shell/key-bindings.zsh

# Enable direnv - https://direnv.net
# eval "$(direnv hook zsh)"

if_not_in_vscode bg_silent test -e "${HOME}/.iterm2_shell_integration.zsh" && bg_silent source "${HOME}/.iterm2_shell_integration.zsh"

zstyle ':completion:*' menu select
fpath+=~/.zfunc

# only run set -m if we're interactive
if [[ $- == *i* ]]; then
    set -m # reenable job output
fi

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
# export MAMBA_EXE='/opt/homebrew/opt/micromamba/bin/micromamba';
# export MAMBA_ROOT_PREFIX='/Users/samm/micromamba';
# __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__mamba_setup"
# else
#     alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
# fi
# unset __mamba_setup
# # <<< mamba initialize <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/homebrew/Caskroom/mambaforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh" ]; then
#         . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/homebrew/Caskroom/mambaforge/base/bin:$PATH"
#     fi
# fi
# unset __conda_setup

# if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/mamba.sh" ]; then
#     . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/mamba.sh"
# fi
# <<< conda initialize <<<

### zoxide ###
if [ -z "$RUNNING_IN_VSCODE" ]; then
  eval "$(zoxide init zsh)"
fi
### zoxide ###

# Load custom aliases
export PATH="$PATH:/Users/samm/Fltr"

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
# [[ -f /Users/samm/.npm/_npx/6913fdfd1ea7a741/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /Users/samm/.npm/_npx/6913fdfd1ea7a741/node_modules/tabtab/.completions/electron-forge.zsh

# Added by LM Studio CLI tool (lms)
export PATH="$PATH:/Users/samm/.cache/lm-studio/bin"
if [ -f "/Users/samm/.config/fabric/fabric-bootstrap.inc" ] && if_not_in_vscode; then . "/Users/samm/.config/fabric/fabric-bootstrap.inc"; fi

fpath+=~/.zfunc

export PATH="/opt/homebrew/opt/tcl-tk@8/bin:$PATH"

# # The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/samm/Downloads/google-cloud-sdk/path.zsh.inc' ] && if_not_in_vscode; then . '/Users/samm/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/samm/Downloads/google-cloud-sdk/completion.zsh.inc' ] && if_not_in_vscode; then . '/Users/samm/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# # Amazon Q post block. Keep at the bottom of this file.
if [[ "$LOADING_Q" == "true" ]]; then
# Amazon Q post block. Keep at the bottom of this file.
  # This is in an if statement because Amazon Q / Kiro CLI is _really_ poorly written and slows down your terminal
  # See https://github.com/aws/amazon-q-developer-cli/discussions/202
  [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
fi

# ####### PROFILING #######
# # Uncomment below to enable debug timing
# zprof
# #### END PROFILING ######

# echo ".zshrc loaded now"

# >>> CLOI_HISTORY_SETTINGS >>>
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# <<< CLOI_HISTORY_SETTINGS <<<

export PATH="$HOME/.local/bin:$PATH"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
