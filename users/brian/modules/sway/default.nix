{
  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    config = {
      modifier = "Mod1";
      # Use kitty as default terminal
      terminal = "alacritty";
      output = rec {
        eDP-1 = {
          scale = "1.175";
        };
      };
      input = { "type:touchpad" = { tap = "enabled"; natural_scroll = "enabled"; }; };
      bars = [
        {
          command = "waybar";
        }
      ];
      input = {
        "type:keyboard" = {
          xkb_options = "ctrl:nocaps";
        };
      };
      # startup = [
      #   # Launch Firefox on start
      #   {command = "firefox";}
      # ];
    };
  };
}
