# --- CORE WRAPPERS ---
alias u='uv'
alias ur='u run'
alias py='ur python'
alias pi='u pip'
alias pk='pkg'
alias g='git'
alias ed='nano'

# --- PYTHON EXECUTION (py) ---
alias pyi='py -m IPython'
alias pyr='py run.py'
alias pym='py main.py'
alias pya='py app.py'
alias pyc='find . -type d -name "__pycache__" -exec rm -rf {} +'
alias pyg='ps aux | grep python'
alias pdoc='py -m pydoc'
alias pls='py -c "import polars as pl; print(pl.Config.state())"'
alias rcat='py -m rich'

# --- DEPENDENCIES (pi) ---
alias pii='pi install --jobs 1'
alias pil='pi list'
alias pif='pi freeze > requirements.txt'
alias pir='pi install -r requirements.txt'
alias piu='pi list | fzf -m --header "Uninstall Pip Lib" | awk "{print $1}" | xargs -r pi uninstall'
alias reqs='pif'

# --- SYSTEM & TERMUX (pk) ---
alias pkup='pk update && pk upgrade'
alias pki='pk install'
alias pku='pk uninstall'
alias pks='pk search'
alias pkr='pk list-installed | fzf -m --header "Uninstall System Pkg" | awk -F/ "{print $1}" | xargs -r pk uninstall -y'
alias tapi='termux-api'

# --- VIRTUAL ENV (v) ---
alias vc='u venv'
alias va='source .venv/bin/activate || source venv/bin/activate'
alias vd='deactivate'
alias venv='python -m venv venv && va && echo "Env Created & Activated"'

# --- DEV TOOLS & QUALITY (r) ---
alias ru='ur ruff'
alias rf='ru format .'
alias rx='ru check --fix'
alias rw='ru check --watch --fix'
alias uv_srv='ur uvicorn'
alias dev='uv_srv main:app --reload'
alias uvh='dev --host 0.0.0.0'
alias fast='ur fastapi dev main.py'
alias sql='sqlite3'
alias csv='column -s, -t <'

# --- CONFIG & NAVIGATION (z) ---
alias zsh='ed ~/.zshrc'
alias als='ed ~/.aliases.zsh'
alias rl='source ~/.zshrc && echo "ZSH Config Reloaded"'
alias goter='cd ~/.termux && ls -a'
alias goals='cd ~ && ls -a | grep aliases'
alias ls='eza --icons --group-directories-first'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias md='mkdir -p'
alias rd='rm -rf'
alias base='cd && cd scr/69/base'

# --- GIT (g) ---
alias gs='g status'
alias ga='g add .'
alias gc='g commit -m'
alias gp='g push'
alias gl='g log --oneline --graph'

# --- HARDWARE & UTILS ---
alias clip='termux-clipboard-set'
alias paste='termux-clipboard-get'
alias say='termux-tts-speak'
alias vib='termux-vibrate -d 500'
alias batt='termux-battery-status'
alias notif='termux-notification -c "Task Complete"'
alias top='htop'
alias dusage='ncdu'
alias size='du -sh *'
alias myip='ifconfig | grep "inet "'
alias path='echo $PATH | tr ":" "\n"'

# --- FUZZY TOOLS ---
alias o='fzf --preview "bat --color=always --style=numbers {}" | xargs -r ed'
alias f='cd $(find . -type d -not -path "./.*") | fzf --header "Jump to Directory"'

# --- Gemini ---
alias gy="gemini -y"
alias ml='/data/data/com.termux/files/home/ralph-claude-code/monolith_tool/run_monolith.sh'
