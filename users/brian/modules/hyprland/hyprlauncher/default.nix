{ config, inputs, pkgs, ... }: {
  home.file = {
    ".config/hypr/hyprlauncher.conf".source = ./hyprlauncher.conf;
  };
}
