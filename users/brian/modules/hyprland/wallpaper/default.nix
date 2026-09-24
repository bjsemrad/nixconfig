{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.wallpaper;
  choice = "${config.xdg.stateHome}/epochshell/wallpaper";
  marker = "${config.xdg.stateHome}/wallpaper/nix-default";

  wallpaperSync = pkgs.writeShellApplication {
    name = "wallpaper-sync";
    runtimeInputs = [
      pkgs.coreutils
      config.programs.epochshell.epochctl.package
    ];
    text = ''
      default=${lib.escapeShellArg cfg.default}
      link=${lib.escapeShellArg cfg.current}
      choice=${lib.escapeShellArg choice}
      marker=${lib.escapeShellArg marker}

      mkdir -p "$(dirname "$link")" "$(dirname "$marker")" "$(dirname "$choice")"

      # A new default in nix becomes the choice, once. No marker means a first run, which keeps
      # whatever was already picked. Going through epochctl switches the screen live and keeps
      # EpochOxide's in-memory choice right; with no daemon to answer, write the file ourselves.
      if [ -f "$marker" ] && [ "$(cat "$marker")" != "$default" ]; then
        export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
        if ! epochctl wallpaper set "$default" >/dev/null 2>&1; then
          printf '%s\n' "$default" > "$choice"
        fi
      fi
      printf '%s\n' "$default" > "$marker"

      # Follow the choice, falling back to the default if that image has since gone.
      chosen="$(head -n1 "$choice" 2>/dev/null || true)"
      [ -f "$chosen" ] || chosen="$default"
      ln -sfn "$chosen" "$link"
    '';
  };
in
{
  options.wallpaper = {
    default = lib.mkOption {
      type = lib.types.str;
      description = ''
        The wallpaper nix asks for. epochshell can switch away from it and the switch survives
        rebuilds; changing this value is what takes it back.
      '';
    };
    current = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "${config.xdg.stateHome}/wallpaper/current";
      description = ''
        A symlink to the chosen wallpaper, for anything that shows one (hyprpaper, hyprlock).
        Kept outside ~/.config/hypr so epochshell's picker does not list it as another image.
      '';
    };
  };

  config = {
    wallpaper.default = "${config.home.homeDirectory}/.config/hypr/retropc.jpg";

    # Every rebuild: after the new files are linked, before home-manager restarts services, so
    # the link exists before hyprpaper could start from it.
    home.activation.wallpaperSync = lib.hm.dag.entryBetween [ "reloadSystemd" ] [ "linkGeneration" ] ''
      run ${wallpaperSync}/bin/wallpaper-sync
    '';

    # Whenever epochshell saves a new choice, so the link (and the next lock screen) follows it.
    systemd.user.paths.wallpaper-sync = {
      Unit.Description = "Follow the chosen wallpaper";
      Path.PathChanged = choice;
      Install.WantedBy = [ "default.target" ];
    };
    systemd.user.services.wallpaper-sync = {
      Unit = {
        Description = "Point the current wallpaper link at the chosen image";
        # The picker applies (and saves) every image it moves over, so browsing fires this many
        # times a second. systemd's default start limit then fails the path unit for good and
        # the final pick is missed; the job is one ln, so let it run as often as it is asked.
        StartLimitIntervalSec = 0;
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${wallpaperSync}/bin/wallpaper-sync";
      };
    };
  };
}
