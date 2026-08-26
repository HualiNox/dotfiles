/** direnv 与 nix-direnv。 */
{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.modules.direnv.enable = mkEnableOption "direnv and nix-direnv";

  config = mkIf config.modules.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
