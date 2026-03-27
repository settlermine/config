#!/usr/bin/env bash
set -e

echo "===> Installing dependencies..."

sudo apt-get update
sudo apt-get install -y \
  ninja-build gettext cmake unzip curl tar \
  libtool libtool-bin autoconf automake g++ pkg-config doxygen jq git

# -------------------------
# Установка Neovim (если нет)
# -------------------------
if ! command -v nvim >/dev/null 2>&1; then
  echo "===> Building Neovim..."

  mkdir -p /tmp/nvim-build
  cd /tmp/nvim-build

  LATEST_TAG=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r .tag_name)
  echo "Building Neovim $LATEST_TAG"

  curl -L -o nvim.tar.gz https://github.com/neovim/neovim/archive/refs/tags/${LATEST_TAG}.tar.gz
  tar -xzf nvim.tar.gz --strip-components=1

  make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install

  cd /
  rm -rf /tmp/nvim-build
else
  echo "===> Neovim already installed"
fi

# -------------------------
# Dotfiles
# -------------------------
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "===> Cloning dotfiles..."

  git clone --depth=1 https://github.com/settlermine/dotfiles.git $HOME/.dotfiles
  mkdir -p $HOME/.config
  ln -s $HOME/.dotfiles/.config/nvim $HOME/.config/nvim
else
  echo "===> Neovim config already exists"
fi

# -------------------------
# Установка плагинов
# -------------------------
echo "===> Installing plugins..."

nvim --headless "+Lazy! sync" +qa

echo "===> Done!"
