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
  ];

  config.modules = {
    desktop = {
      enable = true;

      kde.enable = true;
    };
  };
}
