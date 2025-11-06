{ osConfig, ... }: {
  home.file = {
    ".config/niri/config.kdl".text = ''
      ${builtins.readFile ./${osConfig.networking.hostName}_monitors.kdl}
      ${builtins.readFile ./config.kdl}
    '';
  };
}
