/** 机械盘健康检查与休眠。 */
{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.modules.hddPower;
in
{
  options.modules.hddPower = {
    enable = mkEnableOption "HDD health and standby";
    devices = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      hdparm
      smartmontools
    ];

    services.smartd = {
      enable = true;
      devices = map (device: {
        inherit device;
        options = "-a -d auto -n standby,q";
      }) cfg.devices;
    };

    systemd.services.hdd-spindown = {
      description = "Configure HDD standby timeout";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.hdparm}/bin/hdparm -S 120 ${lib.concatStringsSep " " cfg.devices}";
      };
    };
  };
}
