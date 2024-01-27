{ lib, osConfig, ... }:
lib.mkIf (osConfig.networking.hostName == "odin")  {
  home.file = {
    ".config/OpenRGB/Nix.orp".source = ./Nix.orp;
    ".config/OpenRGB/sizes.ors".source = ./sizes.ors;
  };
}
