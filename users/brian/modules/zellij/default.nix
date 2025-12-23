{ inputs, pkgs, ...}:
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false; #custom session setup
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.zellij;
    # Cannot get keybinds to properly work using config file model.
    #settings = {
    #  theme = "catppuccin-mocha";
    #};
  };

    home.file =  {
        ".config/zellij/config.kdl".source = ./config.kdl;
        ".config/zellij/layouts/custom-simple.kdl".source = ./custom-simple.kdl;
    };

}
