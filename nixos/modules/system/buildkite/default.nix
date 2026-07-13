/**
  Buildkite 私有 agent 模块。

  启用后配置 Docker、插件运行目录、FHS 兼容链接和 private 队列 agent。
*/
{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
in
{
  # 只在需要 CI agent 的主机启用，避免普通桌面环境暴露额外服务。
  options.modules.buildkite.enable = mkEnableOption "buidkite agent config";

  config = mkIf config.modules.buildkite.enable {
    # Pipeline 里会直接调用 docker，因此这里确保 daemon 可用。
    virtualisation.docker.enable = true;

    # secrets 目录由宿主机维护，使用专门用户组限制读取范围。
    users.groups.buildkite-secrets = { };

    # 允许 agent 用户执行 nix build / nix develop 等命令。
    nix.settings.allowed-users = [
      "buildkite-agent-private"
    ];

    # buildkite 插件放在运行时目录，避免写入 Nix Store。
    systemd.services.buildkite-agent-private.serviceConfig = {
      RuntimeDirectory = "buildkite-plugins";
    };

    # 一些上游脚本硬编码 /bin/bash 或 /usr/bin/env，提供最小 FHS 兼容入口。
    system.activationScripts.buildkite-fhs = ''
      mkdir -p /bin /usr/bin

      ln -sf ${pkgs.bash}/bin/bash /bin/bash
      ln -sf ${pkgs.coreutils}/bin/env /usr/bin/env
    '';

    services.buildkite-agents.private = {
      enable = true;

      # agent 名称用于 Buildkite UI 和队列调度识别。
      name = "catserver";

      # Token 必须放在 Nix Store 外
      tokenPath = "/var/lib/secrets/buildkite/agent-token";
      privateSshKeyPath = "/var/lib/secrets/buildkite/ssh/github-bot-key";
      extraConfig = ''
        plugins-path="/run/buildkite-plugins"
      '';

      tags = {
        queue = "private-nixos";
        nixos = "true";
        docker = "true";
      };

      runtimePackages = with pkgs; [
        bash
        git
        gnutar
        gzip
        nix
        docker
        openssh
        curl
        jq
        tailscale

        # buildkite 插件
        buildkite-test-collector-rust
      ];

      extraGroups = [
        "docker"
        "buildkite-secrets"
      ];
    };
  };
}
