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
in
{
  imports = [
    ./fcitx5.nix
    ./gnome.nix
    ./hyprland.nix
  ];

  # 桌面总开关；具体桌面实现通过子模块继续细分。
  options.modules.desktop.enable = mkEnableOption "desktop configuration";

  config = mkIf config.modules.desktop.enable {
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
