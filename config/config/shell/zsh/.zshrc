# Interactive zsh: plugins, prompt, history, keys, aliases.
#
# shellcheck shell=bash
# shellcheck disable=SC2296  # ${(%):-%n} and ${(s.:.)X} are zsh expansion flags
# shellcheck disable=SC1090,SC1091  # sourced paths are runtime values
# shellcheck disable=SC2034  # SAVEHIST and KEYTIMEOUT are read by zsh itself
# shellcheck disable=SC2139  # aliases below expand at login on purpose
# shellcheck disable=SC2154,SC1105,SC2211,SC2288  # (( $+commands[x] )) guards
# shellcheck disable=SC1036,SC2206  # (N), the zsh "skip if missing" qualifier

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Keymap
# ---------------------------------------------
bindkey -v


# PATH
# ---------------------------------------------
typeset -U PATH path fpath

# Prepended, so these shadow the system copies.
export PATH="$CARGO_HOME/bin:$PATH"

# Appended: only reached when nothing earlier provides the command.
export PATH="$PATH:$NPM_PACKAGES/bin:${KREW_ROOT:-$HOME/.krew}/bin"

# MANPATH is deliberately not set: man derives <prefix>/share/man and
# <prefix>/man from every <prefix>/bin on PATH, so the entries above are
# already covered. Setting it would only add entries twice.

case "$OSTYPE" in
	darwin*)
		if (( $+commands[brew] )); then
			eval "$(brew shellenv)"

			path=(
				$HOMEBREW_PREFIX/opt/libpq/bin(N)
				$HOMEBREW_PREFIX/opt/util-linux/sbin(N)
				$HOMEBREW_PREFIX/opt/util-linux/bin(N)
				$HOMEBREW_PREFIX/opt/mysql-client/bin(N)
				$path
			)

			# So compilers find the keg-only util-linux headers and libs.
			if [[ -d $HOMEBREW_PREFIX/opt/util-linux ]]; then
				export LDFLAGS="-L$HOMEBREW_PREFIX/opt/util-linux/lib"
				export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/util-linux/include"
			fi
		fi
		;;
esac


# Plugins
# ---------------------------------------------
# zinit bootstrap.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit wait lucid for \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# Alternatives.
# zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
# zinit light sindresorhus/pure
# zinit light zsh-users/zsh-syntax-highlighting
# zinit light zsh-users/zsh-completions
# zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab

# oh-my-zsh snippets.
zinit snippet OMZP::aws
zinit snippet OMZP::argocd
zinit snippet OMZP::terraform
# zinit snippet OMZP::kubectl

# Local plugins. simple-completion.zsh runs its own compinit.
source "$ZDOTDIR/plugins/simple-completion.zsh"

# Replay the compdefs that the snippets above registered before compinit ran.
zinit cdreplay -q


