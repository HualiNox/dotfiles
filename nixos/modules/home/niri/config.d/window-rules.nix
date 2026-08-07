{ ... }:

{
  programs.niri.settings = {
    layer-rules = [
      {
        matches = [
          { namespace = "^linux-wallpaperengine$"; }
        ];
        place-within-backdrop = true;
      }
    ];

    window-rules = [
      {
        clip-to-geometry = true;
        draw-border-with-background = false;
        geometry-corner-radius = {
          top-left = 2.0;
          top-right = 2.0;
          bottom-left = 2.0;
          bottom-right = 2.0;
        };
      }
      {
        matches = [
          { app-id = "fcitx"; }
          { app-id = "org.fcitx.Fcitx5"; }
          { title = "Fcitx5 Input Window"; }
        ];

        focus-ring.enable = false;
        border.enable = false;
        shadow.enable = false;
        open-focused = false;
      }
      {
        matches = [
          { app-id = "(?i)terminal-float"; }
        ];

        open-floating = true;
        default-column-width.fixed = 1200;
        default-window-height.fixed = 1000;
      }
      {
        matches = [
          {
            app-id = "firefox$";
            title = "^Picture-in-Picture$";
          }
        ];

        open-floating = true;
      }
      {
        matches = [
          { app-id = "org.pulseaudio.pavucontrol"; }
          { app-id = "org.fcitx.fcitx5-config-qt"; }
          { app-id = "org.gnome.FileRoller"; }
          { app-id = "imv"; }
          { app-id = "mpv"; }
          { title = "图片查看器"; }
          { title = "重命名"; }
        ];

        open-floating = true;
      }
    ];
  };
}
