"""Compare two directory trees: exit 0 when identical, 1 when they
differ, 2 when the second one is missing.

Used by restore.yml instead of `diff -rq` because diff is not guaranteed
on a minimal system, while python is what ansible itself runs on. Files
are compared the rsync way (size + mtime); symlinks by their targets,
without following, so equally-broken links count as equal.
"""
import filecmp
import os
import sys


def differs(a, b):
    ea, eb = sorted(os.listdir(a)), sorted(os.listdir(b))
    if ea != eb:
        return True
    for name in ea:
        pa, pb = os.path.join(a, name), os.path.join(b, name)
        la, lb = os.path.islink(pa), os.path.islink(pb)
        if la != lb:
            return True
        if la:
            if os.readlink(pa) != os.readlink(pb):
                return True
        elif os.path.isdir(pa) != os.path.isdir(pb):
            return True
        elif os.path.isdir(pa):
            if differs(pa, pb):
                return True
        elif not filecmp.cmp(pa, pb, shallow=True):
            return True
    return False


snapshot, current = sys.argv[1], sys.argv[2]
if not os.path.isdir(current):
    sys.exit(2)
sys.exit(1 if differs(snapshot, current) else 0)
