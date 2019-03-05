# ~/.zshrc: executed by zsh(1) for non-login shells.
# vim: filetype=zsh

fpath=($fpath ~/.zsh/completions)

### Keys
# Use emacs keybindings
bindkey -e

# alt + arrows
export WORDCHARS='*?[]~=&;!#$%^(){}'
#urxvt
bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word
#tmux
bindkey "\e\eOD" backward-word
bindkey "\e\eOC" forward-word
#xterm
bindkey "\e[1;3C" forward-word
bindkey "\e[1;3D" backward-word

bindkey '^[;' copy-prev-shell-word

### Antigen
if [ -f "$HOME/.zsh/antigen/antigen.zsh" ]; then
  source "$HOME/.zsh/antigen/antigen.zsh"
fi

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle olivierverdier/zsh-git-prompt
antigen bundle RobSis/zsh-completion-generator
#antigen bundle RobSis/zsh-reentry-hook
antigen bundle momo-lab/zsh-abbrev-alias

antigen apply

### Tab completion
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
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' show-ambiguity "1;$color[fg-red]"
zstyle ':completion:*' use-compctl false

# pretty kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# if nothing matches, THEN try case-insensitively
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

### Prompt
autoload -Uz promptinit
promptinit
export PROMPT=$'%B%F{green}%f %F{blue}%~%b%f$(git_super_status) %# '

### History
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history
setopt histignorealldups

setopt glob_complete
setopt interactivecomments

# include shell-independent ~/.shrc if it exists
if [ -f "$HOME/.shrc" ]; then
  source "$HOME/.shrc"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

abbrev-alias -g tunnel="ssh ssh.localhost.run -R 80:localhost:8080"
