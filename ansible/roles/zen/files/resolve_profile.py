"""Print the profile directory zen starts with; exit 1 when it has none.

Zen picks its profile from the [Install<hash>] section of profiles.ini,
not from the Default=1 flag, and the hash is derived from the install
directory -- it can only be read back, never predicted. There is
deliberately NO fallback to the first Path= entry: a registry without an
install section means zen has not run yet, and guessing a profile there
is what used to deploy into a directory zen never opens.
"""
import configparser
import os
import sys


def install_defaults(path):
    ini = configparser.ConfigParser(interpolation=None)
    ini.optionxform = str  # Default/Path/IsRelative are case-sensitive
    ini.read(path)
    return [(s, ini[s]["Default"]) for s in ini.sections()
            if s.startswith("Install") and ini[s].get("Default")]


for root in sys.argv[1:]:
    registry = os.path.join(root, "profiles.ini")
    if not os.path.isfile(registry):
        continue
    found = install_defaults(registry)
    if len(found) > 1:
        sys.exit("several zen installations in %s: %s"
                 % (registry, ", ".join(s for s, _ in found)))
    if not found:
        sys.exit("zen has no default profile yet in %s" % registry)
    # Descriptors are relative to the root unless IsRelative=0 made them
    # absolute.
    descriptor = found[0][1]
    print(descriptor if os.path.isabs(descriptor)
          else os.path.join(root, descriptor))
    sys.exit(0)

sys.exit("no zen profiles.ini under: %s" % ", ".join(sys.argv[1:]))
