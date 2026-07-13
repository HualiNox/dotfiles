/**
  minipc 的 Home Manager 用户入口。

  导入通用 home 模块，并启用当前用户需要的 CLI 与 IDE 配置。
*/
{
  config,
  lib,
  inputs,
  ...
}:

{
  # 主机专属用户配置只放开关，具体实现由 modules/home 维护。
  imports = [ ../../modules/home/default.nix ];

  config.modules = {
    # cli
    nvim.enable = true;
    zsh.enable = true;
    git-ext.enable = true;
    tmux.enable = true;

    # ide
    vscode.enable = true;
  };
}
