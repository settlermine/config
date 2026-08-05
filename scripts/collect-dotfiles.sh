#!/usr/bin/bash

echo "===> Collecting dotfiles..."

cp ~/.zshrc ../dotfiles
cp ~/.tmux.conf ../dotfiles
cp ~/.gitconfig ../dotfiles
cp -r ~/.config/nvim/ ../dotfiles/.config
cp -r ~/.config/niri/ ../dotfiles/.config
cp -r ~/.config/lazygit/ ../dotfiles/.config
cp -r ~/.config/kitty/ ../dotfiles/.config

echo "===> Done!"

