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
        # Every compositor that registers a display-manager session (Hyprland,
        # niri, mango via their programs.* modules).
        command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session --asterisks";
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
