# ~/.bash_profile: executed by bash(1) for login shells.

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

PATH="$HOME/.local/bin${PATH:+:${PATH}}"
