# qemu lab reference

Details behind [SKILL.md](SKILL.md): where things live, the exact input
names, and what to do when something goes wrong.

## Where an instance lives

Each instance is one directory, `~/.cache/dotfiles-lab/vm/<name>/`:

| file | what it is |
|---|---|
| `disk.qcow2` | the disk, with its snapshots inside |
| `distro`, `port` | which distro it is, and its ssh port (fixed at `new`) |
| `key`, `key.pub` | the ssh key the guest accepts |
| `seed.iso` | cloud-init seed (Arch only) |
| `vars.fd` | uefi settings (NixOS and aarch64 guests) |
| `qemu.log` | qemu's own output: look here when qemu won't start |
| `serial.log` | the guest's serial console: look here when boot hangs |
| `qmp.sock`, `vnc.sock`, `serial.sock` | control sockets while it runs |

`~/.cache/dotfiles-lab/vm/base/` holds the downloaded images. Every instance
disk only stores its changes on top of its base image. **Never delete or
replace a file in `base/`**: every instance built on it stops working.

To ssh in by hand instead of `lab/vm shell`, take the port from
`lab/vm list`. The user is `dev` on Arch and `root` on NixOS:

```sh
ssh -p <port> -i ~/.cache/dotfiles-lab/vm/<name>/key dev@127.0.0.1
```

## Screenshots

- **Headless:** read from qemu's vnc server on `vnc.sock`. It works on every
  screen, 3d included. Any vnc viewer that can open a unix socket can watch
  the same screen.
- **Window, on a linux host:** `grim` runs inside the guest, as the user who
  owns the wayland session. It needs someone logged in; the lock screen
  works too, the greeter doesn't.
- **Window, on macOS:** qemu's own dump of its 2d window.

qemu's built-in `screendump` can't read a 3d display at all, which is why
the other two paths exist.

## Input

The mouse commands take screenshot pixel coordinates and convert them for
the vm's usb tablet. With the window, each one first takes a screenshot to
learn the screen size, so it costs about as long as a screenshot.

- **`click`** takes a button: `left` (the default), `right`, `middle`,
  `side` or `extra` (the last two are back and forward in browsers).
  `--double` and `--triple` click two or three times quickly: in a
  terminal or text field that selects a word or a line.
- **`move`** only moves the pointer. Use it to hover, and to park the
  pointer before judging a control.
- **`drag`** presses at the first point, moves to the second in small steps
  (like a hand), and releases. It takes a button too; `right` with
  `--with super` is Hyprland's resize.
- **`scroll`** moves the pointer to the point first, because things scroll
  under the pointer, then turns the wheel `up` or `down` (1 click by
  default). In kitty one click is 5 lines.
- **`--with <keys>`** holds keys during `click`, `move`, `drag` or `scroll`,
  e.g. `--with super` or `--with ctrl+shift`. The keys go down before the
  button and come up after it.

Why the mouse commands pause between steps: the keyboard and the tablet are
separate usb devices, and the guest puts each one to sleep after 2 seconds
without input. A sleeping keyboard takes about 75 ms to deliver its first
key. So `--with` waits 200 ms after pressing its keys; without that, the
button can arrive first and a Super+drag becomes a plain drag. If a
modifier action still misfires, that's the first thing to suspect.

Kitty extends a selection with a right click, not with Shift+click.

`key` takes key names joined with `+`, pressed together:

| name | also accepted as |
|---|---|
| `meta_l` | `super`, `win`, `meta`, `mod` |
| `ctrl` | `control`, `ctl` |
| `alt`, `shift`, `tab`, `backspace`, `up`, `down`, `left`, `right`, `home`, `end`, `f1` ... `f12` | |
| `ret` | `enter`, `return` |
| `esc` | `escape` |
| `spc` | `space` |
| `delete`, `insert`, `pgup`, `pgdn` | `del`, `ins`, `pageup`, `pagedown` |
| letters and digits | themselves: `a`, `7` |
| `minus`, `equal`, `slash`, `comma`, `dot`, ... | `-`, `=`, `/`, `,`, `.` |

Anything else is passed to qemu as a key code as it is. qemu names the key
in its error when it doesn't know one.

`type` types text character by character on a us keyboard layout: letters,
digits, the usual punctuation and space. A real newline or tab character in
the text presses Return or Tab (the two characters `\n` are typed as they
are).

## When something goes wrong

**`new` or `start` stays at "waiting for ssh".**
Start the instance with `--headless` and take a screenshot: you'll see where
the boot is stuck. `serial.log` shows the same from the serial console.
One known cause: on a network that answers DNS with fake addresses (some
proxies do), the guest's clock never syncs over NTP. The Arch cloud image
waits for a synced clock before it starts sshd, so the boot never finishes.

**`new` stops with "cloud-init failed".**
Usually a package mirror was too slow. The instance stays. Fix it in the
guest (`lab/vm shell <name>`, `cloud-init status --long` shows the error),
then run `lab/vm sync <name>`.

**"no desktop session to open the window on".**
The shell has no display (ssh, for example) and no desktop session is
running on the host either. Use `--headless`.

**`screenshot` says nobody is logged in.**
The vm has a window and is still at the greeter; over ssh, `loginctl
list-sessions` shows the `greeter` user on `seat0`. Log in (see "Logging
in" in SKILL.md), or restart it with `--headless` to see the greeter.

**The screenshot isn't 1920x1080, or its size keeps changing.**
The guest's monitor rule is `mode = preferred`, and when the vm window isn't
fullscreen, qemu offers the window's size as the preferred mode. Put the
window back to fullscreen. `lab/vm key` can't do it: Ctrl+Alt+F belongs to
qemu's window, and `lab/vm` input goes into the guest. Restart the vm, or
have the host's window manager fullscreen the window (the machine notes may
have the command).

**A click lands in the wrong place, or does nothing.**
Take a fresh screenshot: the target may have moved, or an animation hadn't
finished. If clicks never land at all, the instance may have been started by
an older version of `lab/vm`; restart it.

**Typing on the lock screen failed three times.**
pam_faillock locked the account for 10 minutes. Reset it over ssh:
`sudo faillock --user <user> --reset`.

**Headless screenshots have no 3d.**
Rendering with 3d while headless needs the host's gpu render node
(`/dev/dri/renderD128`). Without it the vm falls back to a 2d display;
screenshots still work.

**On macOS, qemu can't create a socket.**
Unix socket paths must be shorter than 104 bytes. Keep `XDG_CACHE_HOME`
short.

**A `lab/vm` command fails with a syntax error in the middle of a run.**
The script was edited while it ran; bash reads a script as it goes. Run the
command again.
