{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.initrd.availableKernelModules = [
    "usbhid"
    "usb_storage"
    "uas"
    "xhci_pci"
    "sd_mod"
    "scsi_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  # REQUIRED for USB boot on this Pi. Without it the initrd lacks the modules
  # the drive needs and the kernel hangs looking for root — silent, no console
  # output, just LED activity then nothing. The sd-image module sets this,
  # which is why the stock image boots and a hand-rolled config doesn't.
  hardware.enableAllHardware = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
    options = [ "noatime" ];
  };

  hardware.enableRedistributableFirmware = true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
