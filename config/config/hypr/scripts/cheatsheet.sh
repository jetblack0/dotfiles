#!/bin/sh
# Keybind cheatsheet, searchable in the noctalia launcher.
#
# Rendered from the live hyprctl binds, so the list always matches the active
# layout and the submodes, then piped through the noctalia dmenu. A bind
# without a description is skipped.

set -eu

command -v noctalia >/dev/null 2>&1 || exit 0

hyprctl binds | awk '
	function flush() {
		if (key == "" || desc == "")
			return
		# modmask to names, high bit first so the label reads SUPER + CTRL +
		# SHIFT; the unnamed bits (mod5/mod3/mod2/caps) are only subtracted.
		mods = ""
		m = mask + 0
		if (m >= 128) m -= 128
		if (m >= 64) { mods = mods "SUPER + "; m -= 64 }
		if (m >= 32) m -= 32
		if (m >= 16) m -= 16
		if (m >= 8) { mods = mods "ALT + "; m -= 8 }
		if (m >= 4) { mods = mods "CTRL + "; m -= 4 }
		if (m >= 2) m -= 2
		if (m >= 1) { mods = mods "SHIFT + "; m -= 1 }

		if (smap == "")
			main[++mn] = sprintf("%-34s %s", mods key, desc)
		else
			subs[++sn] = sprintf("%-34s %s", "[" smap "] " key, desc)
	}

	/^bind/           { flush(); mask = ""; smap = ""; key = ""; desc = "" }
	/^\tmodmask:/     { mask = $2 }
	/^\tsubmap:/      { smap = $2 }
	/^\tkey:/         { key = $2 }
	/^\tdescription:/ { desc = $0; sub(/^\tdescription: /, "", desc) }

	END {
		flush()
		# registration order, which is the binds.lua reading order; the
		# submode keys go together at the end.
		for (i = 1; i <= mn; i++) print main[i]
		for (i = 1; i <= sn; i++) print subs[i]
	}
' | noctalia dmenu -p "Keybinds" > /dev/null || true
