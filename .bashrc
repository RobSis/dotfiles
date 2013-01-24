# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

########
# Prompt
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm*) color_prompt=yes;;
    rxvt*) color_prompt=yes;;
    screen*) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

#add GIT branch to prompt
parse_git_branch_and_add_brackets() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}
if [ "$color_prompt" = yes ]; then
    PS1="┌─\[\033[34m\][\w]\033[0m\]\033[0;31m\$(parse_git_branch_and_add_brackets)\033[0m\]\n└─[\u]╼ "
else
    PS1="┌─[\w]\$(parse_git_branch_and_add_brackets)\n└─[\u]╼ "
fi
unset color_prompt force_color_prompt


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export PAGER=vimpager
alias vp='vimpager'
export LD_LIBRARY_PATH="$HOME/.vim/gdbmgr/src:default"

#########
# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias timestamp='date +%s'
alias x2='xmms2'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low \
    "$(er=$?;history|tail -n1|tr "\n" "="|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert *//'\'';echo -ne $er)"'


export JAVA_HOME=/usr/lib/jvm/java-6-sun

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi


# dirclip
# lcd       show list
# mcdN      save to pos N (0-9)
# rcdN      load to pos N (0-9)
#------------------
# setup/reset:
# mkdir ~/.dirclip/ && for file in $(seq 0 9) "main"; do echo > ~/.dirclip/$file; done
export DIRCLIP=~/.dirclip
alias mcd="pwd > $DIRCLIP/main"
alias rcd="cd \"`cat $DIRCLIP/main`\""
for i in  `seq 0 9`; do
        alias mcd$i="pwd > "$DIRCLIP/$i
        alias rcd$i="cd \"`cat "$DIRCLIP/$i" 2>/dev/null`\""
done
alias lcd='echo -ne "~  :";cat ~/.dirclip/main;for i in `seq 0 9`; do echo -ne "$i  :"; cat $DIRCLIP/$i 2>/dev/null; done'
alias ccd='for i in "main" `seq 0 9`; do echo > $DIRCLIP/$i; done'
