
#!/usr/bin/env bash
set -e

echo "===> Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y \
  ninja-build gettext cmake unzip curl tar \
  libtool libtool-bin autoconf automake g++ pkg-config \
  doxygen jq git ripgrep

# -----------------------------
# Neovim в /usr/local с sudo
# -----------------------------
BUILD_DIR="$HOME/tmp/nvim-build"
echo "===> Preparing Neovim build directories..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

LATEST_TAG=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r .tag_name)
echo "===> Building Neovim $LATEST_TAG"

curl -L -o nvim.tar.gz https://github.com/neovim/neovim/archive/refs/tags/${LATEST_TAG}.tar.gz
tar -xzf nvim.tar.gz --strip-components=1

make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

echo "===> Creating symlink for convenience..."
sudo ln -sf /usr/local/bin/nvim /usr/bin/nvim || true

echo "===> Neovim version:"
nvim --version | head -n2

# -----------------------------
# Dotfiles
# -----------------------------
CONFIG_REPO="$HOME/.config-repo"
DOTFILES_DIR="$CONFIG_REPO/dotfiles"

echo "===> Setting up dotfiles..."

rm -rf "$CONFIG_REPO"
git clone --depth=2 https://github.com/settlermine/config.git "$CONFIG_REPO"

rm -rf "$HOME/.config/nvim"
mkdir -p "$HOME/.config"
cp -r "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"


# -----------------------------
# Git
# -----------------------------
echo "===> Building latest Git from source..."

GIT_BUILD_DIR="$HOME/tmp/git-build"
rm -rf "$GIT_BUILD_DIR"
mkdir -p "$GIT_BUILD_DIR"
cd "$GIT_BUILD_DIR"

# Получаем актуальный тег
LATEST_TAG=$(curl -s https://api.github.com/repos/git/git/tags | jq -r '.[0].name')
echo "Latest Git version: $LATEST_TAG"

# Скачиваем исходники
curl -L -o git.tar.gz "https://github.com/git/git/archive/refs/tags/${LATEST_TAG}.tar.gz"
tar -xzf git.tar.gz --strip-components=1

# Сборка и установка
make prefix=$HOME/.local all
make prefix=$HOME/.local install

# Добавляем в PATH временно
export PATH="$HOME/.local/bin:$PATH"

echo "===> Git version check:"
git --version

# -----------------------------
# Lazygit
# -----------------------------
echo "===> Installing latest lazygit..."
LAZYGIT_LATEST=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r .tag_name)
echo "Latest lazygit version: $LAZYGIT_LATEST"

curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_LATEST}/lazygit_${LAZYGIT_LATEST#v}_Linux_x86_64.tar.gz"
tar -xzf lazygit.tar.gz lazygit
sudo mv lazygit /usr/local/bin/
rm lazygit.tar.gz

echo "===> Lazygit version:"
lazygit --version

echo "===> DONE ✅"

