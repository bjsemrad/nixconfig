{ config, pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "timeout 300";
        command = "swaylock -f --clock";
      }
      {
        event = "timeout 305";
        command = "hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on";
      }
      {
        event = "timeout 600";
        command = "systemctl suspend' resume 'hyprctl dispatch dpms on";
      }
      {
        event = "before-sleep";
        command = "swaylock -f --clock";
      }
    ];
  };
}
