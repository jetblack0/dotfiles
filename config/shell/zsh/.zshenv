# zsh environment variable, some variables are defined in /etc/zsh/zshenv

skip_global_compinit=1

# Default programs ---------------------
# --------------------------------------
export EDITOR="nvim"
export GRIMBLAST_EDITOR="pinta"
[ -n "$DISPLAY" ] && export BROWSER=zen-browser



# Default config paths -----------------
# --------------------------------------
# Desktop -----
export ZDOTDIR="$XDG_CONFIG_HOME"/shell/zsh
export ZSH_COMPDUMP="$XDG_CACHE_HOME"/zsh/.zcompdump-${(%):-%m}-${ZSH_VERSION}
export INPUTRC="$XDG_CONFIG_HOME"/shell/inputrc
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export XCURSOR_PATH="$XDG_DATA_HOME"/icons
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
# export MANPATH="${MANPATH-$(manpath)}"
# export MANPATH="$(manpath):$NPM_PACKAGES/share/man"
# pfetch
export PF_SOURCE="$XDG_CONFIG_HOME/pfetch/pfetch.sh"
# fceux
export FCEUX_HOME="$XDG_CONFIG_HOME"/fceux
# pass
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
# electrum
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
# w3m
export W3M_DIR="$XDG_DATA_HOME"/w3m
# gnupg
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# Dev tools -----
# ansible
export ANSIBLE_HOME="$XDG_DATA_HOME"/ansible
export ANSIBLE_COLOR_DOC_CONSTANT="bright green"
# postgres
export PSQL_HISTORY="$XDG_DATA_HOME/psql_history"
# Krew
export KREW_ROOT="$XDG_DATA_HOME"/krew
# Rust
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export PATH=$HOME/.local/share/cargo/bin:$PATH
# Java
# export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export _JAVA_AWT_WM_NONREPARENTING=1
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
# go
export GOPATH="$XDG_DATA_HOME"/go
# node
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
# npm
export NPM_PACKAGES="${XDG_DATA_HOME}/npm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export PATH="$PATH:$NPM_PACKAGES/bin:${KREW_ROOT:-$HOME/.krew}/bin"
# docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
# Vagrant
export VAGRANT_HOME="$XDG_DATA_HOME"/vagrant
# nuget
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
# dotnet
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
# sqlite
export SQLITE_HISTORY="$XDG_CACHE_HOME"/sqlite_history
# python
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc
# Android adb
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
# AWS
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
# Minikube
export MINIKUBE_HOME="$XDG_DATA_HOME"/minikube
# Others
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv



# Override default configurations ------
# --------------------------------------
# fzf
local fzf_base_options='--bind=alt-k:up,alt-j:down --height=10 --layout=reverse --cycle'
# Gruvbox
export FZF_DEFAULT_OPTS="$fzf_base_options --color=fg:#ebdbb2,hl:#b16286 --color=fg+:#689d6a,bg+:#32302f,hl+:#d3869b --color=info:#d65d0e,prompt:#458588,pointer:#fe8019 --color=marker:#8ec07c,spinner:#cc241d,header:#fabd2f"

# Use rg instead of find to list hidden files, doesn't search files
# in .gitignore and skip binary files.
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND='rg --files --hidden .'
export FZF_ALT_C_COMMAND='rg --hidden --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq'

# bat
# export BAT_STYLE="header,numbers,plain"
# export BAT_PAGER=""

# delta
export DELTA_PAGER="less"

# man page
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
# export LESS_TERMCAP_md=$'\e[1;36m'     # begin blink (light green)
export LESS_TERMCAP_md=$'\e[1;32m'     # begin blink (light green)
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal
