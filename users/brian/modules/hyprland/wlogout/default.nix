{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "logout";
        action =
          "pgrep -x Hyprland >/dev/null && hyprctl dispatch exit 0 || pgrep -x niri >/dev/null && niri msg action quit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
    ];

    style = ''
        window {
          font-family: JetBrainsMono Nerd Font;
          font-size: 12pt;
          color: #abb2bf; /* fg_dark */
          background-color:  rgba(30, 33, 39, 0.85);
      }

      button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          border: none;
          color: #abb2bf; /* fg_dark */
          text-shadow: none;
          background-color: rgba(30, 33, 39, 0);
          margin: 5px;
          transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
      }

      button:hover {
          background-color: rgba(50,54,65, 0.5); /* bg3 */
      }

      button:focus {
          background-color: #4fa6ed; /*blue*/
          color: #1E2127; /* bgDark */
          text-shadow: none;
      }

      #lock {
          background-image: image(url("./lock.png"));
      }
      #lock:focus {
          background-image: image(url("./lock-hover.png"));
      }

      #logout {
          background-image: image(url("./logout.png"));
      }
      #logout:focus {
          background-image: image(url("./logout-hover.png"));
      }

      #suspend {
          background-image: image(url("./sleep.png"));
      }
      #suspend:focus {
          background-image: image(url("./sleep-hover.png"));
      }

      #shutdown {
          background-image: image(url("./power.png"));
      }
      #shutdown:focus {
          background-image: image(url("./power-hover.png"));
      }

      #reboot {
          background-image: image(url("./restart.png"));
      }
      #reboot:focus {
          background-image: image(url("./restart-hover.png"));
      }
    '';
  };

  home.file = {
    ".config/wlogout/lock-hover.png".source = ./images/lock-hover.png;
    ".config/wlogout/lock.png".source = ./images/lock.png;
    ".config/wlogout/logout-hover.png".source = ./images/logout-hover.png;
    ".config/wlogout/logout.png".source = ./images/logout.png;
    ".config/wlogout/power-hover.png".source = ./images/power-hover.png;
    ".config/wlogout/power.png".source = ./images/power.png;
    ".config/wlogout/restart-hover.png".source = ./images/restart-hover.png;
    ".config/wlogout/restart.png".source = ./images/restart.png;
    ".config/wlogout/sleep-hover.png".source = ./images/sleep-hover.png;
    ".config/wlogout/sleep.png".source = ./images/sleep.png;
    ".config/wlogout/scripts/wlogout.sh".source = ./scripts/wlogout.sh;
  };
}
