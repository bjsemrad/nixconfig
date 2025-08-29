{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_zen; # pkgs.linuxPackages_latest;
}

