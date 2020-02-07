# ~/.zshrc: executed by zsh(1) for non-login shells.
# vim: filetype=zsh

# uncomment for profiling
# zmodload zsh/zprof

fpath=($fpath ~/.zsh/completions)

# Keybindings
## use emacs keybindings
bindkey -e
## word boundaries
export WORDCHARS='*?[]~=&;!#$%^(){}_'

## alt+arrows
bindkey "\e\eOC" forward-word
bindkey "\e\eOD" backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word

## ctrl+arrows
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\eOc" forward-word
bindkey "\eOd" backward-word

## ctrl+backspace
bindkey '^H' backward-kill-word

## ctrl+delete
bindkey "\e[3;5~" kill-word
bindkey "\e[3^" kill-word

## ctrl+shift+delete
bindkey "\e[3;6~" kill-line
bindkey "\e[3@" kill-line

# Tab completion
autoload -Uz compinit
compinit
set completeinword

[ -e "$HOME/.dircolors" ] && DIR_COLORS="$HOME/.dircolors"
[ -e "$DIR_COLORS" ] || DIR_COLORS=""
eval "$(dircolors -b $DIR_COLORS)"

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' show-ambiguity "1;$color[fg-red]"
zstyle ':completion:*' use-compctl false

## pretty kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

## if nothing matches, THEN try case-insensitively
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Prompt
autoload -Uz promptinit
promptinit
source ~/.gitstatus/gitstatus.prompt.zsh
PROMPT=$'%B%F{green}%f %F{blue}%~%b%f${GITSTATUS_PROMPT:+ $GITSTATUS_PROMPT} %# '

# History
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history
setopt histignorealldups

setopt glob_complete
setopt interactivecomments

# zinit plugin manager
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33} %F{34}Installation successful.%f" || \
        print -P "%F{160} The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit light "zdharma/fast-syntax-highlighting"
zinit light "RobSis/zsh-completion-generator"
zinit light "momo-lab/zsh-abbrev-alias"

# include shell-independent ~/.shrc if it exists
if [ -f "$HOME/.shrc" ]; then
  source "$HOME/.shrc"
fi

# zle widgets
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey "^[;" copy-earlier-word

[ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh
[ -f ~/.fzf/shell/completion.zsh ] && source ~/.fzf/shell/completion.zsh

# abbreviations
abbrev-alias -g tunnel="ssh ssh.localhost.run -R 80:localhost:8080"
