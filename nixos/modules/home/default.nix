{ ... }:

{
  home.stateVersion = "26.05";
  imports = [
    # cli
    ./zsh
    ./nvim
    ./git
    ./tmux

    # desktop
    ./kde

    # ide 需要包或配置文件
    ./vscode

    # 软件包
    ./packages.nix
  ];
}
