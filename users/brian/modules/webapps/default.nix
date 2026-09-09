{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Where webapp-add writes. It edits files in the repo, not in the store, so it
  # needs the checkout path rather than ./. (which resolves to /nix/store/...).
  webappsDir = "${config.home.homeDirectory}/nixconfig/users/brian/modules/webapps";

  # Every *.desktop file next to this module is a web app. Adding one is a matter
  # of dropping the file in, which is all webapp-add does -- no Nix to edit.
  desktopEntries = lib.filterAttrs (
    name: type: type == "regular" && lib.hasSuffix ".desktop" name
  ) (builtins.readDir ./.);

  mkScript =
    name: source:
    pkgs.writeShellScriptBin name ''
      export PATH=${
        lib.makeBinPath [
          pkgs.coreutils
          pkgs.curl
          pkgs.file
          pkgs.findutils
          pkgs.gawk
          pkgs.gnugrep
          pkgs.gnused
          pkgs.imagemagick
        ]
      }:$PATH
      export WEBAPPS_DIR="''${WEBAPPS_DIR:-${webappsDir}}"
      ${builtins.readFile source}
    '';
in
{
  home.packages = [
    (mkScript "webapp-add" ./webapp-add.sh)
    (mkScript "webapp-remove" ./webapp-remove.sh)
  ];

  home.file =
    lib.mapAttrs' (
      name: _:
      lib.nameValuePair ".local/share/applications/${name}" { source = ./. + "/${name}"; }
    ) desktopEntries
    // {
      ".local/share/icons/hicolor" = {
        source = ./hicolor;
        recursive = true;
      };
    };
}
