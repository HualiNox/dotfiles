{ ... }:

{
  programs.niri.settings.spawn-at-startup = [
    {
      sh = "systemctl --user import-environment LANG LANGUAGE LC_MESSAGES TERMINAL WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIRI_SOCKET XDG_RUNTIME_DIR";
    }
    {
      sh = "dbus-update-activation-environment --systemd LANG LANGUAGE LC_MESSAGES TERMINAL WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIRI_SOCKET XDG_RUNTIME_DIR";
    }
    {
      argv = [
        "wl-paste"
        "--type"
        "text"
        "--watch"
        "cliphist"
        "store"
      ];
    }
    {
      argv = [
        "wl-paste"
        "--type"
        "image"
        "--watch"
        "cliphist"
        "store"
      ];
    }
  ];
}
