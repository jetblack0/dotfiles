# Environment for every zsh, interactive or not.
#
# This is the first file zsh reads, and it runs before /etc/zprofile. It must
# not assume a terminal, must not print anything, and must not touch PATH:
# macOS runs path_helper from /etc/zprofile afterwards, which rebuilds PATH
# and pushes anything set here below /usr/bin. PATH and MANPATH are built in
# .zshrc instead, where nothing reorders them.
#
# XDG_* and ZDOTDIR normally come from /etc/zshenv. ZDOTDIR is re-exported
# below so a machine without that file still finds this directory.
#
# shellcheck shell=bash
# shellcheck disable=SC2034  # zsh reads skip_global_compinit itself
# shellcheck disable=SC2296  # ${(%):-%m} is a zsh expansion flag, not bash


# Shell
# ---------------------------------------------
# Skip the compinit that /etc/zshrc runs; plugins/simple-completion.zsh runs
# its own, later, against $ZSH_COMPDUMP.
skip_global_compinit=1

export ZDOTDIR="$XDG_CONFIG_HOME"/shell/zsh
export ZSH_COMPDUMP="$XDG_CACHE_HOME"/zsh/.zcompdump-${(%):-%m}-${ZSH_VERSION}
export INPUTRC="$XDG_CONFIG_HOME"/shell/inputrc


# Default programs
# ---------------------------------------------
export EDITOR="nvim"
export GRIMBLAST_EDITOR="pinta"
[ -n "$DISPLAY" ] && export BROWSER=zen-browser


# XDG paths: terminal and desktop
# ---------------------------------------------
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export PF_SOURCE="$XDG_CONFIG_HOME/pfetch/pfetch.sh"
export FCEUX_HOME="$XDG_CONFIG_HOME"/fceux
export W3M_DIR="$XDG_DATA_HOME"/w3m
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv


# XDG paths: secrets
# ---------------------------------------------
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"


# XDG paths: languages and runtimes
# ---------------------------------------------
# rust
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

# go
export GOPATH="$XDG_DATA_HOME"/go

# node and npm
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NPM_PACKAGES="${XDG_DATA_HOME}/npm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc

# java
# Breaks some JDKs that parse _JAVA_OPTIONS strictly, hence off.
# export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export _JAVA_AWT_WM_NONREPARENTING=1
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

# dotnet
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages

# python
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc


# XDG paths: database clients
# ---------------------------------------------
export PSQL_HISTORY="$XDG_DATA_HOME/psql_history"
export SQLITE_HISTORY="$XDG_CACHE_HOME"/sqlite_history
export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history
export REDISCLI_HISTFILE="$XDG_DATA_HOME"/redis/rediscli_history


# XDG paths: ops tooling
# ---------------------------------------------
export ANSIBLE_HOME="$XDG_DATA_HOME"/ansible
export ANSIBLE_COLOR_DOC_CONSTANT="bright green"
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export VAGRANT_HOME="$XDG_DATA_HOME"/vagrant
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android

# kubernetes
export KREW_ROOT="$XDG_DATA_HOME"/krew
export MINIKUBE_HOME="$XDG_DATA_HOME"/minikube

# aws
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export AWS_PAGER=""

# loki
export LOKI_ADDR="https://loki.ops.unazoomer.com"
export LOKI_ORG_ID="ops"

# claude
# export CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1


# fzf
# ---------------------------------------------
fzf_base_options='--bind=alt-k:up,alt-j:down --height=10 --layout=reverse --cycle'
# Gruvbox
export FZF_DEFAULT_OPTS="$fzf_base_options --color=fg:#ebdbb2,hl:#b16286 --color=fg+:#689d6a,bg+:#32302f,hl+:#d3869b --color=info:#d65d0e,prompt:#458588,pointer:#fe8019 --color=marker:#8ec07c,spinner:#cc241d,header:#fabd2f"
unset fzf_base_options

export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND='rg --files --hidden .'
export FZF_ALT_C_COMMAND='rg --hidden --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq'


# Pagers
# ---------------------------------------------
# -R lets colour through, -i makes search case insensitive.
export LESS=-Ri
export DELTA_PAGER="less"

# bat
# export BAT_STYLE="header,numbers,plain"
# export BAT_PAGER=""

# Colours for man pages.
export LESS_TERMCAP_mb=$'\e[1;31m'     # start blink
export LESS_TERMCAP_md=$'\e[1;32m'     # start bold -- section headings
# export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_so=$'\e[01;44;37m' # start standout -- the status line
export LESS_TERMCAP_us=$'\e[01;37m'    # start underline -- arguments
export LESS_TERMCAP_me=$'\e[0m'        # stop bold and blink
export LESS_TERMCAP_se=$'\e[0m'        # stop standout
export LESS_TERMCAP_ue=$'\e[0m'        # stop underline
# Without this, groff emits SGR sequences the escapes above cannot override.
export GROFF_NO_SGR=1
