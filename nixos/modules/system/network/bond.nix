/** 有线链路聚合模块。 */
{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.modules.networkBond;
in
{
  options.modules.networkBond = {
    enable = mkEnableOption "802.3ad network bond";
    interfaces = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    networking.bonds.bond0 = {
      interfaces = cfg.interfaces;
      driverOptions = {
        mode = "802.3ad";
        miimon = "100";
        lacp_rate = "1";
        xmit_hash_policy = "layer3+4";
      };
    };

    networking.interfaces.enp2s0.useDHCP = false;
    networking.interfaces.enp3s0.useDHCP = false;
    networking.interfaces.bond0.useDHCP = true;
  };
}
