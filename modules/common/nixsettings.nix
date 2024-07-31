{
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 14d";
  nix.optimise.automatic = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" "impure-derivations" "ca-derivations"];

  nix.extraOptions = ''
    extra-platforms = x86_64-linux i686-linux aarch64-linux armv6l-linux armv7l-linux riscv64-linux
  '';

}
