 wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "ALT_L";
      # Use kitty as default terminal
      terminal = "alacritty"; 
      # startup = [
      #   # Launch Firefox on start
      #   {command = "firefox";}
      # ];
    };
  };
