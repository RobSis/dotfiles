### Keys
# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e
setopt glob_complete

fpath=(~/.zsh/completions $fpath)

export WORDCHARS='*?-_[]~=&;!#$%^(){}'
bindkey '^[^[[C' forward-word
bindkey '^[^[[D' backward-word
bindkey '^H'   backward-delete-word
bindkey '^[[Z' reverse-menu-complete

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

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'


### Prompt
# https://github.com/olivierverdier/zsh-git-prompt
autoload -Uz promptinit
promptinit
if [ -f "$HOME/.zsh/zsh-git-prompt/zshrc.sh" ]; then
  source "$HOME/.zsh/zsh-git-prompt/zshrc.sh"
fi
export PROMPT='%B%n %~%b$(git_super_status) %# '


### History
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt histignorealldups

# history search
if [ -f "$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh" ]; then
  . "$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"
  # bind UP and DOWN arrow keys
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

# mvn helper
if [ -f "$HOME/.zsh/zsh-mvn/mvn.plugin.zsh" ]; then
  source "$HOME/.zsh/zsh-mvn/mvn.plugin.zsh"
fi

# include .shrc if it exists
if [ -f "$HOME/.shrc" ]; then
  source "$HOME/.shrc"
fi
