{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.modules.hyprland.enable {
    home.packages = with pkgs; [
      lua-language-server

      # desktop utilities
      grim
      slurp
      wl-clipboard
      playerctl
      pavucontrol
      libnotify

      # hypr ecosystem
      hyprsysteminfo
      hyprtoolkit

      # icons
      papirus-icon-theme

      # cursor
      bibata-cursors

      # gtk theme
      catppuccin-gtk

      # qt
      kdePackages.qt6ct
      qt6Packages.qtstyleplugin-kvantum

      # fonts
      noto-fonts
      nerd-fonts.jetbrains-mono
    ];
  };
}
