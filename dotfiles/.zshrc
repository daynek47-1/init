# --- PATH FIXES ---
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# --- NVM ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# --- OH MY ZSH ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
)

source $ZSH/oh-my-zsh.sh

# --- ALIASES ---
[ -f ~/.aliases.zsh ] && source ~/.aliases.zsh

# --- POWERLEVEL10K CONFIG ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /home/dayne/.aliases.zsh

# --- PRIVATE VARIABLES (NOT VERSION CONTROLLED) ---
# This file contains sensitive information like API keys.
# It should be manually created on your system and excluded from version control.
# Example content for ~/.private_vars:
# export GEMINI_API_KEY="YOUR_ACTUAL_GEMINI_API_KEY"
# export GITHUB_TOKEN="YOUR_ACTUAL_GITHUB_TOKEN"
[ -f ~/.private_vars ] && source ~/.private_vars

export FRACTAL_ROOT="\home\dayne\dev\mcr"
