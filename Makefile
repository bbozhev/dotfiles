# Debug should not be defaulted to a value.
export DEBUG ?=

# Get some OS info
export OS ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')

# Get working dir
export SRC_PATH ?= $(shell 'pwd')

# Set default make target print out info
.DEFAULT_GOAL := help

# Get all .dot files for symlinks / backup configs
DOT_FILES := $(shell find $(SRC_PATH) -name '*.dot')

# Define some colors
ifneq (,$(findstring xterm,${TERM}))
	BLACK        := $(shell tput -Txterm setaf 0)
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	YELLOW       := $(shell tput -Txterm setaf 3)
	LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
	PURPLE       := $(shell tput -Txterm setaf 5)
	BLUE         := $(shell tput -Txterm setaf 6)
	WHITE        := $(shell tput -Txterm setaf 7)
	RESET := $(shell tput -Txterm sgr0)
else
	BLACK        := ""
	RED          := ""
	GREEN        := ""
	YELLOW       := ""
	LIGHTPURPLE  := ""
	PURPLE       := ""
	BLUE         := ""
	WHITE        := ""
	RESET        := ""
endif

.PHONY: help
help:
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'

# Get some package names looped
brew_all_pkgs := $(file < $(SRC_PATH)/system/brew.pkgs)

.PHONY: get.info
get.info: ## Get system info.
	@echo "${GREEN}Date:${RESET}\t\t ${YELLOW}$(shell date +"%F")${RESET}"
	@echo "${GREEN}OS:${RESET}\t\t ${YELLOW}$(OS)${RESET}"
	@echo "${GREEN}usr_home:${RESET}\t$(YELLOW) $(HOME)${RESET}"
	@echo "${GREEN}src_path:${RESET}\t$(YELLOW) $(SRC_PATH)${RESET}"

.PHONY: get.dot.files
get.dot.files: ## List of dot files included in the setup.
	@echo "$(DOT_FILES)"

.PHONY: brew.pkg.list
brew.pkg.list: ## List brew packages and update $(SRC_PATH)/system/brew-$date.pkgs for keeping an up to date package list.
	rm -f $(SRC_PATH)/system/brew-$(shell date +"%F").pkgs~
	brew list > $(SRC_PATH)/system/brew-$(shell date +"%F").pkgs
	brew cleanup

.PHONY: apply.osx.settings
install.osx.xcode: ## Apply MacOS settings from system/macos.sh
	$(shell system/macos.sh)

.PHONY: install.osx.xcode
install.osx.xcode: ## Installs xcode cli tools if not installed
	$(shell system/install-osx-cli-tools.sh)

.PHONY: install.brew
install.brew: install.osx.xcode ## Install homebrew with ruby one-liner
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | ruby

.PHONY: install.misc.tools
install.misc.tools: install.brew ## Install wget,curl,jq,tar,git,fd needed for misc.
	brew install wget curl jq tar git fd

.PHONY: install.fish
install.fish: install.brew ## Install fish shell with brew ( latest version fyi !)
	brew install fish

install.zsh: install.brew ## Install fish shell with brew ( latest version fyi !)
	brew install zsh

.PHONY: install.all.pkgs
install.all.pkgs: install.brew ## Install all brew packages inside of $(SRC_PATH)/system/brew.pkgs .
	for pkg in $$(cat $(SRC_PATH)/system/brew.pkgs); do brew install "$$pkg"; done
	@echo "Remove those old packages which you have been ignoring for a long time."
	brew cleanup

.PHONY: set.shell.fish
set.shell.fish: ## Set default shell to fish
	chsh -s $$(which fish)

.PHONY: set.shell.zsh
set.shell.zsh: ## Set default shell to zsh
	chsh -s $$(which zsh)

.PHONY: set.shell.bash
set.shell.bash: ## Set default shell to bash
	chsh -s $$(which bash)

.PHONY: backup.fish.config
backup.fish.config: ## Make a copy of the fish config
ifeq (,$(wildcard $(HOME)/.config/fish))
    cp $(HOME)/.config/fish $(HOME)/.config/back.fish
endif

.PHONY: backup.zsh.config
backup.zsh.config: ## Make a copy of the zshrc config
ifeq (,$(wildcard $(HOME)/.config/fish))
    cp $(HOME)/.zshrc $(HOME)/.back.zshrc
endif

.PHONY: bckup.all.configs
backup.all.configs: backup.fish.config ## Make a backup copy of all dotfiles
#	cp $(HOME)/.vimrc $(HOME)/back.vimrc
#	cp $(HOME)/.config/fish $(HOME)/.config/back.fish
#	cp $(HOME)/.vim $(HOME)/back.vim
#	cp $(HOME)/.zshrc $(HOME)/back.zshrc
#	cp $(HOME)/.ssh $(HOME)/back.ssh
#	cp $(HOME)/Library/ApplicationSupport/Code/User $(HOME)/Library/ApplicationSupport/Code/Back.User
