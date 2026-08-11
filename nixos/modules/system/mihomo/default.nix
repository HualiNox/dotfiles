/**
  Mihomo 透明代理系统模块。

  启用后将系统 DNS 指向本机 mihomo，并以 TUN 模式加载外部配置文件。
*/
{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
in
{
  # 代理配置含订阅和规则，开关默认关闭，由主机入口按需启用。
  options.modules.mihomo.enable = mkEnableOption "mihomo config";

  config = mkIf config.modules.mihomo.enable {
    # 关闭 TUN 后，使用 NixOS 的全局代理环境变量覆盖用户会话、Nix
    # daemon 以及支持 networking.proxy 的系统服务。
    networking.proxy = {
      default = "http://127.0.0.1:7890";
      allProxy = "socks5://127.0.0.1:7890";
      noProxy = "127.0.0.1,localhost,::1,172.16.0.0/12,192.168.0.0/16";
    };

    services.mihomo = {
      enable = true;
      # 仅提供本机 HTTP/SOCKS 代理，不接管系统路由和 DNS。
      tunMode = false;

      # 配置文件放在 Nix Store 外，便于存放订阅、规则和运行时更新内容。
      configFile = "/var/lib/mihomo/config.yaml";
    };
  };
}
