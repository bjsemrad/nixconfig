{ inputs, pkgs, ... }: {
  home.packages = [
    pkgs.libqalculate
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.iwmenu
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.bzmenu
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.walker
    #inputs.walker.packages.${pkgs.system}.walker
    #inputs.elephant.packages.${pkgs.system}.elephant-with-providers
  ];

  home.file = {
    ".config/walker/config.toml".source = ./config.toml;
    ".config/walker/themes/matte-black.css".source = ./matte-black.css;
  };

  # programs.elephant = { installService = true; };

  # programs.walker = {
  #   enable = true;
  #   runAsService = true;
  # };

  # services.walker = {
  #   enable = false;
  #   systemd.enable = true;
  #
  #   # All options from the config.json can be used here.
  #   settings = {
  #     app_launch_prefix = "uwsm app -- ";
  #     search.placeholder = "";
  #     ui.fullscreen = false;
  #     list = {
  #       height = 200;
  #     };
  #     websearch.prefix = "?";
  #     switcher.prefix = "/";
  #     applications.cache = false;
  #   };
  #
  #   # If this is not set the default styling is used.
  #   #style = ''
  #   # * {
  #   #    color: #dcd7ba;
  #   #   }
  #   #'';
  # };
}
