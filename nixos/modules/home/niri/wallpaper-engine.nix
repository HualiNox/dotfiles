{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = osConfig.modules.desktop.enable && osConfig.modules.desktop.niri.enable;

  linuxWallpaperengineGuiAppImage = pkgs.fetchurl {
    url = "https://github.com/AzPepoze/linux-wallpaperengine-gui/releases/download/v0.4.8/linux-wallpaperengine-gui.AppImage";
    hash = "sha256-gp5KEmbmGByPpXu8rR/iyom2qqilVG3pWN8c9oJpEGo=";
  };

  linuxWallpaperengineGui = pkgs.appimageTools.wrapType2 {
    pname = "linux-wallpaperengine-gui";
    version = "0.4.8";
    src = linuxWallpaperengineGuiAppImage;
  };

  linuxWallpaperengineGuiWayland = pkgs.writeShellScriptBin "linux-wallpaperengine-gui" ''
    export PATH="${lib.makeBinPath [ pkgs.linux-wallpaperengine ]}:$PATH"
    exec ${linuxWallpaperengineGui}/bin/linux-wallpaperengine-gui --native-wayland "$@"
  '';
in
{
  config = lib.mkIf cfg {
    home.packages = [
      pkgs.linux-wallpaperengine
      linuxWallpaperengineGuiWayland
    ];

    xdg.desktopEntries.linux-wallpaperengine-gui = {
      name = "Linux Wallpaper Engine GUI";
      genericName = "Wallpaper Engine";
      comment = "Browse and control Wallpaper Engine wallpapers";
      exec = "${linuxWallpaperengineGuiWayland}/bin/linux-wallpaperengine-gui";
      terminal = false;
      categories = [
        "Utility"
        "Settings"
      ];
      settings.Keywords = "wallpaper;wallpaper engine;壁纸;动态壁纸;";
    };
  };
}
