{ config, inputs, ...}:
let
  hypridle = inputs.hypridle;
in 
{
  #imports = [
  #  hypridle.homeManagerModules.default
  #];

  #services.hypridle.enable = true;
}
