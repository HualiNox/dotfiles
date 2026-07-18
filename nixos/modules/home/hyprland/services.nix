{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  wallpaper = "/run/current-system/sw/share/hypr/wall0.png";
in
{
  config = mkIf config.modules.hyprland.enable {
    programs.fuzzel.enable = true;

    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        label = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 64;
            color = "rgba(cdd6f4ff)";
            position = "0, 160";
            halign = "center";
            valign = "center";
          }
        ];

        "input-field" = [
          {
            monitor = "";
            size = "280, 56";
            position = "0, -80";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgba(cdd6f4ff)";
            inner_color = "rgba(1e1e2ecc)";
            outer_color = "rgba(89b4faff)";
            outline_thickness = 2;
            placeholder_text = "<span foreground=\"##cdd6f4\">Password</span>";
          }
        ];
      };
    };

    services.hypridle = {
      enable = true;

      settings = {
        general = {
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
        ];
      };
    };

    services.hyprpaper = {
      enable = true;

      settings = {
        ipc = true;
        splash = false;
        preload = [ wallpaper ];
        wallpaper = [ ",${wallpaper}" ];
      };
    };

    services.mako.enable = true;
    services.hyprpolkitagent.enable = true;
  };
}
