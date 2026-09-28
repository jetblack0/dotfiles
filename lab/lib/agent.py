"""Drive a lab vm like a person at its screen: screenshots, clicks, keys.

Called by ../vm, which passes the instance's sockets:

    agent.py shot  <vnc.sock> <out.png>
    agent.py size  <file.png>           prints WIDTHxHEIGHT
    agent.py click <qmp.sock> <screen> <x> <y> [left|right|middle]
    agent.py move  <qmp.sock> <screen> <x> <y>
    agent.py key   <qmp.sock> <combo>   e.g. super+return, ctrl+alt+t
    agent.py type  <qmp.sock> <text>

<screen> is the vnc socket, or the screen size as WIDTHxHEIGHT when the
screenshots come from somewhere else (grim inside the guest).

Screenshots come from qemu's vnc server: qemu's own screendump can't read
a 3d (virgl) display, but its vnc server gets every frame. Input goes in
over qmp as real usb tablet and keyboard events, so it works everywhere:
boot screen, greeter, any distro, nothing installed in the guest.
Coordinates are screenshot pixels. Only the python standard library.
"""

import json
import socket
import struct
import sys
import time
import zlib


# qmp
# ---------------------------------------------

class Qmp:
    def __init__(self, path):
        self.sock = socket.socket(socket.AF_UNIX)
        self.sock.connect(path)
        self.file = self.sock.makefile("rw")
        json.loads(self.file.readline())  # greeting
        self.run("qmp_capabilities")

    def run(self, command, **arguments):
        self.file.write(json.dumps({"execute": command, "arguments": arguments}) + "\n")
        self.file.flush()
        while True:
            reply = json.loads(self.file.readline())
            if "error" in reply:
                sys.exit(command + " failed: " + reply["error"]["desc"])
            if "return" in reply:
                return reply["return"]


# vnc
# ---------------------------------------------

class Vnc:
    """Just enough of the vnc protocol (rfb 3.8, no auth) for one frame."""

    def __init__(self, path):
        self.sock = socket.socket(socket.AF_UNIX)
        self.sock.connect(path)
        self.sock.settimeout(20)
        self.recv(12)
        self.sock.sendall(b"RFB 003.008\n")
        if 1 not in self.recv(self.recv(1)[0]):
            sys.exit("the vnc server wants a password")
        self.sock.sendall(b"\x01")
        if struct.unpack(">I", self.recv(4))[0] != 0:
            sys.exit("vnc handshake failed")
        self.sock.sendall(b"\x01")  # share the session with other viewers
        self.width, self.height = struct.unpack(">HH", self.recv(4))
        self.recv(16)  # the server's pixel format; we set our own below
        self.recv(struct.unpack(">I", self.recv(4))[0])  # desktop name

    def recv(self, n):
        data = b""
        while len(data) < n:
            chunk = self.sock.recv(n - len(data))
            if not chunk:
                sys.exit("the vnc connection closed")
            data += chunk
        return data

    def frame(self):
        """The whole screen as rgb bytes, one row after another."""
        w, h = self.width, self.height
        # 32 bits per pixel, little endian: blue, green, red, padding
        self.sock.sendall(struct.pack(">B3xBBBBHHHBBB3x", 0, 32, 24, 0, 1, 255, 255, 255, 16, 8, 0))
        self.sock.sendall(struct.pack(">BxHi", 2, 1, 0))  # raw pixels only
        self.sock.sendall(struct.pack(">BBHHHH", 3, 0, 0, 0, w, h))
        bgrx = bytearray(w * h * 4)
        covered = 0
        while covered < w * h:
            if self.recv(1)[0] != 0:  # only framebuffer updates matter
                continue
            self.recv(1)
            for _ in range(struct.unpack(">H", self.recv(2))[0]):
                x, y, rw, rh, encoding = struct.unpack(">HHHHi", self.recv(12))
                if encoding != 0:
                    sys.exit("unexpected vnc encoding %d" % encoding)
                data = self.recv(rw * rh * 4)
                for row in range(rh):
                    at = ((y + row) * w + x) * 4
                    bgrx[at:at + rw * 4] = data[row * rw * 4:(row + 1) * rw * 4]
                covered += rw * rh
        rgb = bytearray(w * h * 3)
        rgb[0::3] = bgrx[2::4]
        rgb[1::3] = bgrx[1::4]
        rgb[2::3] = bgrx[0::4]
        return rgb


