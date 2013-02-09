#!/bin/bash

target=~/.dotfiles
# dot files
files=".vimrc .vimpagerrc .bashrc .gitconfig .vimrc .vim .mplayer .Xdefaults .xthemes .tmux.conf .mkdotfiles.sh"
# directories from .config/
configs="awesome"

rm -Rf $target
mkdir -p $target/

git clone https://github.com/RobSis/dotfiles.git $target

for file in $files; do
    cp -rf ~/$file $target/
done

for config in $configs; do
    cp -rf ~/.config/$config $target/.config/
done
echo "Copied."


pushd $target
git add -A

git status
popd
echo "Ready for commit."
