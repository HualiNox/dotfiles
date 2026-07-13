/**
  GNOME 桌面用户配置模块。

  在系统 GNOME 桌面启用时部署 Ghostty 配置，并安装主题、图标与光标包。
*/
{
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = osConfig.modules.desktop.gnome.enable;
  desktopCfg = osConfig.modules.desktop.enable;
in
{
  config = mkIf (cfg && desktopCfg) {
    # 用户级配置直接链接仓库目录，便于跨机器复用同一套终端配置。
    xdg.configFile."ghostty".source = ./../../../../ghostty;

    # 只影响当前用户外观，不放到系统级 GNOME 模块里。
    home.packages = with pkgs; [
      papirus-icon-theme
      bibata-cursors
      tela-icon-theme
    ];
  };
}
