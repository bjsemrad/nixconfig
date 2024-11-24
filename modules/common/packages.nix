{ pkgs, inputs, ... }:
{

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" "https://devenv.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="];
  };

  # List packages installed in system profile.
  programs.zsh.enable = true;
  services.flatpak.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    nixfmt-classic
    nixpkgs-fmt
    unzip
    killall
    neofetch
    ripgrep
  ];
}
