# My dotfile and scripts
My arch linux customization for both xorg and wayland ecosystem. Along with some useful scripts.

![](/assets/screen_hyprland.png)

## Program I use and a short introduction
I put all the dotfiles of programs that I customized in this repository, some of them I no longer used and maintained. I am currently using wayland display server, some configuration for xorg exclusive programs maybe outdated. I didn't list all the dotfiles in the readme, you can always take a look of source code to see what's inside.

* **Wayland**:
  * [hyprland](https://github.com/GrenicMars/dotfiles/blob/master/config/hypr/hyprland.conf): A wayland compositor which works well on my nvidia optimus laptop, I made a simple wrapper script to start it in integrated, hybird and nvidia mode, althrough you still need to change your bios settting if you wanna use this compositor in nvidia mode.
  * [eww](https://github.com/GrenicMars/dotfiles/tree/master/config/eww): The top bar you see on the screenshot.
  * [dunst](https://github.com/GrenicMars/dotfiles/tree/master/config/dunst): A Notification daemon.
  * [swaylock](https://github.com/GrenicMars/dotfiles/blob/master/config/swaylock/config): A screen locker for wayland.
  * [swayidle](https://github.com/GrenicMars/dotfiles/blob/master/config/swayidle/config): For dimming screen, unlike xorg, my screen won't dim after a certain time without this program.

* **Xorg**:
  * [awesomewm](https://github.com/GrenicMars/dotfiles/tree/master/config/awesome): A xorg window manager.
  * [picom(dccsillag's fork)](https://github.com/GrenicMars/dotfiles/blob/master/config/picom/picom.conf): A xorg compositor with animation.
  * [lf](https://github.com/GrenicMars/dotfiles/tree/master/config/lf): A terminal file manager, I use ueberzug for image preview, but it doesn't work on wayland side.
  * [betterlockscreen](https://github.com/GrenicMars/dotfiles/blob/master/config/betterlockscreenrc): A screen locker for xorg.

* **Common**:
These programs work fine on both wayland and xorg.
  * [rofi](https://github.com/GrenicMars/dotfiles/tree/master/config/rofi): I use this program for application launcher, emoji and nerd font icon selector and a logout application which you see on the screenshot. It works well on both xorg and xwayland. My configuration comes from this [project](https://github.com/adi1090x/rofi) with some customization.
  * [neovim](https://github.com/GrenicMars/dotfiles/tree/master/config/nvim): Lsp support and some useful plugins which bring me a happy text editing and web development experience. 
  * [tmux](https://github.com/GrenicMars/dotfiles/blob/master/config/tmux/tmux.conf): Some customization override the counter-intuitive default keybindings.
  * [zsh](https://github.com/GrenicMars/dotfiles/tree/master/config/shell/zsh): Debloated, without something like on-my-zsh.
  * [nsxiv](https://github.com/GrenicMars/dotfiles/blob/master/config/nsxiv/exec/key-handler): A image viewer which is a solution for lf image preview doesn't work on wayland.
  * [ncmpcpp](https://github.com/GrenicMars/dotfiles/tree/master/config/ncmpcpp): A music client for mpd.
  * [alacritty](https://github.com/GrenicMars/dotfiles/tree/master/config/alacritty): A terminal emulator which I used for a long time. A perfect match with tmux.

## Requirement
**Note: Those requirement only applies if you wanna simply copy and paste my configuration, which is not recommended. You should check those files first and know what you doing before you use them.**

Install these programs to use my configuration (doesn't include the program itself):
* **nvim**: Open nvim and type `:Mason` to install **luacheck**, **stylua**, **prettierd**, **shfmt**. `yay -S wl-clipboard` for wayland or `yay -S xclip` for xorg.
* **hyprland**: _Note: you don't need to install all of these programs in order to make hyprland work, but some keybindings may break, again, check out those files yourself_. `yay -S swww swayidle swaylock-effects dunst pamixer mpd grimblast-git alacritty rofi eww-wayland hyprpicker-git firefox`. You may need to use my configuration for rofi. _Note: hyprpicker doesn't support nvidia._
* **eww**: `yay -S hyprland bluez bc ripgrep mpc mpd networkmanager pamixer pipewire pipewire-pulse gojq socat jap`. Install **Iosevka** and **Varela Round** font.
* **tmux**: `yay wl-clipboard` for wayland or `yay -S xclip` for xorg, you way need to install [catppuccin color scheme](https://github.com/catppuccin/tmux) and change its path in the config file manually.
* **nsxiv**: `yay -S wl-copy swww`.
* **zsh**: `yay -S fzf nsxiv-git lf exa ripgrep bat hyperfine paru`. You may need to install plugins [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting), [zsh-completion](https://github.com/zsh-users/zsh-completions) manually.
* **rofi**: Install font **Grape Nuts** and **JetBrains Mono Nerd Font**.
* **alacritty**: Install **CaskaydiaCove Nerd Font**, you may need to install [catppuccin theme](https://github.com/catppuccin/alacritty) and change the path in the config file manually.
* **lf**: _Note: I no long use this program so the configuration maybe outdated_. `yay -S ueberzug cowsay mpv vlc unzip unrar feh vidir atool bat mediainfo ffmpegthumbnailer gpg pdftoppm`.
* **awesomewm**: _Note: I no long use this program so the configuration maybe outdated_. `yay -S mpc pamixer betterlockscreen feh rofi flameshot firefox`. You may need to use my configuration for rofi.

## Installation
Currently I don't have a auto-install script and I would say you sill can't safely copy and paste my dotfiles in order to use it even if you meet all the requirement. Check out what's inside those files yourself, figure it what it does and copy paste those lines you need.

## Known bugs
* eww music widget stop working if the music information contains double quote due to the json format.
