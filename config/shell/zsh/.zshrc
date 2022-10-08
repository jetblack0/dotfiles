#                .__                   
# ________  _____|  |_________   ____  
# \___   / /  ___/  |  \_  __ \_/ ___\ 
#  /    /  \___ \|   Y  \  | \/\  \___ 
# /_____ \/____  >___|  /__|    \___  >
#       \/     \/     \/            \/
# JetBlack's zsh configrue


# Theme and outfit
# ------------------------------------------------------------------------------
	pluginPath="$HOME/.config/shell/zsh/plugins"
	source $pluginPath/appearance/appearance.zsh
# ------------------------------------------------------------------------------

# Other basic setting
# ------------------------------------------------------------------------------
# set proxy every time i open terminal
	export http_proxy=http://127.0.0.1:7890
	export https_proxy=http://127.0.0.1:7890
	# export ftp_proxy=http://127.0.0.1:7890

# preferred editor for local and remote sessions
	if [[ -n $SSH_CONNECTION ]]; then
	  export EDITOR='nvim'
	else
	  export EDITOR='nvim'
	fi

# history setting
	# history file path
	HISTFILE="$HOME/.config/shell/zsh/.zsh_history"
	HISTSIZE=10000000
	SAVEHIST=10000000
	# ignore duplicate history
	setopt hist_ignore_all_dups
	# share history between different session
	setopt SHARE_HISTORY
	# don't record command that start with space
	setopt HIST_IGNORE_SPACE
# ------------------------------------------------------------------------------

# Custom functionality
# ------------------------------------------------------------------------------
# use lf to switch directories
	lfcd () {
		tmp="$(mktemp -uq)"
		trap 'rm -f $tmp >/dev/null 2>&1' HUP INT QUIT TERM PWR EXIT
		lfub -last-dir-path="$tmp" "$@"
		if [ -f "$tmp" ]; then
			dir="$(cat "$tmp")"
			[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
		fi
	}

# use vi mode
	bindkey -v
	export KEYTIMEOUT=1

	# change cursor in vi mode
	function zle-keymap-select {
	  if [[ ${KEYMAP} == vicmd ]] ||
		 [[ $1 = 'block' ]]; then
		echo -ne '\e[2 q'
	  elif [[ ${KEYMAP} == main ]] ||
		   [[ ${KEYMAP} == viins ]] ||
		   [[ ${KEYMAP} = '' ]] ||
		   [[ $1 = 'beam' ]]; then
		echo -ne '\e[6 q'
	  fi
	}
	zle -N zle-keymap-select
	zle-line-init() {
		zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
		echo -ne "\e[6 q"
	}
	zle -N zle-line-init
	echo -ne '\e[6 q' # Use beam shape cursor on startup.
	preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.
# ------------------------------------------------------------------------------


# Keybindings
# ------------------------------------------------------------------------------
	bindkey -s '^o' '^ulfcd\n'
	bindkey -s '^y' '^usource /home/jetblack/Development/MyScript/fzfScript/fzfConfig.sh\n'
	bindkey -s '^e' '^usource /home/jetblack/Development/MyScript/fzfScript/fzfCd.sh\n'
# ------------------------------------------------------------------------------


# Plugin
# ------------------------------------------------------------------------------
# TODO: these two things suck, they don't follow the config, they don't show dot file, make one myself
	source /usr/share/fzf/key-bindings.zsh
	source /usr/share/fzf/completion.zsh

	source $pluginPath/zsh-autosuggestions/zsh-autosuggestions.zsh
	source $pluginPath/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	source $pluginPath/zsh-completion/completion.zsh
	# source $pluginPath/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# TODO: tab completion doesn't show dot files
	# source $pluginPath/fzf-tab/fzf-tab.plugin.zsh

# fzf config, only work for fzf program
	# default option for fzf
	export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --cycle --border=rounded'
	# use the_silver_searcher instead of find to list hidden files 
	export FZF_DEFAULT_COMMAND='ag --hidden --ignore .cache --ignore .git --ignore .npm --ignore .pki -f -g ""'
# ------------------------------------------------------------------------------


# Alias
# ------------------------------------------------------------------------------
	alias nvidia-settings="$XDG_CONFIG_HOME/nvidia/settings"
	alias lf="lfcd"
	alias vim="nvim"
	alias diff="diff --color"
	alias pacmanfzfInstall="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
	alias pacmanfzfRemove="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
	alias yay="paru"
	# alias grep="grep --color"

# rust alternative
	# exa
	alias ls="exa"
	alias ll="ls -l"
	alias lla="ls -la"
	alias lsa="ls -a"
	alias tree="exa -TL"
	# ripgrep
	alias grep="rg"
	# bat
	alias cat="bat"
# ------------------------------------------------------------------------------
