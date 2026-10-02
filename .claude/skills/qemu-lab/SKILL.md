---
name: qemu-lab
description: Create, run and drive this repo's qemu lab vms (lab/vm) to test dotfiles changes on a real machine, including seeing and operating a guest's Hyprland and noctalia desktop through screenshots, clicks and key presses. Use it to verify or debug desktop and GUI features, to run the ansible playbook or a nixos rebuild on a clean system, or whenever a change should be checked "in the vm".
---

# qemu lab

`lab/vm` manages qemu virtual machines for testing this repo end to end. Each
vm is a named instance that keeps its disk between boots. There are Arch
guests (set up by the ansible playbook) and NixOS guests (set up by the flake
under `nix/`). You can look at a guest's screen and operate it like a person
sitting in front of it: take a screenshot, read it, click, type, look again.

Run everything from the repo root. `lab/vm help` lists every command.

## Before you start

1. **Read the machine notes if they exist.** `.ctx/tools/qemu-vms.md` is not
   in git. When it's present, it says which instances you may use freely,
   the guest passwords, and quirks of this host. Read it first.
2. **Look at what already exists:** `lab/vm list`.
3. **Don't take over other people's vms.** A running instance may be someone's
   working session, shown in a window on their screen. Unless the machine
   notes say an instance is free to use, create your own (`new`) or clone one
   (`cp`) and work on that.

## Getting a vm

```sh
lab/vm new archlinux my-test --headless    # or: nixos, archlinux-arm, nixos-arm
lab/vm cp provisioned-box my-test          # clone a stopped instance instead
lab/vm start my-test --headless            # boot an existing one
lab/vm stop my-test                        # clean shutdown
lab/vm rm my-test                          # delete it
```

`new` boots the vm, sets up ssh, copies the repo to `~/dotfiles` in the guest
and prints the next step for that distro:

- Arch: `ansible-playbook ansible/base.yml` in `~/dotfiles`. Hosts can add
  their own variables with `-e @ansible/hosts/<host>.yaml`.
- NixOS: `nixos-rebuild switch --flake ./nix#<host>` as root in `~/dotfiles`,
  with the flakes option `new` prints on the first run.

A full provision takes a long time. Afterwards, stop the vm and save a
snapshot, so you can go back to a clean provisioned state in seconds:

```sh
lab/vm stop my-test && lab/vm snapshot my-test provisioned
lab/vm revert my-test provisioned    # later, when the guest is in a bad state
```

## Headless or window

**Start vms with `--headless` unless you're asked for a window.** How you
start a vm decides what you can see:

| | `--headless` | window |
|---|---|---|
| who can watch | a person, with `lab/vm attach <name>` | a person, in a fullscreen window |
| screenshots | every screen: boot, greeter, desktop | from `grim` inside the guest: logged-in desktop and lock screen only (on a macOS host: every screen) |
| screen size | stays at the vm's resolution | follows the window, so it drifts when the window isn't fullscreen |
| clicks and keys | yes | yes |

Headless sees more, keeps its size, and opens nothing on the host's
screen. A person can still watch it, and use it, with `lab/vm attach`: it
opens a vnc viewer that leaves the guest's size alone. Use the window only
when a person asks for one. Switching modes needs a restart
(`lab/vm stop` then `lab/vm start [--headless]`).

## Logging in

Some hosts log their user in by themselves when the vm boots; the machine
notes say which. That happens once per boot: after a logout, the greeter
comes back.

To know for sure whether a vm is at the greeter, ask over ssh. The user who
owns `seat0` is the one at the screen: `greeter` means the greeter, the
desktop user means a logged-in desktop.

```sh
lab/vm shell my-test <<'EOF'
loginctl list-sessions
EOF
```

To log in headless, look at the greeter and type the password as step 7 of
the loop says. In window mode you can't see the greeter, but its password
box has focus when it starts, so this works blind:

```sh
lab/vm type my-test '<password>'
lab/vm key my-test ret
```

Try it once only, then check: the desktop user owns `seat0`, a screenshot
works and shows the bar, and `sudo faillock --user <user>` over ssh shows no
new failures. Typing blind again after a failure can lock the account.

## Seeing and driving the screen

```sh
lab/vm screenshot my-test shot.png          # then read shot.png
lab/vm click my-test 960 540                # left click
lab/vm click my-test 960 540 right          # or middle, side, extra
lab/vm click my-test 530 917 --double       # double click: select a word
lab/vm click my-test 300 917 --triple       # triple click: select a line
lab/vm move my-test 900 850                 # move the pointer (hover)
lab/vm drag my-test 136 917 398 917         # press, move, release: select text
lab/vm scroll my-test 960 500 down 5        # turn the wheel 5 clicks, up or down
lab/vm key my-test super+return             # a key or a combo
lab/vm type my-test 'hello world'           # text, us keyboard characters
```

