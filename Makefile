# Debug should not be defaulted to a value.
export DEBUG ?=

# Get some OS info
export OS ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')

# Get working dir
export SRC_PATH ?= $(shell 'pwd')

# Set default make target print out info 
.DEFAULT_GOAL := make.get.info

# define standard colors
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

# Get some package names looped
brew_all_pkgs := $(file < $(SRC_PATH)/system/brew.pkgs)


.PHONY: make.get.info
make.get.info:
	@echo "${GREEN}Date:${RESET}\t\t ${YELLOW}$(shell date +"%F")${RESET}"
	@echo "${GREEN}OS:${RESET}\t\t ${YELLOW}$(OS)${RESET}"
	@echo "${GREEN}usr_home:${RESET}\t$(YELLOW) $(HOME)${RESET}"
	@echo "${GREEN}src_path:${RESET}\t$(YELLOW) $(SRC_PATH)${RESET}"

.PHONY: brew.pkg.list
brew.pkg.list:
	brew list > $(SRC_PATH)/system/brew-$(shell date +"%F").pkgs

.PHONY: backup.fish.config
backup.fish.config:
ifeq (,$(wildcard $(HOME)/.config/fish))
    mv $(HOME)/.config/fish $(HOME)/.config/back.fish
endif

.PHONY: backup.vim.config
backup.vim.config:
ifeq (,$(wildcard $(HOME)/.vim/))
    mv $(HOME)/.vim/ $(HOME)/.back.vim/
endif

ifeq (,$(wildcard $(HOME)/.vimrc))
    mv $(HOME)/.vimrc $(HOME)/.back.vimrc
endif


.PHONY: bckup.all.configs
backup.all.configs: backup.fish.config
	@echo "Backing up fish config"
#	cp $(HOME)/.vimrc $(HOME)/back.vimrc
#	cp $(HOME)/.config/fish $(HOME)/.config/back.fish
#	cp $(HOME)/.vim $(HOME)/back.vim
#	cp $(HOME)/.zshrc $(HOME)/back.zshrc
#	cp $(HOME)/.ssh $(HOME)/back.ssh
#	cp $(HOME)/Library/ApplicationSupport/Code/User $(HOME)/Library/ApplicationSupport/Code/Back.User
