{ config, inputs, pkgs, osConfig, ...}:
let
  hypridle = inputs.hypridle;
in 
{
  imports = [
   hypridle.homeManagerModules.default
  ];

  services.hypridle = {
    enable = true;
    listeners = [
      {
        timeout = 300;
        onTimeout = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
      }
      {
        timeout = 400;
        onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ] ++ (
      if (osConfig.networking.hostName == "thor") then
        [{
          timeout = 600;
          onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on && ${pkgs.systemd}/bin/systemctl suspend";
          onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }]
      else [ ] 
    );

    lockCmd = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
    beforeSleepCmd = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
    afterSleepCmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
  };
}
