{ pkgs, ...}:
{
  programs.kitty = {
    enable = true;
    font = {
      size = 14;
      name = "Fira Code Nerd Font";
    };
    shellIntegration = {
      enableZshIntegration = true;
    };
    # theme = "Rosé Pine";
    theme = "Catppuccin-Mocha";
  };
}  
