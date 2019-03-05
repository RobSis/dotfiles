# ~/.bashrc: executed by bash(1) for non-login shells.
# vim: filetype=sh

# if not running interactively, don't do anything
[ -z "$PS1" ] && return

# prompt
export PS1="\[\033[1;34m\] \w \[\033[0m\]$ "

# history settings
HISTCONTROL=ignoredups   # don't duplicate lines in the history
HISTIGNORE="ls"
HISTSIZE=2000
HISTFILESIZE=5000
shopt -s histappend
shopt -s histreedit
shopt -s cmdhist

# in-line history expansion
bind space:magic-space

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS
shopt -s checkwinsize

if [ -f "$HOME/.shrc" ]; then
    source "$HOME/.shrc"
fi

if [ -f "/etc/bash_completion" ]; then
    source "/etc/bash_completion"
fi
