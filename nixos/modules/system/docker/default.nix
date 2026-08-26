/**
  Docker 系统模块。

  启用 Docker daemon，并安装 Compose 与 Buildx 客户端插件。
*/
{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
in

{
  options.modules.docker.enable = mkEnableOption "Docker";

  config = mkIf config.modules.docker.enable {
    virtualisation.docker.enable = true;

    # daemon 由 virtualisation.docker 管理，这里只补常用客户端扩展。
    environment.systemPackages = with pkgs; [
      docker-buildx
      docker-compose
    ];
  };
}
