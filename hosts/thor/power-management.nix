{ pkgs, ... }:
{
  powerManagement.enable = true;
  services.thermald.enable = true;
  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = false;
  };
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  environment.systemPackages = with pkgs; [
    powertop
  ];

  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="27c6", ATTR{idProduct}=="609c", TEST=="power/control", ATTR{power/control}="on"
  '';

  services.upower.enable = true;
}
