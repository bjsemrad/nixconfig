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
  };
}
