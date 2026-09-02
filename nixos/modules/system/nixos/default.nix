/**
  NixOS 基础平台配置。

  汇总用户与服务模块，并设置 nix、GC、nix-ld 和系统 stateVersion。
*/
{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  imports = [
    ./services.nix
    ./users.nix
  ];

  # nix 设置
  nix = {
    settings = {
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # 国内镜像优先，官方缓存保留为最后兜底。
      substituters = mkForce [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirrors.cernet.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
      ];
    };

    # 定期清理旧代，避免系统盘长期积累历史闭包。
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # 动态链接修复
  programs.nix-ld.enable = true;

  # NixOS 版本锚点，升级系统版本时再显式更新。
  system.stateVersion = "26.05";
}
