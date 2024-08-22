# zsh environment variable, some variables are defined in /etc/zsh/zshenv

# ------------------------------------ XDG stuff ---------------------------------------
# export XDG_DATA_HOME=$HOME/.local/share
# export XDG_STATE_HOME=$HOME/.local/state
# export XDG_CONFIG_HOME=$HOME/.config
# export XDG_CACHE_HOME=$HOME/.cache


# ---------------------------------- default programs ----------------------------------
export EDITOR="nvim"
[ -n "$DISPLAY" ] && export BROWSER=firefox


# --------------------------------- history setting ------------------------------------
# HISTFILE="$HOME/.config/shell/zsh/.zsh_history"
# HISTSIZE=9223372036854775807
# SAVEHIST=9223372036854775807


# ------------------------------- default path for programs ----------------------------
export ZDOTDIR="$XDG_CONFIG_HOME"/shell/zsh
export INPUTRC="$XDG_CONFIG_HOME"/shell/.inputrc
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export XCURSOR_PATH="$XDG_DATA_HOME"/icons
# pfetch
	export PF_SOURCE="$XDG_CONFIG_HOME/pfetch/pfetch.sh"
# fceux
	export FCEUX_HOME="$XDG_CONFIG_HOME"/fceux
# postgresql
	export PSQL_HISTORY="$XDG_DATA_HOME/psql_history"
# pass
	export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
# other stuff
	export GNUPGHOME="$XDG_DATA_HOME"/gnupg
	export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv


# --------------------------- default configuration for programs -----------------------
# fzf
	# appearance
	export FZF_DEFAULT_OPTS='--bind=alt-k:up,alt-j:down --height 50% --layout=reverse --cycle --border=rounded --color=bw,spinner:#f6c177,hl:#ebbcba:regular,fg:#e0def4,header:#31748f,info:#9ccfd8,pointer:#c4a7e7,marker:#eb6f92,fg+:#9ccfd8:regular,prompt:#908caa,hl+:#ebbcba:regular'
	# export FZF_DEFAULT_OPTS='--bind=alt-k:up,alt-j:down --height 50% --layout=reverse --cycle --border=rounded --color=bw,spinner:#dc8a78,hl:#5F8700:regular,fg:#444444,header:#d20f39,info:#764E37,pointer:#764E37,marker:#5F8700,fg+:#0087AF:regular,prompt:#5F8700,hl+:#5F8700:regular'
	# use rg instead of find to list hidden files, fastest, it doesn't search files in .gitignore and skip binary files 
	export FZF_DEFAULT_COMMAND='rg --files'
	# ctrl t to search all the files in current directory inclue hidden files
	export FZF_CTRL_T_COMMAND='rg --files --hidden .'
	# export FZF_ALT_C_COMMAND='rg --files --hidden --null . | xargs -0 dirname | sort -u'
	export FZF_ALT_C_COMMAND='rg --hidden --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq'
# qt
	export QT_QPA_PLATFORMTHEME=qt5ct
# fcitx (IMF)
	export GTK_IM_MODULE='wayland'
	export QT_IM_MODULE='fcitx'
	export XMODIFIERS='@im=fcitx'
# bat
	# export BAT_STYLE="header,numbers,plain"
	# export BAT_PAGER=""
# grimblast
	export SCREENSHOT_PATH="/home/jetblack/Pictures/Screenshot"
# delta
	export DELTA_PAGER="less"


# ----------------- default path for compilers and other server applications ----------
# rust
	export CARGO_HOME="$XDG_DATA_HOME"/cargo
	export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
	export PATH=/home/jetblack/.local/share/cargo/bin:$PATH
# java
	# export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
	export _JAVA_AWT_WM_NONREPARENTING=1
# go
	export GOPATH="$XDG_DATA_HOME"/go
# node
	export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
# npm
	export NPM_PACKAGES="${XDG_DATA_HOME}/npm"
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
	export PATH="$PATH:$NPM_PACKAGES/bin"
# docker
	# export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
# manpath
	export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
	# export MANPATH="${MANPATH-$(manpath)}"
	# export MANPATH="$(manpath):$NPM_PACKAGES/share/man"
