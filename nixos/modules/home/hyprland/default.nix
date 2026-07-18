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
  options.modules.hyprland.enable = mkEnableOption "Hyprland Home Manager configuration";
  config.modules.hyprland.enable = cfg && desktopCfg;

  imports = [
    ./config-files.nix
    ./packages.nix
    ./services.nix
    ./theme.nix
    ./waybar.nix
  ];
}