`click`, `move`, `drag` and `scroll` take `--with <keys>` to hold keys
during the action. For example, `lab/vm drag my-test 900 500 1200 700 --with
super` moves a window with Hyprland's Super+drag, and `--with super` on a
right-button drag resizes it.

Coordinates are pixels in the screenshot. The input goes in as the vm's own
usb keyboard and tablet, so it behaves like real hardware.

**Check a screenshot's size before you trust sizes in it.** `lab/vm
screenshot` prints it. With a window, the guest takes its resolution from
the window: only a fullscreen window gives a steady size (the host's
screen), and a smaller one makes the guest shrink with it (640x480 has been
seen). Headless, the size is `LAB_VM_RES`, 3072x1920 by default. If the size is
off, see [reference.md](reference.md).

## The loop: look, act, look

Work in small steps and look after every one.

1. **Look first, every time.** Take a screenshot and read it before you
   send any input, even a quick test. The screen may have changed since
   you last looked: the session locks itself when idle, and then your
   keys land in the lock screen's password field. A little later the
   screen turns off, and a headless screenshot comes back all black. That
   isn't a lab bug: wake the screen with `lab/vm move`, which types
   nothing, look again, and expect the lock screen.
2. **After logging in, wait for the desktop.** Hyprland starts before the
   shell does. Keys sent in those first seconds go nowhere. Take a
   screenshot and wait until the bar is there.
3. **One action, then look again.** Wait a second or two for animations,
   then take a new screenshot. Don't chain several clicks you can't see.
4. **Aim at the middle** of a button or list entry, not its edge.
5. **Move the pointer away before judging a control.** Hovering changes how a
   control looks: a hovered tile can look exactly like an active one. Use
   `lab/vm move` to park the pointer on empty space, then look.
6. **Use keys for navigation** (keybinds, Tab, Return) and clicks for things
   only the mouse can reach.
7. **Check a password field before typing into it.** Take a screenshot, make
   sure the field is empty and has focus, then type the password and press
   Return. Three failed unlocks lock the account for 10 minutes
   (pam_faillock); see [reference.md](reference.md) for the reset.
8. **Leave the guest as you found it.** Close the windows you opened, and put
   toggles back.

## Asking the desktop instead of reading pixels

Over ssh you can ask the compositor and the shell exact questions. That's
faster than a screenshot and it doesn't guess. It's also the reliable way to
put a setting back to a known state. Screenshots then confirm what a person
would see.

The desktop runs as the logged-in user, so run these as that user with the
session's environment. This finds the session the same way `lab/vm
screenshot` does:

```sh
lab/vm shell my-test <<'EOF'
sock=$(ls -1 /run/user/*/wayland-[0-9] | head -1)
run() { sudo -u "#$(stat -c %u "$sock")" env XDG_RUNTIME_DIR="$(dirname "$sock")" \
    WAYLAND_DISPLAY="$(basename "$sock")" "$@"; }
run sh -c 'HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr" | head -1) hyprctl clients'
run noctalia msg --help
EOF
```

## Testing a change

1. Edit the files in the repo on the host.
2. Copy the repo into the guest again: `lab/vm sync my-test`.
3. Apply it inside the guest. Configs are copied into place, not linked, so
   an edit only arrives when you apply it:
   - Arch: re-run only what changed, e.g.
     `ansible-playbook ansible/base.yml -t dotfiles` for files under
     `config/config`. The tags are the role names in `ansible/base.yml`.
   - NixOS: `nixos-rebuild switch --flake ./nix#<host>`.
4. Reload what you changed if it doesn't pick the change up by itself, e.g.
   `hyprctl reload` through the `run` helper above.
5. Look, with screenshots and the ssh queries above.

Take a snapshot before a risky experiment. Reverting is quicker than
repairing.

## What this can't test

- **The host's own keyboard handling.** The vm's input goes straight into
  the guest, so it never passes through the host's compositor. Anything
  about what the host does with a key press needs a person at the host.
- **The greeter in window mode.** Its compositor offers no screen capture;
  use `--headless` to see it.
- **Text outside a us keyboard layout** with `lab/vm type`.
- **Horizontal scrolling and trackpad gestures.** The vm's usb tablet has
  no horizontal wheel, and qemu has no virtual touchpad.

When something doesn't work (ssh never comes up, a click misses, a
screenshot fails), check [reference.md](reference.md).
