{ lib, osConfig, ... }:
lib.mkIf (osConfig.networking.hostName == "odin")  {
  home.file = {
    ".config/OpenRGB/Nix.orp".source = ./Nix.orp;
    ".config/OpenRGB/Nix2.orp".source = ./Nix2.orp;
    ".config/OpenRGB/Nix3.orp".source = ./Nix3.orp;
    ".config/OpenRGB/sizes.ors".source = ./sizes.ors;
  };
}
