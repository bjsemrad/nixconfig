{ pkgs, ... }:
{

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  # List packages installed in system profile.
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    flatpak
    #jq
    nixfmt
    nixpkgs-fmt
    unzip
    killall
    neofetch
  ];
}
