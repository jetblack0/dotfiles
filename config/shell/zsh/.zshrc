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
# history setting (environment variables are in ~/.zshenv file)
	# ignore duplicate history
	setopt HIST_EXPIRE_DUPS_FIRST
	setopt HIST_IGNORE_DUPS
	setopt HIST_IGNORE_ALL_DUPS
	setopt HIST_IGNORE_SPACE
	setopt HIST_FIND_NO_DUPS
	setopt HIST_SAVE_NO_DUPS
	# share history between different session
	# setopt SHARE_HISTORY
	# don't record command that start with space
	# setopt HIST_IGNORE_SPACE
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
	bindkey -s '^y' '^usource /home/jetblack/Development/myScript/fzfScript/fzfConfig.sh\n'
	bindkey -s '^p' '^usource /home/jetblack/Development/myScript/fzfScript/fzfCd.sh && lfcd\n'
# ------------------------------------------------------------------------------


# Plugin
# ------------------------------------------------------------------------------
	source /usr/share/fzf/key-bindings.zsh
	source /usr/share/fzf/completion.zsh

	source $pluginPath/zsh-autosuggestions/zsh-autosuggestions.zsh
	source $pluginPath/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	# TODO: works not good, changethe the Keybindings
	source $pluginPath/zsh-completion/completion.zsh
	# source $pluginPath/catppuccin-zsh-syntax-highlighting/catppuccin_macchiato-zsh-syntax-highlighting.zsh
	# source $pluginPath/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# ------------------------------------------------------------------------------


# Alias
# ------------------------------------------------------------------------------
	alias nvidia-settings="$XDG_CONFIG_HOME/nvidia/settings"
	alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
	alias lf="lfcd"
	alias vim="nvim"
	alias nivm="nvim"
	alias diff="diff --color"
	alias pacmanfzfInstall="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
	alias pacmanfzfRemove="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"

# rust alternative
	# paru for yay
	alias yay="paru"
	# exa for ls
	alias ls="exa"
	alias ll="ls -lHg"
	alias lla="ll -a"
	alias lsa="ls -a"
	alias tree="exa -TL"
	# ripgrep for grep
	alias grep="rg"
	# bat for cat
	alias cat="bat"
	# dua for du
	# alias du="dua"
	# benchmark tool
	alias timer="hyperfine"
# ------------------------------------------------------------------------------
