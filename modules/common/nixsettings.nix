{
   nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
    randomizedDelaySec = "5min";
  };

  # Automatic garbage collection (user profiles)
  systemd.user.services."nix-gc" = {
    description = "Garbage collection for user profiles";
    script = "/run/current-system/sw/bin/nix-collect-garbage --delete-older-than 7d";
    startAt = "daily";
  };

  nix.optimise.automatic = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" "impure-derivations" "ca-derivations"];

  nix.extraOptions = ''
    extra-platforms = x86_64-linux i686-linux aarch64-linux armv6l-linux armv7l-linux riscv64-linux
  '';

}
