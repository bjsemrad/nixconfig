{ pkgs, osConfig, ... }:
{
  services.swayidle = {
    enable = false;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f --clock";
      }
    ];

    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock-effects}/bin/swaylock -f --clock";
      }
      {
        timeout = 400;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ] ++ (
      if (osConfig.networking.hostName == "thor") then
        [{
          timeout = 600;
          command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on && ${pkgs.systemd}/bin/systemctl suspend";
          resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }]
      else [ ]
    );
  };
}
