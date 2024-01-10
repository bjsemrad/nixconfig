{ config, pkgs, ... }:
{
  imports =
    [
      ../common/wm/gnome.nix
      ../common/wm/hyprland.nix
    ];
}
