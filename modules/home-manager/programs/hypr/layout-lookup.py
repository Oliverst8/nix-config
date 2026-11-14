import json
import subprocess
import sys
import termios
import tty

KNOWN = "dk"  # layout you already know (and what your keycaps say)
LEARN = "us"  # layout you're learning (us = us(altgr-intl) in hyprland)

# physical key position (xkb name) -> (base, shift, altgr, shift+altgr)
LAYOUTS = {
    "us": {
        "TLDE": ("`", "~"),
        "AE01": ("1", "!"), "AE02": ("2", "@"), "AE03": ("3", "#"),
        "AE04": ("4", "$", "¤", "£"), "AE05": ("5", "%", "€"),
        "AE06": ("6", "^"), "AE07": ("7", "&", None, "½"),
        "AE08": ("8", "*"), "AE09": ("9", "("),
        "AE10": ("0", ")"), "AE11": ("-", "_"), "AE12": ("=", "+"),
        "AD02": ("w", "W", "å", "Å"),
        "AD11": ("[", "{"), "AD12": ("]", "}"), "BKSL": ("\\", "|"),
        "AC02": ("s", "S", None, "§"),
        "AC09": ("l", "L", "ø", "Ø"),
        "AC10": (";", ":"), "AC11": ("'", '"', "´", "¨"),
        "AB01": ("z", "Z", "æ", "Æ"),
        "AB07": ("m", "M", "µ"),
        "AB08": (",", "<"), "AB09": (".", ">"), "AB10": ("/", "?"),
    },
    "dk": {
        "TLDE": ("½", "§"),
        "AE01": ("1", "!"), "AE02": ("2", '"', "@"), "AE03": ("3", "#", "£"),
        "AE04": ("4", "¤", "$"), "AE05": ("5", "%", "€"), "AE06": ("6", "&"),
        "AE07": ("7", "/", "{"), "AE08": ("8", "(", "["), "AE09": ("9", ")", "]"),
        "AE10": ("0", "=", "}"), "AE11": ("+", "?"), "AE12": ("´", "`", "|"),
        "AD11": ("å", "Å"), "AD12": ("¨", "^", "~"), "BKSL": ("'", "*"),
        "AC10": ("æ", "Æ"), "AC11": ("ø", "Ø"), "LSGT": ("<", ">", "\\"),
        "AB08": (",", ";"), "AB09": (".", ":"), "AB10": ("-", "_"),
        "AB07": ("m", "M", "µ"),
    },
}

DEAD = {"dk": {"´", "`", "¨", "^", "~"}, "us": {"´", "¨"}}

WHERE = {
    "TLDE": "top-left, below Esc",
    "AE11": "right of 0", "AE12": "two right of 0",
    "AD11": "right of P", "AD12": "two right of P",
    "AC10": "right of L", "AC11": "two right of L",
    "BKSL": "next to Enter",
    "LSGT": "between left Shift and Z (ISO keyboards only)",
    "AB08": "right of M", "AB09": "two right of M", "AB10": "three right of M",
}

MODS = ["", "Shift", "AltGr", "Shift + AltGr"]

# ansi styling, matches the waybar/hyprland amber -> rose palette
def rgb(h, bg=False):
    r, g, b = (int(h[i:i + 2], 16) for i in (0, 2, 4))
    return f"\x1b[{48 if bg else 38};2;{r};{g};{b}m"


RESET = "\x1b[0m"
BOLD = "\x1b[1m"
AMBER, ROSE, DIM, CHIP = "ffb780", "e8829a", "8a8a8a", "3a2233"


def chip(text):
    return f"{rgb(CHIP, True)}{rgb(AMBER)}{BOLD} {text} {RESET}"


def dim(text):
    return f"{rgb(DIM)}{text}{RESET}"


def find(layout, ch):
    for pos, levels in LAYOUTS[layout].items():
        for lvl, c in enumerate(levels):
            if c == ch:
                return pos, lvl
    return None


