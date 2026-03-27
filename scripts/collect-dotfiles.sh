#!/usr/bin/bash

echo "===> Collecting dotfiles..."

cp ~/.zshrc ../dotfiles
cp ~/.tmux.conf ../dotfiles
cp -r ~/.config/nvim/ ../dotfiles/.config

echo "===> Done!"

