#!/bin/bash

HOME_DOTS=(.tmux.conf .zshrc .zprofile .xkb .xonshrc)
for dot in ${HOME_DOTS[@]}
do
  ln -s $HOME/dotfiles/$dot $HOME/
done

CONFIGS=(nvim rofi sway termite waybar)
for dir in ${CONFIGS[@]}
do
  ln -s $HOME/dotfiles/$dir $HOME/.config/
done
