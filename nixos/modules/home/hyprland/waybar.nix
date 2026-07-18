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
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = builtins.fromJSON (builtins.readFile ../../../../waybar/config.jsonc);
      };

      style = ../../../../waybar/style.css;
    };
  };
}
