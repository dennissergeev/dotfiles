# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE='awesome-flat'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(anaconda dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(ram)
export TERM="xterm-256color"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias rsync="noglob rsync"
alias ssh="noglob ssh"
source ~/.bash_profile

# which + vim (https://ctoomey.com/writing/which-plus-vim-wvim)
# top-level command. Determines the type of the requested command and then
# attempts to open it in vim
wvim() {
  command_name="$1"
  case "$(_definition_type "$command_name")" in
    "alias") _edit_shell_alias "$command_name";;
    "function") _edit_shell_function "$command_name";;
    "script") _edit_script "$command_name";;
    "git-alias") _edit_git_alias "$command_name";;
    "not found") _handle_unknown_command "$command_name"
  esac
}

# This line configures zsh tab completion for `wvim` by reusing the tab completion
# for `which`
compdef wvim=which

# Use the `type` command to determine the type of the provided command
_definition_type() {
  arg_type_string=$(type -a "$1")
  if [[ "$arg_type_string" == *"is an alias"* ]]; then
    echo "alias"
  elif [[ "$arg_type_string" == *"is a shell function"* ]]; then
    echo "function"
  elif which "$1" > /dev/null 2>&1; then
    echo "script"
  elif _is_git_alias "$1"; then
    echo "git-alias"
  else
    echo "not found"
  fi
}

# Special handling for git aliases since `type` doesn't know about them
_is_git_alias() {
  echo "$1" | grep -q 'git-.*' && _git_aliases | grep -qF $(_git_alias_name "$1")
}

_handle_unknown_command() {
  echo "\"$1\" is not recognized as a script, function, or alias" >&2
  return 1
}

_git_alias_name() {
  echo "$1" | sed 's/^git-//'
}

_git_aliases() {
  git config --get-regexp ^alias\. |\
    sed -e s/^alias\.// -e s/\ /\ =\ / |\
    awk '{print $1}'
}

_edit_git_alias() {
  line=$(grep -En "^\s+$(_git_alias_name "$1") =" ~/.gitconfig | cut -d ":" -f 1)
  vim ~/.gitconfig "+$line"
}

_edit_script() {
  vim "$(which "$1")"
}

_definition_field_for_pattern() {
  definition=$(grep -En "$2" ~/.zshrc ~/.zshenv ~/.zsh/**/*.zsh 2>/dev/null)
  echo "$definition" | cut -d ":" -f "$1"
}

_edit_based_on_pattern() {
  file=$(_definition_field_for_pattern 1 "$1")
  line=$(_definition_field_for_pattern 2 "$1")
  vim "$file" "+$line"
}

_edit_shell_function() {
  _edit_based_on_pattern "(^function $1)|(^$1\(\))"
}

_edit_shell_alias() {
  _edit_based_on_pattern "alias $1="
}
