{
  services.kanshi = {
    enable = false;
    systemdTarget = "hyprland-session.target";

    profiles = {
      laptop = {
        outputs = [
          {
            criteria = "eDP-1";
            scale = 1.175;
            status = "enable";
          }
        ];
      };

      home_office = {
        outputs = [
          {
            criteria = "Dell Inc. DELL U3818DW 97F8P96B0R1L";
            position = "0,0";
            #  mode = "3840x2160@60Hz";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };
    };
  };
}
