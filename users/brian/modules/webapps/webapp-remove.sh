#!/usr/bin/env bash
# Remove a web app created by webapp-add from the nix config.

set -euo pipefail

die() {
  printf '\033[31merror:\033[0m %s\n' "$*" >&2
  exit 1
}
info() { printf '\033[32m==>\033[0m %s\n' "$*"; }

[[ -n ${WEBAPPS_DIR:-} ]] || die "WEBAPPS_DIR is not set"
[[ -d $WEBAPPS_DIR ]] || die "WEBAPPS_DIR does not exist: $WEBAPPS_DIR"

if (($# != 1)) || [[ $1 == -h || $1 == --help ]]; then
  cat <<EOF
Usage: webapp-remove <slug>

Installed web apps:
$(
    cd "$WEBAPPS_DIR" && for f in *.desktop; do
      [[ -e $f ]] || continue
      printf '  %s\n' "${f%.desktop}"
    done
  )
EOF
  exit 1
fi

SLUG=$1
[[ $SLUG == */* ]] && die "slug cannot contain '/': $SLUG"
DESKTOP_FILE="$WEBAPPS_DIR/$SLUG.desktop"
[[ -e $DESKTOP_FILE ]] || die "no such web app: $SLUG"

rm -f "$DESKTOP_FILE"
info "removed $SLUG.desktop"

while IFS= read -r icon; do
  rm -f "$icon"
  info "removed ${icon#"$WEBAPPS_DIR"/}"
done < <(find "$WEBAPPS_DIR/hicolor" -type f -name "$SLUG.png" 2>/dev/null)

echo
echo "Next: rebuild home-manager, then commit the deletions."
