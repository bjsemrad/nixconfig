{ pkgs, ... }:

{
  imports = [
  ];


  home = {
    username = "dash";
    homeDirectory = "/home/dash";
    packages = with pkgs; [

    ];

    programs.git = {
      enable = true;
      userName = "Brian Semrad";
      userEmail = "bjsemrad@gmail.com";
    };

    home.file = {
      "compose.yaml".source = ./compose.yaml;
    };

    sessionVariables = {
      # EDITOR = "emacs";
    };
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  # environment.
  programs.direnv.enable = true;

  #CONFIRM  programs.home-manager.enable = true;


}
