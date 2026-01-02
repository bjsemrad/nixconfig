{ config, pkgs, lib, ... }: {
  #=/nix/store/jdw6vbgkwa2ah41m78jskqjh6qbkcryd-uwsm-0.20.4/bin/uwsm start -S -F /run/current-system/sw/bin/Hyprland
  services.greetd = {
    enable = true;
    # vt = 8;
    settings = {
      default_session = {
        command =
          "${pkgs.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session --asterisks";
        user = "greeter";
      };

      initial_session = {
        command = "${lib.getExe config.programs.uwsm.package} start -e -D Hyprland hyprland-uwsm.desktop";
        user = "brian";
      };
    };
  };
}
