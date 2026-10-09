{
  config,
  inputs,
  pkgs,
  osConfig,
  ...
}:
let
  # epochshell's lock screen. Locking is idempotent, so the idle timeout, logind's Lock signal
  # (`loginctl lock-session`) and the before-sleep hook can all fire it without stacking lockers.
  lock = "${config.programs.epochshell.epochctl.package}/bin/epochctl lock";
in
{
  # imports = [
  # hypridle.homeManagerModules.default
  # ];

  # Off: epochshell handles idle itself now (programs.epochshell.idle in modules/epochshell), with
  # the same timeouts. Kept configured so turning it back on is all a return takes.
  services.hypridle = {
    enable = false;
    package = inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.hypridle;
    settings = {
      listener = [
        {
          timeout = 400;
          on-timeout = "[ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
            osConfig.programs.hyprland.package
          }/bin/hyprctl dispatch dpms off || ${
            inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
          }/bin/niri msg action power-off-monitors";
          on-resume = "[ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
            osConfig.programs.hyprland.package
          }/bin/hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })' || ${
            inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
          }/bin/niri msg action power-on-monitors";
        }
      ]
      ++ (
        if (osConfig.networking.hostName == "thor") then
          [
            {
              timeout = 300;
              on-timeout = lock;
            }
            {
              timeout = 600;
              on-timeout = "([ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
                osConfig.programs.hyprland.package
              }/bin/hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })' || ${
                inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
              }/bin/niri msg action power-off-monitors) && ${pkgs.systemd}/bin/systemctl suspend";

              on-resume = "[ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
                osConfig.programs.hyprland.package
              }/bin/hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })' || ${
                inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
              }/bin/niri msg action power-on-monitors";
            }
          ]
        else
          [
            {
              timeout = 1800;
              on-timeout = lock;
            }
            {
              timeout = 3600;
              on-timeout = "([ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
                osConfig.programs.hyprland.package
              }/bin/hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })' || ${
                inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
              }/bin/niri msg action power-off-monitors) && ${pkgs.systemd}/bin/systemctl suspend";

              on-resume = "([ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
                osConfig.programs.hyprland.package
              }/bin/hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })' || ${
                inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
              }/bin/niri msg action power-on-monitors) && openrgb -p Blue";
            }
          ]
      );
      general = {
        lock_cmd = lock;
        # epochctl waits for the compositor to confirm the lock before returning, so the machine
        # does not go to sleep with the desktop still on screen.
        before_sleep_cmd = lock;
        after_sleep_cmd = "[ -n \"$${HYPRLAND_INSTANCE_SIGNATURE:-}\" ] && ${
          osConfig.programs.hyprland.package
        }/bin/hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })' || ${
          inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
        }/bin/niri msg action power-on-monitors";
      };
    };
  };
}
