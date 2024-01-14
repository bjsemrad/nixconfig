{
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than +5";
  nix.optimise.automatic = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
