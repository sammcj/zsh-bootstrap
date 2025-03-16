## AMAZON Q MAKES EVERYTHING SLOWWWWWW
# Amazon Q pre block. Keep at the top of this file.
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# shellcheck disable=SC2148 disable=SC1090 shell=bash

# ~/.zshrc

# set +x

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
# ssh-add-keys # TODO: disabled 2025-03-16 to see if it helps performance, reenable if ssh stops working

### Below are items added by installer scripts (usually homebrew) ####

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /opt/homebrew/Cellar/fzf/*/shell/key-bindings.zsh

# Enable direnv - https://direnv.net
# eval "$(direnv hook zsh)"

if_not_in_vscode bg_silent test -e "${HOME}/.iterm2_shell_integration.zsh" && bg_silent source "${HOME}/.iterm2_shell_integration.zsh"

zstyle ':completion:*' menu select
fpath+=~/.zfunc

set -m # reenable job output

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
eval "$(zoxide init zsh)"
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

# Amazon Q post block. Keep at the bottom of this file.
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/samm/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/samm/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/samm/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/samm/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

####### PROFILING #######
# Uncomment below to enable debug timing
# zprof
#### END PROFILING ######
