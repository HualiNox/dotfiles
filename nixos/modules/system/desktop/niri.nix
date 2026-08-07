{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.desktop.enable && config.modules.desktop.niri.enable;

  sddmAstronautTheme = pkgs.sddm-astronaut.override {
    embeddedTheme = "purple_leaves";

    themeConfig = {
      HeaderTextColor = "#d5c4a1";
    };
  };
in
{
  options.modules.desktop.niri.enable = mkEnableOption "niri configuration";

  config = mkIf cfg {
    # 启用 niri
    programs.niri = {
      enable = true;

      useNautilus = true;
    };

    # 使用 sddm
    services = {
      accounts-daemon.enable = true;
      gnome.gnome-keyring.enable = true;
      power-profiles-daemon.enable = true;

      xserver.enable = true;
      displayManager.sddm = {
        enable = true;
        wayland.enable = false;

        theme = "sddm-astronaut-theme";
        extraPackages = with pkgs; [
          kdePackages.qtmultimedia
          kdePackages.qtvirtualkeyboard
        ];

        settings = {
          General = {
            Numlock = "on";
          };

          Theme = {
            Font = "Noto Sans CJK SC";
            CursorSize = 24;
            EnableAvatars = true;
          };

          Wayland = {
            EnableHiDPI = true;
          };
        };
      };
    };

    services.dbus.packages = with pkgs; [
      cups-pk-helper
    ];

    security.polkit.enable = true;

    fonts.packages = with pkgs; [
      inter
      fira-code
      noto-fonts-cjk-sans
    ];

    environment.systemPackages = with pkgs; [
      cups-pk-helper
      xwayland-satellite
      sddmAstronautTheme
      kdePackages.qtmultimedia
      kdePackages.qtvirtualkeyboard
    ];
  };
}