def lookup(ch):
    """-> (keys, notes) on LEARN for ch, keys None if not found."""
    if ch.isascii() and ch.isalpha():
        return [], ["same key"]
    hit = find(LEARN, ch)
    if hit is None:
        return None, [f"not on {LEARN} (or not in the table)"]
    pos, lvl = hit
    cap = (LAYOUTS[KNOWN].get(pos) or LAYOUTS[LEARN][pos])[0]
    cap = cap.upper() if cap.isalpha() else cap
    keys = [m for m in MODS[lvl].split(" + ") if m] + [cap]

    notes = []
    if pos in WHERE:
        notes.append(WHERE[pos])
    if find(KNOWN, ch) == hit:
        notes.append("same as before")
    if ch in DEAD.get(LEARN, ()):
        notes.append("dead key: press Space after")
    return keys, notes


def describe(ch):
    head = f"  {rgb(ROSE)}{BOLD}{ch}{RESET}  {rgb(AMBER)}→{RESET}  "
    keys, notes = lookup(ch)
    if not keys:
        return head + dim(" · ".join(notes))
    width = sum(len(k) + 2 for k in keys) + 3 * (len(keys) - 1)
    line = head + dim(" + ").join(chip(k) for k in keys)
    return line + " " * max(1, 24 - width) + dim(" · ".join(notes))


# QWERTY letter rows, identical on dk and us
LETTERS = {**{f"AD{i + 1:02}": c for i, c in enumerate("qwertyuiop")},
           **{f"AC{i + 1:02}": c for i, c in enumerate("asdfghjkl")},
           **{f"AB{i + 1:02}": c for i, c in enumerate("zxcvbnm")}}


def notify(pos, lvl):
    """Notify where the char at (pos, lvl) on KNOWN lives on LEARN."""
    levels = LAYOUTS[KNOWN].get(pos)
    if levels is None and pos in LETTERS:
        levels = (LETTERS[pos], LETTERS[pos].upper())
    ch = levels[lvl] if levels and lvl < len(levels) else None
    if ch is None:
        title, body = f"{KNOWN} {MODS[lvl] or 'key'}", "nothing there"
    else:
        keys, notes = lookup(ch)
        title = esc(ch)
        body = " + ".join(f"<b>{esc(k)}</b>" for k in keys or [])
        if notes:
            body += ("\n" if body else "") + esc(" · ".join(notes))
    subprocess.run(["notify-send", "-a", "layout-lookup",
                    "-h", "string:x-dunst-stack-tag:layout-lookup",
                    f"{KNOWN} → {LEARN}: {title}", body])


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def switch(code):
    """Switch Hyprland to the given layout, if it's in kb_layout."""
    try:
        out = subprocess.run(["hyprctl", "devices", "-j"],
                             capture_output=True, text=True).stdout
        kbs = json.loads(out)["keyboards"]
        kb = next((k for k in kbs if k.get("main")), kbs[0])
        idx = [x.strip() for x in kb["layout"].split(",")].index(code)
        subprocess.run(["hyprctl", "switchxkblayout", "all", str(idx)],
                       capture_output=True)
    except (ValueError, KeyError, IndexError, StopIteration, json.JSONDecodeError):
        pass


def read_char():
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        return sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old)


def main():
    switch(KNOWN)
    sys.stdout.write("\x1b[?25l\x1b[2J\x1b[H")  # hide cursor, clear
    print(f"  {rgb(AMBER)}{BOLD}{KNOWN} → {LEARN}{RESET}  "
          + dim("type the Danish way · Esc quits"))
    print(dim("  [X] = the key labelled X on your keyboard") + "\n", flush=True)
    try:
        while True:
            ch = read_char()
            if ch in ("\x1b", "\x03", ""):
                break
            if ch.isprintable() and not ch.isspace():
                print(describe(ch), flush=True)
    finally:
        sys.stdout.write("\x1b[?25h")
        switch(LEARN)


if len(sys.argv) == 4 and sys.argv[1] == "--notify":
    notify(sys.argv[2], int(sys.argv[3]))
else:
    main()
