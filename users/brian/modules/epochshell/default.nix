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
