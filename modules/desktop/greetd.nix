{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{

  services.greetd = {
    enable = true;
    settings = {
      terminal = {
        vt = lib.mkForce 8;
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
        }/share/wayland-sessions:${
          inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
        }/share/wayland-sessions --remember --remember-user-session --asterisks";

        #command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session --asterisks";
        user = "greeter";
      };

      initial_session = {
        #command = "niri-session";
        command = "start-hyprland";
        user = "brian";
      };
    };
  };
}
