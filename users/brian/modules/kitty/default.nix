{ pkgs, ...}:
{
  programs.kitty = {
    enable = true;
    font = {
      size = 13;
      name = "JetBrainsMono Nerd Font";
    };
    shellIntegration = {
      enableZshIntegration = true;
    };
    # theme = "Rosé Pine";
    theme = "Catppuccin-Mocha";
  };
}  
