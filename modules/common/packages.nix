{ pkgs, inputs, ... }:
{

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" "https://cosmic.cachix.org/" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
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
