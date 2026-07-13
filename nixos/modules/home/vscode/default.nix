/**
  VS Code 开发辅助包模块。

  VS Code Remote 需要动态链接支持；如果出现 ld 问题，检查如下配置是否开启：
    programs.nix-ld.enable
*/
{
  lib,
  pkgs,
  config,
  ...
}:
with lib;

{
  # 这里只放 VS Code 相关开发辅助工具，GUI 应用本体由 packages.nix 管理。
  options.modules.vscode.enable = mkEnableOption "vscode";

  config = mkIf config.modules.vscode.enable {
    home.packages = with pkgs; [
      # nix
      nixd
      nixfmt
    ];
  };
}
