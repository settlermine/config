#!/usr/bin/env bash
set -euo pipefail

case "$(uname -m)" in
	x86_64)  nvim_a=x86_64; rg_a=x86_64-unknown-linux-musl; ts_a=x64; node_a=x64 ;;
	aarch64) nvim_a=arm64;  rg_a=aarch64-unknown-linux-musl; ts_a=arm64; node_a=arm64 ;;
	*) echo "unsupported arch: $(uname -m)" >&2; exit 1 ;;
esac

cd "$(mktemp -d)"

# unzip (no portable binary) 
if ! command -v unzip >/dev/null; then
	echo "installing unzip..."
	if command -v apt-get >/dev/null; then
		export DEBIAN_FRONTEND=noninteractive
		apt-get update -qq && apt-get install -y -qq unzip
	elif command -v apk >/dev/null; then
		apk add --no-cache unzip
	elif command -v dnf >/dev/null; then
		dnf install -y unzip
	elif command -v yum >/dev/null; then
		yum install -y unzip
	else
		echo "unzip: no package manager found" >&2
		exit 1
	fi
else
	echo "unzip already present, skip"
fi

# npm
if ! command -v npm >/dev/null; then
	echo "installing node/npm..."
	ver="$(curl -fsSL https://nodejs.org/dist/index.json \
		| tr '{' '\n' \
		| grep '"lts":"' \
		| sed -n 's/.*"version":"\([^"]*\)".*/\1/p' \
		| sed -n '1p' || true)"
	if [[ -z "${ver}" ]]; then
		echo "npm: could not resolve node LTS version" >&2
		exit 1
	fi
	curl -fsSL -o node.tar.gz \
		"https://nodejs.org/dist/${ver}/node-${ver}-linux-${node_a}.tar.gz"
	tar -xzf node.tar.gz
	rm -rf /usr/local/node
	mv "node-${ver}-linux-${node_a}" /usr/local/node
	ln -sfn /usr/local/node/bin/node /usr/local/bin/node
	ln -sfn /usr/local/node/bin/npm /usr/local/bin/npm
	ln -sfn /usr/local/node/bin/npx /usr/local/bin/npx
else
	echo "npm already present, skip"
fi

# nvim
curl -fsSL -o nvim.tar.gz \
	"https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${nvim_a}.tar.gz"
tar -xzf nvim.tar.gz
rm -rf /usr/local/nvim
mv "nvim-linux-${nvim_a}" /usr/local/nvim
ln -sfn /usr/local/nvim/bin/nvim /usr/local/bin/nvim

# ripgrep (musl)
rg_url="$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
	| sed -n 's/.*"browser_download_url": "\([^"]*'"${rg_a}"'\.tar\.gz\)".*/\1/p' \
	| head -n1)"
curl -fsSL -o rg.tar.gz "$rg_url"
tar -xzf rg.tar.gz
install -m755 ripgrep-*/rg /usr/local/bin/rg

# tree-sitter
curl -fsSL -o tree-sitter.gz \
	"https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${ts_a}.gz"
gzip -dc tree-sitter.gz >/usr/local/bin/tree-sitter
chmod +x /usr/local/bin/tree-sitter

nvim --version | sed -n '1p' || true
rg --version | sed -n '1p' || true
tree-sitter --version
unzip -v 2>&1 | sed -n '1p' || true
npm --version

# Auto-activate virtual environment if needed
# TODO: Add
