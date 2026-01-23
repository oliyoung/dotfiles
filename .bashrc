# Minimal Bash Configuration
# Note: Zsh is the primary shell - see .zshrc for main configuration

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
# WSL2 DISPLAY for X11 forwarding
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0

# Editor
export EDITOR=vim

# ============================================================================
# ALIASES
# ============================================================================
# Colors for common commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ls shortcuts
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# ============================================================================
# TOOLS & INTEGRATIONS
# ============================================================================
# rbenv - Ruby version manager
if command -v rbenv &> /dev/null; then
    eval "$(rbenv init - --no-rehash bash)"
fi

# Local environment
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
