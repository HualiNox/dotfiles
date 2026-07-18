{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.hyprland.enable;
  desktopCfg = config.modules.desktop.enable;

in
{

  options.modules.desktop.hyprland.enable = mkEnableOption "Hyprland Configure";

  config = mkIf (cfg && desktopCfg) {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    services = {
      xserver.enable = true;
      gnome.gnome-keyring.enable = true;
      displayManager.sddm = {
        enable = true;
        wayland.enable = false;
        theme = "astronaut";
      };
    };

    xdg.portal = {
      enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };

    programs.dconf.enable = true;

    security = {
      polkit.enable = true;

      pam.services.hyprlock = { };
    };

    environment.systemPackages = with pkgs; [
      # 主题
      #      (catppuccin-sddm.override {
      #       flavor = "mocha";
      #      accent = "mauve";
      #   })
      sddm-astronaut

      # 桌面环境
      wayland

      xdg-desktop-portal-hyprland
      libsecret

      # 工具
      wl-clipboard
      nautilus
      file-roller
      wofi
    ];

    fonts.packages = with pkgs; [
      source-han-sans
      source-han-serif
      noto-fonts-cjk-sans
    ];
  };
}
