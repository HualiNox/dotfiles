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
    gtk = {
      enable = true;

      theme = {
        name = "Catppuccin-Mocha-Standard-Blue-Dark";
        package = pkgs.catppuccin-gtk;
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

      style = {
        name = "kvantum";
      };
    };

    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_STYLE_OVERRIDE = "kvantum";
    };

    fonts.fontconfig = {
      enable = true;

      defaultFonts = {
        sansSerif = [
          "Noto Sans"
        ];

        monospace = [
          "JetBrainsMono Nerd Font"
        ];
      };
    };
  };
}
