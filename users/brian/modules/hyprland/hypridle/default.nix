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
          on-timeout = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
        }
      ] ++ (
        if (osConfig.networking.hostName == "thor") then
          [{
            timeout = 300;
            on-timeout = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
          }
            {
              timeout = 600;
              on-timeout = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on && ${pkgs.systemd}/bin/systemctl suspend";
              on-resume = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
            }]
        else [{
              timeout = 600;
              on-timeout = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
             }
             {
              timeout = 1800;
              on-timeout = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on && ${pkgs.systemd}/bin/systemctl suspend";
              on-resume = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
            }]
      );
      general = {
        lock_cmd = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
        after_sleep_cmd = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
      };
    };
  };
}
