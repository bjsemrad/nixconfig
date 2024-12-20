{
  programs.git = {
    enable = true;
    userName = "Brian Semrad";
    userEmail = "bjsemrad@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
    };
  };
}
