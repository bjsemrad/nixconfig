{ pkgs, ...}:
{
  programs.kitty = {
    enable = true;
    font = {
      size = 14;
      name = "JetBrainsMono Nerd Font";
    };
    shellIntegration = {
      enableZshIntegration = true;
    };
    
    settings = {
      include = "onedark-dark.conf";
    };
    # theme = "One Dark";
    #theme = "Rosé Pine";
    #theme = "Catppuccin-Mocha";
    #theme = "Dracula";
  };

   home.file = {
    ".config/kitty/rose-pine-cust.conf".source = ./rose-pine-cust.conf;
    ".config/kitty/onedark-dark.conf".source = ./onedark-dark.conf;
  };
}
