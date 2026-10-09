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
        command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${config.programs.hyprland.package}/share/wayland-sessions:${
          inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri
        }/share/wayland-sessions
        :/share/wayland-sessions --remember --remember-user-session --asterisks";
        #   ${
        #   inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango
        # }

        #command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session --asterisks";
        user = "greeter";
      };

      initial_session = {
        command = "niri-session";
        #command = "start-hyprland";
        user = "brian";
      };
    };
  };
}
