# my zsh environment variable, some variables did list here, they are:
# LS_COLORS, LESS_TERMCAP_mb, LESS_TERMCAP_md, LESS_TERMCAP_so, LESS_TERMCAP_us, LESS_TERMCAP_me, LESS_TERMCAP_se, LESS_TERMCAP_ue, GROFF_NO_SGR

# ------------------------------------ XDG stuff ---------------------------------------
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache


# ----------------------------- config path of some programs ---------------------------
export ZDOTDIR="$XDG_CONFIG_HOME"/shell/zsh
export INPUTRC="$XDG_CONFIG_HOME"/shell/.inputrc
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export XCURSOR_PATH="$XDG_DATA_HOME"/icons
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export PATH=/home/jetblack/.local/share/cargo/bin:$PATH
# java
	export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
# pfetch
	export PF_SOURCE="$XDG_CONFIG_HOME/pfetch/pfetch.sh"
# node
	export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
# npm
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
	NPM_PACKAGES="${XDG_DATA_HOME}/npm"
	export PATH="$PATH:$NPM_PACKAGES/bin"
	export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
# fceux
	export FCEUX_HOME="$XDG_CONFIG_HOME"/fceux

	export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# ---------------------------------- default programs ----------------------------------
export EDITOR="nvim"
[ -n "$DISPLAY" ] && export BROWSER=firefox


# --------------------------------- history setting ------------------------------------
HISTFILE="$HOME/.config/shell/zsh/.zsh_history"
HISTSIZE=9223372036854775807
SAVEHIST=9223372036854775807


# --------------------------- config and options for some programs ---------------------
# fzf
	# default option
	export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --cycle --border=rounded --color=bw,spinner:#f4dbd6,hl:#F5BDE6:regular,fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6,marker:#f4dbd6,fg+:#B7BDF8:regular,prompt:#c6a0f6,hl+:#F5BDE6:regular'
	# use rg instead of find to list hidden files, fastest, it doesn't search files in .gitignore and skip binary files 
	export FZF_DEFAULT_COMMAND='rg --files'
	# ctrl t to search all the files in current directory inclue hidden files
	export FZF_CTRL_T_COMMAND='rg --files --hidden .'
	# export FZF_ALT_C_COMMAND='rg --files --hidden --null . | xargs -0 dirname | sort -u'
	export FZF_ALT_C_COMMAND='rg --hidden --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq'

# qt
	export QT_QPA_PLATFORMTHEME=qt5ct

# fcitx (IMF)
	export GTK_IM_MODULE='fcitx'
	export QT_IM_MODULE='fcitx'
	export XMODIFIERS='@im=fcitx'

# bat
	export BAT_STYLE="header,numbers,plain"
	export BAT_PAGER=""


# --------------------------- other stuff ----------------------------------------------
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
