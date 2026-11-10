{ inputs, config, ... }:
{
  imports = [ inputs.rex.homeManagerModules.default ];

  programs.rex.enable = true;
  services.rex.enable = true;
  programs.ssh.enable = true; # needed for the SSH fallback rex adds to ~/.ssh/config
}
