#!/usr/bin/env bash
# Create a Brave web app launcher and commit it to the nix config.
#
# Writes three things into $WEBAPPS_DIR (a directory inside the nixconfig repo):
#   <slug>.desktop                     the launcher
#   hicolor/<size>/apps/<slug>.png     the icon, at every size in SIZES
# webapps/default.nix picks both up automatically, so nothing here edits Nix code.

set -euo pipefail

SIZES=(32 48 128 256 512)
BROWSER="brave"

die() {
  printf '\033[31merror:\033[0m %s\n' "$*" >&2
  exit 1
}
info() { printf '\033[32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[33mwarn:\033[0m %s\n' "$*" >&2; }

usage() {
  cat <<EOF
Usage: webapp-add <Name> <url> [options]

Options:
  --icon <url|path>  Use this icon instead of autodetecting one from the site.
  --slug <slug>      Override the derived file/icon name.
  --class <wmclass>  Override the derived StartupWMClass.
  --force            Overwrite an existing web app of the same slug.
  -h, --help         Show this message.

Examples:
  webapp-add "YouTube" youtube.com
  webapp-add "Home Assistant" https://home.semrad.net --icon ~/Pictures/ha.png

Writes into: \$WEBAPPS_DIR (currently ${WEBAPPS_DIR:-unset})
EOF
}

# --- argument parsing -------------------------------------------------------

NAME="" URL="" ICON_REF="" SLUG="" WMCLASS="" FORCE=0
while (($#)); do
  case $1 in
  -h | --help)
    usage
    exit 0
    ;;
  --icon)
    ICON_REF="${2:-}"
    shift 2
    ;;
  --slug)
    SLUG="${2:-}"
    shift 2
    ;;
  --class)
    WMCLASS="${2:-}"
    shift 2
    ;;
  --force)
    FORCE=1
    shift
    ;;
  -*) die "unknown option: $1" ;;
  *)
    if [[ -z $NAME ]]; then
      NAME=$1
    elif [[ -z $URL ]]; then
      URL=$1
    else
      die "unexpected argument: $1"
    fi
    shift
    ;;
  esac
done

[[ -n $NAME && -n $URL ]] || {
  usage >&2
  exit 1
}
[[ -n ${WEBAPPS_DIR:-} ]] || die "WEBAPPS_DIR is not set"
[[ -d $WEBAPPS_DIR ]] || die "WEBAPPS_DIR does not exist: $WEBAPPS_DIR"

# --- naming -----------------------------------------------------------------

slugify() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' |
    sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//'
}

