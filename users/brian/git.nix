{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Brian Semrad";
    userEmail = "bjsemrad@gmail.com";
  };
}