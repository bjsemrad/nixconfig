{ pkgs, ...}:
{
  programs.kitty = {
    enable = true;
    font = {
      size = 12;
      name = "JetBrainsMono Nerd Font";
    };
    shellIntegration = {
      enableZshIntegration = true;
    };
    theme = "Catppuccin-Mocha";
  };
}  
