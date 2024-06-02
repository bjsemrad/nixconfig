{ config, inputs, pkgs, osConfig, ... }:
{
  # imports = [
  # hypridle.homeManagerModules.default
  # ];

  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.system}.hypridle;
    settings = {
      listener = [
        {
          timeout = 400;
          onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
      ] ++ (
        if (osConfig.networking.hostName == "thor") then
          [{
            timeout = 300;
            onTimeout = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
          }
            {
              timeout = 600;
              onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on && ${pkgs.systemd}/bin/systemctl suspend";
              onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
            }]
        else [{
          timeout = 600;
          onTimeout = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
        }]
      );
      general = {
        lock_cmd = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      };
    };
  };
}
