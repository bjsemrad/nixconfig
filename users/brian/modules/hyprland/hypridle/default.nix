{
  config,
  inputs,
  pkgs,
  osConfig,
  ...
}:
{
  # imports = [
  # hypridle.homeManagerModules.default
  # ];

  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.hypridle;
    settings = {
      listener = [
        {
          timeout = 400;
          on-timeout = "[ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
            inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
          }/bin/hyprctl dispatch dpms off || ${
            inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
          }/bin/niri msg action power-off-monitors";
          on-resume = "[ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
            inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
          }/bin/hyprctl dispatch dpms on || ${
            inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
          }/bin/niri msg action power-on-monitors";
        }
      ]
      ++ (
        if (osConfig.networking.hostName == "thor") then
          [
            {
              timeout = 300;
              on-timeout = "${inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock}/bin/hyprlock";
            }
            {
              timeout = 600;
              on-timeout = "([ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
                inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
              }/bin/hyprctl dispatch dpms off || ${
                inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
              }/bin/niri msg action power-off-monitors) && ${pkgs.systemd}/bin/systemctl suspend";

              on-resume = "[ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
                inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
              }/bin/hyprctl dispatch dpms on || ${
                inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
              }/bin/niri msg action power-on-monitors";
            }
          ]
        else
          [
            {
              timeout = 400;
              on-timeout = "${inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock}/bin/hyprlock";
            }
            {
              timeout = 600;
              on-timeout = "([ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
                inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
              }/bin/hyprctl dispatch dpms off || ${
                inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
              }/bin/niri msg action power-off-monitors) && ${pkgs.systemd}/bin/systemctl suspend";

              on-resume = "([ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
                inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
              }/bin/hyprctl dispatch dpms on || ${
                inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
              }/bin/niri msg action power-on-monitors) && openrgb -p Blue";
            }
          ]
      );
      general = {
        lock_cmd = "${inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "${
          inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock
        }/bin/hyprlock";
        after_sleep_cmd = "[ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
        }/bin/hyprctl dispatch dpms on || ${
          inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
        }/bin/niri msg action power-on-monitors";
      };
    };
  };
}
