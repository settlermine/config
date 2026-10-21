#!/usr/bin/env bash
set -euo pipefail

case "$(uname -m)" in
	x86_64)  nvim_a=x86_64; musl_a=x86_64-unknown-linux-musl; ts_a=x64; node_a=x64; fzf_a=amd64 ;;
	aarch64) nvim_a=arm64;  musl_a=aarch64-unknown-linux-musl; ts_a=arm64; node_a=arm64; fzf_a=arm64 ;;
	*) echo "unsupported arch: $(uname -m)" >&2; exit 1 ;;
esac

cd "$(mktemp -d)"

# Resolved from the /releases/latest redirect: the API is rate limited and its JSON breaks sed parsing
gh_latest_tag() {
	local tag
	tag="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest")"
	tag="${tag##*/}"
	if [[ -z "$tag" || "$tag" == latest ]]; then
		echo "$1: could not resolve latest release tag" >&2
		exit 1
	fi
	echo "$tag"
}

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
rg_tag="$(gh_latest_tag BurntSushi/ripgrep)"
curl -fsSL -o rg.tar.gz \
	"https://github.com/BurntSushi/ripgrep/releases/download/${rg_tag}/ripgrep-${rg_tag}-${musl_a}.tar.gz"
tar -xzf rg.tar.gz
install -m755 ripgrep-*/rg /usr/local/bin/rg

# fd (musl)
fd_tag="$(gh_latest_tag sharkdp/fd)"
curl -fsSL -o fd.tar.gz \
	"https://github.com/sharkdp/fd/releases/download/${fd_tag}/fd-${fd_tag}-${musl_a}.tar.gz"
tar -xzf fd.tar.gz
install -m755 fd-*/fd /usr/local/bin/fd

# fzf
fzf_tag="$(gh_latest_tag junegunn/fzf)"
curl -fsSL -o fzf.tar.gz \
	"https://github.com/junegunn/fzf/releases/download/${fzf_tag}/fzf-${fzf_tag#v}-linux_${fzf_a}.tar.gz"
tar -xzf fzf.tar.gz
install -m755 fzf /usr/local/bin/fzf

# tree-sitter
curl -fsSL -o tree-sitter.gz \
	"https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${ts_a}.gz"
gzip -dc tree-sitter.gz >/usr/local/bin/tree-sitter
chmod +x /usr/local/bin/tree-sitter

nvim --version | sed -n '1p' || true
rg --version | sed -n '1p' || true
fd --version
fzf --version
tree-sitter --version
unzip -v 2>&1 | sed -n '1p' || true
npm --version

# Auto-activate virtual environment if needed
# TODO: Add
