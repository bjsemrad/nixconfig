{ pkgs, ... }:
{
  powerManagement.enable = true;
  services.thermald.enable = true;

  # Off: applies aggressive autosuspend once at boot, doesn't adapt
  # to AC/battery, common source of USB weirdness.
  powerManagement.powertop.enable = false;

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;

  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "auto";
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
