# better color for ls and lf
	autoload -U colors && colors
	eval "$(dircolors -b)"
# prompt TODO: add git prompt
	PROMPT='%B%(?.%F{007}.%F{009})%b %B%F{magenta}%~%f%b '
# colored man page
	export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
	export LESS_TERMCAP_md=$'\e[1;36m'     # begin blink (light green)
	export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
	export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
	export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
	export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
	export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
	export GROFF_NO_SGR=1                  # for konsole and gnome-terminal
