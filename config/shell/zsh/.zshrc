#
# zshrc configuration
#

# Basic settings
# ------------------------------------------------------------------------------
	# history settings --------------------
	# ignore duplicate history
	setopt HIST_EXPIRE_DUPS_FIRST
	setopt HIST_IGNORE_DUPS
	setopt HIST_IGNORE_ALL_DUPS
	setopt HIST_IGNORE_SPACE
	setopt HIST_FIND_NO_DUPS
	setopt HIST_SAVE_NO_DUPS
	# share history between different session
	setopt SHARE_HISTORY
	# don't record command that start with space
	setopt HIST_IGNORE_SPACE


# Custom functionality
# ------------------------------------------------------------------------------
	# use lf to switch directories (image preview doesn't work on wayland)
	# lfcd () {
	# 	tmp="$(mktemp -uq)"
	# 	trap 'rm -f $tmp >/dev/null 2>&1' HUP INT QUIT TERM PWR EXIT
	# 	lfub -last-dir-path="$tmp" "$@"
	# 	if [ -f "$tmp" ]; then
	# 		dir="$(cat "$tmp")"
	# 		[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
	# 	fi
	# }

 lfcd () {
     tmp="$(mktemp)"
     # `command` is needed in case `lfcd` is aliased to `lf`
     command lf -last-dir-path="$tmp" "$@"
     if [ -f "$tmp" ]; then
         dir="$(cat "$tmp")"
         rm -f "$tmp"
         if [ -d "$dir" ]; then
             if [ "$dir" != "$(pwd)" ]; then
                 cd "$dir"
             fi
         fi
     fi
 }

 # open all the images in current directory using nsxiv
 images() {
	# fd -e "jpeg" -e "png" -e "jpg" --print0 | xargs -0 exa --reverse --sort=time | nsxiv -i
	find . -regextype awk -iregex ".*png|.*jpeg|.*jpg" -print0 | xargs -0 exa --reverse --sort=time | nsxiv -i
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


# Plugin
# ------------------------------------------------------------------------------
	plugin_path="$HOME/.config/shell/zsh/plugins"
	source $plugin_path/appearance/appearance.zsh

	source /usr/share/fzf/key-bindings.zsh
	source /usr/share/fzf/completion.zsh

	source $plugin_path/zsh-autosuggestions/zsh-autosuggestions.zsh
	source $plugin_path/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	source $plugin_path/zsh-completion/completion.zsh
	# source $pluginPath/catppuccin-zsh-syntax-highlighting/catppuccin_macchiato-zsh-syntax-highlighting.zsh
	# source $pluginPath/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh


# Keybindings
# ------------------------------------------------------------------------------
	bindkey -s '^f' '^ulfcd\n'
	bindkey -s '^n' '^uimages\n'
	# bindkey -s '^e' '^usource /home/jetblack/Development/myScript/fzfScript/fzfListDirectories.sh\n'
	bindkey -s '^p' '^usource /home/johnny/Development/script/programs/fzf/fzfcd.sh\n'
	bindkey -s '^o' '^usource /home/johnny/Development/script/programs/fzf/fzfopen.sh\n'
	bindkey -s '^v' '^unvim .\n'
	# bindkey -M menuselect 'u' send-break
	# bindkey -M menuselect '\e' accept-line
# ------------------------------------------------------------------------------


# Alias
# ------------------------------------------------------------------------------
	alias neofetch="fastfetch"
	alias nvidia-settings="nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings""
	alias yarn="yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config"
	alias wget="wget --hsts-file=$XDG_DATA_HOME/wget/wget-hsts"
	# alias lf="lfcd"
	alias vim="nvim"
	alias diff="diff --color"
	alias pfi="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
	alias pfr="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
	alias ip="ip -c=always"
	alias sudo="sudo "
	# run a program with less CPU and half memory, useful for compiling and installing un-urgent things. CPUQuota higher than this would cause noticeable lags
	alias climit="systemd-run --user --scope --slice=program.slice -u compiling.scope -p CPUQuota=100% -p MemoryMax=50%"

	# Systemd command suite ----------------
	alias cgtop="systemd-cgtop"
	alias cgls="systemd-cgls"
	alias ctl="systemctl"
	alias clt="systemctl"
	alias jclt="journalctl"
	alias jctl="journalctl"
	alias rctl="resolvectl"
	alias rclt="resolvectl"
	alias lctl="loginctl"
	alias lclt="loginctl"
	alias nctl="networkctl"
	alias nclt="networkctl"

	# Alternatives -------------------------
	# paru for yay
	alias yay="paru"
	# exa for ls
	alias ls="eza"
	alias ll="ls -lHg"
	alias lla="ll -a"
	alias la="ls -a"
	alias tree="exa -TL"
	# ripgrep for grep
	alias grep="rg"
	# bat for cat
	alias cat="bat"
	# dua for du
	# alias du="dua"
	# benchmark tool
	alias timer="hyperfine"
	alias diff="delta"

	# Typo ---------------------------------
	alias s="ls"
	alias sl="ls"
	alias l="ls"
	alias nivm="nvim"
	alias handbrakecli="HandBrakeCLI"
	alias suod="sudo"
	alias sduo="sudo"
