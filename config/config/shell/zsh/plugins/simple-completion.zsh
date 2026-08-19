# Adapted from Phantas0s:
#   https://thevaluable.dev/zsh-completion-guide-examples/
#   https://github.com/Phantas0s/.dotfiles/blob/master/zsh/completion.zsh
#
# shellcheck shell=bash
# shellcheck disable=SC2296,SC2034,SC2016  # zsh expansion flags and zstyle values


# compinit
# ---------------------------------------------
# Extra completion functions live next to this file, so a completion can be
# dropped in without touching a package manager.
fpath=("$ZDOTDIR/plugins/completions" "${fpath[@]}")

# Must be loaded before compinit: it provides the menuselect keymap below.
zmodload zsh/complist

autoload -Uz compinit; compinit -u -d "$ZSH_COMPDUMP"

# Offer dotfiles as completion matches too.
_comp_options+=(globdots)


# Menu selection
# ---------------------------------------------
# hjkl inside the completion menu. Interactive mode is left alone; the two
# do not combine well.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Escape accepts the highlighted match, u throws the whole menu away.
bindkey -M menuselect '\e' accept-line
bindkey -M menuselect 'u' send-break

# bindkey -M menuselect '^xg' clear-screen
# bindkey -M menuselect '^xi' vi-insert                      # Insert
# bindkey -M menuselect '^xh' accept-and-hold                # Hold
# bindkey -M menuselect '^xn' accept-and-infer-next-history  # Next

# ctrl-a expands the alias under the cursor in place, rather than running it.
zle -C alias-expansion complete-word _generic
bindkey '^a' alias-expansion
zstyle ':completion:alias-expansion:*' completer _expand_alias


# Options
# ---------------------------------------------
setopt MENU_COMPLETE        # highlight the first match straight away
setopt AUTO_LIST            # list choices when the completion is ambiguous
setopt COMPLETE_IN_WORD     # complete from both ends of a word
# setopt GLOB_COMPLETE      # show the menu for globs as well


# zstyles
# ---------------------------------------------
# Pattern is :completion:<function>:<completer>:<command>:<argument>:<tag>

# _extensions first (complete a bare extension), then exact matches, then
# approximate ones as a last resort.
zstyle ':completion:*' completer _extensions _complete _approximate

# Cache the completions that are expensive to compute.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Let _expand_alias complete alias names when it is used as a completer.
zstyle ':completion:*' complete true

# Arrow-key selectable menu, with the newest files first.
zstyle ':completion:*' menu select
zstyle ':completion:*' file-sort modification

# Complete cd's own options instead of the directory stack.
zstyle ':completion:*' complete-options true
# ...and for cd, offer directories only, nearest first.
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

# Case insensitive, then partial-word, then substring matching.
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' keep-prefix true

# Group matches under a heading named after their tag.
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# Headings for each kind of message.
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{magenta}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{blue} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Complete hosts from the known_hosts files.
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
