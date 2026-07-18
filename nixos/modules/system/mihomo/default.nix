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
  inherit (lib) mkIf mkEnableOption mkForce;
  fakeIpRoute = "198.18.0.0/16";
  mihomoFakeIpGateway = "198.18.0.2";
  mihomoTunDevice = "mihomo";
  installFakeIpMainRoute = pkgs.writeShellScript "mihomo-install-fakeip-main-route" ''
    set -eu

    ip="${pkgs.iproute2}/bin/ip"
    grep="${pkgs.gnugrep}/bin/grep"
    sleep="${pkgs.coreutils}/bin/sleep"

    i=0
    while [ "$i" -lt 50 ]; do
      if "$ip" -4 route show dev ${mihomoTunDevice} 2>/dev/null | "$grep" -q '^198\.18\.0\.0/30 '; then
        "$ip" -4 route replace ${fakeIpRoute} via ${mihomoFakeIpGateway} dev ${mihomoTunDevice}
        exit 0
      fi

      i=$((i + 1))
      "$sleep" 0.1
    done

    echo "mihomo TUN route was not ready; unable to install ${fakeIpRoute} route" >&2
    exit 1
  '';
  cleanupFakeIpMainRoute = pkgs.writeShellScript "mihomo-cleanup-fakeip-main-route" ''
    "${pkgs.iproute2}/bin/ip" -4 route del ${fakeIpRoute} via ${mihomoFakeIpGateway} dev ${mihomoTunDevice} 2>/dev/null || true
  '';
in
{
  # 代理配置含订阅和规则，开关默认关闭，由主机入口按需启用。
  options.modules.mihomo.enable = mkEnableOption "mihomo config";

  config = mkIf config.modules.mihomo.enable {
    networking = {
      # DNS 请求交给本机 mihomo 处理，配合 TUN 模式统一出站策略。
      nameservers = [ "127.0.0.1" ];

      # 阻止 dhcpcd 覆盖 resolv.conf，避免 nameserver 被 DHCP 改回上游。
      dhcpcd.extraConfig = ''
        nohook resolv.conf
      '';
    };

    services = {
      mihomo = {
        enable = true;
        tunMode = true;

        # 配置文件放在 Nix Store 外，便于存放订阅、规则和运行时更新内容。
        configFile = "/var/lib/mihomo/config.yaml";
      };
    };

    # TUN 和本地 DNS 监听需要网络管理与低端口绑定能力。
    systemd.services.mihomo.serviceConfig = {
      AmbientCapabilities = lib.mkForce [
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
      ];
      CapabilityBoundingSet = lib.mkForce [
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
      ];

      # Tailscale 会给自己的控制面连接打 fwmark 0x80000，并在 mihomo 策略规则前查询 main 表。
      # 将 fake-ip 段放进 main 表，避免这些连接把 fake-ip 泄漏到物理网关。
      ExecStartPost = installFakeIpMainRoute;
      ExecStopPost = cleanupFakeIpMainRoute;
    };
  };
}
