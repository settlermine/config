DOTFILES_DIR := ./dotfiles

FILES        := ~/.zshrc ~/.tmux.conf ~/.gitconfig
CONFIG_DIRS  := ~/.config/nvim ~/.config/niri ~/.config/lazygit ~/.config/kitty

.PHONY: collect update

collect:
	@echo "===> Collecting dotfiles..."
	@rm -rf $(DOTFILES_DIR)
	@mkdir -p $(DOTFILES_DIR) $(DOTFILES_DIR)/.config
	@cp $(FILES) $(DOTFILES_DIR)/
	@for dir in $(CONFIG_DIRS); do \
		rsync -a $$dir $(DOTFILES_DIR)/.config/; \
	done
	@echo "===> Done!"

update:
	@echo "===> Updating system configs from dotfiles..."
	@for f in $(FILES); do \
		rm -f $$f; \
		cp $(DOTFILES_DIR)/$$(basename $$f) $$f; \
	done
	@for dir in $(CONFIG_DIRS); do \
		rm -rf $$dir; \
		rsync -a $(DOTFILES_DIR)/.config/$$(basename $$dir) $$(dirname $$dir)/; \
	done
	@echo "===> Done!"

