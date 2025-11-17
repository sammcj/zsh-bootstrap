# ####### PROFILING #######
# # Uncomment below to enable debug timing
# zmodload zsh/zprof
# # Remember to uncomment zprof at the end of the file!
# #### END PROFILING ######

if [[ "$LOADING_Q" == "true" ]]; then
  # Kiro CLI pre block. Keep at the top of this file.
  # This is in an if statement because Amazon Q / Kiro CLI is _really_ poorly written and slows down your terminal
  # See https://github.com/aws/amazon-q-developer-cli/discussions/202
  [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh"
fi


# echo ".zprofile loaded now"
if [[ "$LOADING_Q" == "true" ]]; then
  # Kiro CLI post block. Keep at the bottom of this file.
  # This is in an if statement because Amazon Q / Kiro CLI is _really_ poorly written and slows down your terminal
  # See https://github.com/aws/amazon-q-developer-cli/discussions/202
  [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh"
fi

export PATH="$HOME/.local/bin:$PATH"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
