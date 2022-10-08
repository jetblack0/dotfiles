#! /bin/bash

cdEntry() {
	read -r dir
	if [ -s "$dir" ]; then
		cd "$dir" || exit
		# bug: can't delete files in this lf
		lfcd
	fi
}

cdEntry=(
	"$HOME/Downloads" "$HOME/Downloads/projects" "$HOME/Downloads/torrents"
	"$HOME/Pictures/Screenshot" "$HOME/Pictures/Wallpaper"
	"$HOME/Resources/Courses" "$HOME/Resources/Software" "$HOME/Resources/Software/VMs" "$HOME/Resources/Software/VMs/share" "$HOME/Resources/System/backups" "$HOME/Resources/System"
	"$HOME/Videos/Movies" "$HOME/Videos/Shows"
	"$HOME/Documents/Books" "$HOME/Documents/temp"
	"$HOME/Development" "$HOME/Development/dotfiles" "$HOME/Development/MyScript"
	"$HOME/.config" "$HOME/.config/awesome" "$HOME/.config/clash" "$HOME/.config/kitty" "$HOME/.config/nvim" "$HOME/.config/picom" "$HOME/.config/rofi" "$HOME/.config/alacritty" "$HOME/.config/shell" "$HOME/.config/shell/zsh" "$HOME/.config/shell/zsh/plugins" "$HOME/.config/X11"
)

for entry in "${cdEntry[@]}"; do
	echo "$entry"
done | fzf | cdEntry
