#!/usr/bin/env bash

set -e

echo "Updating system..."
sudo pacman -Syu --noconfirm


echo "Installing aur..."
if ! command -v yay &> /dev/null; then
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
fi
yay -Syu

echo "Installing pacman packages..."
sudo pacman -S tmux openvpn firejail sshfs lazygit ripgrep --noconfirm 

echo "Installing yay packages..."
yay -S openvpn-update-systemd-resolved tmuxinator 

echo "Configuring openvpn..."
sudo systemctl enable --now systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
