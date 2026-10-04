#!/usr/bin/env bash
set -euo pipefail

# Keybinds menu generator for the EpochOxide menus provider.
# Emits a JSON array of {text, subtext, icon, value, keywords} menu entries.

hypr_entries() {
  python3 - <<'PY'
import json, os, re, subprocess, sys

# Hyprland reports every bind of a Lua config as the `__lua` dispatcher with a callback index,
# so `hyprctl binds -j` alone can only say "Lua bind 5". The readable name lives in the config
# that registered it: parse the hl.bind("CHORD", <body>) calls and join them to the live binds
# by chord, exactly as the menu did before the config moved to Lua.

MODS = [(128, "MOD5"), (64, "SUPER"), (32, "MOD3"), (16, "MOD2"), (8, "ALT"), (4, "CTRL"), (2, "CAPS"), (1, "SHIFT")]
KEY_LABELS = {
    "RETURN": "Return", "SPACE": "Space", "TAB": "Tab", "ESC": "Esc", "LEFT": "Left",
    "RIGHT": "Right", "UP": "Up", "DOWN": "Down", "BACKSPACE": "Backspace",
    "DELETE": "Delete", "PERIOD": "Period", "SLASH": "/", "COMMA": ",",
}
MOD_ALIASES = {
    "super": "super", "super_l": "super", "super_r": "super", "mod": "super", "mod4": "super",
    "ctrl": "ctrl", "control": "ctrl", "alt": "alt", "mod1": "alt", "shift": "shift",
    "caps": "caps", "mod2": "mod2", "mod3": "mod3", "mod5": "mod5",
}
DIRECTIONS = {"l": "left", "r": "right", "u": "up", "d": "down"}
WINDOW_LABELS = {
    "close": "Close window", "float": "Toggle floating", "fullscreen": "Toggle fullscreen",
    "fullscreen_state": "Toggle fullscreen", "center": "Center window", "drag": "Drag window",
    "resize": "Resize window", "pin": "Pin window", "kill": "Kill window",
}


def key_label(key):
    if not key:
        return ""
    upper = key.upper()
    if upper in KEY_LABELS:
        return KEY_LABELS[upper]
    return upper if len(key) == 1 else key


def combo_label(modmask, key):
    parts = [name for bit, name in MODS if modmask & bit]
    label = key_label(key)
    if label:
        parts.append(label)
    return "+".join(parts)


def canonical(parts):
    """Order-insensitive chord key, so SUPER+SHIFT+S and SHIFT+SUPER+S match."""
    out = sorted(MOD_ALIASES.get(p.strip().lower(), p.strip().lower()) for p in parts if p.strip())
    return "+".join(out)


def canonical_from_bind(modmask, key):
    return canonical([name for bit, name in MODS if modmask & bit] + [key])


def quote(value):
    return "'" + value.replace("'", "'\\''") + "'"


def lua_run(body):
    """Re-run the bind's own Lua through the REPL: `dispatch` on a Lua config is Lua itself."""
    body = " ".join(body.split())
    if body.startswith("function"):
        return "hyprctl repl " + quote("(%s)()" % body)
    return "hyprctl repl " + quote("hl.dispatch(%s)" % body)


def describe(body):
    """A readable name and a runnable command for the body of one hl.bind call."""
    exec_cmd = re.search(r"""exec(?:_cmd)?\s*\(\s*(["'])(.*?)\1""", body, re.S)
    if exec_cmd:
        command = exec_cmd.group(2)
        return "Run: " + command, command

    workspace = re.search(r"""focus\s*\(\s*\{[^}]*workspace\s*=\s*["']?([^"',}]+)""", body, re.S)
    if workspace:
        return "Focus workspace " + workspace.group(1).strip(), lua_run(body)

    move_ws = re.search(r"""window\.move\s*\(\s*\{[^}]*workspace\s*=\s*["']?([^"',}]+)""", body, re.S)
    if move_ws:
        return "Move window to workspace " + move_ws.group(1).strip(), lua_run(body)

    direction = re.search(r"""(focus|window\.swap|window\.move)\s*\(\s*\{[^}]*direction\s*=\s*["']([^"']+)""", body, re.S)
    if direction:
        what = {"focus": "Focus", "window.swap": "Swap window", "window.move": "Move window"}[direction.group(1)]
        return "%s %s" % (what, DIRECTIONS.get(direction.group(2), direction.group(2))), lua_run(body)

    window_op = re.search(r"hl\.dsp\.window\.([\w_]+)", body)
    if window_op:
        return WINDOW_LABELS.get(window_op.group(1), "Window: " + window_op.group(1).replace("_", " ")), lua_run(body)

    layout = re.search(r"""layout\s*=\s*["']([^"']+)""", body)
    if layout:
        return "Set layout: " + layout.group(1), lua_run(body)

    layout_action = re.search(r"""hl\.dsp\.layout\s*\(\s*["']([^"']+)""", body)
    if layout_action:
        return "Layout: " + layout_action.group(1), lua_run(body)

    if re.search(r"hl\.dsp\.focus\s*\(\s*\{[^}]*last", body, re.S):
        return "Focus last window", lua_run(body)

    generic = re.search(r"hl\.dsp\.([\w_.]+)", body)
    if generic:
        return generic.group(1).replace(".", " ").replace("_", " ").capitalize(), lua_run(body)

    return "", lua_run(body)


def parse_lua_config(path):
    """chord -> (name, command) for every hl.bind call in the Lua config."""
    try:
        with open(path, encoding="utf-8") as handle:
            source = handle.read()
    except OSError:
        return {}
    source = "\n".join(line for line in source.splitlines() if not line.lstrip().startswith("--"))

    binds = {}
    for match in re.finditer(r"""hl\.bind\s*\(\s*(["'])(.*?)\1\s*,""", source):
        chord, cursor, depth = match.group(2), match.end(), 0
        while cursor < len(source):
            char = source[cursor]
            if char == "(":
                depth += 1
            elif char == ")":
                if depth == 0:
                    break
                depth -= 1
            cursor += 1
        body = source[match.end():cursor].strip().rstrip(",")
        # A trailing option table (`, { mouse = true }`) is not part of the dispatcher.
        binds[canonical(chord.split("+"))] = describe(body)
    return binds


def workspace_fallback(modmask, key):
    """Binds generated in a config loop have no source text to match; read them off the chord."""
    if not key.isdigit():
        return None
    mods = {name for bit, name in MODS if modmask & bit}
    if mods not in ({"SUPER"}, {"SUPER", "SHIFT"}):
        return None
    workspace = 10 if key == "0" else int(key)
    if not 1 <= workspace <= 10:
        return None
    if "SHIFT" in mods:
        return "Move window to workspace %d" % workspace, lua_run("hl.dsp.window.move({ workspace = %d })" % workspace)
    return "Focus workspace %d" % workspace, lua_run("hl.dsp.focus({ workspace = %d })" % workspace)


def main():
    try:
        raw = subprocess.run(["hyprctl", "binds", "-j"], capture_output=True, text=True, check=True).stdout
        binds = json.loads(raw)
    except Exception:
        json.dump([], sys.stdout)
        return

    config = os.path.join(os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config")), "hypr/hyprland.lua")
    from_config = parse_lua_config(config)

    entries, seen = [], set()
    for bind in binds:
        if bind.get("mouse") or not bind.get("key"):
            continue
        modmask, key, dispatcher = bind.get("modmask", 0), bind["key"], bind.get("dispatcher", "")
        arg = (bind.get("arg") or "").strip()
        name, command = from_config.get(canonical_from_bind(modmask, key), ("", ""))

        if not name:
            name = bind.get("description", "").strip()
        if not name:
            name, command = workspace_fallback(modmask, key) or ("", command)
        if not name and dispatcher and dispatcher != "__lua":
            name = dispatcher.replace("_", " ").capitalize() + (": " + arg if arg else "")
        if not name:
            name = "Lua bind " + arg if arg else "Scripted shortcut"
        # `hyprctl dispatch` is itself parsed as Lua on a Lua config, so it is only a usable
        # fallback for a real dispatcher. An unmatched __lua bind is left with nothing to run
        # rather than something that will fail: the chord is still worth finding.
        if not command and dispatcher and dispatcher != "__lua":
            command = "hyprctl dispatch " + dispatcher + (" " + quote(arg) if arg else "")

        combo = combo_label(modmask, key)
        if (name, combo) in seen:
            continue
        seen.add((name, combo))
        entries.append({
            "text": name,
            "subtext": combo,
            "icon": "",
            "value": command,
            "keywords": [combo.replace("+", " ")],
        })

    json.dump(entries, sys.stdout)


main()
PY
}

niri_entries() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/niri/config.kdl"
  [ -f "$cfg" ] || { echo "[]"; return 0; }
  # niri has no IPC for its binds, so read them from config.kdl. Binds are almost always one line
  # (`Mod+Q repeat=false { close-window; }`), so this tokenizes the KDL rather than going line by
  # line: a bind is a key node inside `binds { }` whose children are its action and arguments.
  python3 - "$cfg" <<'PY'
import json, shlex, sys

try:
    src = open(sys.argv[1]).read()
except OSError:
    json.dump([], sys.stdout)
    sys.exit(0)

def tokens(s):
    i, n = 0, len(s)
    while i < n:
        c = s[i]
        if s.startswith("//", i):
            while i < n and s[i] != "\n":
                i += 1
        elif s.startswith("/*", i):
            end = s.find("*/", i + 2)
            i = n if end < 0 else end + 2
        elif s.startswith("/-", i):
            # KDL slashdash comments out the next node, argument, or block
            yield ("slashdash", None)
            i += 2
        elif c == '"':
            buf, i = [], i + 1
            while i < n and s[i] != '"':
                if s[i] == "\\" and i + 1 < n:
                    i += 1
                    buf.append({"n": "\n", "t": "\t"}.get(s[i], s[i]))
                else:
                    buf.append(s[i])
                i += 1
            yield ("str", "".join(buf))
            i += 1
        elif c in "{};":
            yield ("punct", c)
            i += 1
        elif c == "\n":
            yield ("punct", ";")
            i += 1
        elif c.isspace() or c == "\\":
            i += 1
        else:
            j = i
            while j < n and not s[j].isspace() and s[j] not in '{};"':
                j += 1
            word = s[i:j]
            # a property's value may be a quoted string: `hotkey-overlay-title="..."`
            if word.endswith("=") and j < n and s[j] == '"':
                yield ("prop", word[:-1])
            elif "=" in word:
                k, v = word.split("=", 1)
                yield ("prop", k)
                yield ("str", v)
            else:
                yield ("word", word)
            i = j

def nodes(toks):
    """Parse a token stream into (name, args, props, children) nodes."""
    out, cur, skip = [], None, False
    while True:
        t = next(toks, None)
        if t is None or t == ("punct", "}"):
            if cur and not skip:
                out.append(cur)
            return out
        kind, val = t
        if kind == "slashdash":
            if cur is None:
                skip = True
            else:
                nxt = next(toks, None)
                if nxt == ("punct", "{"):
                    nodes(toks)
            continue
        if kind == "punct" and val == ";":
            if cur and not skip:
                out.append(cur)
            cur, skip = None, False
        elif kind == "punct" and val == "{":
            children = nodes(toks)
            if cur is not None:
                cur["children"] = children
                if not skip:
                    out.append(cur)
            cur, skip = None, False
        elif cur is None:
            cur = {"name": val, "args": [], "props": {}, "children": []}
        elif kind == "prop":
            v = next(toks, (None, ""))[1]
            cur["props"][val] = v
        else:
            cur["args"].append(val)

def title_case(name):
    return " ".join(w.capitalize() for w in name.replace("-", " ").split())

LABELS = {
    "close-window": "Close window",
    "show-hotkey-overlay": "Show hotkey overlay",
    "fullscreen-window": "Toggle fullscreen",
    "toggle-window-floating": "Toggle floating",
    "toggle-overview": "Toggle overview",
    "quit": "Quit niri",
    "screenshot": "Screenshot",
    "screenshot-screen": "Screenshot screen",
    "screenshot-window": "Screenshot window",
    "power-off-monitors": "Power off monitors",
}

entries, seen = [], set()
for top in nodes(tokens(src)):
    if top["name"] != "binds":
        continue
    for bind in top["children"]:
        combo = bind["name"]
        title = bind["props"].get("hotkey-overlay-title")
        for action in bind["children"][:1]:
            name, args = action["name"], [str(a) for a in action["args"]]
            if name in ("spawn", "spawn-sh"):
                display = " ".join(args)
                if name == "spawn-sh" or (args[:2] == ["sh", "-c"] or args[:2] == ["bash", "-c"]):
                    cmd = args[-1] if args else ""
                    value = "niri msg action spawn-sh -- " + shlex.quote(cmd)
                    fallback = cmd if len(cmd) <= 80 else cmd[:80] + " …"
                else:
                    value = "niri msg action spawn -- " + " ".join(shlex.quote(a) for a in args)
                    fallback = "Launch " + (args[0] if args else "command")
                text = title or fallback
                subtext = f"{combo}  ·  {display}"
                keywords = [name, display]
            else:
                if name.startswith("focus-workspace") and args:
                    fallback = f"Focus workspace {args[0]}"
                elif name.startswith("move-column-to-workspace") and args and args[0].isdigit():
                    fallback = f"Move column to workspace {args[0]}"
                elif name.startswith("move-window-to-workspace") and args and args[0].isdigit():
                    fallback = f"Move window to workspace {args[0]}"
                else:
                    fallback = LABELS.get(name) or title_case(name)
                    if args:
                        fallback += ": " + " ".join(args)
                text = title or fallback
                value = "niri msg action " + name + "".join(" " + shlex.quote(a) for a in args)
                subtext = combo
                keywords = [name] + args
            key = (text, combo)
            if key in seen:
                continue
            seen.add(key)
            entries.append({
                "text": text,
                "subtext": subtext,
                "icon": "",
                "value": value,
                "keywords": keywords + [combo.replace("+", " ")],
            })

json.dump(entries, sys.stdout)
PY
}

EMPTY="[]"

# Same order EpochOxide's compositor detection uses for workspaces: the session's own socket
# variables first, then XDG_CURRENT_DESKTOP. hyprctl merely being installed says nothing about
# which compositor is running, so it is not a signal.
running_niri() {
  [ -n "${NIRI_SOCKET:-}" ] && return 0
  case "${XDG_CURRENT_DESKTOP:-}" in *[Nn]iri*) return 0 ;; esac
  compgen -G "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/niri.*.sock" >/dev/null
}

if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  hypr_entries
elif running_niri; then
  niri_entries
else
  echo "$EMPTY"
fi
