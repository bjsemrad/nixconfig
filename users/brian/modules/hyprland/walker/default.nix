{ inputs, pkgs, ...}:
{
  home.packages = [
    pkgs.libqalculate
    inputs.iwmenu.packages.${pkgs.system}.default
    inputs.bzmenu.packages.${pkgs.system}.default
  ];

  programs.walker = {
    enable = true;
    runAsService = false;

    # All options from the config.json can be used here.
    config = {
      app_launch_prefix = "uwsm app -- ";
      search.placeholder = "";
      ui.fullscreen = false;
      list = {
        height = 200;
      };
      websearch.prefix = "?";
      switcher.prefix = "/";
      applications.cache = false;
    };

    # If this is not set the default styling is used.
    #style = ''
    # * {
    #    color: #dcd7ba;
    #   }
    #'';
  };
}
