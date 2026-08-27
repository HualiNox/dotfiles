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

        # WTR Pro 的 UEFI NVRAM Boot#### 不可靠，
        # 使用标准 EFI fallback 路径 EFI/BOOT/BOOTX64.EFI。
        efiInstallAsRemovable = true;

        theme = grubTheme;
        configurationLimit = 15;

        gfxmodeEfi = "auto";
        gfxpayloadEfi = "keep";
      };

      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = false;
      };
    };

    consoleLogLevel = 4;
  };
}
