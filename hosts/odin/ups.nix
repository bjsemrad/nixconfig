{ pkgs, ... }:
let
  vid = "0764";
  pid = "0601";
  pwfile = "/etc/nut/pw.config";
  password = "powermonups";
  configFile = pkgs.writeText "${pwfile}" ''${password}'';
in
{
  power.ups = {
    enable = true;
    mode = "standalone";
    ups.cyberpower = {
      # https://networkupstools.org/docs/man/usbhid-ups.html
      driver = "usbhid-ups";
      description = "CP1500 VA  UPS";
      port = "auto";
      directives = [
        "vendorid = ${vid}"
        "productid = ${pid}"
      ];
      maxStartDelay = null;
    };
    upsmon = {
      enable = true;
      monitor.cyberpower = {
        user = "nut";
        type = "master";
        system = "cyberpower@localhost";
        powerValue = 1;
        passwordFile = "${configFile}";
      };
      settings = {
        #   RUN_AS_USER="nut";
        #   MINSUPPLIES=1;
        SHUTDOWNCMD = "shutdown -h 0";
        POLLFREQ = 5;
        POLLFREQALERT = 5;
        HOSTSYNC = 15;
        DEADTIME = 15;
        RBWARNTIME = 43200;
        NOCOMMWARNTIME = 300;
        FINALDELAY = 5;
        #   MONITOR="cyberpower@localhost 1 upsmon ${password} master";
        # };
      };
    };
    users.nut = {
      upsmon = "master";
      passwordFile = "${configFile}";
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
  # environment.etc = {
  #   # all this file needs to do is exist
  #   upsdConf = {
  #     text = "";
  #     target = "nut/upsd.conf";
  #     mode = "0440";
  #     group = "nut"; 
  #     user = "nut";
  #   };
  #   upsdUsers = {
  #     # update upsmonConf MONITOR to match
  #     text = ''
  #       [upsmon]
  #         password = ${password}
  #         upsmon master
  #     '';
  #     target = "nut/upsd.users";
  #     mode = "0440";
  #     group = "nut";
  #     user = "nut";
  #   };
  # upsmonConf = {
  #   text = ''
  #     RUN_AS_USER nut
  #
  #     MINSUPPLIES 1
  #     SHUTDOWNCMD "shutdown -h 0"
  #     POLLFREQ 5
  #     POLLFREQALERT 5
  #     HOSTSYNC 15
  #     DEADTIME 15
  #     RBWARNTIME 43200
  #     NOCOMMWARNTIME 300
  #     FINALDELAY 5
  #     MONITOR cyberpower@localhost 1 upsmon ${password} master
  #   '';
  #   target = "nut/upsmon.conf";
  #   mode = "0444";
  # };
  # /};
}
