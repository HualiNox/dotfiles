/**
  启动加载与内核启动体验配置。

  使用 GRUB EFI、Catppuccin 主题和 Plymouth，减少启动日志噪音。
*/
{ pkgs, ... }:

let
  # GRUB 主题需要先 override，再传给 boot.loader.grub.theme。
  grubTheme = pkgs.catppuccin-grub.override {
    flavor = "mocha";
  };
in
{
  boot = {
    loader = {
      timeout = 3;

      grub = {
        # EFI 环境下 GRUB 不写入传统磁盘 MBR，device 固定为 nodev。
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

      # NixOS 品牌启动动画
      theme = "breeze";
    };

    initrd.kernelModules = [ "amdgpu" ];

    # 保持启动界面安静，只在必要时显示系统状态。
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
