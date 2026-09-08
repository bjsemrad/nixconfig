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
  [ -f "$cfg" ] || return 0
  # Minimal kdl binds parser: find `binds {` block and per-combo "action" lines.
  python3 - "$cfg" <<'PY'
import json, sys, re

cfg = sys.argv[1]
try:
    src = open(cfg).read()
except OSError:
    json.dump([], sys.stdout)
    sys.exit(0)

src = re.sub(r"//.*", "", src)
in_binds = False
depth = 0
combo = None
entries = []

def value_of(tok):
    if tok.startswith('"') or tok.startswith("'"):
        return tok[1:-1]
    return tok

lines = [l for l in src.splitlines() if l.strip() and not l.strip().startswith(("/", "/*"))]
i = 0
while i < len(lines):
    line = lines[i].strip()
    if not in_binds and line.startswith("binds"):
        in_binds, depth = True, 0
        i += 1
        continue
    if not in_binds:
        i += 1
        continue
    # track depth within binds block
    depth += line.count("{") - line.count("}")
    if depth < 0:
        break
    if line.rstrip().endswith("{") or line.startswith(("Mod", "Super", "Ctrl", "Alt", "Shift")):
        # combo header, e.g. "Mod+Shift+T { spawn ... }"
        head = line.split("{")[0]
        combo = " ".join(head.split()).replace("+", "+")
        # gather actions until matching close
        inner = []
        while i < len(lines) and "}" not in lines[i]:
            inner.append(lines[i].strip())
            i += 1
        for a in inner:
            if a.startswith("spawn"):
                args = value_of(a.split(None, 1)[1]) if len(a.split(None, 1)) > 1 else ""
                text = args.split()[0] if args else "command"
                entries.append({
                    "text": f"Launch {text}",
                    "subtext": combo,
                    "icon": "",
                    "value": f"niri msg action spawn -- {args}",
                    "keywords": ["spawn", args],
                })
            elif a.startswith("action"):
                parts = a.split()
                name = parts[1] if len(parts) > 1 else ""
                rest = value_of(parts[2]) if len(parts) > 2 else ""
                text = " ".join(w.capitalize() for w in name.replace("-", " ").split())
                entries.append({
                    "text": text,
                    "subtext": combo,
                    "icon": "",
                    "value": f"niri msg action {name}" + (f" {rest}" if rest else ""),
                    "keywords": [name],
                })
    i += 1

json.dump(entries, sys.stdout)
PY
}

EMPTY="[]"

if [ -n "${NIRI_SOCKET:-}" ] || [ -S "${XDG_RUNTIME_DIR:-/run/user/1000}/niri.sock" ]; then
  niri_entries
elif [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] || command -v hyprctl >/dev/null; then
  hypr_entries
else
  echo "$EMPTY"
fi
