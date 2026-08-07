/**
  桌面环境通用系统模块。

  提供桌面总开关，并负责禁止睡眠策略。
*/
{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  desktopLocale = "zh_CN.UTF-8";
in
{
  imports = [
    ./fcitx5.nix
    ./gnome.nix
    ./niri.nix
  ];

  # 桌面总开关；具体桌面实现通过子模块继续细分。
  options.modules.desktop.enable = mkEnableOption "desktop configuration";

  config = mkIf config.modules.desktop.enable {
    # 桌面会话统一使用中文环境；无桌面主机保持 system/i18n 的英文默认值。
    i18n = {
      defaultLocale = lib.mkForce desktopLocale;

      extraLocaleSettings = {
        LC_ADDRESS = desktopLocale;
        LC_COLLATE = desktopLocale;
        LC_CTYPE = desktopLocale;
        LC_IDENTIFICATION = desktopLocale;
        LC_MEASUREMENT = desktopLocale;
        LC_MESSAGES = desktopLocale;
        LC_MONETARY = desktopLocale;
        LC_NAME = desktopLocale;
        LC_NUMERIC = desktopLocale;
        LC_PAPER = desktopLocale;
        LC_TELEPHONE = desktopLocale;
        LC_TIME = desktopLocale;
      };
    };

    environment.sessionVariables = {
      LANGUAGE = "zh_CN:zh";
      LC_MESSAGES = desktopLocale;
    };

    systemd.services.display-manager.environment = {
      LANG = desktopLocale;
      LANGUAGE = "zh_CN:zh";
      LC_MESSAGES = desktopLocale;
    };

    # 使用 NixOS Steam 模块，让系统级 32 位图形驱动、音频与硬件规则一并启用。
    programs.steam.enable = true;

    # 1. 禁止 logind 因按键、合盖、空闲触发睡眠/休眠
    services.logind.settings.Login = {
      IdleAction = "ignore";

      HandleSuspendKey = "ignore";
      HandleHibernateKey = "ignore";

      # 笔记本合盖不睡
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };

    # 2. 硬禁用 systemd 的睡眠/休眠目标
    systemd.targets.sleep.enable = lib.mkForce false;
    systemd.targets.suspend.enable = lib.mkForce false;
    systemd.targets.hibernate.enable = lib.mkForce false;
    systemd.targets."hybrid-sleep".enable = lib.mkForce false;
    systemd.targets."suspend-then-hibernate".enable = lib.mkForce false;
  };
}
