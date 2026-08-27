# WTR Pro hardware configuration generated from the current machine.
{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "uas"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/21ea24a3-fc02-4b17-9058-f2397ba95124";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/5A4E-3DCE";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/srv/storage/hdd-a" = {
    device = "/dev/disk/by-uuid/ab7c9afa-f386-4083-9b8c-5837b11d7fec";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/srv/storage/hdd-b" = {
    device = "/dev/disk/by-uuid/78d1ab32-e77d-423f-a330-5012bf916c9d";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];

  boot.kernel.sysctl."vm.swappiness" = 10;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
