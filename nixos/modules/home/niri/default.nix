{
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = osConfig.modules.desktop.enable && osConfig.modules.desktop.niri.enable;
in
{
  imports = [
    ./config.nix
    ./dms-plugins.nix
    ./wallpaper-engine.nix

    inputs.dms.homeModules.dank-material-shell
  ];

  config = mkIf cfg {
    programs.dank-material-shell = {
      enable = true;

      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dank-material-shell changes
      };

      niri = {
        enableKeybinds = false;
        enableSpawn = false;

        includes = {
          enable = true;
          override = true;
          originalFileName = "hm";
          filesToInclude = [
            "alttab"
            "colors"
            "cursor"
            "layout"
            "outputs"
            "windowrules"
            "wpblur"
          ];
        };
      };

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableVPN = false; # VPN management widget
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = false; # Calendar integration (khal)
    };

    gtk = {
      enable = true;

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };
    };

    qt = {
      enable = true;

      platformTheme = {
        name = "qt6ct";
      };
    };

    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";
    };

    home.packages = with pkgs; [
      nautilus

      adw-gtk3
      brightnessctl
      bibata-cursors
      cava
      cliphist
      ffmpeg
      file
      grim
      kdePackages.qt6ct
      libnotify
      papirus-icon-theme
      pavucontrol
      playerctl
      python3
      satty
      slurp
      uv
      wl-clipboard
      xdg-utils
    ];
  };
}
