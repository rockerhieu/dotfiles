# ~/.zshrc - Main Zsh configuration file

# PATH configuration
source ~/.config/shell/path

# History configuration
source ~/.config/shell/history

# Antigen and oh-my-zsh setup (handles completions)
source ~/.config/shell/antigen

# Autocomplete
source ~/.config/shell/completion

# Directory navigation options
source ~/.config/shell/navigation

# Shell aliases
source ~/.config/shell/aliases

# Environment variables
source ~/.config/shell/environment

# Homebrew setup
source ~/.config/shell/homebrew

# Node version manager
source ~/.config/shell/nvm

# Python version manager
source ~/.config/shell/pyenv

# Zoxide (smart cd)
source ~/.config/shell/zoxide

# FZF configuration
source ~/.config/shell/fzf

# Prompt configuration (Starship)
source ~/.config/shell/prompt

# Dotfiles management functions
source ~/.config/shell/dotfiles

# Interactive shell functions
source ~/.config/shell/functions

# Local customizations (optional)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
