{
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkEnableOption;

  desktopCfg = osConfig.modules.desktop.enable;
  cfg = osConfig.modules.desktop.hyprland.enable;

in
{
  options.modules.hyprland.enable = mkEnableOption "Hyprland Home Manager Packages";
  config.modules.hyprland.enable = cfg && desktopCfg;

  imports = [
    ./hyprland.nix
  ];
}
