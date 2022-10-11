# ---------------- XDG -------------------
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
# ----------------------------------------

# ------ config path of some programs ----------------
export ZDOTDIR="$XDG_CONFIG_HOME"/shell/zsh
export INPUTRC="$XDG_CONFIG_HOME"/shell/.inputrc
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export XCURSOR_PATH="$XDG_DATA_HOME"/icons
# ----------------------------------------------------

# --- default programs ----
export EDITOR="nvim"
[ -n "$DISPLAY" ] && export BROWSER=firefox
# -------------------------

# --------------- history setting --------------------
export HISTFILE="$HOME/.config/shell/zsh/.zsh_history"
export HISTSIZE=9223372036854775807
export SAVEHIST=9223372036854775807
# ----------------------------------------------------

# ------------------- config and options for some programs ---------------------------------------------------------
# fzf
	# default option
	export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --cycle --border=rounded'
	# use rg instead of find to list hidden files, fastest, it doesn't search files in .gitignore and skip binary files 
	export FZF_DEFAULT_COMMAND='rg --files --hidden'
	# ctrl t to search all the files in current directory inclue hidden files
	export FZF_CTRL_T_COMMAND='rg --files --hidden .'
	# export FZF_ALT_C_COMMAND='rg --files --hidden --null . | xargs -0 dirname | sort -u'
	export FZF_ALT_C_COMMAND='rg --hidden --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq'
# ------------------------------------------------------------------------------------------------------------------

# ---------- other stuff ----------------
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
# ---------------------------------------
