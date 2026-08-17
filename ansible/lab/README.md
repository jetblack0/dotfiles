# Lab

Disposable containers for testing the playbooks end to end -- and for trying
this setup out before letting it loose on a real machine.

The rules of the game:

- the image is a stock system plus `ansible`, nothing else
- no host directory is mounted; the repo is *copied* in
- the playbook alone has to produce a working system

## Usage

```sh
./lab start archlinux
```

builds the image if needed, starts a fresh container, and drops you into a
shell with the repo at `~/dotfiles`. From there:

```sh
ansible-playbook ansible/local.yml
```

then poke around: `tmux`, `nvim`, `yazi`, ... `start` always gives you a
clean box, so re-running it is the reset button. The other commands:

```sh
./lab build archlinux    # rebuild the image (also picks up newer packages)
./lab shell archlinux    # second shell into the same box
./lab stop archlinux     # tear it down
```

macOS has no container runtime to test against; the darwin side is covered by
running the playbook with `--check` on a real Mac.

## Adding a distro

Drop a `Dockerfile` into `distros/<name>/` that builds a stock system with
ansible installed and `sleep infinity` as CMD -- the script picks it up by
directory name, nothing else to register.

## Container gotchas encoded here

- pacman >= 7 sandboxes downloads with Landlock, which containers don't
  permit; the image sets `DisableSandbox` (real machines are unaffected)
- the official `archlinux` image is amd64-only; on arm64 the Dockerfile
  falls back to Arch Linux ARM via a per-arch base stage
- the lab shell forces `TERM=xterm-256color`: fancy terminals set values
  like `xterm-kitty` whose terminfo a stock image doesn't have, which makes
  tmux die with "missing or unsuitable terminal"
