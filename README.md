# Config syncronization 
Run all commands in repo directory.

## Adding new config

1. Move new config to the repo. For example:
```bash
mv ~/.zshrc .
```
2. Start synchorization:
```bash
stow .
```

## Setting up a new computer 

Run these commands in repo directory.
1. Remove old configs:
```bash
rm -r ~/.zshrc ~/.tmux.conf ~/.config/niri ~/.config/kitty ~/.config/lazygit ~/.config/nvim/ ~/.config/noctalia/ ~/.local/state/noctalia/settings.toml ~/.gitconfig
```
2. Start synchronization:
```bash
stow .
```
3. Reboot Noctalia:
```bash
pkill -x noctalia; while pgrep -x noctalia >/dev/null; do sleep 0.2; done; niri msg action spawn -- noctalia
```
