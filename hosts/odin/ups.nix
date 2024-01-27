let
  vid = "0764";
  pid = "0601";
  password = "powermonups";
in
{
  # at some point something will make a /var/state/ups directory,
  # chown that to nut:
  # $ sudo chown nut:nut /var/state/ups
  power.ups = {
    enable = true;
    mode = "standalone";
    # debug by calling the driver:
    # $ sudo NUT_CONFPATH=/etc/nut/ usbhid-ups -u nut -D -a cyberpower
    ups.cyberpower = {
      # find your driver here:
      # https://networkupstools.org/docs/man/usbhid-ups.html
      driver = "usbhid-ups";
      description = "CP1500 VA  UPS";
      port = "auto";
      directives = [
        "vendorid = ${vid}"
        "productid = ${pid}"
      ];
      # this option is not valid for usbhid-ups
      maxStartDelay = null;
    };
    maxStartDelay = 10;
  };

  users = {
    users.nut = {
      isSystemUser = true;
      group = "nut";
      # it does not seem to do anything with this directory
      # but something errored without it, so whatever
      home = "/var/lib/nut";
      createHome = true;
    };
    groups.nut = { };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="${vid}", ATTRS{idProduct}=="${pid}", MODE="664", GROUP="nut", OWNER="nut"
  '';

  systemd.services.upsd.serviceConfig = {
    User = "nut";
    Group = "nut";
  };

  systemd.services.upsdrv.serviceConfig = {
    User = "nut";
    Group = "nut";
  };

  # reference: https://github.com/networkupstools/nut/tree/master/conf
  environment.etc = {
    # all this file needs to do is exist
    upsdConf = {
      text = "";
      target = "nut/upsd.conf";
      mode = "0440";
      group = "nut";
      user = "nut";
    };
    upsdUsers = {
      # update upsmonConf MONITOR to match
      text = ''
        [upsmon]
          password = ${password}
          upsmon master
      '';
      target = "nut/upsd.users";
      mode = "0440";
      group = "nut";
      user = "nut";
    };
    # RUN_AS_USER is not a default
    # the rest are from the sample
    # grep -v '#' /nix/store/8nciysgqi7kmbibd8v31jrdk93qdan3a-nut-2.7.4/etc/upsmon.conf.sample
    upsmonConf = {
      text = ''
        RUN_AS_USER nut

        MINSUPPLIES 1
        SHUTDOWNCMD "shutdown -h 0"
        POLLFREQ 5
        POLLFREQALERT 5
        HOSTSYNC 15
        DEADTIME 15
        RBWARNTIME 43200
        NOCOMMWARNTIME 300
        FINALDELAY 5
        MONITOR cyberpower@localhost 1 upsmon ${password} master
      '';
      target = "nut/upsmon.conf";
      mode = "0444";
    };
  };
}
