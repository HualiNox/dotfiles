/**
  系统模块聚合入口。

  统一导入基础系统、服务、桌面与可选服务模块；主机启用策略由 hosts/* 维护。
*/
{ ... }:

{
  imports = [
    # 基本配置文件
    ./i18n
    ./nixos

    # 服务配置文件
    ./android
    ./docker
    ./tailscale
    ./network/bond.nix
    ./samba.nix
    ./ups.nix
    ./hdd-power.nix
    ./packages.nix

    # 桌面配置
    ./desktop

    # mihomo
    ./mihomo

    # buildkite
    ./buildkite
  ];
}
