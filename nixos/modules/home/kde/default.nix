/**
  KDE 桌面用户配置模块。

  在系统 KDE 桌面启用时部署 fcitx5/Ghostty 配置，并安装主题、图标与光标包。
*/
{
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = osConfig.modules.desktop.kde.enable;
  desktopCfg = osConfig.modules.desktop.enable;
in
{
  config = mkIf (cfg && desktopCfg) {
    # 用户级配置直接链接仓库目录，便于跨机器复用同一套桌面配置。
    xdg.configFile."fcitx5".source = ./../../../../fcitx5;
    xdg.configFile."ghostty".source = ./../../../../ghostty;

    # 只影响当前用户外观，不放到系统级 KDE 模块里。
    home.packages = with pkgs; [
      catppuccin-kde
      papirus-icon-theme
      bibata-cursors
      tela-icon-theme
    ];
  };
}
