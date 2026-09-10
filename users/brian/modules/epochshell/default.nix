{
  config,
  pkgs,
  osConfig,
  inputs,
  ...
}:

let
  # The keybinds menu is a generator: EpochOxide runs it and reads the JSON entries it prints.
  # It asks the running compositor for its binds (niri's config.kdl, else hyprctl), so it carries
  # its own jq/python3 rather than relying on whatever the service PATH happens to have.
  keybindsMenu = pkgs.writeShellScriptBin "epochshell-keybinds-menu" ''
    export PATH=${
      pkgs.lib.makeBinPath [
        pkgs.jq
        pkgs.python3
      ]
    }:$PATH
    ${builtins.readFile ./menus/keybinds.sh}
  '';
in
{
  imports = [
    inputs.epochshell.homeManagerModules.default
  ];

  # Custom menus live in EpochOxide's menus_dir; each becomes a provider named after the menu,
  # reachable by the prefix given to it in query_prefixes below.
  home.file.".config/epochoxide/menus/keybinds.toml".text = ''
    name = "keybinds"
    name_pretty = "Keybinds"
    description = "Search the keybinds of the running compositor"
    icon = ""
    action = "%VALUE%"
    command = "${keybindsMenu}/bin/epochshell-keybinds-menu"
  '';

  # Capture: screenshots, OCR and screen recording, all through epochctl so the launcher, a
  # keybinding and a script do the same thing. No query prefix: it is found by typing.
  home.file.".config/epochoxide/menus/capture.toml".text = ''
    name = "capture"
    name_pretty = "Capture"
    description = "Screenshots, text capture and recording"
    icon = "󰄀"
    action = "epochctl capture screenshot %VALUE%"

    [[entries]]
    text = "Region"
    subtext = "Drag out a rectangle"
    value = "region"
    keywords = ["screenshot", "area", "select", "crop", "snip"]

    [[entries]]
    text = "Region to clipboard"
    subtext = "Copy it without keeping a file"
    value = "region --no-save"
    keywords = ["screenshot", "copy", "paste"]

    [[entries]]
    text = "Focused window"
    subtext = "The window you were just in"
    value = "window --delay 0.5"
    keywords = ["screenshot", "app", "active"]

    [[entries]]
    text = "Pick a window"
    subtext = "Click the window to capture"
    value = "window --select"
    keywords = ["screenshot", "choose", "click"]

    [[entries]]
    text = "This monitor"
    subtext = "The whole focused screen"
    value = "fullscreen --delay 0.5"
    keywords = ["screenshot", "display", "screen"]

    [[entries]]
    text = "All monitors"
    subtext = "Every screen as one image"
    value = "all --delay 0.5"
    keywords = ["screenshot", "desktop", "everything"]

    [[entries]]
    text = "Region in 3 seconds"
    subtext = "Time to open the menu you want in the shot"
    value = "region --delay 3"
    keywords = ["screenshot", "delay", "timer", "menu"]

    [[entries]]
    text = "Text from region"
    subtext = "Read it with OCR and copy the text"
    value = "region"
    keywords = ["ocr", "text", "copy", "read", "scan"]

    [entries.actions]
    default = "epochctl capture ocr %VALUE%"

    [[entries]]
    text = "Record region"
    subtext = "Start recording a rectangle"
    value = "region"
    keywords = ["record", "video", "screencast"]

    [entries.actions]
    default = "epochctl capture record %VALUE%"

    [[entries]]
    text = "Record this monitor"
    subtext = "Start recording the focused screen"
    value = "fullscreen --delay 0.5"
    keywords = ["record", "video", "screencast", "monitor"]

    [entries.actions]
    default = "epochctl capture record %VALUE%"

    [[entries]]
    text = "Stop recording"
    subtext = "Finish the recording in progress"
    value = "stop"
    keywords = ["record", "stop", "finish"]

    [entries.actions]
    default = "epochctl capture record %VALUE%"

    [[entries]]
    text = "Screenshots folder"
    subtext = "Open where shots are saved"
    value = "~/Pictures/Screenshots"
    keywords = ["screenshot", "folder", "open"]

    [entries.actions]
    default = "xdg-open %VALUE%"
  '';

  # System: updates, idle inhibition, and the session actions. The three that end a session sit at
  # the bottom on purpose -- a launcher is one keystroke from running whatever is selected.
  home.file.".config/epochoxide/menus/system.toml".text = ''
    name = "system"
    name_pretty = "System"
    description = "Updates, idle, and session actions"
    icon = "󰒓"
    action = "%VALUE%"

    [[entries]]
    text = "Check for updates"
    subtext = "Resolve every flake input; nothing is written to the flake"
    value = "epochctl nix check"
    keywords = ["nix", "flake", "update", "upgrade"]

    [[entries]]
    text = "Update flake"
    subtext = "Open a terminal running nix flake update"
    value = "epochctl nix update"
    keywords = ["nix", "flake", "update", "lock"]

    [[entries]]
    text = "Rebuild thor"
    subtext = "Runs nixupdate in a terminal"
    value = "epochctl nix rebuild thor"
    keywords = ["nix", "rebuild", "switch", "thor"]

    [[entries]]
    text = "Rebuild odin"
    subtext = "Runs nixupdate in a terminal"
    value = "epochctl nix rebuild odin"
    keywords = ["nix", "rebuild", "switch", "odin"]

    [[entries]]
    text = "Night mode"
    subtext = "Toggle: warm the screen"
    value = "epochctl toggle night-light"
    keywords = ["night", "warm", "blue", "light", "sunset", "gamma", "evening"]

    [[entries]]
    text = "Night mode on"
    subtext = "Warm the screen regardless of what it was"
    value = "epochctl toggle night-light on"
    keywords = ["night", "warm", "blue", "light", "sunset"]

    [[entries]]
    text = "Night mode off"
    subtext = "Hand the screen back to normal"
    value = "epochctl toggle night-light off"
    keywords = ["night", "warm", "blue", "light", "daylight"]

    [[entries]]
    text = "Stay awake"
    subtext = "Toggle: hold the machine out of idle and sleep"
    value = "epochctl toggle stay-awake"
    keywords = ["idle", "inhibit", "caffeine", "sleep", "presentation", "awake"]

    [[entries]]
    text = "Stay awake on"
    subtext = "Hold it awake regardless of what it was"
    value = "epochctl toggle stay-awake on"
    keywords = ["idle", "inhibit", "caffeine", "awake"]

    [[entries]]
    text = "Stay awake off"
    subtext = "Let it idle and sleep normally again"
    value = "epochctl toggle stay-awake off"
    keywords = ["idle", "inhibit", "sleep", "normal"]

    [[entries]]
    text = "Lock screen"
    subtext = "Through logind, so hypridle's own locker runs"
    value = "loginctl lock-session"
    keywords = ["lock", "screen", "away", "hyprlock"]

    [[entries]]
    text = "Sleep"
    subtext = "Suspend to RAM"
    value = "systemctl suspend"
    keywords = ["suspend", "sleep", "ram"]

    [[entries]]
    text = "Log out"
    subtext = "Quit the compositor and return to the login screen"
    value = "([ -n \"$HYPRLAND_INSTANCE_SIGNATURE\" ] && hyprctl dispatch exit) || niri msg action quit"
    keywords = ["logout", "exit", "session", "quit"]

    [[entries]]
    text = "Restart"
    subtext = "Reboot the machine"
    value = "systemctl reboot"
    keywords = ["reboot", "restart"]

    [[entries]]
    text = "Shut down"
    subtext = "Power the machine off"
    value = "systemctl poweroff"
    keywords = ["shutdown", "poweroff", "off", "halt"]
  '';

  programs.epochshell = {
    enable = true;
    configDir = "epochshell";
    autostart = true;

    homeAssistant = {
      enable = true;
      baseUrl = "https://home.semrad.net";
      tokenFile = osConfig.sops.secrets."home-assistant-token".path;
      favorites = [
        "light.office_lights"
      ];
    };

    # Flake update awareness. Checking never writes to the flake: EpochOxide resolves the inputs
    # into a throwaway lock file and compares, so flake.lock is left alone. The commands below run
    # in a terminal through zsh interactively, which is what makes an alias work here.
    nixUpdates = {
      enable = true;
      flake = "${config.home.homeDirectory}/nixconfig";
      checkIntervalMinutes = 60;
      hosts = [
        {
          name = "thor";
          rebuild = "nixupdate";
        }
        {
          name = "odin";
          rebuild = "nixupdate";
        }
        {
          name = "baldr";
          rebuild = "rebuild-baldr";
        }
        {
          name = "loki";
          rebuild = "rebuild-loki";
        }

      ];
    };

    epochoxide.settings = {
      launch_prefix = "";
      persistent_index = true;

      provider_enabled = {
        apps = true;
        files = true;
        calc = true;
        clipboard = true;
        menus = true;
        windows = true;
        runner = true;
      };

      # Each menu in ~/.config/epochoxide/menus is its own provider, named after the menu, so it
      # takes a query prefix here like any other provider.
      query_prefixes = {
        "?" = "keybinds";
        "!" = "capture";
        "," = "system";
      };

      file_roots = [
        "~"
      ];
    };
  };

  systemd.user.services.epochshell.Unit = {
    PartOf = [ "epochoxide.service" ];
    After = [ "epochoxide.service" ];
  };

  # programs.epochshell = {
  #   enable = true;
  #   configDir = "epochshell"; # ~/.config/epochshell
  #   autostart = true;
  #   homeAssistant = {
  #     enable = true;
  #     baseUrl = "https://home.semrad.net";
  #     tokenFile = osConfig.sops.secrets."home-assistant-token".path;
  #     favorites = [
  #       "light.office_lights"
  #     ];
  #   };
  #   elephant = {
  #     providers = [
  #       "files"
  #       "desktopapplications"
  #       "calc"
  #       "clipboard"
  #       "menus"
  #       "windows"
  #       # "bitwarden"
  #       "providerlist"
  #     ];
  #
  #     settings = {
  #       providers = {
  #         files = {
  #           min_score = 50;
  #         };
  #         desktopapplications = {
  #           launch_prefix = "";
  #         };
  #       };
  #     };
  #   };
  # };
}
