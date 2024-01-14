{ config, pkgs, ... }:

{
  services.fwupd.enable = true;
  hardware.enableAllFirmware = true;
}