# Prompt
# ---------------------------------------------
[[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"

# pure
# PURE_CMD_MAX_EXEC_TIME=10
# PURE_PROMPT_SYMBOL='󱙝 '
# PURE_PROMPT_VICMD_SYMBOL='󱙜 '
# zstyle ':prompt:pure:prompt:*' color white
# zstyle :prompt:pure:path color magenta


# History
# ---------------------------------------------
HISTFILE="$XDG_DATA_HOME/zsh/zsh_history"
HISTSIZE=9223372036854775807
SAVEHIST=$HISTSIZE

# Every pane sees every other pane's history as it is typed.
setopt sharehistory
# A leading space keeps a command out of the file entirely.
setopt hist_ignore_space
# Drop duplicates on write, and skip them again when searching.
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups


# Completion
# ---------------------------------------------
(( $+commands[dircolors] )) && eval "$(dircolors -b)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# fzf-tab, if the plugin above is ever enabled.
# zstyle ':completion:*' menu no
# zstyle ':fzf-tab:*' fzf-bindings 'alt-j:down' 'alt-k:up'
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'


# Keybindings
# ---------------------------------------------
# No ESC delay in vi mode.
KEYTIMEOUT=1

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Launchers. Each one clears the line first (^u) so it also works mid-command.
bindkey -s '^f' '^uyy\n'
bindkey -s '^v' '^unvim .\n'
bindkey -s '^o' '^uzicd\n'
bindkey -s '^e' '^ufzfed\n'
bindkey -s '^n' '^uimages &\n'


# Aliases
# ---------------------------------------------
alias vim="nvim"
alias neofetch="fastfetch -c ani"
alias ip="ip -c=always"
# The trailing space makes zsh expand the *next* word as an alias too, so
# things like `sudo ll` keep working.
alias sudo="sudo "

# Tools that write to $HOME unless told otherwise.
alias nvidia-settings="nvidia-settings --config=$XDG_CONFIG_HOME/nvidia/settings"
alias yarn="yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config"
alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"

# Modern alternatives.
alias ls="eza"
alias ll="ls -lHg"
alias lla="ll -a"
alias la="ls -a"
alias grep="rg"
alias cat="bat"
alias diff="delta"
alias timer="hyperfine"

# Typos.
alias s="ls"
alias sl="ls"
alias l="ls"
alias nivm="nvim"
alias suod="sudo"
alias sduo="sudo"
alias handbrakecli="HandBrakeCLI"

# Ops.
alias claudex='ANTHROPIC_SMALL_FAST_MODEL=gpt-5.6-luna[1m] \
ANTHROPIC_DEFAULT_OPUS_MODEL=gpt-5.6-terra[1m] \
ANTHROPIC_DEFAULT_SONNET_MODEL=gpt-5.6-terra[1m] \
ANTHROPIC_DEFAULT_HAIKU_MODEL=gpt-5.6-luna[1m] \
ANTHROPIC_DEFAULT_FABLE_MODEL=gpt-5.6-sol[1m] \
CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK=1 \
claude --model "gpt-5.6-sol[1m]"'

case "$OSTYPE" in
	darwin*)
		alias tldr="tldr -p linux"

		# coreutils on brew.
		for _g in stat awk tr df sort head tail uniq wc du nohup uname \
		          who whoami uptime seq; do
			(( $+commands[g$_g] )) && alias "$_g=g$_g"
		done
		unset _g
		;;
	*)
		# systemd.
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
		alias cgtop="systemd-cgtop"
		alias cgls="systemd-cgls"

		# Build in a scope that cannot eat the whole machine.
		alias climit="systemd-run --user --scope --slice=program.slice -u compiling.scope -p CPUQuota=100% -p MemoryMax=50%"

		# pacman.
		alias yay="paru"
		alias pfi="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
		alias pfr="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
		;;
esac


# Integrations
# ---------------------------------------------
(( $+commands[fzf] )) && eval "$(fzf --zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init --cmd cd zsh)"


# Functions
# ---------------------------------------------
tree() {
	local depth=2
	if [[ $1 =~ ^[0-9]+$ ]]; then
		depth=$1
		shift
	fi
	eza -T -L "$depth" "$@"
}

# Open yazi, and stay in whatever directory it was left in.
yy() {
	local tmp cwd
	tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	cwd="$(command cat -- "$tmp")"
	rm -f -- "$tmp"
	if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd" || return
	fi
}

# Jump to a directory picked out of the zoxide database.
zicd() {
	local dir
	dir=$(zoxide query --interactive)

	[ -z "$dir" ] && echo "cancelled" && return 0
	[ ! -d "$dir" ] && echo "not a dir" && return 1

	__zoxide_z "$dir" || return 1
}

# Edit one of the config files.
fzfed() {
	local files file
	files=(
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

		"$HOME/.ssh/config"
		"$XDG_DOCUMENTS_DIR/quick-note.md"
		"$XDG_DOCUMENTS_DIR/learning/note.md"
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

	[ -z "$file" ] && echo "cancelled" && return 0
	[ ! -e "$file" ] && echo "not a file" && return 1

	nvim "$file"
}

# Open every image under the current directory in swayimg, newest first.
images() {
	find . -regextype awk -iregex ".*png|.*jpeg|.*jpg|.*gif|.*webp" -print0 | xargs -0 eza -1 --color=never --reverse --sort=time | swayimg -f /dev/stdin -e 'swayimg.imagelist.order = "none"'
}
