DOTFILES_DIR := $(shell pwd)
HOME_DIR := $(HOME)

# Files/directories to exclude from symlinking
EXCLUDE := . .. .git .gitignore README.md Makefile

# Get all dotfiles and directories, excluding the ones in EXCLUDE
DOTFILES := $(filter-out $(EXCLUDE), $(wildcard .*))

.PHONY: all install uninstall list backup

all: install

install:
	@echo "Creating symlinks from $(DOTFILES_DIR) to $(HOME_DIR)..."
	@for file in $(DOTFILES); do \
		if [ -e "$(HOME_DIR)/$$file" ] && [ ! -L "$(HOME_DIR)/$$file" ]; then \
			echo "  Backing up existing $$file to $$file.backup"; \
			mv "$(HOME_DIR)/$$file" "$(HOME_DIR)/$$file.backup"; \
		fi; \
		if [ -L "$(HOME_DIR)/$$file" ]; then \
			echo "  Removing existing symlink $$file"; \
			rm "$(HOME_DIR)/$$file"; \
		fi; \
		echo "  Linking $$file"; \
		ln -s "$(DOTFILES_DIR)/$$file" "$(HOME_DIR)/$$file"; \
	done
	@echo "Done!"

uninstall:
	@echo "Removing symlinks..."
	@for file in $(DOTFILES); do \
		if [ -L "$(HOME_DIR)/$$file" ]; then \
			echo "  Removing $$file"; \
			rm "$(HOME_DIR)/$$file"; \
			if [ -e "$(HOME_DIR)/$$file.backup" ]; then \
				echo "  Restoring $$file.backup"; \
				mv "$(HOME_DIR)/$$file.backup" "$(HOME_DIR)/$$file"; \
			fi; \
		fi; \
	done
	@echo "Done!"

backup:
	@echo "Backing up existing dotfiles..."
	@for file in $(DOTFILES); do \
		if [ -e "$(HOME_DIR)/$$file" ] && [ ! -L "$(HOME_DIR)/$$file" ]; then \
			echo "  Backing up $$file"; \
			mv "$(HOME_DIR)/$$file" "$(HOME_DIR)/$$file.backup"; \
		fi; \
	done
	@echo "Done!"

list:
	@echo "Dotfiles to be symlinked:"
	@for file in $(DOTFILES); do \
		echo "  $$file"; \
	done
