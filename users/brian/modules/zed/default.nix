 config, pkgs, inputs, ... }:
{
  home.packages = [
    inputs.zed-flake.packages.${pkgs.system}.zed-editor 
  ];

}
