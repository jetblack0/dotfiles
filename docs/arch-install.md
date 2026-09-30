# Arch Linux install runbook

Everything between "boot the ISO" and "a booting, network-connected system
with a sudo-capable user" — the point where [ansible](../ansible/README.md)
takes over. Disk layout, encryption, boot loader, primary user and network
are deliberately out of ansible's scope, so they live here.

Written for the T480 (UEFI, Intel, two internal drives, the second one kept
across reinstalls), but nothing below is model-specific except the layout.

Conventions:

- `<user>`, `<hostname>`, `<Region/City>` — replace as you go.
- `$DISK` etc. are real shell variables — set them once in step 1 and the
  rest of the disk commands copy-paste safely.
- Every step that can be verified ends with a check. Don't skip them; each
  one catches the mistake *before* it becomes an unbootable machine.

* [0. Pre-flight — before wiping anything](#0-pre-flight--before-wiping-anything)
* [1. Boot the ISO](#1-boot-the-iso)
    * [Rank the package mirrors](#rank-the-package-mirrors)
* [2. Partition](#2-partition)
* [3. Encrypt, format, mount](#3-encrypt-format-mount)
* [4. Install the base system](#4-install-the-base-system)
* [5. fstab](#5-fstab)
* [6. Chroot: system basics](#6-chroot-system-basics)
* [7. Initramfs — the encryption hooks](#7-initramfs--the-encryption-hooks)
* [8. Boot loader (systemd-boot)](#8-boot-loader-systemd-boot)
* [9. Second drive (cryptdata)](#9-second-drive-cryptdata)
* [10. Users](#10-users)
* [11. Services](#11-services)
* [12. Reboot](#12-reboot)
* [13. Post-install hardening (recommended)](#13-post-install-hardening-recommended)
    * [Back up the LUKS headers](#back-up-the-luks-headers)
    * [TPM2 auto-unlock (optional — read the trade-off first)](#tpm2-auto-unlock-optional--read-the-trade-off-first)
* [14. Hand over to ansible](#14-hand-over-to-ansible)

## 0. Pre-flight — before wiping anything

**Run this entire section on the T480 as it is today** — booted normally
into the old install, as root, with both drives up. Nothing here needs the
ISO, another machine, or pulling drives; everything is read-only except
`luksAddKey`, which only *adds* a keyslot and is safe on a mounted drive.
(Fallback if the old system won't boot: the same commands work from the
ISO with the drives in place — but then the keyfile has to be fished off
the old root manually.)

The data drive survives, the root drive doesn't. These exist **only on the
old root** and are gone after the wipe:

1. **The data-drive keyfile** `/etc/luks/lukskey-cryptdata` — copy it to a
   USB stick (not to the data drive: you'd need the key to reach the key).
2. **A passphrase fallback for the data drive.** The passphrase typed at
   boot unlocks the *root* drive; the data drive is unlocked silently by
   the keyfile — so it may well have no passphrase at all. If the keyfile
   copy is lost, a keyfile-only drive is unrecoverable. Check what you
   actually hold:

   ```sh
   # Which partition backs the data drive — read the "device:" line
   # (if the mapper name isn't cryptdata, find it with lsblk -f):
   cryptsetup status cryptdata

   DATA=/dev/sdb1                              # <- the device from above

   # Note "Version:" (LUKS1 vs LUKS2 — step 9 needs it) and the keyslots:
   cryptsetup luksDump "$DATA"
   ```

   LUKS2 lists slots under `Keyslots:` (`0: luks2`, `1: luks2`, …); LUKS1
   prints `Key Slot 0: ENABLED` lines. The dump **cannot** tell a
   passphrase slot from a keyfile slot — the only way to know is to test
   each secret. Both tests are read-only and safe while mounted:

   ```sh
   # Does the keyfile work, and which slot is it?
   cryptsetup open --test-passphrase --verbose --key-file /etc/luks/lukskey-cryptdata "$DATA"

   # Do you know a passphrase? Type your best guess at the prompt:
   cryptsetup open --test-passphrase --verbose "$DATA"
   ```

   "Key slot N unlocked" means that secret is enrolled; "No key available
   with this passphrase" means it isn't (wrong guesses are harmless — try
   as many as you like). If no passphrase unlocks the drive, or the dump
   showed a single keyslot, enrol one now — the keyfile authorises it, the
   command prompts for the new passphrase:

   ```sh
   cryptsetup luksAddKey --key-file /etc/luks/lukskey-cryptdata "$DATA"
   cryptsetup open --test-passphrase "$DATA"   # re-test: the new passphrase must unlock
   ```

3. **A record of the drives** so the right disk gets wiped:

   ```sh
   lsblk -o NAME,SIZE,MODEL,SERIAL,FSTYPE > drives.txt ; blkid >> drives.txt
   ```

4. Anything in the old home that is *not* on the data drive (ssh keys,
   gnupg, shell history — walk `~/.local`, `~/.ssh`).

## 1. Boot the ISO

```sh
# Must print 64 — anything else is the wrong boot mode, stop and fix firmware
cat /sys/firmware/efi/fw_platform_size

# Wi-Fi (skip on ethernet/dock)
iwctl
[iwd]# device list
[iwd]# station wlan0 connect <SSID>

ping -c1 archlinux.org

# NTP is already active on current ISOs — just confirm:
timedatectl
```

### Rank the package mirrors

The stock mirrorlist is roughly geographic, not speed-sorted, so `pacstrap`
can end up pulling from a slow or distant mirror. `reflector` — already on
the ISO, it ran once at boot against *worldwide* mirrors — rebuilds the
list scoped to your region and ordered by measured throughput. Re-run it
now that the network is up, before `pacstrap`:

```sh
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector \
    --country China,'Hong Kong',Japan,Singapore,Taiwan \
    --protocol https --age 12 --latest 20 --sort rate \
    --save /etc/pacman.d/mirrorlist

# Check: a dozen nearby https mirrors, freshest/fastest first
head -n 12 /etc/pacman.d/mirrorlist
```

`--sort rate` downloads a probe from each candidate and orders by real
throughput, so the list reflects the network you are actually on (VPN and
all); `--country` + `--latest 20` bound that probe so it does not crawl the
whole world. It can still take a minute or two — each unreachable mirror
burns a 5s timeout before it is ranked last, so let it finish. `pacstrap`
copies this mirrorlist into the new system, so the
ranking carries over — no need to redo it in the chroot. (If the region
filter returns too few, widen `--age`, add countries, or drop `--country`
to rate-sort globally.)

Identify the disks against the pre-flight record and set the variables.
**Triple-check `$DISK` — the other drive holds the data.**

```sh
lsblk -o NAME,SIZE,MODEL,SERIAL

DISK=/dev/sda            # the greenfield target
ESP="${DISK}1"           # NVMe naming: ${DISK}p1, p2, p3
XBOOT="${DISK}2"
ROOT="${DISK}3"
```

## 2. Partition

| # | size | type            | fs        | label       | mount  |
|---|------|-----------------|-----------|-------------|--------|
| 1 | 1G   | EFI System      | FAT32     | `ESP`       | `/efi` |
| 2 | 4G   | Linux ext. boot | FAT32     | `XBOOT`     | `/boot`|
| 3 | rest | Linux fs        | LUKS2+ext4| `cryptroot` | `/`    |

- Both boot partitions **must stay FAT** — systemd-boot reads them through
  UEFI filesystem drivers, ext4 is not an option (Boot Loader Spec).
- 1G ESP: current baseline recommendation; fwupd firmware capsules land
  there too. 4G XBOOTLDR: two kernels × (normal + fallback) initramfs, and
  fallback images are fat.
- No swap partition — swap is a file on the encrypted root (step 3). The
  old plaintext swap partition leaked RAM contents around the encryption.
- Scripted `sfdisk` instead of interactive `fdisk`: the numeric type
  indexes (`142`, `19`, `20`) drift between util-linux versions; a script
  is reviewable and idempotent. The GUID below is XBOOTLDR's, stable
  forever.

```sh
# Optional on SSD: instant full wipe, clears old LUKS headers and resets cells
blkdiscard "$DISK"

wipefs --all "$DISK"

sfdisk "$DISK" <<'EOF'
label: gpt
size=1GiB, type=uefi
size=4GiB, type=bc13c2ff-59e6-4262-a352-b275fd6f7172
type=linux
EOF

# Check: three partitions, correct types and sizes
sfdisk -l "$DISK"
```

## 3. Encrypt, format, mount

The LUKS2 header carries a **label**, so everything downstream (crypttab,
boot entries) references `/dev/disk/by-label/cryptroot` — no UUIDs to
copy around, the boot entries become static text.

```sh
cryptsetup luksFormat --label cryptroot "$ROOT"
cryptsetup open "$ROOT" cryptroot

mkfs.fat  -F 32 -n ESP   "$ESP"
mkfs.fat  -F 32 -n XBOOT "$XBOOT"
mkfs.ext4 -L root /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt
mount --mkdir "$XBOOT" /mnt/boot
mount --mkdir "$ESP"   /mnt/efi

# Swap file on the encrypted root (adjust size to taste; hibernation is
# out of scope — that would need >= RAM and resume= wiring)
mkswap -U clear --size 8G --file /mnt/swapfile
swapon /mnt/swapfile

# Check: labels everywhere, /mnt /mnt/boot /mnt/efi mounted, swap active
lsblk -o NAME,FSTYPE,LABEL,MOUNTPOINTS "$DISK"
```

## 4. Install the base system

`pacstrap -K` initialises the new machine's pacman keyring; the full set
goes in here — no second install round inside the chroot.

```sh
pacstrap -K /mnt \
    base base-devel linux linux-headers linux-zen linux-zen-headers \
    linux-firmware intel-ucode \
    cryptsetup e2fsprogs dosfstools efibootmgr \
    networkmanager \
    terminus-font neovim less man-db man-pages texinfo \
    git openssh rsync ansible
```

(`sudo` rides in with base-devel. `os-prober` is a GRUB tool and `mtools`
serves nothing here — both dropped from the old list.)

## 5. fstab

```sh
genfstab -L /mnt >> /mnt/etc/fstab
```

Review `/mnt/etc/fstab`:

- `/`, `/boot`, `/efi` mount by `LABEL=`;
- the swap line must read `/swapfile`, **not** `/mnt/swapfile` — fix it if
  genfstab kept the prefix;
- nothing from the ISO leaked in.

## 6. Chroot: system basics

```sh
arch-chroot /mnt
```

```sh
# Time
ln -sf /usr/share/zoneinfo/<Region/City> /etc/localtime
hwclock --systohc

# Locale: uncomment en_US.UTF-8 UTF-8, zh_CN.UTF-8 UTF-8 in /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# Console font — must exist BEFORE the initramfs is built (step 7):
# sd-vconsole bakes this file into the image for the unlock prompt
echo 'FONT=ter-d24b' > /etc/vconsole.conf

# Hostname
echo '<hostname>' > /etc/hostname
cat > /etc/hosts <<'EOF'
127.0.0.1   localhost
::1         localhost
127.0.1.1   <hostname>
EOF

# No PC-speaker beep
echo 'blacklist pcspkr' > /etc/modprobe.d/nobeep.conf
```

(There is deliberately **no `hostname` binary** on this system: it ships in
`inetutils`, which nothing here pulls in and nothing depends on. That is
normal, not a broken install. `/etc/hostname` above is the source of truth;
read it back with `hostnamectl hostname` or `uname -n`, and inside zsh with
`print -P %m`. Ansible's fact gathering uses the same syscall, not the
binary, so the playbook is unaffected — install `inetutils` only if some
third-party script insists on the command.)

## 7. Initramfs — the encryption hooks

Systemd-flavoured initramfs (`sd-encrypt`): it reads a crypttab baked into
the image, understands labels, and TPM2 enrolment (step 13) plugs straight
into it. In `/etc/mkinitcpio.conf`:

```sh
HOOKS=(base systemd keyboard autodetect microcode modconf kms sd-vconsole block sd-encrypt filesystems fsck)
```

Deltas from the shipped default: `keyboard` moved before `autodetect` so
external/dock keyboards work at the passphrase prompt; `microcode` embeds
the CPU microcode into the image itself (the `initrd /intel-ucode.img`
boot-entry lines are obsolete); `sd-vconsole` replaces `keymap consolefont`;
`sd-encrypt` replaces `encrypt`.

Tell the initramfs how to unlock root — by label, no UUID:

```sh
cat > /etc/crypttab.initramfs <<'EOF'
cryptroot   /dev/disk/by-label/cryptroot   none   discard
EOF
```

(`discard` = TRIM through the encryption layer, wanted on an SSD. Note for
later: mkinitcpio > 41.1 deprecates this file in favour of one
`/etc/crypttab` with `x-initrd.attach` — it will print a warning when the
time comes, just do what it says.)

```sh
mkinitcpio -P
```

Both kernels must build **without errors**; warnings about missing
firmware for exotic drivers are normal.

## 8. Boot loader (systemd-boot)

```sh
bootctl --esp-path=/efi --boot-path=/boot install
```

`/efi/loader/loader.conf`:

```ini
default      arch-zen.conf
timeout      5
console-mode keep
editor       no
```

(`editor no`: the entry editor lets anyone with the laptop append
`init=/bin/bash` — pure hardening, costs nothing.)

Entries in `/boot/loader/entries/` — static, identical `options` on all
four, no microcode lines, no UUIDs:

```ini
# arch-zen.conf
title    Arch Linux zen
linux    /vmlinuz-linux-zen
initrd   /initramfs-linux-zen.img
options  root=/dev/mapper/cryptroot rw

# arch-zen-fallback.conf
title    Arch Linux zen (fallback initramfs)
linux    /vmlinuz-linux-zen
initrd   /initramfs-linux-zen-fallback.img
options  root=/dev/mapper/cryptroot rw

# arch.conf
title    Arch Linux
linux    /vmlinuz-linux
initrd   /initramfs-linux.img
options  root=/dev/mapper/cryptroot rw

# arch-fallback.conf
title    Arch Linux (fallback initramfs)
linux    /vmlinuz-linux
initrd   /initramfs-linux-fallback.img
options  root=/dev/mapper/cryptroot rw
```

```sh
# Check: all four entries listed, default marked, no complaints
bootctl list
```

## 9. Second drive (cryptdata)

Restore the keyfile from the USB stick (get it into the chroot via a
mounted stick or a second TTY on the ISO side):

```sh
install -d -m 700 /etc/luks
install -m 400 <usb>/lukskey-cryptdata /etc/luks/lukskey-cryptdata
```

Label the container and the filesystem (one-time; skip if already done on
a previous pass). **LUKS2 only** — pre-flight noted the version; on LUKS1
either convert (`cryptsetup convert --type luks2`, after a header backup)
or keep `UUID=` addressing as below.

```sh
DATA=<data-partition>                       # e.g. /dev/sdb1 — from the pre-flight record
cryptsetup config "$DATA" --label cryptdata

# Verify the keyfile actually opens it BEFORE trusting it at boot:
cryptsetup open --key-file /etc/luks/lukskey-cryptdata "$DATA" cryptdata
e2label /dev/mapper/cryptdata data
cryptsetup close cryptdata
```

Wire it up (`discard` only if the drive is an SSD):

```sh
cat >> /etc/crypttab <<'EOF'
cryptdata   /dev/disk/by-label/cryptdata   /etc/luks/lukskey-cryptdata   discard
EOF

cat >> /etc/fstab <<'EOF'
LABEL=data   /home/<user>/assets   ext4   rw,relatime   0 2
EOF
```

(LUKS1 fallback for the crypttab line: `cryptdata UUID=<luks-uuid> …`.)

Notes:

- systemd creates the mount point automatically; ownership comes from the
  filesystem itself, i.e. the old uid. **Make the new user the first user
  created (uid 1000)** and the old files line up without a chown.
- The mount point is `~/assets` — the drive is the self-managed "second
  home" (documents, downloads, media, selected state). The repo defaults
  follow that layout: `wallpaper_directory` (ansible) and
  `desktop.wallpaperDirectory` (nix) both point at
  `~/assets/media/pics/wallpaper/landscape`.

## 10. Users

```sh
passwd                                   # root — without this the box is a brick
useradd -m -G wheel <user>               # first user => uid 1000, see step 9
passwd <user>

EDITOR=nvim visudo                       # uncomment:  %wheel ALL=(ALL:ALL) ALL
```

## 11. Services

```sh
systemctl enable NetworkManager          # otherwise the first boot has no way online
systemctl enable systemd-timesyncd
systemctl enable fstrim.timer            # periodic TRIM for both SSDs
systemctl enable systemd-boot-update.service   # keeps the ESP's systemd-boot current
```

(`sshd` stays disabled by default; enable if the box should be reachable.)

## 12. Reboot

```sh
exit                        # leave the chroot
swapoff /mnt/swapfile       # or umount -R fails with the swapfile busy
umount -R /mnt
cryptsetup close cryptroot
reboot
```

First-boot checklist:

- unlock prompt appears in the terminus font, passphrase opens root;
- `systemctl --failed` is empty;
- `lsblk` shows `cryptdata` open and mounted at `~/assets`, files owned
  by `<user>`;
- `nmtui` / `nmcli device wifi connect <SSID> --ask` gets online;
- `timedatectl` shows NTP synchronized;
- `bootctl status` is happy (no "out of date" warnings).

## 13. Post-install hardening (recommended)

### Back up the LUKS headers

Your data is not encrypted with your passphrase — it is encrypted with a
random *master key*, and the passphrase merely unwraps that key. The master
key exists in exactly one place: a 16 MiB header at the front of the
partition (on this layout the data itself starts at offset 16 MiB). Destroy
that header and the drive is gone no matter how well you remember the
passphrase. A stray `mkfs` on the wrong device, a bad write, or an
interrupted `cryptsetup` operation is all it takes.

```sh
# As root. The target is the LUKS partition itself, not /dev/mapper/*
cryptsetup luksHeaderBackup /dev/disk/by-label/cryptroot --header-backup-file cryptroot-header.img
cryptsetup luksHeaderBackup /dev/disk/by-label/cryptdata --header-backup-file cryptdata-header.img
```

Each file comes out 16 MiB. **Test the backup before trusting it** — an
untested backup is not a backup. Opening the disk *through* the file as a
detached header proves the file is good and writes nothing to the disk:

```sh
cryptsetup open --header cryptroot-header.img --test-passphrase /dev/disk/by-label/cryptroot
# asks for the passphrase, then prints nothing and exits 0 on success
```

**Where to keep them.** Never on the drive they protect — a `cryptdata`
header stored in `~/assets` is unreachable exactly when you need it. And
treat them as secret material, not just backups: the file holds the wrapped
master key, so the header plus any passphrase that was valid when it was
taken decrypts a stolen copy of the disk. Encrypt them and keep two copies
off the machine — the USB stick that already holds the `cryptdata` keyfile,
plus one somewhere else:

```sh
gpg --encrypt --recipient <your-key> cryptroot-header.img   # -> .img.gpg
shred -u cryptroot-header.img
```

**Re-take them after any key change.** A restored header brings back
exactly the keyslots it had when it was made — verified in both directions:
a passphrase you later revoked starts working again, and a passphrase or
TPM slot you added after the backup stops working. Refresh these images
after every `luksAddKey`, `luksRemoveKey` or `systemd-cryptenroll`.

**When it actually goes wrong**, boot the ISO and put the header back.
Note the device path: with the header destroyed there is no LUKS label to
read any more, so `/dev/disk/by-label/cryptroot` will not exist — address
the raw partition:

```sh
lsblk -o NAME,SIZE,MODEL,SERIAL            # find the partition again
cryptsetup luksHeaderRestore /dev/sda3 --header-backup-file cryptroot-header.img
```

That overwrites the current header — every keyslot on it — with the saved
one, after which the drive unlocks with the passphrases it had at backup
time. If you would rather not write to a disk you do not yet trust, skip
the restore and read through the detached header instead:

```sh
cryptsetup open --header cryptroot-header.img /dev/sda3 rescue
mount -o ro /dev/mapper/rescue /mnt
```

### TPM2 auto-unlock (optional — read the trade-off first)

`systemd-cryptenroll` generates a random key, adds it as a **new LUKS2
keyslot**, and seals that key to the laptop's TPM chip. On boot the
`sd-encrypt` hook asks the TPM to unseal it and the root volume unlocks
with nothing typed. Your passphrase slot is untouched and keeps working.

```sh
systemd-cryptenroll --tpm2-device=list      # confirm the T480's TPM2 is seen
systemd-cryptenroll --tpm2-device=auto /dev/disk/by-label/cryptroot
# then add the option in /etc/crypttab.initramfs:
#   cryptroot  /dev/disk/by-label/cryptroot  none  discard,tpm2-device=auto
mkinitcpio -P
```

**So how is that secure?** What guards the sealed key is the TPM's release
policy — and by default there is almost none: `--tpm2-pcrs=` defaults to
*no PCRs at all*, so the TPM will hand the key to whatever asks for it on
this machine. The bare command above therefore buys exactly one property:
the key is locked to this laptop's TPM chip.

- **Protects against** the drive being pulled out and read in another
  machine, or a raw image of it being copied off. Elsewhere that keyslot is
  useless, and the passphrase slot is Argon2id-hardened.
- **Does not protect against** someone holding the whole laptop. They press
  the power button, the disk unlocks itself, and all that stands between
  them and your files is the lock screen. Nor does it stop them booting a
  modified initramfs *on that machine* and having the TPM hand the key
  over — this install has no Secure Boot, so nothing measures the kernel
  and initramfs that get booted.

Binding PCRs (`--tpm2-pcrs=7`) narrows the policy, but it is fragile — a
firmware update, a changed BIOS setting or a bootloader update moves the
measurements and the unlock silently stops working — and without Secure
Boot plus a signed kernel it still leaves the tampered-initramfs hole open.

The middle ground worth having on a laptop that leaves the house is a PIN:

```sh
systemd-cryptenroll --tpm2-device=auto --tpm2-with-pin=yes /dev/disk/by-label/cryptroot
```

You still type something at boot, but it can be short (any characters, not
only digits), it is hardened with Argon2id before it reaches the TPM — so a
compromised TPM alone does not expose the volume key — and wrong entries
feed the TPM's dictionary-attack lockout instead of being freely guessable.

**Verdict for this machine:** keep typing the passphrase (simplest and
strongest at rest), or enroll TPM+PIN. Bare TPM-only unlocking is a
convenience that defends a stolen *drive* but not a stolen *laptop* —
pick it only with that framing in mind.

Housekeeping: keep the passphrase keyslot as the fallback (a broken TPM
policy otherwise locks you out), inspect what is enrolled with
`cryptsetup luksDump <device>` (the TPM slot appears as a `systemd-tpm2`
token), undo an enrollment with `systemd-cryptenroll --wipe-slot=tpm2
<device>`, and re-take the header backup afterwards — enrolling added a
keyslot.

## 14. Hand over to ansible

```sh
sudo pacman -S ansible
PYTHONUNBUFFERED=1 ansible-pull --url https://github.com/jetblack0/dotfiles ansible/base.yml --ask-become-pass
```

Keep `PYTHONUNBUFFERED=1`: `ansible-pull` never flushes the output it relays,
so without it the run prints nothing at all until it is over — see the
ansible README.

Then wire the second home in — deliberately a separate, personal playbook
(it asserts the drive is mounted and the data already in place, and tells
you what to fix if not):

```sh
ansible-playbook data.yml
```

Laptop-specific knobs (monitors, dpi, package excludes) follow the
`ansible/hosts/mac-vm.yml` pattern — keep a `hosts/<hostname>.yml` and
pass it with `-e @…`. Details in [ansible/README.md](../ansible/README.md).
