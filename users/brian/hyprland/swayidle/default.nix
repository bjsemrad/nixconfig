{ config, pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "swaylock -f --clock";
      }
    ];

    timeouts = [
      {
        timeout = 300;
        command = "swaylock -f --clock";
      }
      {
        timeout = 305;
        command = "hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on";
      }
      {
        timeout = 600;
        command = "systemctl suspend' resume 'hyprctl dispatch dpms on";
      }
    ]
      };
  }
