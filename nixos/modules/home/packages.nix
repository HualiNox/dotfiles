/**
  Home Manager 软件包模块。

  基础 CLI 包始终安装，桌面应用只在系统桌面开关启用时加入。
*/
{
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf optionals;

  cfg = osConfig.modules.desktop.enable;

  # 少量桌面软件需要跟进新版，单独从 unstable 包集取用。
  unstablePkgs = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;

    config = {
      allowUnfree = true;
    };
  };

  yesplaymusic = pkgs.callPackage ../../pkgs/yesplaymusic { };

  homePackages = with pkgs; [
    fastfetch
    btop

    # distrobox
    distrobox
    distrobox-tui
  ];

  # 桌面应用体积较大，只在启用桌面模块时进入用户环境。
  desktopPackages = (
    with unstablePkgs;
    [
      # ide
      vscode
      jetbrains.idea
      android-studio
      zed-editor

      # 浏览器
      google-chrome

      # 通讯工具
      qq # QQ Linux 官方客户端
      wechat # 微信 Linux 官方客户端
      telegram-desktop # Telegram Desktop

      # 娱乐
      yesplaymusic
    ]
  );
in
{
  # optionals 保持无桌面主机的 home closure 更小。
  home.packages = homePackages ++ optionals cfg desktopPackages;
}
