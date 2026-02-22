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

# Zoxide - smarter cd command
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# Direnv - per-directory environment variables
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# Source API keys and secrets (if file exists)
if [ -f "$HOME/.secrets" ]; then
    source "$HOME/.secrets"
fi

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
# PATH
# ============================================================================
# Shared PATH setup (Ruby gems, ~/bin, ~/.local/bin, LM Studio)
. "$HOME/.profile"

path=(
    /opt/homebrew/opt/ruby/bin
    $path
)
typeset -U path  # Remove duplicates

# Local environment
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ============================================================================
# TMUX - auto-attach or create session
# ============================================================================
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -z "$INSIDE_EMACS" ] && [ -z "$VSCODE_RESOLVING_ENVIRONMENT" ]; then
    tmux attach -t default 2>/dev/null || tmux new-session -s default
fi
