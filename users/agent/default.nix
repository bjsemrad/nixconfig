{ config, pkgs, ... }:

# Home profile for the unprivileged `agent` user on loki. Claude Code, Codex and
# gh are logged in interactively (subscription OAuth), not via sops secrets.
{
  home = {
    username = "agent";
    homeDirectory = "/home/agent";
    packages = with pkgs; [
      # Fast-moving CLIs, taken from unstable like brian's claude-code.
      pkgs.unstable.claude-code
      pkgs.unstable.codex
      nodejs_24 # current LTS
      python3
    ];

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "26.05"; # Please read the comment before changing.
  };

  programs.bash.enable = true;
  programs.git.enable = true;
  programs.gh.enable = true;
  programs.tmux = {
    enable = true;
    baseIndex = 1;
  };
}
