{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.niri.enable;
in
{
  imports = [
    inputs.niri.homeModules.config
    inputs.dms.homeModules.niri

    ./config.d/animations.nix
    ./config.d/appearance.nix
    ./config.d/autostart.nix
    ./config.d/binds.nix
    ./config.d/environment.nix
    ./config.d/input.nix
    ./config.d/layout.nix
    ./config.d/window-rules.nix
  ];

  config = lib.mkIf cfg {
    programs.niri.package = pkgs.niri;
  };
}
