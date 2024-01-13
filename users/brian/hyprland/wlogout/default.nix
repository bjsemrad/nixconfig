{ config, pkgs, ... }:

{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "swaylock";
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
        action = "hyprctl dispatch exit 0";
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
          font-family: CaskaydiaCove Nerd Font, monospace;
          font-size: 12pt;
          color: #cdd6f4; 
          background-color: rgba(30, 30, 46, 0.5);
      }

      button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          border: none;
          color: #ced7f4;
          text-shadow: none;
          background-color: rgba(30, 30, 46, 0);
          margin: 5px;
          transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
      }

      button:hover {
          background-color: rgba(49, 50, 68, 0.1);
      }

      button:focus {
          background-color: #f6f5f4;
          color: #18182a;
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

  home.files = {
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
  };
}
