### Keys
# Use emacs keybindings even if our EDITOR is set to vi
setopt glob_complete
setopt interactivecomments

fpath=($fpath ~/.zsh/completions)

bindkey -e
# ctrl + arrows/backspace
export WORDCHARS='*?[]~=&;!#$%^(){}'
bindkey '^[[C' forward-word
bindkey '^[[D' backward-word
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
#antigen bundle zsh-users/zsh-autosuggestions
antigen bundle olivierverdier/zsh-git-prompt
antigen bundle RobSis/zsh-completion-generator
#antigen bundle RobSis/zsh-reentry-hook

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
zstyle ':completion:*' show-ambiguity "1;$color[fg-red]"

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# if nothing matches, THEN try case-insensitively
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

### Prompt
autoload -Uz promptinit
promptinit

export PROMPT=$'%B%F{green}%f %F{blue}%~%b$f$(git_super_status) %# '
# stderred
#export LD_PRELOAD="/home/rsiska/.local/lib/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"


### History
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history
setopt histignorealldups
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

# include shell-independent ~/.shrc if it exists
if [ -f "$HOME/.shrc" ]; then
  source "$HOME/.shrc"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#export NVM_DIR="/home/rsiska/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# mgnl-tabcompletion-start
# load mgnl command tab completion
autoload bashcompinit
bashcompinit
# mgnl-tabcompletion-end

#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
