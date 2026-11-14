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


def describe(ch):
    head = f"  {rgb(ROSE)}{BOLD}{ch}{RESET}  {rgb(AMBER)}→{RESET}  "
    if ch.isascii() and ch.isalpha():
        return head + dim("same key")
    hit = find(LEARN, ch)
    if hit is None:
        return head + dim(f"not on {LEARN} (or not in the table)")
    pos, lvl = hit
    cap = (LAYOUTS[KNOWN].get(pos) or LAYOUTS[LEARN][pos])[0]
    cap = cap.upper() if cap.isalpha() else cap

    keys = [chip(m) for m in MODS[lvl].split(" + ") if m] + [chip(cap)]
    width = sum(len(m) + 2 for m in MODS[lvl].split(" + ") if m) + len(cap) + 2
    width += 3 * (len(keys) - 1)
    line = head + dim(" + ").join(keys) + " " * max(1, 24 - width)

    notes = []
    if pos in WHERE:
        notes.append(WHERE[pos])
    if find(KNOWN, ch) == hit:
        notes.append("same as before")
    if ch in DEAD.get(LEARN, ()):
        notes.append("dead key: press Space after")
    return line + dim(" · ".join(notes))


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


main()