[[ -n $SLUG ]] || SLUG=$(slugify "$NAME")
[[ -n $SLUG ]] || die "could not derive a usable slug from name: $NAME"
[[ $SLUG == */* ]] && die "slug cannot contain '/': $SLUG"

# Checked before the icon fetch so a repeat invocation fails instantly instead of
# spending a round trip on an icon it is about to refuse to write.
if [[ -e "$WEBAPPS_DIR/$SLUG.desktop" && $FORCE -eq 0 ]]; then
  die "$SLUG already exists; pass --force to overwrite"
fi

# --- url --------------------------------------------------------------------

# Bare "youtube.com" is the common way to type this, so add the scheme. Anything
# that then isn't http(s) is refused: chromium's --app= treats javascript:,
# data: and file: as a document to execute.
[[ $URL =~ ^[a-zA-Z][a-zA-Z0-9+.-]*: ]] || URL="https://$URL"
[[ ${URL,,} =~ ^https?:// ]] || die "url must be http or https: $URL"
[[ $URL =~ [[:space:]] ]] && die "url must not contain whitespace: $URL"

URL_HOST=$(sed -E 's|^https?://||; s|/.*$||; s|\?.*$||' <<<"$URL")
URL_PATH=$(sed -E 's|^https?://[^/]*||' <<<"$URL")
[[ -n $URL_PATH ]] || URL_PATH="/"
ORIGIN=$(sed -E 's|^(https?://[^/]+).*|\1|' <<<"$URL")

# Chromium derives the app's WM class from GenerateApplicationNameFromURL(),
# which is host + "_" + path, with "/" replaced by "_". Verified against a live
# session: https://gmail.com -> brave-gmail.com__-Default, and
# https://mail.proton.me/u/0/inbox -> brave-mail.proton.me__u_0_inbox-Default.
# The hyprland/niri/mango window rules match on exactly this string.
if [[ -z $WMCLASS ]]; then
  WMCLASS="${BROWSER}-${URL_HOST}_${URL_PATH//\//_}-Default"
fi

# --- icon fetching ----------------------------------------------------------

TMPDIR_WORK=$(mktemp -d)
trap 'rm -rf "$TMPDIR_WORK"' EXIT

download_icon() {
  local url=$1 dest=$2
  curl -fsSL --max-time 15 -A 'Mozilla/5.0' -o "$dest" "$url" 2>/dev/null || return 1
  [[ -s $dest ]] || return 1
  [[ $(file -b --mime-type "$dest") == image/* ]] || return 1
}

# Pull every icon-ish <link> out of the page and try them largest-first. Sites
# advertise apple-touch-icon at 180px+ where favicon.ico is often 16px, so
# preferring it is what keeps these launchers from looking blurry.
scrape_icon_urls() {
  local page=$1
  grep -oiE '<link[^>]+>' <<<"$page" |
    grep -iE 'rel=["'"'"']?[^"'"'"'>]*icon' |
    while IFS= read -r tag; do
      local href size
      href=$(grep -oiE 'href=["'"'"'][^"'"'"']+' <<<"$tag" | head -1 | sed -E 's/^href=["'"'"']//')
      [[ -n $href ]] || continue
      size=$(grep -oiE 'sizes=["'"'"']?[0-9]+' <<<"$tag" | head -1 | grep -oE '[0-9]+' || true)
      # Unsized apple-touch-icons are 180 by convention; plain unsized icons rank last.
      if [[ -z $size ]]; then
        if grep -qi 'apple-touch-icon' <<<"$tag"; then size=180; else size=1; fi
      fi
      printf '%s\t%s\n' "$size" "$href"
    done | sort -rn -k1,1 | cut -f2
}

absolutize() {
  case $1 in
  http://* | https://*) printf '%s' "$1" ;;
  //*) printf 'https:%s' "$1" ;;
  /*) printf '%s%s' "$ORIGIN" "$1" ;;
  *) printf '%s/%s' "$ORIGIN" "$1" ;;
  esac
}

fetch_site_icon() {
  local dest=$1 page href
  page=$(curl -fsSL --max-time 10 -A 'Mozilla/5.0' "$URL" 2>/dev/null | head -c 200000 | tr '\n' ' ' || true)

  if [[ -n $page ]]; then
    while IFS= read -r href; do
      [[ -n $href ]] || continue
      if download_icon "$(absolutize "$href")" "$dest"; then return 0; fi
    done < <(scrape_icon_urls "$page")
  fi

  download_icon "$ORIGIN/apple-touch-icon.png" "$dest" && return 0
  download_icon "$ORIGIN/favicon.ico" "$dest" && return 0
  download_icon "https://www.google.com/s2/favicons?domain=${URL_HOST}&sz=256" "$dest" && return 0
  return 1
}

SRC_ICON="$TMPDIR_WORK/icon.src"
if [[ -z $ICON_REF ]]; then
  info "fetching icon for $URL_HOST"
  fetch_site_icon "$SRC_ICON" || die "could not find an icon; pass one with --icon <url|path>"
elif [[ $ICON_REF =~ ^https?:// ]]; then
  info "downloading icon"
  download_icon "$ICON_REF" "$SRC_ICON" || die "could not download icon: $ICON_REF"
else
  [[ -f $ICON_REF ]] || die "icon file not found: $ICON_REF"
  cp "$ICON_REF" "$SRC_ICON"
fi

# .ico files carry several frames; the first is usually the 16px one, so ask
# imagemagick which scene is widest and scale that up rather than a thumbnail.
best_frame() {
  magick identify -format '%[fx:w] %s\n' "$1" 2>/dev/null |
    sort -rn | head -1 | awk '{print $2}'
}
FRAME=$(best_frame "$SRC_ICON" || true)
[[ -n ${FRAME:-} ]] || FRAME=0

# --- write the files --------------------------------------------------------

DESKTOP_FILE="$WEBAPPS_DIR/$SLUG.desktop"

for size in "${SIZES[@]}"; do
  out_dir="$WEBAPPS_DIR/hicolor/${size}x${size}/apps"
  mkdir -p "$out_dir"
  magick "${SRC_ICON}[${FRAME}]" \
    -background none -alpha on \
    -resize "${size}x${size}>" \
    -gravity center -extent "${size}x${size}" \
    -strip "PNG32:$out_dir/$SLUG.png" ||
    die "failed to convert icon at ${size}x${size}"
done
info "wrote icons: hicolor/{$(
  IFS=,
  echo "${SIZES[*]}"
)}/apps/$SLUG.png"

# Desktop Entry values are newline-terminated, so a raw newline in the name would
# start a new key line and could inject a second Exec=.
desktop_escape() {
  local v=$1
  v=${v//\\/\\\\}
  v=${v//$'\t'/\\t}
  v=${v//$'\r'/\\r}
  v=${v//$'\n'/\\n}
  printf '%s' "$v"
}

cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$(desktop_escape "$NAME")
Comment=$(desktop_escape "$NAME")
Exec=$BROWSER --app="$URL" --ozone-platform=wayland
Icon=$SLUG
Terminal=false
StartupNotify=true
StartupWMClass=$(desktop_escape "$WMCLASS")
Categories=Network;
EOF
info "wrote $SLUG.desktop"

cat <<EOF

  $NAME
    url        $URL
    slug       $SLUG
    wm class   $WMCLASS

Next: rebuild home-manager, then 'git add' the new files in
$WEBAPPS_DIR
EOF
