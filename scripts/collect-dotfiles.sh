#!/usr/bin/bash

echo "===> Collecting dotfiles..."

cp ~/.zshrc ../dotfiles
cp ~/.tmux.conf ../dotfiles
cp -r ~/.config/nvim/ ../dotfiles/.config
cp -r ~/.config/alacritty/ ../dotfiles/.config

echo "===> Done!"

