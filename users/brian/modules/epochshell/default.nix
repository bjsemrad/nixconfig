{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.epochshell.homeManagerModules.default
  ];
  programs.epochshell = {
    enable = true;
    configDir = "epochshell"; # ~/.config/epochshell
    autostart = true;
    elephant = {
      providers = [
        "files"
        "desktopapplications"
        "calc"
        "clipboard"
        "menus"
        "windows"
        # "bitwarden"
        "providerlist"
      ];

      settings = {
        providers = {
          files = {
            min_score = 50;
          };
          desktopapplications = {
            launch_prefix = "";
          };
        };
      };
    };
  };
}
