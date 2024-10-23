{ pkgs, ...}:
{
  programs.kitty = {
    enable = true;
    font = {
      size = 14;
      name = "JetBrains Mono Nerd Font";
    };
    shellIntegration = {
      enableZshIntegration = true;
    };
    # theme = "Rosé Pine";
    theme = "Catppuccin-Mocha";
  };
}  
