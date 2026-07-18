/**
  系统级基础软件包模块。

  启用 nix-index/comma、非自由包，并安装维护系统所需的通用 CLI 工具。
*/
{ pkgs, inputs, ... }:

{
  imports = [
    # nix-index-database
    inputs.nix-index-database.nixosModules.nix-index
  ];

  # 启用非自由软件
  nixpkgs.config.allowUnfree = true;

  # 启用 comma
  programs.nix-index-database.comma.enable = true;

  # 系统软件
  environment.systemPackages = with pkgs; [
    # essential
    vim
    nano
    git
    curl
    wget
    openssh
    bash

    # archives
    unzip
    zip
    gnutar
    gzip
    xz
    p7zip
    zstd

    # inspection
    file
    tree
    which
    lsof
    pciutils
    usbutils
    dmidecode
    jq
    pv

    # disk / filesystem
    parted
    gptfdisk
    dosfstools
    e2fsprogs
    ntfs3g
    exfatprogs

    # monitor
    htop
    btop
    iotop
    sysstat

    # build basics
    gcc
    gnumake
    pkg-config

    # nix tools
    nh
    nix-output-monitor
    nvd
    nix-tree
    nix-du
    direnv

    # tools
    rsync
  ];
}