def write_png(path, width, height, rgb):
    rows = bytearray()
    for y in range(height):
        rows.append(0)  # no png filter
        rows += rgb[y * width * 3:(y + 1) * width * 3]

    def chunk(kind, data):
        body = kind + data
        return struct.pack(">I", len(data)) + body + struct.pack(">I", zlib.crc32(body) & 0xffffffff)

    with open(path, "wb") as f:
        f.write(b"\x89PNG\r\n\x1a\n")
        f.write(chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)))
        f.write(chunk(b"IDAT", zlib.compress(bytes(rows), 6)))
        f.write(chunk(b"IEND", b""))


# keys
# ---------------------------------------------

# names people write -> qemu's key codes
ALIASES = {
    "super": "meta_l", "win": "meta_l", "meta": "meta_l", "mod": "meta_l",
    "control": "ctrl", "ctl": "ctrl",
    "enter": "ret", "return": "ret",
    "escape": "esc", "space": "spc",
    "del": "delete", "ins": "insert",
    "pageup": "pgup", "pagedown": "pgdn",
    "-": "minus", "=": "equal", "[": "bracket_left", "]": "bracket_right",
    "\\": "backslash", ";": "semicolon", "'": "apostrophe", "`": "grave_accent",
    ",": "comma", ".": "dot", "/": "slash",
}

# characters for `type`, on a us keyboard: key code, needs shift
CHARS = {" ": ("spc", False), "\n": ("ret", False), "\t": ("tab", False)}
for c in "abcdefghijklmnopqrstuvwxyz":
    CHARS[c] = (c, False)
    CHARS[c.upper()] = (c, True)
for c in "0123456789":
    CHARS[c] = (c, False)
for c, shifted in zip("-=[]\\;'`,./", "_+{}|:\"~<>?"):
    CHARS[c] = (ALIASES[c], False)
    CHARS[shifted] = (ALIASES[c], True)
for c, digit in zip("!@#$%^&*()", "1234567890"):
    CHARS[c] = (digit, True)


def keycodes(combo):
    return [{"type": "qcode", "data": ALIASES.get(k.lower(), k.lower())}
            for k in combo.split("+") if k]


# commands
# ---------------------------------------------

def screen_size(screen):
    """WIDTHxHEIGHT as given, or asked from the vnc socket."""
    if "x" in screen and "/" not in screen:
        w, h = screen.split("x")
        return int(w), int(h)
    vnc = Vnc(screen)
    return vnc.width, vnc.height


def to_tablet(size, x, y):
    """Screenshot pixels -> the usb tablet's 0..32767 range."""
    (w, h), x, y = size, int(x), int(y)
    if not (0 <= x < w and 0 <= y < h):
        sys.exit("%d,%d is outside the %dx%d screen" % (x, y, w, h))
    return (x * 32767 // max(w - 1, 1), y * 32767 // max(h - 1, 1))


def move(qmp, ax, ay):
    qmp.run("input-send-event", events=[
        {"type": "abs", "data": {"axis": "x", "value": ax}},
        {"type": "abs", "data": {"axis": "y", "value": ay}},
    ])


def main():
    cmd, args = sys.argv[1], sys.argv[2:]
    if cmd == "shot":
        vnc = Vnc(args[0])
        write_png(args[1], vnc.width, vnc.height, vnc.frame())
        print("%s (%dx%d)" % (args[1], vnc.width, vnc.height))
    elif cmd == "size":
        with open(args[0], "rb") as f:
            head = f.read(24)
        if head[:8] != b"\x89PNG\r\n\x1a\n":
            sys.exit(args[0] + " is not a png")
        print("%dx%d" % struct.unpack(">II", head[16:24]))
    elif cmd in ("click", "move"):
        qmp = Qmp(args[0])
        ax, ay = to_tablet(screen_size(args[1]), args[2], args[3])
        move(qmp, ax, ay)
        if cmd == "click":
            button = args[4] if len(args) > 4 else "left"
            time.sleep(0.05)  # let the pointer arrive before pressing
            for down in (True, False):
                qmp.run("input-send-event", events=[
                    {"type": "btn", "data": {"down": down, "button": button}}])
                time.sleep(0.05)
    elif cmd == "key":
        Qmp(args[0]).run("send-key", keys=keycodes(args[1]))
    elif cmd == "type":
        qmp = Qmp(args[0])
        for c in args[1]:
            if c not in CHARS:
                sys.exit("can't type %r (us keyboard characters only)" % c)
            code, shift = CHARS[c]
            keys = [{"type": "qcode", "data": "shift"}] if shift else []
            qmp.run("send-key", keys=keys + [{"type": "qcode", "data": code}], **{"hold-time": 20})
            time.sleep(0.02)
    else:
        sys.exit("unknown agent command " + cmd)


if __name__ == "__main__":
    main()
