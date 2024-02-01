{
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod1";
      # Use kitty as default terminal
      terminal = "alacritty";
      # startup = [
      #   # Launch Firefox on start
      #   {command = "firefox";}
      # ];
    };
  };
}
