# Minimal Zsh Configuration
# Migrated from Oh My Zsh - see .zshrc.bak for previous config

# Exit early if not running interactively
[[ $- != *i* ]] && return

# ============================================================================
# HISTORY
# ============================================================================
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE

setopt EXTENDED_HISTORY       # Timestamps in history
setopt HIST_IGNORE_ALL_DUPS   # No duplicates
setopt HIST_IGNORE_SPACE      # Don't record commands starting with space
setopt SHARE_HISTORY          # Share history between sessions

# ============================================================================
# SHELL OPTIONS
# ============================================================================
setopt autocd                 # cd by just typing directory name
setopt interactive_comments   # Allow comments in interactive shell

# ============================================================================
# COMPLETION
# ============================================================================
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(Nmh+24) ]]; then
    compinit
else
    compinit -C
fi

# ============================================================================
# KEYBINDINGS
# ============================================================================
# Emacs keybindings (default)
bindkey -e

# ============================================================================
# FZF - Fuzzy Finder Integration
# ============================================================================
if command -v fzf &> /dev/null; then
    # Try Ubuntu/Debian path first
    if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
    else
        # Fall back to fzf --zsh (works with most installations)
        eval "$(fzf --zsh 2>/dev/null)" || true
    fi
fi

# ============================================================================
# TERMINAL & THEME
# ============================================================================
# Directory colors (uses custom dircolors configuration)
if [ -f "$HOME/.dircolors" ]; then
    if output=$(dircolors "$HOME/.dircolors" 2>/dev/null); then
        eval "$output"
    fi
fi

# Starship prompt - modern shell prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
# Editor
export EDITOR=vim

# WSL2 DISPLAY for X11 forwarding (if nameserver available)
if grep -qi microsoft /proc/version 2>/dev/null; then
    nameserver=$(grep nameserver /etc/resolv.conf 2>/dev/null | awk '{print $2; exit;}')
    if [ -n "$nameserver" ]; then
        export DISPLAY="${nameserver}:0.0"
    fi
fi

# Puppeteer - dynamically locate the browser executable
_set_puppeteer_path() {
    local cache_dir="$HOME/.cache/puppeteer/chrome-headless-shell"
    if [ -d "$cache_dir" ]; then
        local latest=$(ls -td "$cache_dir"/linux-* 2>/dev/null | head -1)
        if [ -n "$latest" ]; then
            local browser="$latest/chrome-headless-shell-linux64/chrome-headless-shell"
            [ -x "$browser" ] && export PUPPETEER_EXECUTABLE_PATH="$browser"
        fi
    fi
}
_set_puppeteer_path
unset _set_puppeteer_path

# ============================================================================
# ALIASES
# ============================================================================
# Text search (color output)
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Directory listing (eza - modern ls replacement)
if command -v eza &> /dev/null; then
    alias ls='eza --group-directories-first'
    alias l='eza -alF --group-directories-first'
    alias la='eza -a --group-directories-first'
    alias ll='eza -l --group-directories-first'
    alias lsd='eza -D --group-directories-first'
    alias tree='eza --tree'
else
    alias ls='ls -G'
    alias l='ls -alFh'
    alias la='ls -A'
    alias lsd='ls -d */'
fi

# Git operations
alias gs='git status'                # Status
alias ga='git add'                   # Add
alias gc='git commit'                # Commit
alias gcm='git commit -m'            # Commit with message
alias gl='git pull'                  # Pull
alias gp='git push'                  # Push
alias gco='git checkout'             # Checkout
alias gb='git branch'                # Branch
alias gd='git diff'                  # Diff
alias gst='git stash'                # Stash
alias gcl='git clone'                # Clone

# Local environment
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
