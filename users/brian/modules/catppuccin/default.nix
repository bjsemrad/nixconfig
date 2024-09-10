 {config, pkgs, inputs, ... }:

{
  imports =[
      inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = {
    # enable = true;
    flavor = "mocha";
  };
  # gtk.catppuccin.enable = true;

}
