{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    enableDefaultPackages = true;

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.noto
      nerd-fonts.caskaydia-mono
      nerd-fonts.hack
      font-awesome
      noto-fonts
    ];
  };
}
