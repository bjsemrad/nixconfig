{ inputs, pkgs, ... }: {
  home.packages = [
    pkgs.libqalculate
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.iwmenu
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.bzmenu
  ];

  home.file = {
    #".config/walker/config.toml".source = ./config.toml;
    ".config/walker/themes/matteblack/style.css".source = ./matte-black.css;
    # ".config/walker/themes/matte-black/matte-black.json".source =
    #   ./matte-black.json;

  };

  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      close_when_open = true;
      #theme = "matteblack";
      hotreload_theme = true;
      force_keyboard_focus = true;

      search = { placeholder = "Search..."; };

      builtins.hyprland_keybinds = { path = "~/.config/hypr/hyprland.conf"; };

      builtins.applications = {
        launch_prefix = "uwsm app -- ";
        placeholder = "Search...";
        prioritize_new = false;
        context_aware = false;
        show_sub_when_single = false;
        history = true;
        icon = "";
      };
    };
  };
}
