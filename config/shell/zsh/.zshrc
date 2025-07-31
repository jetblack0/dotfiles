if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# zshrc configuration
#

# Plugin -------------------------------
# --------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
# zinit light sindresorhus/pure
zinit ice depth=1; zinit light romkatv/powerlevel10k
# zinit light zsh-users/zsh-syntax-highlighting
# zinit light zsh-users/zsh-completions
# zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab

zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# snippets -----
# zinit snippet OMZP::command-not-found

# local plugins -----
local plugin_path="$HOME/.config/shell/zsh/plugins"
source $plugin_path/simple-completion.zsh

# autoload -Uz compinit && compinit -d $XDG_DATA_HOME/zsh
zinit cdreplay -q

# plugin configurations -----
# powerlevel10k
[[ ! -f ~/.config/shell/zsh/.p10k.zsh ]] || source ~/.config/shell/zsh/.p10k.zsh

# pure
# PURE_CMD_MAX_EXEC_TIME=10
# PURE_PROMPT_SYMBOL='󱙝 '
# PURE_PROMPT_VICMD_SYMBOL='󱙜 '
# zstyle ':prompt:pure:prompt:*' color white
# zstyle :prompt:pure:path color magenta



# Functions ----------------------------
# --------------------------------------
# yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# zoxide with fzf
function zicd() {
	dir=$(zoxide query --interactive)
	eval "local real_dir=$dir"

	[ -z "$real_dir" ] && echo "cancelled" && return 0
	[ ! -d "$real_dir" ] && echo "not a dir" && return 1

	__zoxide_z "$real_dir" || return 1
}

# quickly edit some files
function fzfed() {
	local files=(
		"$XDG_DATA_HOME/zsh/zsh_history"
		"$XDG_CONFIG_HOME/shell/zsh/.zshrc"
		"$XDG_CONFIG_HOME/shell/zsh/.zshenv"
		"$XDG_CONFIG_HOME/nsxiv/exec/key-handler"
		"$XDG_CONFIG_HOME/tmux/tmux.conf"
		"$XDG_CONFIG_HOME/lf/lfrc"
		"$XDG_CONFIG_HOME/aerc/aerc.conf"
		"$XDG_CONFIG_HOME/aerc/binds.conf"
		"$XDG_CONFIG_HOME/foot/foot.ini"
		"$XDG_CONFIG_HOME/hypr/hyprland.conf"
		"$XDG_CONFIG_HOME/hypr/hyprlock.conf"
		"$XDG_CONFIG_HOME/hypr/hypridle.conf"
		"$XDG_CONFIG_HOME/hypr/subconfig/keybinding.conf"

		"$HOME/Documents/quick-note.md"
		"$HOME/Documents/learning/note.md"
	)

	file=$(printf "%s\n" "${files[@]}" | fzf \
		--preview 'bat --style=numbers,changes --color=always {}' \
		--preview-window=right \
		--bind=alt-k:up,alt-j:down \
		--height=20 \
		--layout=reverse \
		--cycle \
		--border=sharp
	)
	eval "local real_file=$file"

	[ -z "$real_file" ] && echo "cancelled" && return 0
	[ ! -e "$real_file" ] && echo "not a file" && return 1

	nvim "$real_file"
}

# Open all the images in current directory using nsxiv
function images() {
	find . -regextype awk -iregex ".*png|.*jpeg|.*jpg|.*gif|.*webp" -print0 | xargs -0 eza -1 --color=never --reverse --sort=time | nsxiv -i
}



# Basic settings -----------------------
# --------------------------------------
# history settings -----
HISTFILE="$XDG_DATA_HOME/zsh/zsh_history"
HISTSIZE=9223372036854775807
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

KEYTIMEOUT=1

# completion style -----
eval "$(dircolors -b)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# zstyle ':completion:*' menu no
# zstyle ':fzf-tab:*' fzf-bindings 'alt-j:down' 'alt-k:up'
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'



# Keybindings --------------------------
# --------------------------------------
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -s '^f' '^uyy\n'
bindkey -s '^v' '^unvim .\n'
# bindkey -s '^n' '^uimages &\n'
bindkey -s '^o' '^uzicd\n'
bindkey -s '^e' '^ufzfed\n'



# Aliases ------------------------------
# --------------------------------------
alias neofetch="fastfetch -c ani"
alias manw="manwebb"
alias nvidia-settings="nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings""
alias yarn="yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config"
alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"
alias vim="nvim"
alias diff="diff --color"
alias pfi="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias pfr="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
alias ip="ip -c=always"
alias sudo="sudo "
alias climit="systemd-run --user --scope --slice=program.slice -u compiling.scope -p CPUQuota=100% -p MemoryMax=50%"

# systemd command suite -----
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
alias tctl="timedatectl"
alias tclt="timedatectl"
alias hctl="hostnamectl"
alias hclt="hostnamectl"

# alternatives -----
alias yay="paru"
alias ls="eza"
alias ll="ls -lHg"
alias lla="ll -a"
alias la="ls -a"
alias tree="exa -TL"
alias grep="rg"
alias cat="bat"
alias timer="hyperfine"
alias diff="delta"

# typo ------
alias s="ls"
alias sl="ls"
alias l="ls"
alias nivm="nvim"
alias handbrakecli="HandBrakeCLI"
alias suod="sudo"
alias sduo="sudo"



# Integration --------------------------
# --------------------------------------
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
