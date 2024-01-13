{ config, pkgs, ... }:

{
  programs.swaylock = {
    enable = true;
    settings = {
      image = ~/.config/hypr/nix-purple.png;
      clock = true;
      timestr=%I:%M %p;
      indicator-idle-visible;
      color=282a36;
      inside-color=232629;
      line-color=232629;
      ring-color=232629;
      text-color=f8f8f2;

      layout-bg-color=1F202A;
      layout-text-color=f8f8f2;

      inside-clear-color=232629;
      line-clear-color=232629;
      ring-clear-color=232629;
      text-clear-color=f8f8f2;

      inside-ver-color=232629;
      line-ver-color=232629;
      ring-ver-color=232629;
      text-ver-color=f8f8f2;

      inside-wrong-color=232629;
      line-wrong-color=232629;
      ring-wrong-color=232629;
      text-wrong-color=ed1515;

      bs-hl-color=ff5555;
      key-hl-color=50fa7b;

      text-caps-lock-color=f8f8f2;


    };
  };
}
