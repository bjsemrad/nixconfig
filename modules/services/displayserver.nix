{ configs, pkgs, ... }:
{
  # Enable the X11/Wayland windowing system.
  services.xserver.enable = true;

  # Configure keymap
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
}
