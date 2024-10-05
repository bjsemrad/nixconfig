{  inputs, ... }:

{
  #Setup overlay to access the alacritty theme
  nixpkgs.overlays = [ 
    inputs.alacritty-theme.overlays.default 
    #inputs.neovim-flake.overlays.default
  ];
}
