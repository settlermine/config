DOTFILES_DIR := ./dotfiles

FILES        := ~/.zshrc ~/.tmux.conf ~/.gitconfig
CONFIG_DIRS  := ~/.config/nvim ~/.config/niri ~/.config/lazygit ~/.config/kitty

.PHONY: all collect apply 

collect:
	@echo "===> Collecting dotfiles..."
	@rm -rf $(DOTFILES_DIR)
	@mkdir -p $(DOTFILES_DIR) $(CONFIG_DIR)
	@cp $(FILES) $(DOTFILES_DIR)/

	@rsync -a ~/.config/nvim $(DOTFILES_DIR)/.config/
	@rsync -a ~/.config/niri $(DOTFILES_DIR)/.config/
	@rsync -a ~/.config/lazygit $(DOTFILES_DIR)/.config/
	@rsync -a ~/.config/kitty $(DOTFILES_DIR)/.config/
	@echo "===> Done!"

