import json
import subprocess
import sys
import termios
import tty

KNOWN = "dk"  # layout you already know (and what your keycaps say)
LEARN = "us"  # layout you're learning -- swap these two to go the other way

# physical key position (xkb name) -> (base, shift, altgr)
LAYOUTS = {
    "us": {
        "TLDE": ("`", "~"),
        "AE01": ("1", "!"), "AE02": ("2", "@"), "AE03": ("3", "#"),
        "AE04": ("4", "$"), "AE05": ("5", "%"), "AE06": ("6", "^"),
        "AE07": ("7", "&"), "AE08": ("8", "*"), "AE09": ("9", "("),
        "AE10": ("0", ")"), "AE11": ("-", "_"), "AE12": ("=", "+"),
        "AD11": ("[", "{"), "AD12": ("]", "}"), "BKSL": ("\\", "|"),
        "AC10": (";", ":"), "AC11": ("'", '"'),
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

DEAD = {"dk": {"´", "`", "¨", "^", "~"}}

WHERE = {
    "TLDE": "top-left, below Esc",
    "AE11": "right of 0", "AE12": "two right of 0",
    "AD11": "right of P", "AD12": "two right of P",
    "AC10": "right of L", "AC11": "two right of L",
    "BKSL": "next to Enter",
    "LSGT": "between left Shift and Z (ISO keyboards only)",
    "AB08": "right of M", "AB09": "two right of M", "AB10": "three right of M",
}

MODS = ["", "Shift + ", "AltGr + "]


def find(layout, ch):
    for pos, levels in LAYOUTS[layout].items():
        for lvl, c in enumerate(levels):
            if c == ch:
                return pos, lvl
    if ch.isascii() and ch.isalpha():
        return "LETTER", 1 if ch.isupper() else 0
    return None


def describe(ch):
    hit = find(LEARN, ch)
    if hit is None:
        return f"{ch}  →  not on {LEARN} (or not in the table)"
    pos, lvl = hit
    if pos == "LETTER":
        return f"{ch}  →  same key as on {KNOWN}"
    cap = (LAYOUTS[KNOWN].get(pos) or LAYOUTS[LEARN][pos])[0]
    cap = cap.upper() if cap.isalpha() else cap
    where = f", {WHERE[pos]}" if pos in WHERE else ""
    same = "  (same as before)" if find(KNOWN, ch) == hit else ""
    dead = "  (dead key: press Space after)" if ch in DEAD.get(LEARN, ()) else ""
    return f"{ch}  →  {MODS[lvl]}[{cap}]{where}{same}{dead}"


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
    except (ValueError, KeyError, IndexError, json.JSONDecodeError):
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
    print(f"Type a character the {KNOWN} way to see it on {LEARN}.")
    print("[X] = the key labelled X on your keyboard. Esc to quit.\n")
    try:
        while True:
            ch = read_char()
            if ch in ("\x1b", "\x03", ""):
                break
            if ch.isprintable() and not ch.isspace():
                print(describe(ch), flush=True)
    finally:
        switch(LEARN)


main()
