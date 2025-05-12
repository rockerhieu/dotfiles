####### install homebrew
if [[ ! -x "/opt/homebrew/bin/brew" ]]; then
  echo "Homebrew is not installed. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

####### Initialize Homebrew shell environment
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

####### install rvm
if [[ ! -d "$HOME/.rvm" ]]; then
    echo "RVM is not installed. Installing..."
    curl -sSL https://get.rvm.io | bash -s stable --ruby
fi

####### Ensure RVM is added to PATH and sourced correctly
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

####### install nvm
if [[ ! -d "$HOME/.nvm" ]]; then
    echo "NVM is not installed. Installing..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

####### Ensure NVM is sourced correctly
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

####### install antigen
if [[ ! -f "/opt/homebrew/share/antigen/antigen.zsh" ]]; then
  echo "Antigen is not installed. Installing..."
  brew install antigen
  brew install fzf
fi
source /opt/homebrew/share/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

# Load the theme.
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply

# for zsh-history-substring-search
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# for moving between words
bindkey -e
bindkey '\e\e[C' forward-word
bindkey '\e\e[D' backward-word

# Load the shell dotfiles:
for file in ~/.{brew,java,path,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Function to capture the start time in milliseconds
function preexec {
    timer=$EPOCHREALTIME
}

# Function to calculate and display the duration in milliseconds
function precmd {
    if [[ -n "$timer" ]]; then
        # EPOCHREALTIME includes seconds and microseconds, split by a dot
        # Calculate the duration by subtracting the start time from the current time
        # and then formatting the result to show milliseconds.
        end_time=$EPOCHREALTIME
        elapsed=$(bc <<< "($end_time - $timer) * 1000")
        # Reset the timer
        unset timer
        # Update RPROMPT to show the current time and last command duration in milliseconds
        RPROMPT="%D{%H:%M:%S} (last: ${elapsed}ms)"
    else
        RPROMPT="%D{%H:%M:%S}"
    fi
}

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


#compdef cdxgen
###-begin-cdxgen-completions-###
#
# yargs command completion script
#
# Installation: cdxgen completion >> ~/.zshrc
#    or cdxgen completion >> ~/.zprofile on OSX.
#
_cdxgen_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" cdxgen --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _cdxgen_yargs_completions cdxgen
###-end-cdxgen-completions-###

#compdef cdxgen
###-begin-cdxgen-completions-###
#
# yargs command completion script
#
# Installation: cdxgen completion >> ~/.zshrc
#    or cdxgen completion >> ~/.zprofile on OSX.
#
_cdxgen_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" cdxgen --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _cdxgen_yargs_completions cdxgen
###-end-cdxgen-completions-###


. "$HOME/.local/bin/env"

# bun completions
[ -s "/Users/hhua/.bun/_bun" ] && source "/Users/hhua/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/hhua/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
