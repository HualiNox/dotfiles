/**
  Home Manager 模块聚合入口。

  统一导入 CLI、桌面、IDE 和用户软件包模块，并固定 home.stateVersion。
*/
{ ... }:

{
  # Home Manager 版本锚点，升级 HM/NixOS 大版本时再显式更新。
  home.stateVersion = "26.05";

  imports = [
    # cli
    ./zsh
    ./nvim
    ./git
    ./tmux

    # desktop
    ./gnome
    ./niri

    # ide 需要包或配置文件
    ./vscode

    # 软件包
    ./packages.nix
  ];
}
