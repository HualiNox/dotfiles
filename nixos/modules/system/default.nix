/**
  系统模块聚合入口。

  统一导入基础系统、服务、桌面与可选服务模块，并声明当前主机默认启用项。
*/
{ ... }:

{
  imports = [
    # 基本配置文件
    ./boot
    ./i18n
    ./nixos

    # 服务配置文件
    ./android
    ./docker
    ./tailscale
    ./packages.nix

    # 桌面配置
    ./desktop

    # mihomo
    ./mihomo

    # buildkite
    ./buildkite
  ];

  # 主机级默认开关集中放在聚合入口，具体模块只声明行为。
  config.modules = {
    desktop = {
      enable = true;
      fcitx5.enable = true;
      # gnome.enable= true;
      hyprland.enable = true;
    };

    mihomo.enable = true;
    buildkite.enable = true;
  };
}
