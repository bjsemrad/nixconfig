{ config, pkgs, ... }:

{
     home.file = { 
        ".alacritty.toml".source = ./alacritty.toml;
     };
}
