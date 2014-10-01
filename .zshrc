### Keys
# Use emacs keybindings even if our EDITOR is set to vi
setopt glob_complete

fpath=($fpath ~/.zsh/completions)

bindkey -e
# ctrl + arrows/backspace
export WORDCHARS='*?[]~=&;!#$%^(){}'
bindkey '^[OC' forward-word
bindkey '^[OD' backward-word
bindkey '^[[C' forward-char
bindkey '^[[D' backward-char
bindkey '^H'   backward-delete-word
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
# shift + tab
bindkey '^[[Z' reverse-menu-complete


### Antigen
if [ -f "$HOME/.zsh/antigen/antigen.zsh" ]; then
  source "$HOME/.zsh/antigen/antigen.zsh"
fi

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle robbyrussell/oh-my-zsh plugins/mvn
antigen bundle robbyrussell/oh-my-zsh plugins/dircycle
antigen bundle olivierverdier/zsh-git-prompt
antigen bundle RobSis/zsh-completion-generator

antigen apply


### Completion
autoload -Uz compinit
compinit
set completeinword

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'


### Prompt
autoload -Uz promptinit
promptinit

export PROMPT='%B%n %~%b$(git_super_status) %# '


### History
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt histignorealldups

# include shell-independent ~/.shrc if it exists
if [ -f "$HOME/.shrc" ]; then
  source "$HOME/.shrc"
fi
