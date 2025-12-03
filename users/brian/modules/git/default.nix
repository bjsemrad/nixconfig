{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Brian Semrad";
        email = "bjsemrad@gmail.com";
      };
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
