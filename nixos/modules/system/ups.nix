/** CyberPower UT650EGC UPS 监控。 */
{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.modules.ups;
in
{
  options.modules.ups = {
    enable = mkEnableOption "USB UPS monitoring";
    name = mkOption {
      type = types.str;
      default = "ups";
    };
    description = mkOption {
      type = types.str;
      default = "USB UPS";
    };
    driver = mkOption {
      type = types.str;
      default = "usbhid-ups";
    };
    vendorId = mkOption {
      type = types.str;
      default = "";
    };
    productId = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    power.ups = {
      enable = true;
      mode = "standalone";

      ups.${cfg.name} = {
        description = cfg.description;
        driver = cfg.driver;
        port = "auto";
        directives = [
          "vendorid = ${cfg.vendorId}"
          "productid = ${cfg.productId}"
          "offdelay = 60"
          "ondelay = 70"
          "lowbatt = 20"
          "ignorelb"
        ];
      };

      upsd.listen = [
        {
          address = "127.0.0.1";
          port = 3493;
        }
      ];

      users."nut-monitor" = {
        passwordFile = "/var/lib/secrets/nut/monitor.pass";
        upsmon = "primary";
      };

      upsmon.monitor.${cfg.name} = {
        system = "${cfg.name}@localhost";
        powerValue = 1;
        user = "nut-monitor";
        passwordFile = "/var/lib/secrets/nut/monitor.pass";
        type = "primary";
      };

      upsmon.settings = {
        MINSUPPLIES = 1;
        SHUTDOWNNODE = "true";
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/secrets/nut 0700 root root -"
    ];
  };
}
