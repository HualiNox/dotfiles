/**
  Tailscale 系统网络模块。

  启用 tailscaled、开放防火墙，并避免 Tailnet DNS 覆盖本机 DNS 策略。
*/
{ pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;

    # DNS 交给本机网络/代理配置管理，不接受 Tailnet 下发的 nameserver。
    extraUpFlags = [ "--accept-dns=false" ];
  };

  # 信任 Tailnet 接口，允许来自 tailscale0 的入站连接走本机防火墙白名单。
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # 提供 tailscale CLI，便于登录、状态检查和 ACL 调试。
  environment.systemPackages = with pkgs; [
    tailscale
  ];
}
