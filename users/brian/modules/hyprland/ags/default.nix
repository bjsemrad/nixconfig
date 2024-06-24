{ inputs, pkgs, ... }: {

  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    bun
    dart-sass
  ];
  programs.ags = {
    enable = true;
    configDir = ./config;
    extraPackages = with pkgs; [ accountsservice ];
  };
}
