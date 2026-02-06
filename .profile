# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Ruby gems
if [ -d "$HOME/.gem/ruby/4.0.0/bin" ] ; then
    PATH="$HOME/.gem/ruby/4.0.0/bin:$PATH"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/oliyoung/.lmstudio/bin"
# End of LM Studio CLI section

# Editor
export EDITOR=vim

# WSL2 DISPLAY for X11 forwarding (if running under WSL)
if grep -qi microsoft /proc/version 2>/dev/null; then
    nameserver=$(grep nameserver /etc/resolv.conf 2>/dev/null | awk '{print $2; exit;}')
    if [ -n "$nameserver" ]; then
        export DISPLAY="${nameserver}:0.0"
    fi
fi

# Detect current shell
if [ -n "$ZSH_VERSION" ]; then
    _shell="zsh"
elif [ -n "$BASH_VERSION" ]; then
    _shell="bash"
else
    _shell="posix"
fi

# conda
if [ -f "/opt/homebrew/Caskroom/miniforge/base/bin/conda" ]; then
    __conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' "shell.$_shell" 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi

# rbenv - Ruby version manager
if command -v rbenv > /dev/null 2>&1; then
    eval "$(rbenv init - --no-rehash)"
fi

unset _shell

# ============================================================================
# ALIASES
# ============================================================================
# Modern CLI replacements
if command -v bat > /dev/null 2>&1; then
    alias cat='bat --paging=never'
    alias catp='bat'  # bat with pager
fi

if command -v rg > /dev/null 2>&1; then
    alias grep='rg'
    alias fgrep='rg -F'
    alias egrep='rg'
else
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if command -v fd > /dev/null 2>&1; then
    alias find='fd'
fi

if command -v zoxide > /dev/null 2>&1; then
    alias cd='z'
fi

# Directory listing (eza - modern ls replacement)
if command -v eza > /dev/null 2>&1; then
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

if command -v tree > /dev/null 2>&1; then
    alias tree='tree -l -L 2 -a'
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

