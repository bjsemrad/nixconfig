{ config, pkgs, ... }:
{
  # Enable the X11/Wayland windowing system.
  services.xserver.enable = true;

  # Configure keymap
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  imports =
    [
      ../common/wm/gnome.nix
      ../common/wm/hyprland
      ../common/wm/kde.nix
    ];
}
