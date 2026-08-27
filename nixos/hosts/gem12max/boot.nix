{ pkgs, ... }:

let
  grubTheme = pkgs.catppuccin-grub.override {
    flavor = "mocha";
  };
in
{
  boot = {
    loader = {
      timeout = 3;

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        theme = grubTheme;
        configurationLimit = 15;
        useOSProber = true;
        gfxmodeEfi = "auto";
        gfxpayloadEfi = "keep";
      };

      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
    };

    plymouth = {
      enable = true;
      theme = "breeze";
    };

    initrd.kernelModules = [ "amdgpu" ];
    consoleLogLevel = 3;
    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
      "systemd.show_status=auto"
    ];
  };
}
