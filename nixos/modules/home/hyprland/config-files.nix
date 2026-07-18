{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.modules.hyprland.enable {
    xdg.configFile."ghostty".source = ../../../../ghostty;
    xdg.configFile."fuzzel/fuzzel.ini".source = ../../../../fuzzel/fuzzel.ini;
    xdg.configFile."mako/config".source = ../../../../mako/config;

    xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-Mocha
    '';

    xdg.configFile."hypr/.luarc.json".text = builtins.toJSON {
      workspace = {
        library = [
          "/run/current-system/sw/share/hypr/stubs"
        ];

        checkThirdParty = false;
      };

      diagnostics = {
        globals = [
          "hl"
        ];
      };
    };
  };
}
