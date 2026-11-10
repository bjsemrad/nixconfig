#!/usr/bin/env bash
# Launch a web app in its own Firefox profile, as an app-like window.
#
# Firefox has no equivalent of chromium's --app=, so each web app gets a private
# profile under $XDG_DATA_HOME/webapps/<slug> whose userChrome.css hides the tab
# strip and toolbars. --name sets the Wayland app_id (and --class the X11 class)
# to webapp-<slug>, which is what the hyprland/niri/mango window rules match.
#
# The cost of separate profiles: each app keeps its own cookies, so you sign in
# once per app rather than sharing your main Firefox session.

set -euo pipefail

die() {
  printf '\033[31merror:\033[0m %s\n' "$*" >&2
  exit 1
}

(($# == 2)) || die "usage: webapp-launch <slug> <url>"
SLUG=$1 URL=$2
[[ $SLUG =~ ^[a-z0-9][a-z0-9-]*$ ]] || die "invalid slug: $SLUG"
[[ ${URL,,} =~ ^https?:// ]] || die "url must be http or https: $URL"

PROFILE="${XDG_DATA_HOME:-$HOME/.local/share}/webapps/$SLUG"
mkdir -p "$PROFILE/chrome"

# Re-linked on every launch so a rebuild that changes the settings (and lets the
# old store path be collected) takes effect the next time the app opens.
ln -sfn "$WEBAPP_USER_JS" "$PROFILE/user.js"
ln -sfn "$WEBAPP_USER_CHROME" "$PROFILE/chrome/userChrome.css"

# If this profile is already running, Firefox hands --new-window to that process
# instead of starting a second one.
exec "$WEBAPP_FIREFOX" \
  --profile "$PROFILE" \
  --name "webapp-$SLUG" \
  --class "webapp-$SLUG" \
  --new-window "$URL"
