{
  # Enable the X11/Wayland windowing system.
  services.xserver.enable = true;

  # Configure keymap
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };
}
