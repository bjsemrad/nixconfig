{ config, pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f --clock";
      }
    ];

    timeouts = [
      {
        timeout = 30;
        command = "${pkgs.swaylock-effects}/bin/swaylock -f --clock";
      }
      {
        timeout = 35; #5
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
      {
        timeout = 40;
        command = "${pkgs.systemd}/bin/systemctl suspend";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };
}
