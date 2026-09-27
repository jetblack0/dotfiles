#!/bin/sh
# Select a region on a frozen screen and print it as a PNG on stdout.
# Exits non-zero with no output when the selection is cancelled.
#
# Usage: ./region-grab.sh > shot.png

set -eu

exec still -c 'region=$(slurp </dev/null) || exit 1
exec grim -g "$region" -'
