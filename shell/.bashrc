# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# append to the history file, don't overwrite it
HISTCONTROL=ignoredups   # don't duplicate lines in the history
HISTIGNORE='ls'
HISTSIZE=2000
HISTFILESIZE=5000

shopt -s histappend
shopt -s histreedit
shopt -s cmdhist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#GIT stuff
parse_git_branch_and_add_brackets() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}
export PS1="\w\[\033[0;32m\]\$(parse_git_branch_and_add_brackets) \[\033[0m\]\$ "

bind space:magic-space

# include .shrc if it exists
if [ -f "$HOME/.shrc" ]; then
. "$HOME/.shrc"
fi

if [ -f "/etc/bash_completion" ]; then
. "/etc/bash_completion"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
